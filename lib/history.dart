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
  List<String> favList = new List<String>();

  @override
  Widget build(BuildContext context) {
    
      getFromHistory().then((value) => setState(() {
          historyWord = value;
        }));
  

    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.purple[900],
            onPressed: () {
              if (historyWord != null && historyWord.length > 0) {
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
                        content: Text("History is Empty!"),
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
        title: Text("History"),
        backgroundColor: Colors.purple[900],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: historyWord.length,

          itemBuilder: (context, index) {
            final item = historyWord[index];
            return Dismissible(
              background: Container(
                color: Colors.orange,
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      Text(
                        "Add to Favorites",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              secondaryBackground: Container(
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
              ),
              key: Key(item),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  getFromFavorites().then((value) => setState(() {
                        historyWord = value;
                        favList = historyWord;
                        favList.add(item);
                        addToFavorites(favList);
                      }));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("$item added favorites!"),
                    backgroundColor: Colors.orange,
                  ));
                } else if (direction == DismissDirection.endToStart) {
                  setState(() {
                    historyWord.removeAt(index);
                    remove(historyWord);
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "$item dismissed",
                    ),
                    backgroundColor: Colors.red,
                  ));
                }
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
                     onTap: () {
                     }
                    ),
                  ))),
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
    historyWord.clear();
    remove(historyWord);
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

Future<bool> addToFavorites(List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setStringList("favorite", value);
}

Future<List<String>> getFromFavorites() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("favorite");
}

Future<bool> remove(List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setStringList("history", value);
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
