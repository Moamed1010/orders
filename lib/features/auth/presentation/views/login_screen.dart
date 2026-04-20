import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/core/routing/app_routes.dart';
import 'package:orders/core/styling/app_assets.dart';
import 'package:orders/core/styling/app_colors.dart';
import 'package:orders/core/styling/app_styles.dart';
import 'package:orders/core/widgets/custom_text_field.dart';
import 'package:orders/core/widgets/primay_button_widget.dart';
import 'package:orders/core/widgets/spacing_widgets.dart';
import 'package:orders/features/auth/presentation/manger/auth/auth_cubit.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Form(
              key: formKey,
           
              child: BlocConsumer<AuthCubit, AuthState>(
               
                listener: (context, state) {
                  if (state is AuthFailure) {
                    AnimatedSnackBar.material(
                      state.message,
                      type: AnimatedSnackBarType.error,
                    ).show(context);
                  } else if (state is AuthSuccess) {
                    AnimatedSnackBar.material(
                      'Login successfully',
                      type: AnimatedSnackBarType.success,
                    ).show(context);

                  
                    context.pushReplacementNamed(AppRoutes.homeScreen);
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(28),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "Login To Your Account",
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                      ),
                      const HeightSpace(8),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "it's great to see you again",
                          style: AppStyles.grey12MediumStyle,
                        ),
                      ),
                      const HeightSpace(20),
                      Center(
                        child: Image.asset(
                          AppAssets.order,
                          width: 190.w,
                          height: 190.w,
                        ),
                      ),
                      const HeightSpace(32),
                      Text("Email", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: email,
                        hintText: "Enter Your Email",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Email";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(16),
                      Text("Password", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        hintText: "Enter Your Password",
                        controller: password,
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: AppColors.greyColor,
                          size: 20.sp,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(55),

                      
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : PrimayButtonWidget(
                              buttonText: "Sign in",
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                 
                                  context.read<AuthCubit>().login(
                                    email: email.text.trim(),
                                    password: password.text,
                                  );
                                }
                              },
                            ),

                      const HeightSpace(24),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.pushReplacementNamed(AppRoutes.registerScreen);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: AppStyles.black16w500Style.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text: "Join",
                                  style: AppStyles.black15BoldStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const HeightSpace(16),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
