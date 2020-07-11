import 'package:flutter/material.dart';

class ButtonCheckBoxGroup extends StatefulWidget {
  final List<String> buttonLables;
  final List buttonValuesList;
  final Function(List<dynamic>) checkBoxButtonValues;


  ButtonCheckBoxGroup(this.buttonLables, this.buttonValuesList, this.checkBoxButtonValues): assert(buttonLables.length == buttonValuesList.length);

  @override
  _ButtonCheckBoxGroupState createState() => _ButtonCheckBoxGroupState();
}

class _ButtonCheckBoxGroupState extends State<ButtonCheckBoxGroup> {

  List<dynamic> selectedLables = [];



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
          children: generateItems(),
          spacing: 10.0,
          runSpacing: 10.0,
          direction: Axis.horizontal,
      ),
    );
  }

  List<Widget> generateItems() {
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      buttons.add(item(index));
    }
    return buttons;
  }

  Widget item(int index) {
    return OutlineButton(
      child: Text('Batuk'),
      color: selectedLables.contains(widget.buttonValuesList[index])
          ? Colors.green
          : Colors.transparent,
      onPressed: () {
        if (selectedLables.contains(widget.buttonValuesList[index])) {
          selectedLables.remove(widget.buttonValuesList[index]);
        } else {
          selectedLables.add(widget.buttonValuesList[index]);
        }
        setState(() {});
        widget.checkBoxButtonValues(selectedLables);
      },
    );
  }
}
