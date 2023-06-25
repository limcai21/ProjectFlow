import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final tProjectController = TextEditingController();
    final tTopicController = TextEditingController();
    final tTitleController = TextEditingController();
    final tDescriptionController = TextEditingController();
    final tStartDateController = TextEditingController();
    // final tEndDateController = TextEditingController();

    return CustomScaffold(
      title: "New Task",
      subtitle: "Create task and add them to your project",
      layout: 2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROJECT
              CustomTextFormField(
                controller: tProjectController,
                labelText: 'Select Project',
                readOnly: true,
                validator: (val) => print("Project: " + val),
                onTap: () => simpleDialog(
                  title: "Select Project",
                  context: context,
                  children: [
                    simpleDialogOption(
                      child: Text("Project 1"),
                      onPressed: () => print("P1"),
                    ),
                    simpleDialogOption(
                      child: Text("Project 2"),
                      onPressed: () => print("P2"),
                    ),
                    simpleDialogOption(
                      child: Text("Project 3"),
                      onPressed: () => print("P3"),
                    )
                  ],
                ),
              ),
              // TOPIC
              CustomTextFormField(
                controller: tTopicController,
                // icon: FluentIcons.slide_multiple_24_regular,
                labelText: 'Select Topic',
                readOnly: true,
                validator: (val) => print("Topic: " + val),
                onTap: () => simpleDialog(
                  title: "Select Topic",
                  context: context,
                  children: null,
                ),
              ),
              // TITLE
              CustomTextFormField(
                controller: tTitleController,
                // icon: FluentIcons.slide_multiple_24_regular,
                labelText: 'Task',
                validator: (val) => print("Task: " + val),
              ),
              // DESCRIPTION
              CustomTextFormField(
                controller: tDescriptionController,
                // icon: task_icon,
                labelText: 'Description',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                maxLength: 100,
                validator: (val) => print("Task Description: " + val),
              ),

              // START DATE
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'dd MMM yyyy, h:mm a',
                controller: tStartDateController,
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 99),
                initialEntryMode: DatePickerEntryMode.input,
                errorFormatText: "Invalid format",
                // icon: Icon(Icons.event),
                dateLabelText: 'Start Date & Time',
                use24HourFormat: false,
                scrollPhysics: BouncingScrollPhysics(),
                validator: (val) {
                  if (val == "") {
                    return empty_fields;
                  } else {
                    print("Start Date & Time: " + val);
                    return null;
                  }
                },
              ),

              // END DATE

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print("Create Task");
                    }
                  },
                  child: Text('Create'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
