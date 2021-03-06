import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timer/constants.dart';

/// This is the MAIN function that handles the logic of the background service
///
/// Use all the logic inside this `onStart()` function
///
/// Set any actions you want with a string and enum combination
/// And define what has to be done when you recieve that action in the
/// `service.onDataRecieved()` listener.
///
/// You can send the reply to the UI by using `service.sendData()`
/// with as a Map (JSON)
///

/// We are defining two streams for the case of normal operation without the
/// background service:
///
/// 1. `uiToBusinessLogic` is a stream for the UI to talk to the business logic
/// 2. `businessLogicToUI` is a stream for the business logic to talk to the UI
///
///
/// A simple solution is to make them global but it's probably not the best way
StreamController<Map<String, dynamic>> uiToBusinessLogic = StreamController();
StreamController<Map<String, dynamic>> businessLogicToUI = StreamController();
int seconds = 0;
bool isPaused = false;
bool hasStarted = false;

void onStart() {
  /// By checking the platform we make the necessary declarations
  /// and intialisations.
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();

    /// Bring to foreground at the start
    service.setForegroundMode(true);

    /// This code sets the notification content
    service.setNotificationInfo(
      title: "Timer",
      content: "Timer is running in the background",
    );

    /// This is the main listener that listens to commands from the UI
    /// and sends replies
    service.onDataReceived.listen((event) async {
      timerLogic(event, service);
    });
  } else {
    /// This is the main listener that listens to commands from the UI
    /// and sends replies without using the background service
    uiToBusinessLogic.stream.listen((event) {
      timerLogic(event, businessLogicToUI);
    });
  }
}

/// This is the common logic that sends the seconds
void timerLogic(event, service) {
  /// 1. Action to start the TIMER
  if (event!["action"] == actionToString[actions.start]) {
    hasStarted = true;
    isPaused = false;

    /// This is run every second sending the seconds to UI

    Timer.periodic(Duration(seconds: 1), (timer) async {
      /// TIMER logic to cancel is its started, and to increment
      /// the counter only if it is not paused
      if (!hasStarted) {
        timer.cancel();
      } else if (!isPaused) seconds += 1;

      sendDataBack(service);
    });
  }

  /// 2. Action to stop the TIMER
  else if (event["action"] == actionToString[actions.stop]) {
    seconds = 0;
    hasStarted = false;
    isPaused = true;
  }

  /// 3. Action to pause the TIMER
  else if (event["action"] == actionToString[actions.pause]) {
    isPaused = true;
  }

  /// 4. Action to play the TIMER
  else if (event["action"] == actionToString[actions.play]) {
    isPaused = false;
  }

  /// 5. Action to reset the TIMER
  else if (event["action"] == actionToString[actions.reset]) {
    seconds = 0;
  }

  /// This is to update the UI with the status of `hasStarted` and `isPaused`
  sendDataBack(service);
}

/// A common method to send the data back to the respective streams
void sendDataBack(service) {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    service.sendData(
      {"seconds": seconds, "hasStarted": hasStarted, "isPaused": isPaused},
    );
  } else {
    service.add(
      {"seconds": seconds, "hasStarted": hasStarted, "isPaused": isPaused},
    );
  }
}
