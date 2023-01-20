import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notesbytes/screen/HomeScreen.dart';

class Splacescreen extends StatefulWidget {
  @override
  State<Splacescreen> createState() => _SplacescreenState();
}
class _SplacescreenState extends State<Splacescreen> {
  @override
  delayscreen(){
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    delayscreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("img/large_notebyte.png"),
      ),
    );
  }
}
