import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timer/background_service.dart';
import 'package:timer/ui/timer.dart';

void main() {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterBackgroundService.initialize(onStart);
  } else {
    onStart();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Flutter Timer',
      home: TimerView(),
    );
  }
}
