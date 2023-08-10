import 'package:flutter/material.dart';

class CustomBottomSheet {
  const CustomBottomSheet(this.child);

  const CustomBottomSheet.loading()
      : child = const Center(child: CircularProgressIndicator());

  final Widget child;

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
