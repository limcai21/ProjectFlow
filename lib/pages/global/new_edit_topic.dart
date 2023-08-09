import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewEditTopic extends StatefulWidget {
  final String id;
  final bool edit;
  final Topic topicData;
  final Color bg;
  NewEditTopic(
      {@required this.id, @required this.edit, this.topicData, this.bg});

  @override
  State<NewEditTopic> createState() => _NewEditTopicState();
}

class _NewEditTopicState extends State<NewEditTopic> {
  var formKey = GlobalKey<FormState>();
  final tTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.edit) {
      var data = widget.topicData;
      tTitleController.text = data.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    submitForm() async {
      final isValid = formKey.currentState.validate();
      if (isValid) {
        loadingCircle(context: context);
        if (widget.edit) {
          Map result = await Firestore().updateTopic(
            title: tTitleController.text,
            id: widget.topicData.id,
          );
          Get.back();
          normalAlertDialog(
            title: result['status'] ? 'Updated!' : alertErrorTitle,
            description: result['data'],
            context: context,
            goBackTwice: result['status'] ? true : false,
            backResult: result['status'] ? 'reload' : null,
          );
        } else {
          Map result = await Firestore().createTopic(
            title: tTitleController.text,
            projectID: widget.id,
          );
          Get.back();
          normalAlertDialog(
            title: result['status'] ? 'Created!' : alertErrorTitle,
            description: result['data'],
            context: context,
            goBackTwice: result['status'] ? true : false,
            backResult: result['status'] ? 'reload' : null,
          );
        }
      } else {
        return null;
      }
    }

    return CustomScaffold(
      layout: 2,
      title: widget.edit ? 'Edit Topic' : 'New Topic',
      backgroundColor: widget.bg ?? Theme.of(context).primaryColor,
      subtitle: widget.edit
          ? 'Make some adjustment to your topic'
          : 'Create topic to add task inside',
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
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
                    child: Text(widget.edit ? 'Update' : 'Create'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        widget.bg ?? Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
