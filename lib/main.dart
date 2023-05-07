import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import "dart:math";
import 'dart:core';
//import 'package:audio_session/audio_session.dart';
//import 'package:flutter/services.dart';
//import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Time',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Focus & Motivation Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedNavigationBarIndex = 0;
  int trackCount = 3;
  int _counter = 0;
  bool playing = false;
  late AudioPlayer myAudioPlayer;
  String imageLink = "images/waves.jpg";
  String selectedValue = "0";
  String msgAudio = "Ocean Waves";
  String quoteToDisplay = "Never give up.";
  String data = "";

  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('text/quotes.txt');

    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    super.initState();
    myAudioPlayer = AudioPlayer()..setAsset("assets/audio/ocean-waves.mp3");
    myAudioPlayer.setLoopMode(LoopMode.all);
    fetchFileData();
    super.initState();
  }

  @override
  void dispose() {
    myAudioPlayer.dispose();
    super.dispose();
  }

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter++;
      _counter = _counter % trackCount;
      selectedValue = _counter.toString();
      //keep updating this value based on how many tracks there are
      counterHelper(_counter);
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter--;
      _counter = _counter % trackCount;
      selectedValue = _counter.toString();
      //keep updating this value based on how many tracks there are
      counterHelper(_counter);
    });
  }

  void counterHelper(int counterNumber) {
    //only call this function within setState()
    if (counterNumber == 0) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/ocean-waves.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Ocean Waves";
      imageLink = "images/waves.jpg";
    } else if (counterNumber == 1) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/nightscapes.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Nightscapes";
      imageLink = "images/nightscapes.jpg";
    } else if (counterNumber == 2) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/aircraft.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Aircraft";
      imageLink = "images/airplane.jpg";
    }
  }

  bool playButtonAudio() {
    setState(() {
      if (playing) {
        playing = false;
        myAudioPlayer.pause();
      } else {
        playing = true;
        myAudioPlayer.play();
      }
    });
    return playing;
  }

  bool pauseAudio() {
    setState(() {
      if (playing) {
        playing = false;
        myAudioPlayer.pause();
      }
    });
    return playing;
  }

  void selectNavigationBarIndex(int index) {
    setState(() {
      selectedNavigationBarIndex = index;
    });
  }

  void updateSelectedValue(String updatedVal) {
    selectedValue = updatedVal;
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Ocean Waves"), value: "0"),
      DropdownMenuItem(child: Text("Nightscapes"), value: "1"),
      DropdownMenuItem(child: Text("Aircraft"), value: "2"),
      //DropdownMenuItem(child: Text("England"),value: "England"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

          child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(imageLink),
          fit: BoxFit.cover,
        )),
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              quoteToDisplay,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 50),
            DropdownButton(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    _counter = int.parse(selectedValue);
                    counterHelper(_counter);
                  });
                },
                items: dropdownItems),
            Text(
              'Track $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              msgAudio,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: _decrementCounter,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 245, 139, 0))),
                    child: const Text("Previous")),
                TextButton(
                  onPressed: playButtonAudio,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 114, 87, 236))),
                  child: playing == true
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                ),
                TextButton(
                    onPressed: _incrementCounter,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 227, 241, 21))),
                    child: const Text("Next")),
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Player & Quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Add Quotes',
          ),
        ],
        currentIndex: selectedNavigationBarIndex,
        selectedItemColor: Colors.amber[800],
        onTap: selectNavigationBarIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


/* To-Do

- implement a countdown timer that auto pauses the music whenever it is done
- change the background based on the track playing
- implement a drop down menu that allows you to see all tracks and select one
- make a bank of quotes, and display one at random at the top of the page
- use the increment button to create a dialogue to add more quotes, 
        or 
    use the bottom nav bar to make a text box to add quotes
- change the color of the text and icons from blue to black or any other suitable color




*/