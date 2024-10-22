import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextFormField extends HookWidget {
  CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    required this.keyboardType,
    required this.validator,
    // required this.icon,
    required this.onChanged,
  });

  final TextEditingController? controller;
  bool isPassword;
  final String label;
  final String hintText;
  //final String icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> obscureTextNotifier = useState(isPassword);
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox(
        height: 78,
        child: Stack(
          children: [
            TextFormField(
              onChanged: onChanged,
              keyboardType: keyboardType,
              validator: validator,
              obscureText: obscureTextNotifier.value,
              decoration: InputDecoration(
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: () {
                          obscureTextNotifier.value =
                              !obscureTextNotifier.value;
                        },
                        icon: Icon(
                          obscureTextNotifier.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      )
                    : null,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
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
              controller: controller,
            ),
            Align(
              alignment: const Alignment(0, -1.9),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                color: Colors.white,
                child: Row(
                  children: [
                    // Image.asset(icon),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(label,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
