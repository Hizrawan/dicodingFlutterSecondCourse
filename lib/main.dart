import 'package:flutter/material.dart';
import 'package:restaurant_app/screen/home/home.dart';
import 'package:restaurant_app/stateful_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: 
      //HomeScreen(), //restaurant app
      const MyStatefulWidget() // untuk latihan lifecycle
    );
  }

 late final AppLifecycleListener _listener;

 @override
 void initstate(){
  super.initState();
  _listener = AppLifecycleListener(
    onDetach: () => debugPrint("AppLifecycleState.detached"),
    onInactive: () => debugPrint("AppLifecycleState.inactive"),
    onPause: () => debugPrint("AppLifecycleState.paused"),
    onResume: () => debugPrint("AppLifecycleState.resumed"),
    onRestart: () => debugPrint("AppLifecycleState.restarted")
    );
 }
 @override
 void dispose(){
  _listener.dispose();
  super.dispose();
 }
}