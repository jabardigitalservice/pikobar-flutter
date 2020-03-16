// import 'package:fancy_on_boarding/fancy_on_boarding.dart';
// import 'package:flutter/material.dart';
// import 'package:sapawarga/repositories/AuthRepository.dart';
// import 'package:sapawarga/screens/onBoarding/OnboardingData.dart';

// class OnBoardingScreen extends StatefulWidget {
//   final AuthRepository authRepository = AuthRepository();
//   @override
//   _OnBoardingScreenState createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FancyOnBoarding(
//         doneButtonText: "Selesai",
//         skipButtonText: "Lewati",
//         pageList: OnBoardingData.onboardingList,
//         onDoneButtonPressed: _finish,
//         onSkipButtonPressed: _finish,
//       ),
//     );
//   }

//   _finish() async {
//     await widget.authRepository.setOnboarding();
//     Navigator.of(context).pop();
//   }
// }
