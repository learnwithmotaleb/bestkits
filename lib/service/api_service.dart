import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';
import '../core/routes/route_path.dart';
import '../helper/local_db/local_db.dart';
import '../helper/no_internet/controller/no_internet_controller.dart';
import '../helper/tost_message/show_snackbar.dart';

final log = Logger();

typedef ApiResult = Response;

class ApiClient {
  static const defaultTimeout = Duration(seconds: 30);

  // Guard so a burst of parallel 401 responses only triggers one
  // session-expired redirect instead of clearing/navigating repeatedly.
  static bool _isHandlingSessionExpiry = false;

  Future<Map<String, String>> _headers({
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    // Basic Auth
    if (isBasic) {
      const basicAuth = "Basic your_basic_key";
      headers["Authorization"] = basicAuth;
    }

    // Bearer Token
    if (isToken) {
      String? token = await SharePrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      } else {
        print("Token is missing!");
      }
    }

    // Custom Headers
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// ---------------- Master Request Handler ---------------------
  /// ---------------- Master Request Handler ---------------------
  Future<ApiResult> safeRequest(
    Future<http.Response> Function() requestFn, {
    required String url,
    String method = "GET",
    bool checkInternet = true,
    bool isToken = false,
  }) async {
    try {
      // Optional: check internet before request
      if (checkInternet && Get.isRegistered<InternetController>()) {
        final controller = Get.find<InternetController>();
        if (!controller.isConnected.value) {
          return _handleException("No internet connection!");
        }
      }

      final response = await requestFn().timeout(defaultTimeout);

      // Update internet status on success
      if (Get.isRegistered<InternetController>()) {
        Get.find<InternetController>().setConnected();
      }

      return _handleResponse(response, isToken: isToken);
    }

    // No internet
    on SocketException {
      if (Get.isRegistered<InternetController>()) {
        Get.find<InternetController>().setDisconnected();
      }
      return _handleException("No internet connection!");
    }

    // Timeout
    on TimeoutException {
      return _handleException("Request timeout. Please try again.");
    }

    // Client error
    on http.ClientException catch (e) {
      return _handleException("Client error: ${e.message}");
    }

    // Unknown error
    catch (e) {
      return _handleException("Unexpected error: $e");
    }
  }

  /// ---------------- Response Handler ---------------------------
  ApiResult _handleResponse(http.Response response, {bool isToken = false}) {
    // Token expired / invalid on an authenticated request → force re-login.
    if (isToken && response.statusCode == 401) {
      _handleSessionExpired();
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    // Pretty-print the response body
    String prettyBody;
    try {
      prettyBody = const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      prettyBody = response.body;
    }

    log.i(
      "\n┌─── RESPONSE ───────────────────────────────\n"
      "│ Status : ${response.statusCode} ${response.reasonPhrase}\n"
      "│ Body   :\n$prettyBody\n"
      "└────────────────────────────────────────────",
    );

    return Response(
      statusCode: response.statusCode,
      body: decoded,
      bodyString: response.body,
      statusText: response.reasonPhrase,
    );
  }

  /// ---------------- Error Handler -------------------------------
  ApiResult _handleException(String message) {
    log.e("\n✖ API ERROR: $message");
    return Response(statusCode: 400, body: {}, statusText: message);
  }

  /// ---------------- Session Expired Handler ----------------------
  /// Called when an authenticated request comes back 401 (token
  /// expired/invalid). Clears the saved session and sends the user
  /// back to the login screen so they can log in again.
  void _handleSessionExpired() {
    if (_isHandlingSessionExpiry) return;

    // Already logged out / already on the login screen — nothing to do.
    final token = SharePrefsHelper.getToken();
    if (token == null || token.isEmpty) return;
    if (Get.currentRoute == RoutePath.login) return;

    _isHandlingSessionExpiry = true;
    log.e("\n✖ SESSION EXPIRED: token invalid/expired, redirecting to login");

    Future(() async {
      try {
        await SharePrefsHelper.clearAll();
        AppSnackBar.fail("Your session has expired. Please log in again.");
        Get.offAllNamed(RoutePath.login);
      } finally {
        _isHandlingSessionExpiry = false;
      }
    });
  }

  /// ---------------- Logging -------------------------------------
  void _logRequest(String url, String method,
      {Map<String, dynamic>? body, Map<String, String>? headers}) {
    String prettyBody = '';
    if (body != null && body.isNotEmpty) {
      try {
        prettyBody = const JsonEncoder.withIndent('  ').convert(body);
      } catch (_) {
        prettyBody = body.toString();
      }
    }

    log.i(
      "\n┌─── REQUEST ────────────────────────────────\n"
      "│ Method  : $method\n"
      "│ URL     : $url\n"
      "│ Headers : $headers\n"
      "│ Body    : ${prettyBody.isEmpty ? '(none)' : '\n$prettyBody'}\n"
      "└────────────────────────────────────────────",
    );
  }

  // ======================== HTTP METHODS ========================

  Future<ApiResult> get({
    required String url,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    _logRequest(url, "GET", headers: headers);

    return safeRequest(
      () async => http.get(Uri.parse(url), headers: headers),
      url: url,
      method: "GET",
      isToken: isToken,
    );
  }

  Future<ApiResult> post({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    _logRequest(url, "POST", body: body, headers: headers);

    return safeRequest(
      () async => http.post(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "POST",
      isToken: isToken,
    );
  }

  Future<ApiResult> put({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    _logRequest(url, "PUT", body: body, headers: headers);

    return safeRequest(
      () async => http.put(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "PUT",
      isToken: isToken,
    );
  }

  Future<ApiResult> patch({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    _logRequest(url, "PATCH", body: body, headers: headers);

    return safeRequest(
      () async => http.patch(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "PATCH",
      isToken: isToken,
    );
  }

  Future<ApiResult> delete({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    _logRequest(url, "DELETE", body: body, headers: headers);

    return safeRequest(
      () async {
        final request = http.Request("DELETE", Uri.parse(url))
          ..headers.addAll(headers)
          ..body = jsonEncode(body ?? {});

        final streamedResponse = await request.send().timeout(defaultTimeout);
        return http.Response.fromStream(streamedResponse);
      },
      url: url,
      method: "DELETE",
      isToken: isToken,
    );
  }

  // ================================================================
//                      MULTIPART Upload (Enhanced Logging)
// ================================================================
  Future<ApiResult> multipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFileData> files,
    String method = "POST",
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      _logRequest(url, "MULTIPART $method");

      final request = http.MultipartRequest(method, Uri.parse(url));

      // Add headers
      final headers = await _headers(
          isBasic: isBasic, isToken: isToken, customHeaders: customHeaders);
      request.headers.addAll(headers);
      log.i("Request Headers: $headers");

      // Add fields
      request.fields.addAll(fields);
      log.i("Request Fields: $fields");

      // Add files
      for (var file in files) {
        final fileObj = File(file.path);

        if (!fileObj.existsSync()) {
          log.e("File not found: ${file.path}");
          continue; // skip missing files
        }

        final mimeTypeData = (lookupMimeType(file.path)?.split('/') ??
            ['application', 'octet-stream']);
        final contentType = MediaType(mimeTypeData[0], mimeTypeData[1]);

        log.i(
            "Adding file -> Key: ${file.key}, Path: ${file.path}, MIME: ${mimeTypeData.join('/')}, Size: ${fileObj.lengthSync()} bytes");

        request.files.add(
          await http.MultipartFile.fromPath(
            file.key,
            file.path,
            contentType: contentType,
          ),
        );
      }

      // Send request with timeout
      final streamed = await request.send().timeout(ApiClient.defaultTimeout);

      // Convert streamed response to http.Response
      final response = await http.Response.fromStream(streamed);

      log.i("Multipart Response Status: ${response.statusCode}");
      log.i("Multipart Response Body: ${response.body}");

      return _handleResponse(response, isToken: isToken);
    } catch (e) {
      log.e("Multipart Error: $e");
      return _handleException("Multipart Error: $e");
    }
  }

  Future<ApiResult> postMultipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFileData> files,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    return multipart(
      url: url,
      fields: fields,
      files: files,
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );
  }

  // ... your existing _headers, _logRequest, _handleResponse, etc.

  /// ---------------- PATCH with multipart & token -----------------
  Future<ApiResult> patchWithMultipart({
    required String url,
    required Map<String, String> fields,
    File? imageFile,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      _logRequest(url, "MULTIPART PATCH");

      final request = http.MultipartRequest("PATCH", Uri.parse(url));

      final headers = await _headers(
        isBasic: isBasic,
        isToken: isToken,
        customHeaders: customHeaders,
      );
      request.headers.addAll(headers);

      request.fields.addAll(fields);

      if (imageFile != null && imageFile.existsSync()) {
        final mimeTypeData = (lookupMimeType(imageFile.path)?.split('/') ??
            ['application', 'octet-stream']);

        request.files.add(
          await http.MultipartFile.fromPath(
            "insurance_Photo", // ✅ correct key
            imageFile.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      final streamed = await request.send().timeout(defaultTimeout);
      final response = await http.Response.fromStream(streamed);

      return _handleResponse(response, isToken: isToken);
    } catch (e) {
      return _handleException("PATCH Multipart Error: $e");
    }
  }

  Future<ApiResult> uploadMedicalImage({
    required String url,
    required String imageKey, // medical_mySelf_image / medical_family_image
    required File imageFile,
    bool isToken = true,
  }) async {
    return multipart(
      url: url,
      fields: {},
      files: [
        MultipartFileData(
          key: imageKey,
          path: imageFile.path,
        ),
      ],
      customHeaders: isToken
          ? {
              "Authorization":
                  "Bearer ${await SharePrefsHelper.getToken() ?? ""}"
            }
          : null,
    );
  }

  Future<ApiResult> getMedicalImages({
    required String url,
    bool isToken = true,
  }) async {
    return get(
      url: url,
      isToken: isToken,
    );
  }

  Future<ApiResult> removeMedicalImage({
    required String url,
    required Map<String, dynamic> body,
    bool isToken = true,
  }) async {
    return patch(
      url: url,
      body: body,
      isToken: isToken,
    );
  }
}

/// ================= Multipart File Model ========================
class MultipartFileData {
  final String key;
  final String path;

  MultipartFileData({
    required this.key,
    required this.path,
  });

  String get mimeType => lookupMimeType(path) ?? "application/octet-stream";
}
