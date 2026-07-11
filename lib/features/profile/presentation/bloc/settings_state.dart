import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool notificationsEnabled;

  const SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, notificationsEnabled];
}
