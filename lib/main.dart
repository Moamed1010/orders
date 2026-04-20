import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // استيراد البلوك
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orders/core/routing/router_generation_config.dart';
import 'package:orders/core/styling/theme_data.dart';
import 'package:orders/firebase_options.dart';

import 'package:orders/core/di/service_locator.dart' as di; 
// استيراد الكيوبت
import 'package:orders/features/auth/presentation/manger/auth/auth_cubit.dart'; 

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  
  await di.init(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // التعديل هنا: غلفنا التطبيق بـ MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp.router(
          title: "Orders",
          theme: AppThemes.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: RouterGenerationConfig.goRouter,
        ),
      ),
    );
  }
}