import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/core/routing/app_routes.dart';
import 'package:orders/core/styling/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: Text('Home', style: TextStyle(color: Colors.white)),
          leading: Container(),
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.all(8.sp),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.sp,
              mainAxisSpacing: 8.sp,
            ),
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Center(
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  context.pushNamed(AppRoutes.addOrderScreen);
                },
                child: Container(
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Center(
                    child: Text(
                      'Add Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
