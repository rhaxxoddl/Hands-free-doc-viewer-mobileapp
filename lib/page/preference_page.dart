import 'package:flutter/material.dart';
import '../provider/preference_provider.dart';
import 'package:provider/provider.dart';
import '../components/preferenceSlider.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  late PreferenceProvider _preferenceProvider;

  @override
  void didChangeDependencies() {
    _preferenceProvider = Provider.of<PreferenceProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings),
        title: Text("Preference"),
      ),
      body: Column(
        children: [
          PreferenceSlider(
            inputValue: _preferenceProvider.PAGE_SCROLL_SPEED,
            inputOnchange: _preferenceProvider.changePageScrollSpeed,
            min: 0,
            max: 1000,
            title: "Page scroll speed",
          ),
          PreferenceSlider(
            inputValue: _preferenceProvider.EYE_TRACKING_DELAY,
            inputOnchange: _preferenceProvider.changeEyeTrackingDelay,
            min: 0,
            max: 3000,
            title: "Eye tracking delay time",
          ),
        ],
      ),
    );
  }
}
