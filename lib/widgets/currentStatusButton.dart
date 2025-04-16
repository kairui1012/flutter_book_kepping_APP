import 'package:flutter/material.dart';

import '../ultis/color.dart';

class CurrentStatusButton extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;

  const CurrentStatusButton({
    super.key,
    required this.title,
    required this.value,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: border,
            ),
            color: gray60,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: gray40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 65,
          height: 1.5,
          color: statusColor,
        ),
      ],
    );
  }
}