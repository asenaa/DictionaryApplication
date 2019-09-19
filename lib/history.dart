import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dictapp/favorites.dart' as favPage;
import 'package:dictapp/main.dart' as mainPage;

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
  int _selectedIndex = 1;
  ListView listView = ListView();
  List<String> historyWord = new List<String>();

  @override
  Widget build(BuildContext context) {
    getFromHistory().then((value) => setState(() {
          listView = _myListView(context, historyWord);
          historyWord = value;
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
          ),
        ],
        title: Text("History"),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 5, 5),
            ),
            Expanded(
              child: listView,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 50, 5),
            ),
            /*RaisedButton(
              textColor: Colors.white,
              color: Colors.orange,
              child: Text('Search Page'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainPage.MyApp()));
              },
            ),*/
            // Padding(
            //   padding: EdgeInsets.fromLTRB(50, 60, 5, 0),
            // ),
          ],
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
      if (index == 2) {
        navigateToMyHomePagess(context);
      }
    });
  }
}
  Future<List<String>> getFromHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("history");
  }

Future navigateToMyHomePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => mainPage.MyApp()));   
}

Future navigateToMyHomePagess(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => favPage.MyFavPage()));
}

Widget _myListView(BuildContext context, List wordList) {
  if (wordList != null && wordList.length > 0) {
    return ListView.builder(
        itemCount: wordList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(wordList[index], textAlign: TextAlign.center,),
          );
        });
  } else {
    return ListView(children: <Widget>[
      ListTile(title: Text("History Empty!", textAlign: TextAlign.center)),
    ]);
  }
}