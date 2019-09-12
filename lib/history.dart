import 'package:dictapp/main.dart';
import 'package:flutter/material.dart';
class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Click button to back to Search Page'),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blueGrey[800],
              child: Text('Back to Search Page'),
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            )
          ],
        ),
      ),
    );
  }
}