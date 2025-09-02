import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:webappnursingapp/Billing/Patientlist/addpatient.dart';
import 'package:webappnursingapp/Billing/Patientlist/patientlist.dart';
import 'package:webappnursingapp/Billing/Ready%20to%20Bill%20Encounter%20List.dart';
import 'package:webappnursingapp/Billing/encounterfinalization(MD).dart';
import 'package:webappnursingapp/Encounterslist/add%20encounter.dart';
import 'package:webappnursingapp/Encounterslist/addannotations.dart';
import 'package:webappnursingapp/Encounterslist/copyencounter.dart';
import 'package:webappnursingapp/Encounterslist/editencounter.dart';
import 'package:webappnursingapp/Encounterslist/encounterlist.dart';
import 'package:webappnursingapp/Login/Login.dart';
import 'package:webappnursingapp/Login/createpassword.dart';
import 'package:webappnursingapp/Login/originallogin.dart';
import 'package:webappnursingapp/Login/resetpassword.dart';
import 'package:webappnursingapp/Login/signup.dart';
import 'package:webappnursingapp/onboarding/outing.dart';
import 'package:webappnursingapp/usersettings.dart';
// Add other screens if needed

void main() {
  usePathUrlStrategy(); // 👈 Removes # from URLs
  runApp(const MyApp());
}

// ✅ Define GoRouter with custom base path
final _router = GoRouter(
  initialLocation: '/Voxlipi/login',
  routes: [

    GoRoute(
      path: '/',
      redirect: (context, state) => '/Voxlipi/login',
    ),
    GoRoute(
      path: '/Voxlipi/Web-Signup',
      builder: (context, state) => WebSignUpPage(),
    ),
    GoRoute(
      path: '/Voxlipi/login',
      builder: (context, state) => WebLoginPage(),
    ),
    GoRoute(
      path: '/Voxlipi/create-password',
      builder: (context, state) => CreatePasswordPage(),
    ),
    GoRoute(
      path: '/Voxlipi/Login',
      builder: (context, state) => LoginPage1(),
    ),
    GoRoute(
      path: '/Voxlipi/Reset-Password',
      builder: (context, state) => ResetPasswordPage(),
    ),
    GoRoute(
      path: '/Voxlipi/Ready-To-Bill',
      builder: (context, state) => ReadyToBillPage(),
    ),
    GoRoute(
      path: '/Voxlipi/Ready-To-Bill',
      builder: (context, state) => ReadyToBillPage(),
    ),
    GoRoute(
      path: '/Voxlipi/Add-Patient',
      builder: (context, state) => AddPatientPage(),
    ),
    GoRoute(
      path: '/Voxlipi/Patient-List',
      builder: (context, state) => PatientListScreen(),
    ),
    GoRoute(
      path: '/Voxlipi/Encounter-List',
      builder: (context, state) => EncounterListScreen(),
    ),
    GoRoute(
      path: '/Voxlipi/AddEncounter',
      builder: (context, state) => AddEncounterPage(),
    ),
    GoRoute(
      path: '/Voxlipi/EncounterFinalization',
      builder: (context, state) => EncounterFinalizationScreen(),
    ),
    GoRoute(
      path: '/Voxlipi/Settings',
      builder: (context, state) => UserSettingsPage(),
    ),
    GoRoute(
      path: '/Voxlipi/EditEncounter',
      builder: (context, state) => EditEncounterPage(),
    ),
    GoRoute(
      path: '/Voxlipi/CopyEncounter',
      builder: (context, state) => CopyEncounterScreen(),
    ),
    GoRoute(
      path: '/Voxlipi/AddAnnotation',
      builder: (context, state) => AddAnnotationScreen(),
    ),
    GoRoute(
      path: '/Voxlipi/Onboarding',
      builder: (context, state) => OnboardingForm(),
    ),

    // Add more routes here if needed
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Voxlipi',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
