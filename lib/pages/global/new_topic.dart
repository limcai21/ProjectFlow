import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:flutter/material.dart';

class NewTopic extends StatelessWidget {
  final String id;
  NewTopic({@required this.id});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final tTitleController = TextEditingController();

    submitForm() async {
      final isValid = formKey.currentState.validate();
      if (isValid) {
        Map result = await Firestore().createTopic(
          title: tTitleController.text,
          projectID: id,
        );
        normalAlertDialog(
          title: result['status'] ? 'Created!' : 'Error',
          description: result['data'],
          context: context,
          goBackTwice: result['status'] ? true : false,
          backResult: result['status'] ? 'reload' : null,
        );
      } else {
        return null;
      }
    }

    return CustomScaffold(
      layout: 2,
      title: 'New Topic',
      subtitle: 'Create topic to add task inside',
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tTitleController,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  suffixIcon: Icon(topic_icon),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return topicEmptyNull;
                  }
                  return null;
                },
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () => submitForm(),
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
