import 'dart:async';
import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      this.hintText = '',
      this.controller,
      this.obscureText = false,
      required this.label})
      : super(key: key);
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String label;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Timer? _debounce;

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: MyTheme.colorGrey,
              fontWeight: MyTheme.semiBold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: MyTheme.colorDarkGrey,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 45,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    obscureText: widget.obscureText ? isObscure : false,
                    decoration: InputDecoration.collapsed(
                      hintText: widget.hintText,
                    ),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 800), () {});
                    },
                  ),
                ),
                widget.obscureText
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
