import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dictapp/favorites.dart' as favPage;
import 'package:dictapp/favorites.dart' as mainPage;
import 'package:dictapp/history.dart' as historyPage;
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
  List<String> historyList = new List<String>();

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
          padding: EdgeInsets.fromLTRB(50, 30, 60, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoImageWidget(),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                  controller: word,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 2.0,
                      ),
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
              FloatingActionButton(
                backgroundColor: Colors.deepPurple[400],
                onPressed: () {
                  _translate(word.text);
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Expanded(
                child: listView,
              ),
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
      if (index == 0) {
        navigateToMyHomePage(context);
      }
      if (index == 1) {
        navigateToMyHomePages(context);
      }
      if (index == 2) {
        navigateToMyHomePagess(context);
      }
    });
  }

  _translate(String word) async {
    String url = "http://localhost:57170/api/word";
    url = url + "/" + word;
    url=Uri.encodeFull(url);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
    });
    print(response);
    getFromHistory().then((value) => setState(() {
          historyList = value;
          result = json.decode(response.body);
          listView = _myListView(context, result, word);
          historyList.add(word);
          addToHistory(historyList);
        }));
  }
}

Future navigateToMyHomePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => mainPage.MyApp()));
}

Future navigateToMyHomePages(context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => historyPage.MyHistoryPage()));
}

Future navigateToMyHomePagess(context) async {
  if(context!=null)
  {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => favPage.MyFavPage()));
  }
  else{
    Text("Data is null");
  }
  
}

Future<bool> addToHistory(List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setStringList("history", value);
}

Future<List<String>> getFromHistory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("history");
}

class LogoImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage logoAsset = AssetImage("images/purple.png");
    Image image = Image(
      image: logoAsset,
      width: 250.0,
      height: 150.0,
    );
    return Container(child: image);
  }
}

Widget _myListView(BuildContext context, List wordList, String word) {
  if (word != null && wordList.length > 0) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey,
      ),
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        if (word == wordList[index]["wordEn"]) {
          return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    "http://icons.iconarchive.com/icons/iconscity/flags/256/turkey-icon.png"),
              ),
              title: Text(wordList[index]["wordTr"]),
              subtitle: Text("En -> Tr"));
        } else {
          return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://icon-library.net/images/usa-flag-icon-png/usa-flag-icon-png-22.jpg"),
              ),
              title: Text(wordList[index]["wordEn"]),
              subtitle: Text("Tr -> En"));
        }
      },
    );
  } else {
    return ListView(children: <Widget>[
      ListTile(
        title: AlertDialog(
          content: Text("KELİME BULUNAMADI! \n NO WORDS FOUND"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ]);
  }
}