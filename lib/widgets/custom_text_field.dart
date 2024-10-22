import 'package:flutter/material.dart';

Widget customTextFormField({
  required TextEditingController controller,
  required String labelText,
  String? hintText,
  bool obscureText = false,
  IconButton? suffixIcon,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  double? width,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isTablet =
          constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
      bool isDesktop = constraints.maxWidth >= 1024;

      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
            fontSize: isDesktop ? 20 : (isTablet ? 18 : 16),
          ),
          hintStyle: TextStyle(
            fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: isDesktop || isTablet ? 20 : 16,
            horizontal: isDesktop || isTablet ? 20 : 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              width: isDesktop || isTablet ? 2 : 1,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        onChanged: onChanged,
      );
    },
  );
}
