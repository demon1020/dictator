import 'package:flutter/material.dart';

class AppExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final Color tileColor;
  final bool isExpanded;
  final Color iconColor;
  final GestureTapCallback onTap;

  const AppExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.isExpanded = false,
    this.tileColor = Colors.white,
    this.iconColor = Colors.black,
    required this.onTap,
  }) : super(key: key);

  @override
  _AppExpansionTileState createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: widget.onTap,
          tileColor: widget.tileColor,
          title: widget.title,
          trailing: IconButton(
            color: widget.iconColor,
            iconSize: 30,
            icon: Icon(widget.isExpanded
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
            onPressed: widget.onTap,
          ),
        ),
        Visibility(
          visible: widget.isExpanded,
          child: Column(
            children: widget.children,
          ),
        )
      ],
    );
  }
}
