import 'package:flutter/material.dart';
import 'package:utara_drive/themes/my_themes.dart';

class SwitchLayout extends StatefulWidget {
  const SwitchLayout(
      {super.key, this.isGrid = true, required this.changeLayout});
  final bool isGrid;

  final Function(bool isGrid) changeLayout;

  @override
  State<SwitchLayout> createState() => _SwitchLayoutState();
}

class _SwitchLayoutState extends State<SwitchLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => widget.changeLayout(true),
              child: Icon(
                Icons.grid_view_rounded,
                color:
                    widget.isGrid ? MyTheme.colorGrey : MyTheme.colorDarkerGrey,
                size: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => widget.changeLayout(false),
            child: Icon(
              Icons.list_rounded,
              color:
                  widget.isGrid ? MyTheme.colorDarkerGrey : MyTheme.colorGrey,
              size: 24,
            ),
          )
        ],
      ),
    );
  }
}
