import 'package:flutter/material.dart';
import 'package:dictapp/main.dart' as mainPage;
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
      home: MyFavPage(
        title: 'Favorites',
      ),
    );
  }
}
class MyFavPage extends StatefulWidget {
  MyFavPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyFavPageState createState() => _MyFavPageState();
}

class _MyFavPageState extends State<MyFavPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.purple[900],
            onPressed: () {},
            child: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
          ),
        ],
        title: Text("Favorites"),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 5, 5),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.orange,
              child: Text('Search'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainPage.MyApp()));
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 60, 5, 0),
            ),
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
      if (index == 1) {
        navigateToMyHomePages(context);
      }
    });
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
