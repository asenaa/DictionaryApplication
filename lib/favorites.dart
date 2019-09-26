import 'package:flutter/material.dart';
import 'package:dictapp/main.dart' as mainPage;
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
  ListView listView = ListView();
  List<String> favWord = new List<String>();
  @override
  Widget build(BuildContext context) {
    getFromFavorites().then((value) => setState(() {
      favWord = value;
    }));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.purple[900],
            onPressed: () {
              if (favWord!= null && favWord.length > 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Clean"),
                        content: Text("Are you sure to delete history?"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Delete"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _clearAllItems();
                            },
                          ),
                          new FlatButton(
                            child: new Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Favorites Empty!"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
          ),
        ],
        title: Text("Favorites"),
        backgroundColor: Colors.purple[900],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: favWord.length,
          itemBuilder: (context, index) {
            final item = favWord[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  favWord.removeAt(index);
                  remove(favWord);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "$item dismissed",
                  ),
                  backgroundColor: Colors.orange,
                ));
              },
              child: InkWell(
                  onTap: () {
                    print("$item clicked.");
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        '$item',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      onTap: () {},
                    ),
                  ))),
              background: slideLeftBackground(),
            );
          },
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

  void _clearAllItems() {
    favWord.clear();
    remove(favWord);
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

Future<List<String>> getFromFavorites() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("favorite");
}

Future navigateToMyHomePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => mainPage.MyApp()));
}

Future<bool> addToFavorites(List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setStringList("favorite", value);
}

Future<bool> remove(List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setStringList("favorite", value);
}

Future navigateToMyHomePages(context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => historyPage.MyHistoryPage()));
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
