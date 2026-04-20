import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orders/core/styling/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final double? width;
  final bool? isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.width,
    this.isPassword,
    this.controller,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // المتغير ده هيتحكم في إظهار أو إخفاء النص (في البداية مخفي)
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 331.w,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        autofocus: false,
        
        // هنا بنقول: لو هو باسورد استخدم المتغير، لو مش باسورد خليه false دايماً (عشان يظهر عادي)
        obscureText: widget.isPassword == true ? _isObscured : false,
        
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText ?? "",
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: const Color(0xff8391A1),
            fontWeight: FontWeight.w500,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: const Color(0xffF7F8F9),
          
          // هنا السحر: لو ده باسورد هنعمل أيقونة بتغير حالتها.. لو لأ، هنعرض الأيقونة العادية اللي إنت باعتها
          suffixIcon: widget.isPassword == true
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xff8391A1), // نفس لون الـ hint عشان يبقى متناسق
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured; // بنعكس الحالة لما يدوس
                    });
                  },
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}