import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dictapp/favorites.dart' as favPage;
import 'package:dictapp/history.dart' as historyPage;

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
      home: MyHomePage(title: 'Dictionary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sonuc = "";
  List result = new List();
  ListView listView = ListView();
  final word = new TextEditingController();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(100, 0, 100, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoImageWidget(),
              TextField(
                controller: word,
                decoration: InputDecoration(
                  hintText: "Kelime Giriniz / Enter Word",
                  contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              Text(
                '',
                style: optionStyle,
              ),
              Text(
                '',
                style: optionStyle,
              ),
              RaisedButton(
                onPressed: () {
                  _translate(word.text);
                },
                child: Text("Çevir / Translate"),
                textColor: Colors.white,
                color: Colors.blueGrey[800],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              Expanded(child: listView,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[900],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        navigateToMyHomePage(context);
      }
      if (index == 2) {
        navigateToMyHomePages(context);
      }
    });
  }
    _translate(String word) async {
    String url =
        "https://dictionaryapplication.azurewebsites.net/api/word";
    url = url + "/" + word;
        var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
    });
    print(response);
    setState(() {
      result = json.decode(response.body);
      listView = _myListView(context, result, word);
    });
  }
}

Future navigateToMyHomePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => historyPage.SubPage()));
}

Future navigateToMyHomePages(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => favPage.SubPage()));
}

class LogoImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage logoAsset = AssetImage("images/dict.jpg");
    Image image = Image(
      image: logoAsset,
      width: 400.0,
      height: 350.0,
    );
    return Container(child: image);
  }
}

Widget _myListView(BuildContext context, List wordList, String word) {
  if (word != null && wordList.length > 0) {
    return ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        if (word == wordList[index]["wordEn"]) {
          return ListTile(
              title: Text(wordList[index]["wordTr"],
                  textAlign: TextAlign.center));
        } else {
          return ListTile(

              title: Text(" TR -> EN    "+wordList[index]["wordEn"],
                  textAlign: TextAlign.center));
        }
      },
    );
  } else {
    return ListView(children: <Widget>[
      ListTile(
          title: Text("KELİME SÖZLÜKTE BULUNAMADI \n WORD NOT FOUND IN DICTIONARY.",
              textAlign: TextAlign.center)),
    ]);
  }
}
