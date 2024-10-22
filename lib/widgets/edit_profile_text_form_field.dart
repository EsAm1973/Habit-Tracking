import 'package:flutter/material.dart';

class EditProfileTextFormField extends StatelessWidget {
  const EditProfileTextFormField({
    super.key,
    // required this.initialValue,
    required this.dataKey,
  });

  // final String initialValue;
  final String dataKey;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {

      },
      //initialValue: initialValue,
      style: const TextStyle(
          color: Color(0xff5C5C5C), fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: dataKey,
        hintStyle: const TextStyle(
            color: Color(0xff5C5C5C),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color(0xffE9E9E9),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color(0xffE9E9E9),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color(0xffE9E9E9),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
