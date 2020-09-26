import 'package:flutter/cupertino.dart';

class OptionsWidget extends StatelessWidget {
  final VoidCallback onTap;

  OptionsWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Icon(CupertinoIcons.ellipsis),
    );
  }
}
