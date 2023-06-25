import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final List<Widget> actionBtn;
  final String backgroundColor;
  final int layout;

  CustomScaffold({
    @required this.title,
    this.subtitle,
    @required this.body,
    this.actionBtn,
    this.backgroundColor,
    @required this.layout,
  });

  titleWidget(title, context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: Theme.of(context).textTheme.headline6.fontSize,
      ),
    );
  }

  // NORMAL SCAFFOLD
  scaffoldLayout(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        title: Text(title),
        actions: actionBtn,
      ),
      body: body,
    );
  }

  // CUSTOM SCAFFOLD
  scaffoldLayout2(context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: actionBtn,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            color: backgroundColor != null
                ? backgroundColor
                : Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget(title, context),
                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[300]),
                  )
                ]
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (layout.toString()) {
      case "1":
        {
          return scaffoldLayout(context);
        }
        break;
      case "2":
        {
          return scaffoldLayout2(context);
        }
        break;

      default:
        {
          return scaffoldLayout(context);
        }
    }
  }
}
