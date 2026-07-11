import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/bloc/network_bloc.dart';
import 'core/network/bloc/network_state.dart';
import 'di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/profile/presentation/bloc/settings_cubit.dart';
import 'features/profile/presentation/bloc/settings_state.dart';
import 'routes/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/no_internet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(di.sl<SharedPreferences>());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => di.sl<NetworkBloc>()),
        BlocProvider(create: (_) => di.sl<TrackingBloc>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, networkState) {
              return MaterialApp.router(
                title: 'Technician App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                routerConfig: appRouter.router,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  return Stack(
                    children: [
                      if (child != null) child,
                      if (networkState is NetworkDisconnected)
                        const Positioned.fill(child: NoInternetScreen()),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
