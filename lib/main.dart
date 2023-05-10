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
  int trackCount = 8;
  int _counter = 0;
  bool playing = false;
  late AudioPlayer myAudioPlayer;
  String imageLink = "assets/images/waves.jpg";
  String selectedValue = "0";
  String msgAudio = "Ocean Waves";
  String quoteToDisplay = "Never give up.";
  String data = "";
  String selectedTimerValue = "0";
  String quoteToAdd = "";

  List<String> quotes = [
    'Never give up.',
    'Just do it.',
    'I am inevitable.',
    'You are perfect.'
  ];

  addQuote() {
    setState(() {
      quotes.add(quoteToAdd);
      quoteToDisplay = quoteToAdd;
    });
  }

  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('text/quotes.txt');

    setState(() {
      data = responseText;
    });
  }

  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    myAudioPlayer = AudioPlayer()..setAsset("assets/audio/ocean-waves.mp3");
    myAudioPlayer.setLoopMode(LoopMode.all);
    //fetchFileData();
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    myAudioPlayer.dispose();
    controller.dispose();
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
      imageLink = "assets/images/waves.jpg";
    } else if (counterNumber == 1) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/nightscapes.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Nightscapes";
      imageLink = "assets/images/nightscapes.jpg";
    } else if (counterNumber == 2) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/aircraft.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Aircraft";
      imageLink = "assets/images/airplane.jpg";
    } else if (counterNumber == 3) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()
        ..setAsset("assets/audio/air-conditioner.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Air Conditioner";
      imageLink = "assets/images/air-conditioner.jpg";
    } else if (counterNumber == 4) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/arctic-wind.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Arctic Wind";
      imageLink = "assets/images/arctic-wind.jpg";
    } else if (counterNumber == 5) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/birds.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Birds";
      imageLink = "assets/images/birds.jpg";
    } else if (counterNumber == 6) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/city.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "City";
      imageLink = "assets/images/city.jpg";
    } else if (counterNumber == 7) {
      pauseAudio();
      myAudioPlayer = AudioPlayer()..setAsset("assets/audio/underwater.mp3");
      myAudioPlayer.setLoopMode(LoopMode.one);
      msgAudio = "Underwater";
      imageLink = "assets/images/underwater.jpg";
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

  var newRandom;
  var prevRandom;
  void generateRandomQuote() {
    setState(() {
      final _random = new Random();

      // generate a random index based on the list length
      // and use it to retrieve the element
      newRandom = _random.nextInt(quotes.length);
      while (newRandom == prevRandom) {
        newRandom = _random.nextInt(quotes.length);
      }
      quoteToDisplay = quotes[newRandom];
      prevRandom = newRandom;
    });
  }

  int secondsRemaining = 30;
  Timer? timer;

  var timerActive = false;
  void _startCountDown() {
    if (!timerActive) {
      setState(() {
        timerActive = true;
      });

      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          _stopTimer();
          setState(() {
            pauseAudio();
          });
        }
      });
    }
  }

  void _playPauseTimer() {
    if (timerActive) {
      _stopTimer();
    } else if (!timerActive) {
      _startCountDown();
    }
  }

  void _stopTimer() {
    if (timerActive) {
      timer?.cancel();
      setState(() {
        timerActive = false;
      });
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      secondsRemaining = 0;
    });
  }

  void _increaseSeconds() {
    setState(() {
      secondsRemaining++;
    });
  }

  void _increaseMinutes() {
    setState(() {
      secondsRemaining += 60;
    });
  }

  void _increaseHours() {
    setState(() {
      secondsRemaining += 3600;
    });
  }

  void _decreaseSeconds() {
    setState(() {
      secondsRemaining--;
    });
  }

  void _decreaseMinutes() {
    if (secondsRemaining <= 60) {
      setState(() {
        secondsRemaining -= secondsRemaining;
      });
    } else {
      setState(() {
        secondsRemaining -= 60;
      });
    }
  }

  void _decreaseHours() {
    if (secondsRemaining <= 3600) {
      setState(() {
        secondsRemaining -= secondsRemaining;
      });
    } else {
      setState(() {
        secondsRemaining -= 3600;
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Ocean Waves"), value: "0"),
      DropdownMenuItem(child: Text("Nightscapes"), value: "1"),
      DropdownMenuItem(child: Text("Aircraft"), value: "2"),
      DropdownMenuItem(child: Text("Air Conditioner"), value: "3"),
      DropdownMenuItem(child: Text("Arctic Wind"), value: "4"),
      DropdownMenuItem(child: Text("Birds"), value: "5"),
      DropdownMenuItem(child: Text("City"), value: "6"),
      DropdownMenuItem(child: Text("Underwater"), value: "7"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get timeIntervals {
    List<DropdownMenuItem<String>> intervals = [
      DropdownMenuItem(child: Text("0 sec"), value: "0"),
      DropdownMenuItem(child: Text("1 min"), value: "60"),
      DropdownMenuItem(child: Text("5 min"), value: "300"),
      DropdownMenuItem(child: Text("30 min"), value: "1800"),
      DropdownMenuItem(child: Text("1 hr"), value: "3600"),
      DropdownMenuItem(child: Text("3 hr"), value: "10800"),
    ];
    return intervals;
  }

  String _getSeconds() {
    return (secondsRemaining % 60).toString();
  }

  String _getMinutes() {
    if (secondsRemaining >= 60) {
      return (secondsRemaining % 3600 / 60).floor().toString();
    }
    return "0";
  }

  String _getHours() {
    if (secondsRemaining >= 3600) {
      return (secondsRemaining / 3600).floor().toString();
    }
    return "0";
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Add Quote'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your quote'),
              controller: controller,
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                child: Text('Submit'),
                onPressed: submit,
              )
            ],
          ));

  void submit() {
    setState(() {
      Navigator.of(context).pop(controller.text);
      controller.clear();
    });
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
                quoteToDisplay, // change back after testing
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              TextButton(
                  onPressed: generateRandomQuote,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 227, 241, 21))),
                  child: const Text("Random Quote")),
              SizedBox(height: 50),
              DropdownButton(
                  value: selectedValue,
                  style: Theme.of(context).textTheme.headlineMedium,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      _counter = int.parse(selectedValue);
                      counterHelper(_counter);
                    });
                  },
                  items: dropdownItems),
              /*
            Text(
              'Track $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              msgAudio,
              style: Theme.of(context).textTheme.headlineMedium,
            ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      onPressed: _decrementCounter,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 245, 139, 0))),
                      child: const Text("Prev")),
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
              SizedBox(height: 50),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Presets: ",
                      selectionColor: Colors.orange,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    DropdownButton(
                        value: selectedTimerValue,
                        onChanged: (String? newVal) {
                          setState(() {
                            selectedTimerValue = newVal!;
                            secondsRemaining = int.parse(selectedTimerValue);
                          });
                        },
                        items: timeIntervals),
                  ]),
              Text(
                // ignore: prefer_interpolation_to_compose_strings
                "Hours: " +
                    _getHours() +
                    "  Minutes: " +
                    _getMinutes() +
                    "  Seconds: " +
                    _getSeconds(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                MaterialButton(
                  onPressed: _decreaseHours,
                  child: Text('Hour', style: TextStyle(color: Colors.white)),
                  color: Colors.red[900],
                ),
                MaterialButton(
                  onPressed: _decreaseMinutes,
                  child: Text('Minute', style: TextStyle(color: Colors.white)),
                  color: Colors.red[900],
                ),
                MaterialButton(
                  onPressed: _decreaseSeconds,
                  child: Text('Second', style: TextStyle(color: Colors.white)),
                  color: Colors.red[900],
                ),
                /*MaterialButton(
                onPressed: _stopTimer,
                child: Text('Pause',
                    style: timerActive
                        ? TextStyle(color: Colors.green)
                        : TextStyle(color: Colors.red)),
                color: Colors.deepPurple,
              ), old    */
                MaterialButton(
                  onPressed: _playPauseTimer,
                  child: Icon(
                    !timerActive == false ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  color: Colors.deepPurple,
                ),
                MaterialButton(
                  onPressed: _increaseSeconds,
                  child: Text('Second', style: TextStyle(color: Colors.white)),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _increaseMinutes,
                  child: Text('Minute', style: TextStyle(color: Colors.white)),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _increaseHours,
                  child: Text('Hour', style: TextStyle(color: Colors.white)),
                  color: Colors.lightGreen,
                ),
              ]),
              MaterialButton(
                onPressed: _resetTimer,
                child: Text('Reset', style: TextStyle(color: Colors.black)),
                color: Colors.yellow,
              ),
            ],
          ),
        )),
        /*bottomNavigationBar: BottomNavigationBar(
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
      ), PROB NOT USING BOTTOM NAV BAR */

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final quoteReceived = await openDialog();
            if (quoteReceived == null || quoteReceived.isEmpty) {
              return;
            } else {
              quoteToAdd = quoteReceived;
              addQuote();
            }
          },
          tooltip: 'Add Quote',
          child: const Icon(Icons.add),
        )); // This trailing comma makes auto-formatting nicer for build methods.
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