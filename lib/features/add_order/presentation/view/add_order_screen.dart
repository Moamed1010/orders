import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:orders/core/routing/app_routes.dart';
import 'package:orders/core/styling/app_assets.dart';
import 'package:orders/core/widgets/custom_text_field.dart';
import 'package:orders/core/widgets/primay_button_widget.dart';
import 'package:orders/core/widgets/spacing_widgets.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _orderNameController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  // 👈 ضفنا Controller جديد عشان نعرض فيه العنوان اللي هيرجع من الخريطة
  final TextEditingController _addressController = TextEditingController();

  LatLng? orderLocation;
  LatLng? userLocation;
  DateTime? orderArrivalTime;

  @override
  void dispose() {
    _orderNameController.dispose();
    _orderIdController.dispose();
    _arrivalTimeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              // 👈 حطينا الـ Form هنا عشان الـ Validation يشتغل صح
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpace(20),
                  SizedBox(
                    width: 335.w,
                    child: Text(
                      'Add New Order',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const HeightSpace(8),
                  SizedBox(
                    width: 335.w,
                    child: Text(
                      'let\'s create a new order',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const HeightSpace(20),
                  Center(
                    child: Image.asset(
                      AppAssets.order,
                      height: 190.h,
                      width: 190.w,
                    ),
                  ),
                  const HeightSpace(32),

                  // Order ID
                  Text(
                    'Order ID',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const HeightSpace(8),
                  CustomTextField(
                    controller: _orderIdController,
                    hintText: 'Enter Order ID',
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an order ID';
                      return null;
                    },
                  ),
                  const HeightSpace(16),

                  // Order Name
                  Text(
                    'Order Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const HeightSpace(8),
                  CustomTextField(
                    controller: _orderNameController,
                    hintText: 'Enter Order Name',
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an order name';
                      return null;
                    },
                  ),
                  const HeightSpace(16),

                  // Arrival Time
                  Text(
                    'Arrival Time',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const HeightSpace(8),
                  CustomTextField(
                    readonly: true,
                    controller: _arrivalTimeController,
                    hintText: 'Enter Arrival Time',
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an arrival time';
                      return null;
                    },
                    onTap: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                        initialDate: DateTime.now(),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          orderArrivalTime = pickedDate;
                          String formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(orderArrivalTime!);
                          _arrivalTimeController.text = formattedDate;
                        }
                      });
                    },
                  ),
                  const HeightSpace(16),

                  // 👈 Order Location (العنوان النصي اللي راجع من الخريطة)
                  Text(
                    'Order Address',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const HeightSpace(8),
                  CustomTextField(
                    readonly: true,
                    controller: _addressController,
                    hintText: 'Select location from map',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select the order location';
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(25),

                  // زرار فتح الخريطة
                  PrimayButtonWidget(
                    buttonText: "Select Order Location",
                    icon: Icon(
                      Icons.location_pin,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                    onPress: () async {
                      // 👈 هنستقبل الـ Map اللي راجعة من الخريطة (اللي فيها الإحداثيات والعنوان)
                      final result = await context.push<Map<String, dynamic>>(
                        AppRoutes.placepickerScreen,
                      );

                      // لو الـ User اختار مكان وداس Confirm
                      if (result != null) {
                        setState(() {
                          orderLocation = result['location'] as LatLng;
                          _addressController.text =
                              result['address']
                                  as String; // بنحط العنوان في הـ TextField
                        });
                        log(
                          "Location: ${orderLocation!.latitude}, ${orderLocation!.longitude}",
                        );
                        log("Address: ${_addressController.text}");
                      }
                    },
                  ),
                  const HeightSpace(45),

                  // زرار إضافة الأوردر
                  PrimayButtonWidget(
                    buttonText: "Add Order",
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        // 👈 هنا تقدر تبعت الـ orderLocation و باقي الداتا للـ Backend
                        log(
                          "Ready to submit: ID: ${_orderIdController.text}, Name: ${_orderNameController.text}, Location: ${_addressController.text}, Arrival Time: ${_arrivalTimeController.text}",
                        );
                      }
                    },
                  ),
                  const HeightSpace(25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
