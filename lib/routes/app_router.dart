import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/jobs/presentation/screens/job_map_screen.dart';
import '../features/service_update/presentation/screens/service_update_screen.dart';
import '../features/profile/presentation/screens/service_history_screen.dart';
import '../features/profile/presentation/screens/help_support_screen.dart';
import '../features/profile/presentation/screens/delete_account_screen.dart';
import '../features/profile/presentation/screens/earnings_screen.dart';
import '../features/notification/presentation/screens/notifications_screen.dart';
import '../shared/widgets/main_navigation_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final SharedPreferences sharedPreferences;

  AppRouter(this.sharedPreferences);

  late final GoRouter router = GoRouter(
    initialLocation: _getInitialLocation(),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/job-map',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return JobMapScreen(
            jobId: extra['jobId'] ?? '#UNK',
            title: extra['title'] ?? 'Job Location',
          );
        },
      ),
      GoRoute(
        path: '/service-update',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ServiceUpdateScreen(
            jobDbId: extra['jobDbId'] ?? 0,
            jobId: extra['jobId'] ?? '#UNK',
            customerName: extra['customerName'] ?? 'Unknown',
            serviceName: extra['serviceName'] ?? 'Unknown',
            statusLabel: extra['statusLabel'] ?? 'Unknown',
          );
        },
      ),
      GoRoute(
        path: '/service-history',
        builder: (context, state) => const ServiceHistoryScreen(),
      ),
      GoRoute(
        path: '/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/delete-account',
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    redirect: (context, state) {
      final hasSeenOnboarding = sharedPreferences.getBool(AppConstants.onboardingCompleteKey) ?? false;
      final token = sharedPreferences.getString(AppConstants.tokenKey);
      final isLoggedIn = token != null && token.isNotEmpty;
      
      final isGoingToOnboarding = state.uri.toString() == '/onboarding';
      final isGoingToLogin = state.uri.toString() == '/login';

      if (!hasSeenOnboarding && !isGoingToOnboarding) {
        return '/onboarding';
      }

      if (hasSeenOnboarding) {
        if (!isLoggedIn && !isGoingToLogin) {
          return '/login';
        }
        if (isLoggedIn && (isGoingToLogin || isGoingToOnboarding)) {
          return '/dashboard';
        }
      }
      
      return null;
    },
  );

  String _getInitialLocation() {
    final hasSeenOnboarding = sharedPreferences.getBool(AppConstants.onboardingCompleteKey) ?? false;
    if (!hasSeenOnboarding) return '/onboarding';
    
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    final isLoggedIn = token != null && token.isNotEmpty;
    if (isLoggedIn) return '/dashboard';
    
    return '/login';
  }
}

