import 'package:flutter/material.dart';
import '../provider/preference_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class PreferenceSlider extends StatefulWidget {
  PreferenceSlider(
      {Key? key,
      required this.inputValue,
      required this.inputOnchange,
      required this.min,
      required this.max,
      required this.title})
      : super(key: key);
  final int inputValue;
  final Function(int) inputOnchange;
  final double min;
  final double max;
  final String title;

  @override
  State<PreferenceSlider> createState() => _PreferenceSliderState();
}

class _PreferenceSliderState extends State<PreferenceSlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              widget.title,
              style: tPreferenceTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                    value: widget.inputValue.toDouble(),
                    label: "eye tracking delay time",
                    min: widget.min,
                    max: widget.max,
                    onChanged: (newValue) {
                      widget.inputOnchange(newValue.toInt());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Container(
                  width: 40.0,
                  child: Text('${widget.inputValue}'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
