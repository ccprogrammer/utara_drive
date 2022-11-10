import 'package:utara_drive/themes/my_themes.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget searchAppBar() {
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
          // search button
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: MyTheme.colorCyan,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
              ),
              child: Image.asset(
                'assets/icons/icon_search.png',
                width: 18,
                height: 18,
                color: MyTheme.colorWhite,
              ),
            ),
          ),

          // search field
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                border: Border.all(
                  width: 1,
                  color: MyTheme.colorGrey,
                ),
              ),
              height: 48,
              child: Center(
                child: TextFormField(
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: MyTheme.colorDarkGrey)),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
