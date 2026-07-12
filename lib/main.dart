import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/bloc/network_bloc.dart';
import 'core/network/bloc/network_state.dart';
import 'di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/jobs/presentation/bloc/job_action_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/profile/presentation/bloc/settings_cubit.dart';
import 'features/profile/presentation/bloc/settings_state.dart';
import 'routes/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/no_internet_screen.dart';
import 'core/services/background_service_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await initializeBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(di.sl<SharedPreferences>());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => di.sl<NetworkBloc>()),
        BlocProvider(create: (_) => di.sl<TrackingBloc>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
        BlocProvider(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider(create: (_) => di.sl<JobActionBloc>()),
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
                routerConfig: _appRouter.router,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  return BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthUnauthenticated) {
                        _appRouter.router.go('/login');
                      }
                    },
                    child: Stack(
                      children: [
                        if (child != null) child,
                        if (networkState is NetworkDisconnected)
                          const Positioned.fill(child: NoInternetScreen()),
                      ],
                    ),
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
