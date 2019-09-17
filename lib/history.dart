import 'package:dictapp/main.dart' as mainPage;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHistoryPage(
        title: 'History',
      ),
    );
  }
}

class MyHistoryPage extends StatefulWidget {
  MyHistoryPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHistoryPageState createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  ListView listView = ListView();
  List<String> historyWord = new List<String>();

  @override
  Widget build(BuildContext context) {
    getFromHistory().then((value) => setState(() {
          historyWord = value;
          String word;
          listView = _myListView(context, historyWord, word);
        }));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.purple[900],
            onPressed: () {},
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
          ),
        ],
        title: Text("History"),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Click button to back to Search Page'),
            Text(
                //controller: key,
                historyWord != null && historyWord.length > 0
                    ? historyWord[0]
                    : "history empty"),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.orange,
              child: Text('Back to Search Page'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainPage.MyApp()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getFromHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool CheckValue = prefs.('value');
    //setState(() {
    return prefs.getStringList("history").cast<String>();
    //.});
  }
}

Widget _myListView(BuildContext context, List wordList, String word) {
  return ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        // if (word == wordList[index]["wordEn"]) {
        //   return ListTile(
        //       title:
        //           Text(wordList[index]["wordEn"], textAlign: TextAlign.center));
        // } else {
        return ListTile(
            title:
                Text(wordList[index]["wordEn"], textAlign: TextAlign.center));
      });
}
