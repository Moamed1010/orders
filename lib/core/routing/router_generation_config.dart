import 'package:go_router/go_router.dart';
import 'package:orders/core/routing/app_routes.dart';
import 'package:orders/features/add_order/presentation/view/add_order_screen.dart';
import 'package:orders/features/add_order/presentation/view/place_picker_screen.dart';
import 'package:orders/features/auth/presentation/views/login_screen.dart';
import 'package:orders/features/auth/presentation/views/register_screen.dart';
import 'package:orders/features/home_screen/home_screen.dart';
import 'package:orders/features/splash_screen/splash_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder: (context, state) => const AddOrderScreen(),
      ),
      
      GoRoute(
        name: AppRoutes.placepickerScreen,
        path: AppRoutes.placepickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),

    ],
  );
}
