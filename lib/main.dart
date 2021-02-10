import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomCompanyWords(),
      theme: ThemeData(
        primaryColor: Colors.brown,
      ),
    );
  }
}

class RandomCompanyWords extends StatefulWidget {
  @override
  _RandomCompanyWordsState createState() => _RandomCompanyWordsState();
}

class _RandomCompanyWordsState extends State<RandomCompanyWords> {
  final _userSuggestions = <WordPair>[];
  final _userFavourited = Set<WordPair>();
  final _largerFont = TextStyle(fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blockchain Startup Top 10'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushFavourited),
        ],
      ),
      body: _constructSuggestions(),
    );
  }

  Widget _constructSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(18.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _userSuggestions.length) {
            _userSuggestions.addAll(generateWordPairs().take(10));
          }
          return _constructRow(_userSuggestions[index]);
        });
  }

  Widget _constructRow(WordPair currentPair) {
    final alreadyFavourited = _userFavourited.contains(currentPair);
    return ListTile(
      title: Text(
        currentPair.asPascalCase,
        style: _largerFont,
      ),
      trailing: Icon(
        alreadyFavourited ? Icons.favorite : Icons.favorite_border,
        color: alreadyFavourited ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadyFavourited) {
            _userFavourited.remove(currentPair);
          } else {
            _userFavourited.add(currentPair);
          }
        });
      },
    );
  }

  void _pushFavourited() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final favouriteTiles = _userFavourited.map(
            (WordPair favouritePair) {
              return ListTile(
                title: Text(
                  favouritePair.asPascalCase,
                  style: _largerFont,
                ),
              );
            },
          );
          final divider = ListTile.divideTiles(
            context: context,
            tiles: favouriteTiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Favourite Blockchain Names'),
            ),
            body: ListView(children: divider),
          );
        },
      ),
    );
  }
}
