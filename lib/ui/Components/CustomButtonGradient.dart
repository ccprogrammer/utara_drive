import 'package:flutter/material.dart';

class Custombutton extends StatefulWidget {
  const Custombutton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.textColor = Colors.white,
    this.elevation = 0,
    this.isLoading = false,
    this.gradient = const [
      Color(0xff56CCF2),
      Color(0xff2F80ED),
    ],
    this.radius = 0,
  }) : super(key: key);
  final String label;
  final Function onPressed;
  final bool isLoading;

  final Color textColor;
  final double elevation;
  final List<Color> gradient;
  final double radius;

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.3, 1],
          colors: widget.gradient,
        ),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.grey.withOpacity(0.6),
                ),
              )
            : Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
      ),
    );
  }
}
