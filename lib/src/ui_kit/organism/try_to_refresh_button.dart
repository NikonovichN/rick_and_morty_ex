import 'package:flutter/material.dart';

class TryToRefreshButton extends StatelessWidget {
  static const _text = 'Try to refresh';
  final void Function()? onPressed;

  const TryToRefreshButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(colorScheme.primary)),
        onPressed: onPressed,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: colorScheme.onPrimary),
          child: Text(_text),
        ),
      ),
    );
  }
}
