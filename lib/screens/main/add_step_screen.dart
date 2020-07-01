import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStepScreen extends StatefulWidget {
  static String id = "add_step_screen";
  @override
  _AddStepScreenState createState() => _AddStepScreenState();
}

class _AddStepScreenState extends State<AddStepScreen> {
  final TextEditingController textController = TextEditingController();
  final _stepKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _pr = Provider.of<MissionData>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Steps",
              style: TextStyle(color: Colors.black),
            ),
            FlatButton(
              onPressed: () async {
                await MissionBrain()
                    .addStepToDatabase(_pr.stepsList, _pr.textMission);
                _pr.stepsList.clear();
                Navigator.pop(context);
              },
              child: Text(
                "Add Steps",
                style: TextStyle(color: kBlueLaserColor, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: _pr.stepsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${_pr.stepsList[index].index}."),
                subtitle: Text(
                  _pr.stepsList[index].text,
                  style: TextStyle(fontSize: 18.0),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 25.0,
                  ),
                  onPressed: () {
                    _pr.removeStep(index);
                  },
                ),
              );
            },
          )),
          Form(
            key: _stepKey,
            child: TextFormField(
              controller: textController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please Enter something";
                }
                return null;
              },
              onChanged: (String value) {
                _pr.getStepText(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.20),
                hintText: "Write steps Here",
                suffixIcon: IconButton(
                  onPressed: () {
                    if (_stepKey.currentState.validate()) {
                      print(_pr.stepText);
                      _pr.addStep();
                      textController.clear();
                    }
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 30.0,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
