import 'package:json_annotation/json_annotation.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsResponse {
  final bool success;
  final String message;
  final AppSettingsModel data;

  AppSettingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) => _$AppSettingsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsResponseToJson(this);
}

@JsonSerializable()
class AppSettingsModel {
  @JsonKey(name: 'site_name')
  final String? siteName;
  @JsonKey(name: 'support_email')
  final String? supportEmail;
  @JsonKey(name: 'contact_number')
  final String? contactNumber;
  final String? address;

  @JsonKey(name: 'android_version')
  final String? androidVersion;
  @JsonKey(name: 'ios_version')
  final String? iosVersion;
  @JsonKey(name: 'playstore_url')
  final String? playstoreUrl;
  @JsonKey(name: 'ios_url')
  final String? iosUrl;
  @JsonKey(name: 'force_update')
  final bool? forceUpdate;

  @JsonKey(name: 'technician_android_version')
  final String? technicianAndroidVersion;
  @JsonKey(name: 'technician_ios_version')
  final String? technicianIosVersion;
  @JsonKey(name: 'technician_playstore_url')
  final String? technicianPlaystoreUrl;
  @JsonKey(name: 'technician_ios_url')
  final String? technicianIosUrl;
  @JsonKey(name: 'technician_force_update')
  final bool? technicianForceUpdate;

  @JsonKey(name: 'privacy_policy_url')
  final String? privacyPolicyUrl;
  @JsonKey(name: 'about_us_url')
  final String? aboutUsUrl;

  @JsonKey(name: 'maintenance_mode')
  final bool? maintenanceMode;
  @JsonKey(name: 'maintenance_message')
  final String? maintenanceMessage;

  @JsonKey(name: 'enable_amc')
  final dynamic enableAmc;
  @JsonKey(name: 'enable_tracking')
  final dynamic enableTracking;
  @JsonKey(name: 'enable_wallet')
  final dynamic enableWallet;
  @JsonKey(name: 'enable_offers')
  final dynamic enableOffers;

  @JsonKey(name: 'razorpay_enabled')
  final bool? razorpayEnabled;
  @JsonKey(name: 'paypal_enabled')
  final dynamic paypalEnabled;
  @JsonKey(name: 'cod_enabled')
  final dynamic codEnabled;
  @JsonKey(name: 'emi_enabled')
  final bool? emiEnabled;

  AppSettingsModel({
    this.siteName,
    this.supportEmail,
    this.contactNumber,
    this.address,
    this.androidVersion,
    this.iosVersion,
    this.playstoreUrl,
    this.iosUrl,
    this.forceUpdate,
    this.technicianAndroidVersion,
    this.technicianIosVersion,
    this.technicianPlaystoreUrl,
    this.technicianIosUrl,
    this.technicianForceUpdate,
    this.privacyPolicyUrl,
    this.aboutUsUrl,
    this.maintenanceMode,
    this.maintenanceMessage,
    this.enableAmc,
    this.enableTracking,
    this.enableWallet,
    this.enableOffers,
    this.razorpayEnabled,
    this.paypalEnabled,
    this.codEnabled,
    this.emiEnabled,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);
}
