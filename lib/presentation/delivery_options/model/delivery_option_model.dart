class DeliveryOptionModel {
  bool? success;
  int? statusCode;
  String? message;
  DeliveryOptionDataWrapper? data;

  DeliveryOptionModel({this.success, this.statusCode, this.message, this.data});

  DeliveryOptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? DeliveryOptionDataWrapper.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeliveryOptionDataWrapper {
  DeliveryOptionData? data;

  DeliveryOptionDataWrapper({this.data});

  DeliveryOptionDataWrapper.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DeliveryOptionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeliveryOptionData {
  int? id;
  int? sellerId;
  String? domesticPartner;
  double? domesticCost;
  int? domesticDaysMin;
  int? domesticDaysMax;
  String? internationalPartner;
  double? internationalCost;
  int? internationalDaysMin;
  int? internationalDaysMax;
  String? createdAt;
  String? updatedAt;

  DeliveryOptionData({
    this.id,
    this.sellerId,
    this.domesticPartner,
    this.domesticCost,
    this.domesticDaysMin,
    this.domesticDaysMax,
    this.internationalPartner,
    this.internationalCost,
    this.internationalDaysMin,
    this.internationalDaysMax,
    this.createdAt,
    this.updatedAt,
  });

  DeliveryOptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['sellerId'];
    domesticPartner = json['domestic_partner'];
    domesticCost = json['domestic_cost'] != null ? double.parse(json['domestic_cost'].toString()) : null;
    domesticDaysMin = json['domestic_days_min'];
    domesticDaysMax = json['domestic_days_max'];
    internationalPartner = json['international_partner'];
    internationalCost = json['international_cost'] != null ? double.parse(json['international_cost'].toString()) : null;
    internationalDaysMin = json['international_days_min'];
    internationalDaysMax = json['international_days_max'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sellerId'] = sellerId;
    data['domestic_partner'] = domesticPartner;
    data['domestic_cost'] = domesticCost;
    data['domestic_days_min'] = domesticDaysMin;
    data['domestic_days_max'] = domesticDaysMax;
    data['international_partner'] = internationalPartner;
    data['international_cost'] = internationalCost;
    data['international_days_min'] = internationalDaysMin;
    data['international_days_max'] = internationalDaysMax;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
