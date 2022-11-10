import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBar() {
  User? user = FirebaseAuth.instance.currentUser;

  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: MyTheme.colorWhite,
    toolbarHeight: 82,
    elevation: 0,
    titleSpacing: 0,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${user!.displayName}',
              style: const TextStyle(color: MyTheme.colorBlue),
            ),
          ),
          // sign out button
          Consumer<AuthProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: () {
                  provider.signOut(context);
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                iconSize: 24,
                icon: const Icon(Icons.logout),
                color: MyTheme.colorCyan,
              );
            },
          ),
        ],
      ),
    ),
  );
}
