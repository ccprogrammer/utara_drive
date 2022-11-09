import 'dart:io';

import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class AddScreen extends StatefulWidget {
  const AddScreen(this.image, {super.key});
  final File image;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        Image.file(
          widget.image,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        _buildTextField(hint: 'Write a description...'),
        _buildTextField(hint: 'Add location'),
        _buildTextField(hint: 'Add tag'),
      ],
    );
  }

  Widget _buildTextField({String hint = 'Write a description...'}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
              maxLines: null,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: MyTheme.colorDarkerGrey,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyTheme.colorCyan,
      elevation: 0,
      title: const Text(
        'New Image',
      ),
      actions: [
        IconButton(
          onPressed: () {},
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.check,
          ),
          color: MyTheme.colorWhite,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
