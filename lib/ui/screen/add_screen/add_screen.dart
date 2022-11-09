import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/add_image_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_text_field2.dart';

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
    return Consumer<AddImageProvider>(
      builder: (context, provider, _) {
        return ListView(
          children: [
            Image.file(
              widget.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 24),
            CustomTextField2(
              hint: 'Write a description...',
              controller: provider.descriptionC,
              maxLines: null,
            ),
            CustomTextField2(
              hint: 'Add location',
              controller: provider.locationC,
              inputAction: TextInputAction.next,
            ),
            if (provider.tagList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Wrap(
                  spacing: 16,
                  children: [
                    for (var tag in provider.tagList)
                      Chip(
                        backgroundColor: MyTheme.colorGrey,
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.colorBlack.withOpacity(0.6),
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        deleteIconColor: MyTheme.colorRed,
                        onDeleted: () => provider.deleteTag(tag),
                        deleteIcon: Icon(
                          Icons.close,
                          color: MyTheme.colorRed.withOpacity(0.6),
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            CustomTextField2(
              hint: 'Add tag',
              controller: provider.tagC,
              inputAction: TextInputAction.done,
              onEditingComplete: (tag) => provider.addTag(),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: MyTheme.colorCyan,
      elevation: 0,
      iconTheme: const IconThemeData(color: MyTheme.colorWhite),
      title: const Text(
        'New Image',
        style: TextStyle(
          color: MyTheme.colorWhite,
        ),
      ),
      actions: [
        Consumer<AddImageProvider>(
          builder: (context, provider, _) {
            return IconButton(
              onPressed: () {
                provider.addImage();
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.check,
              ),
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
