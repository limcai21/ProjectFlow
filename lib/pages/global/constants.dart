import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

const empty_fields = "Field cannot be empty";
const something_wrong_validation = "Something wrong with validation";
const project_icon = FluentIcons.dock_panel_left_24_regular;
const task_icon = FluentIcons.note_24_regular;

// COMPANY
const app_brief_long =
    "Experience seamless task management with ProjectFlow, the intuitive app that empowers you to create, organize, and track your tasks effortlessly. Stay on top of your schedule with smart reminders and due dates. Boost productivity and achieve your goals with ease. Let ProjectFlow guide your projects from start to finish, making task management a breeze.";
const company_number = "+65 64515115";
const company_feedback_email = "feedback@arnet.com.sg";
const company_name = "arnet";
const company_developer = 'Lim Cai';
const company_website = "arnet.com.sg";

// PROJECT
const project_existed = 'Project exists. Please try another name';

const color_list = [
  {'title': 'Aqua', 'hex': 0xFF00FFFF},
  {'title': 'Black', 'hex': 0xFF000000},
  {'title': 'Blue', 'hex': 0xFF0000FF},
  {'title': 'Fuchsia', 'hex': 0xFFFF00FF},
  {'title': 'Gray', 'hex': 0xFF808080},
  {'title': 'Green', 'hex': 0xFF008000},
  {'title': 'Lime', 'hex': 0xFF00FF00},
  {'title': 'Maroon', 'hex': 0xFF800000},
  {'title': 'Navy', 'hex': 0xFF000080},
  {'title': 'Olive', 'hex': 0xFF808000},
  {'title': 'Purple', 'hex': 0xFF800080},
  {'title': 'Red', 'hex': 0xFFFF0000},
  {'title': 'Silver', 'hex': 0xFFC0C0C0},
  {'title': 'Teal', 'hex': 0xFF008080},
  {'title': 'Yellow', 'hex': 0xFFFFFF00},
];

int getHexValue(String colorTitle) {
  for (var color in color_list) {
    if (color['title'] == colorTitle) {
      return color['hex'];
    }
  }
  return null;
}

class CustomLeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double t;
  final double borderRadius;
  final Color iconColor;
  CustomLeadingIcon({
    @required this.icon,
    @required this.color,
    @required this.t,
    this.borderRadius,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.lerp(Colors.white, color, t),
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
      ),
      child: Icon(
        icon,
        size: 24,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final IconData trailingIcon;
  final Color bgColor;
  final Function onTap;
  final double t;
  final double borderRadius;

  CustomListTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.trailingIcon,
    this.iconColor,
    this.borderRadius,
    @required this.bgColor,
    this.onTap,
    @required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Icon(trailingIcon, size: 18),
      leading: CustomLeadingIcon(
        color: bgColor,
        iconColor: iconColor,
        icon: icon,
        t: t,
        borderRadius: borderRadius,
      ),
      onTap: onTap,
    );
  }
}

class ListViewHeader extends StatelessWidget {
  final title;
  ListViewHeader({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(String value) validator;
  final String initalValue;
  final IconData icon;
  final String hintText;
  final Function onTap;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int maxLength;
  final TextInputType keyboardType;
  final Function(String value) onChanged;

  CustomTextFormField({
    this.controller,
    this.labelText,
    this.validator,
    this.initalValue = '',
    this.icon,
    this.hintText,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    controller.text = initalValue;
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      maxLength: maxLength,
      onChanged: (v) => onChanged(v),
      // initialValue: initalValue,
      decoration: InputDecoration(
        suffixIcon: Icon(icon),
        enabled: enabled,
        hintText: hintText,
        labelText: labelText,
      ),
      validator: (value) {
        if (!readOnly) {
          if (value == null || value.isEmpty) {
            return empty_fields;
          } else {
            return validator(value);
          }
        }
        return null;
      },
    );
  }
}

simpleDialog({
  @required String title,
  @required BuildContext context,
  @required List<Widget> children,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        title: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Text(title, style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        children: children,
      );
    },
  );
}

simpleDialogOption({
  @required Widget child,
  @required Function onPressed,
}) {
  return SimpleDialogOption(
    child: child,
    onPressed: () => onPressed(),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  );
}

int getColorHex(String title) {
  int temp = 0;
  color_list.forEach((element) {
    if (element['title'] == title) {
      temp = element['hex'];
    }
  });

  return temp;
}
