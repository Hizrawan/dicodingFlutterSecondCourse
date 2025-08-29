
// file ini untuk latihan lifecycle
import 'package:flutter/material.dart';
import 'package:restaurant_app/stateless_widget.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
  });

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _counter = 0;

  @override 

  void initState() {
    super.initState();
    debugPrint("initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("didChangeDependencies");
  }

  @override
  void didUpdateWidget(covariant MyStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    debugPrint("setState");
  }
  
  @override
  void dispose() {
    debugPrint("dispose");
    super.dispose();
  }
  

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _nextPage() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MyStatelessWidget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Lifecycle App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: _incrementCounter,
              icon: const Icon(Icons.add),
              label: Text("Add this number ($_counter)"),
            ),
            const SizedBox.square(dimension: 20),
            OutlinedButton.icon(
              onPressed: _nextPage,
              icon: const Icon(Icons.next_plan_outlined),
              label: const Text("Replace page to other page"),
            ),
          ],
        ),
      ),
    );
  }
}