import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
  int trackCount = 3;
  int _counter = 0;
  bool playing = false;
  String msgAudio = "Ocean Waves";
  late AudioPlayer myAudioPlayer;
  @override
  void initState() {
    super.initState();
    myAudioPlayer = AudioPlayer()..setAsset("assets/audio/ocean-waves.mp3");
    myAudioPlayer.setLoopMode(LoopMode.all);
  }

  @override
  void dispose() {
    myAudioPlayer.dispose();
    super.dispose();
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
      //keep updating this value based on how many tracks there are
      if (_counter == 0) {
        pauseAudio();
        myAudioPlayer = AudioPlayer()..setAsset("assets/audio/ocean-waves.mp3");
        myAudioPlayer.setLoopMode(LoopMode.one);
        msgAudio = "Ocean Waves";
      }
      if (_counter == 1) {
        pauseAudio();
        myAudioPlayer = AudioPlayer()..setAsset("assets/audio/nightscapes.mp3");
        myAudioPlayer.setLoopMode(LoopMode.one);
        msgAudio = "Nightscapes";
      }
      if (_counter == 2) {
        pauseAudio();
        myAudioPlayer = AudioPlayer()..setAsset("assets/audio/aircraft.mp3");
        myAudioPlayer.setLoopMode(LoopMode.one);
        msgAudio = "Aircraft";
      }
    });
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
              msgAudio,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: playButtonAudio,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 12.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
