import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;

  SettingsCubit({required this.prefs}) : super(const SettingsState(isDarkMode: false, notificationsEnabled: true)) {
    _loadSettings();
  }

  void _loadSettings() {
    final isDark = prefs.getBool('IS_DARK_MODE') ?? false;
    final notifications = prefs.getBool('NOTIFICATIONS_ENABLED') ?? true;
    emit(SettingsState(isDarkMode: isDark, notificationsEnabled: notifications));
  }

  void toggleTheme(bool isDark) {
    prefs.setBool('IS_DARK_MODE', isDark);
    emit(state.copyWith(isDarkMode: isDark));
  }

  void toggleNotifications(bool enabled) {
    prefs.setBool('NOTIFICATIONS_ENABLED', enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }
}
