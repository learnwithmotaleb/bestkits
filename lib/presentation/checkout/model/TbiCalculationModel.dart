class TbiCalculationModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  TbiCalculationModel({this.success, this.statusCode, this.message, this.data});

  TbiCalculationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = (json['statusCode'] as num?)?.toInt();
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? country;
  String? currency;
  String? baseCurrency;
  double? amount;
  double? amountUsd;
  int? categoryId;
  List<Schemes>? schemes;

  Data(
      {this.country,
      this.currency,
      this.baseCurrency,
      this.amount,
      this.amountUsd,
      this.categoryId,
      this.schemes});

  Data.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    currency = json['currency'];
    baseCurrency = json['base_currency'];
    amount = (json['amount'] as num?)?.toDouble();
    amountUsd = (json['amount_usd'] as num?)?.toDouble();
    categoryId = (json['category_id'] as num?)?.toInt();
    schemes = (json['schemes'] as List?)
            ?.map((value) => Schemes.fromJson(value as Map<String, dynamic>))
            .toList() ??
        <Schemes>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['base_currency'] = this.baseCurrency;
    data['amount'] = this.amount;
    data['amount_usd'] = this.amountUsd;
    data['category_id'] = this.categoryId;
    if (this.schemes != null) {
      data['schemes'] = this.schemes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schemes {
  int? id;
  int? schemeId;
  String? name;
  int? period;
  double? installment;
  double? totalDue;
  double? nir;
  double? apr;
  double? amountMin;
  double? amountMax;
  String? categoryId;
  String? bankProduct;
  dynamic promoCode;
  dynamic ftosProduct;
  double? analysisFee;
  dynamic insurance;
  Raw? raw;

  Schemes(
      {this.id,
      this.schemeId,
      this.name,
      this.period,
      this.installment,
      this.totalDue,
      this.nir,
      this.apr,
      this.amountMin,
      this.amountMax,
      this.categoryId,
      this.bankProduct,
      this.promoCode,
      this.ftosProduct,
      this.analysisFee,
      this.insurance,
      this.raw});

  Schemes.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    schemeId = (json['scheme_id'] as num?)?.toInt();
    name = json['name'];
    period = (json['period'] as num?)?.toInt();
    installment = (json['installment'] as num?)?.toDouble();
    totalDue = (json['total_due'] as num?)?.toDouble();
    nir = (json['nir'] as num?)?.toDouble();
    apr = (json['apr'] as num?)?.toDouble();
    amountMin = (json['amount_min'] as num?)?.toDouble();
    amountMax = (json['amount_max'] as num?)?.toDouble();
    categoryId = json['category_id']?.toString();
    bankProduct = json['bank_product'];
    promoCode = json['promo_code'];
    ftosProduct = json['ftos_product'];
    analysisFee = (json['analysis_fee'] as num?)?.toDouble();
    insurance = json['insurance'];
    raw = json['raw'] != null ? Raw.fromJson(json['raw']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['scheme_id'] = this.schemeId;
    data['name'] = this.name;
    data['period'] = this.period;
    data['installment'] = this.installment;
    data['total_due'] = this.totalDue;
    data['nir'] = this.nir;
    data['apr'] = this.apr;
    data['amount_min'] = this.amountMin;
    data['amount_max'] = this.amountMax;
    data['category_id'] = this.categoryId;
    data['bank_product'] = this.bankProduct;
    data['promo_code'] = this.promoCode;
    data['ftos_product'] = this.ftosProduct;
    data['analysis_fee'] = this.analysisFee;
    data['insurance'] = this.insurance;
    if (this.raw != null) {
      data['raw'] = this.raw!.toJson();
    }
    return data;
  }
}

class Raw {
  int? id;
  String? name;
  String? bankProduct;
  int? period;
  double? installmentFactor;
  double? totalDueFactor;
  double? nir;
  double? apr;
  double? amountMin;
  double? amountMax;
  String? categoryId;
  String? currency;
  double? amountMinBgn;
  double? amountMaxBgn;

  Raw(
      {this.id,
      this.name,
      this.bankProduct,
      this.period,
      this.installmentFactor,
      this.totalDueFactor,
      this.nir,
      this.apr,
      this.amountMin,
      this.amountMax,
      this.categoryId,
      this.currency,
      this.amountMinBgn,
      this.amountMaxBgn});

  Raw.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    name = json['name'];
    bankProduct = json['bank_product'];
    period = (json['period'] as num?)?.toInt();
    installmentFactor = (json['installment_factor'] as num?)?.toDouble();
    totalDueFactor = (json['total_due_factor'] as num?)?.toDouble();
    nir = (json['nir'] as num?)?.toDouble();
    apr = (json['apr'] as num?)?.toDouble();
    amountMin = (json['amount_min'] as num?)?.toDouble();
    amountMax = (json['amount_max'] as num?)?.toDouble();
    categoryId = json['category_id']?.toString();
    currency = json['currency'];
    amountMinBgn = (json['amount_min_bgn'] as num?)?.toDouble();
    amountMaxBgn = (json['amount_max_bgn'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['bank_product'] = this.bankProduct;
    data['period'] = this.period;
    data['installment_factor'] = this.installmentFactor;
    data['total_due_factor'] = this.totalDueFactor;
    data['nir'] = this.nir;
    data['apr'] = this.apr;
    data['amount_min'] = this.amountMin;
    data['amount_max'] = this.amountMax;
    data['category_id'] = this.categoryId;
    data['currency'] = this.currency;
    data['amount_min_bgn'] = this.amountMinBgn;
    data['amount_max_bgn'] = this.amountMaxBgn;
    return data;
  }
}
