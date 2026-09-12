/// Response model for GET /tbi-credit/calculations (TBI Fusion Pay
/// installment schemes).
///
/// NOTE: The API docs currently only show a generic placeholder example for
/// this endpoint (`{"id": 1, "name": "..."}`), not the real installment
/// scheme shape. This model is written defensively — each field tries a few
/// common key spellings — so it keeps working once the backend confirms the
/// exact response. If the real payload uses different keys, just extend the
/// key lists in [InstallmentScheme.fromJson].
class TbiCalculationModel {
  final bool? success;
  final num? statusCode;
  final String? message;
  final List<InstallmentScheme> schemes;

  TbiCalculationModel({
    this.success,
    this.statusCode,
    this.message,
    this.schemes = const [],
  });

  factory TbiCalculationModel.fromJson(dynamic json) {
    final rawData = json is Map ? json['data'] : null;
    List<dynamic> rawSchemes = [];

    if (rawData is List) {
      // "data" is already the list of installment schemes.
      rawSchemes = rawData;
    } else if (rawData is Map) {
      // "data" wraps the list under a nested key.
      final nested = rawData['schemes'] ??
          rawData['installmentSchemes'] ??
          rawData['options'] ??
          rawData['plans'];
      if (nested is List) rawSchemes = nested;
    }

    return TbiCalculationModel(
      success: json is Map ? json['success'] as bool? : null,
      statusCode: json is Map ? json['statusCode'] as num? : null,
      message: json is Map ? json['message']?.toString() : null,
      schemes: rawSchemes
          .whereType<Map>()
          .map((e) => InstallmentScheme.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class InstallmentScheme {
  final int months;
  final double monthlyAmount;
  final double totalAmount;
  final double aprPercent;

  const InstallmentScheme({
    required this.months,
    required this.monthlyAmount,
    required this.totalAmount,
    required this.aprPercent,
  });

  factory InstallmentScheme.fromJson(Map<String, dynamic> json) {
    return InstallmentScheme(
      months: _firstInt(json, const [
        'months',
        'numberOfInstallments',
        'installments',
        'term',
        'periodMonths',
      ]),
      monthlyAmount: _firstDouble(json, const [
        'monthlyAmount',
        'monthlyInstallment',
        'installmentAmount',
        'monthlyPayment',
        'monthly_amount',
        'monthly_installment',
      ]),
      totalAmount: _firstDouble(json, const [
        'totalAmount',
        'totalRepaymentAmount',
        'totalPayable',
        'total_amount',
        'total',
      ]),
      aprPercent: _firstDouble(json, const [
        'apr',
        'aprPercent',
        'interestRate',
        'nominalRate',
        'apr_percent',
      ]),
    );
  }

  static int _firstInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = num.tryParse(value);
        if (parsed != null) return parsed.toInt();
      }
    }
    return 0;
  }

  static double _firstDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = num.tryParse(value);
        if (parsed != null) return parsed.toDouble();
      }
    }
    return 0.0;
  }
}
