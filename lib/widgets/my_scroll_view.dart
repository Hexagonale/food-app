import 'package:flutter/material.dart';

class MyScrollView extends StatelessWidget {
  const MyScrollView({
    Key? key,
    required this.child,
    this.direction = Axis.vertical,
  }) : super(key: key);

  final Widget child;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: direction,
          child: ConstrainedBox(
            constraints: direction == Axis.vertical
                ? BoxConstraints(
                    minHeight: boxConstraints.maxHeight,
                  )
                : BoxConstraints(
                    minWidth: boxConstraints.maxWidth,
                  ),
            child: child,
          ),
        );
      },
    );
  }
}
