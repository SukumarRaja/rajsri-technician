// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsResponse _$AppSettingsResponseFromJson(Map<String, dynamic> json) =>
    AppSettingsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AppSettingsModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppSettingsResponseToJson(
  AppSettingsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      siteName: json['site_name'] as String?,
      supportEmail: json['support_email'] as String?,
      contactNumber: json['contact_number'] as String?,
      address: json['address'] as String?,
      androidVersion: json['android_version'] as String?,
      iosVersion: json['ios_version'] as String?,
      playstoreUrl: json['playstore_url'] as String?,
      iosUrl: json['ios_url'] as String?,
      forceUpdate: json['force_update'] as bool?,
      technicianAndroidVersion: json['technician_android_version'] as String?,
      technicianIosVersion: json['technician_ios_version'] as String?,
      technicianPlaystoreUrl: json['technician_playstore_url'] as String?,
      technicianIosUrl: json['technician_ios_url'] as String?,
      technicianForceUpdate: json['technician_force_update'] as bool?,
      privacyPolicyUrl: json['privacy_policy_url'] as String?,
      aboutUsUrl: json['about_us_url'] as String?,
      maintenanceMode: json['maintenance_mode'] as bool?,
      maintenanceMessage: json['maintenance_message'] as String?,
      enableAmc: json['enable_amc'],
      enableTracking: json['enable_tracking'],
      enableWallet: json['enable_wallet'],
      enableOffers: json['enable_offers'],
      razorpayEnabled: json['razorpay_enabled'] as bool?,
      paypalEnabled: json['paypal_enabled'],
      codEnabled: json['cod_enabled'],
      emiEnabled: json['emi_enabled'] as bool?,
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'site_name': instance.siteName,
      'support_email': instance.supportEmail,
      'contact_number': instance.contactNumber,
      'address': instance.address,
      'android_version': instance.androidVersion,
      'ios_version': instance.iosVersion,
      'playstore_url': instance.playstoreUrl,
      'ios_url': instance.iosUrl,
      'force_update': instance.forceUpdate,
      'technician_android_version': instance.technicianAndroidVersion,
      'technician_ios_version': instance.technicianIosVersion,
      'technician_playstore_url': instance.technicianPlaystoreUrl,
      'technician_ios_url': instance.technicianIosUrl,
      'technician_force_update': instance.technicianForceUpdate,
      'privacy_policy_url': instance.privacyPolicyUrl,
      'about_us_url': instance.aboutUsUrl,
      'maintenance_mode': instance.maintenanceMode,
      'maintenance_message': instance.maintenanceMessage,
      'enable_amc': instance.enableAmc,
      'enable_tracking': instance.enableTracking,
      'enable_wallet': instance.enableWallet,
      'enable_offers': instance.enableOffers,
      'razorpay_enabled': instance.razorpayEnabled,
      'paypal_enabled': instance.paypalEnabled,
      'cod_enabled': instance.codEnabled,
      'emi_enabled': instance.emiEnabled,
    };
