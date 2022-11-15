import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class CustomTextField2 extends StatefulWidget {
  const CustomTextField2({
    super.key,
    this.controller,
    this.hint = 'Write a description...',
    this.inputAction = TextInputAction.newline,
    this.maxLines = 1,
    this.onEditingComplete,
  });
  final String hint;
  final TextEditingController? controller;
  final TextInputAction inputAction;
  final int? maxLines;
  final Function(String tag)? onEditingComplete;

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: MyTheme.colorDarkGrey,
          ),
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                maxLines: widget.maxLines,
                controller: widget.controller,
                style: const TextStyle(fontSize: 13, color: MyTheme.colorGrey),
                textInputAction: widget.inputAction,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: MyTheme.colorDarkerGrey,
                  ),
                ),
                onEditingComplete: () {
                  widget.onEditingComplete != null
                      ? widget.onEditingComplete!(widget.controller!.text)
                      : null;
                  FocusScope.of(context).unfocus();
                }),
          ),
        ],
      ),
    );
  }
}
