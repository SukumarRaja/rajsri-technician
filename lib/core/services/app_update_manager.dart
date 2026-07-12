import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_settings_model.dart';
import '../network/dio_client.dart';

class AppUpdateManager {
  final DioClient dioClient;

  AppUpdateManager({required this.dioClient});

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      final response = await dioClient.dio.get('/settings');
      final settingsResponse = AppSettingsResponse.fromJson(response.data);
      final settings = settingsResponse.data;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      String? targetVersion;
      String? updateUrl;

      if (Platform.isAndroid) {
        targetVersion = settings.technicianAndroidVersion;
        updateUrl = settings.technicianPlaystoreUrl;
      } else if (Platform.isIOS) {
        targetVersion = settings.technicianIosVersion;
        updateUrl = settings.technicianIosUrl;
      }

      if (targetVersion != null && targetVersion.isNotEmpty && updateUrl != null && updateUrl.isNotEmpty) {
        if (_isUpdateAvailable(currentVersion, targetVersion)) {
          final isForceUpdate = settings.technicianForceUpdate ?? false;
          if (context.mounted) {
            _showUpdateDialog(context, updateUrl, isForceUpdate);
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  bool _isUpdateAvailable(String currentVersion, String targetVersion) {
    try {
      final currentParts = currentVersion.split('.').map(int.parse).toList();
      final targetParts = targetVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < currentParts.length && i < targetParts.length; i++) {
        if (targetParts[i] > currentParts[i]) return true;
        if (targetParts[i] < currentParts[i]) return false;
      }
      return targetParts.length > currentParts.length;
    } catch (e) {
      return false;
    }
  }

  void _showUpdateDialog(BuildContext context, String url, bool isForceUpdate) {
    showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (context) => WillPopScope(
        onWillPop: () async => !isForceUpdate,
        child: AlertDialog(
          title: const Text('Update Available'),
          content: Text(
            isForceUpdate
                ? 'A new version of the app is available. You must update to continue using the app.'
                : 'A new version of the app is available. Would you like to update now?',
          ),
          actions: [
            if (!isForceUpdate)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Later'),
              ),
            FilledButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }
}
