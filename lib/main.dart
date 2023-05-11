import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:io';
//import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
//import 'package:flutter/foundation.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import "dart:math";
import 'dart:core';
//import 'package:file_picker/file_picker.dart';

/*
class CounterStorage {
  //unused for file writing
  // might fix later
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeQuote(String quoteToAppend) async {
    final file = await _localFile;
    return file.writeAsString('\n$quoteToAppend');
  }
}
*/
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
  //final CounterStorage storage = CounterStorage(); unused, might fix later
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
  int trackCount = 8; // how many tracks are supported atm
  int _counter = 0; // track index
  bool playing = false; // is audio playing?
  late AudioPlayer myAudioPlayer; //Audio player object
  String imageLink = "assets/images/waves.jpg"; //path for image link
  String selectedValue = "0"; //default track dropdown choice index
  String msgAudio = "Ocean Waves"; //
  String quoteToDisplay = "Never give up."; // Quote that is shown on the screen
  late Future<String> data; // will hold the data from the txt file
  String selectedTimerValue = "0"; //default preset dropdown choice value
  String quoteToAdd = ""; //quote that should be added to the quotes bank
  final file = File('assets/text/quotes.txt'); //path to get the quotes
  late TextEditingController controller; // controller for dialog box

  List<String> quotes = [
    'Never give up.',
    'Just do it.',
    'You are perfect.'
  ]; // some hardcoded quotes if file not present

  /*---------------- FILE WRITING (CRASHES APP)-----------------
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  writingTime() {
    // does not work properly
    widget.storage.writeQuote(quoteToAdd);
  }*/

  //----------------- QUOTE STUFF-------------------------
  getData() async {
    String txtfile = await rootBundle.loadString('assets/text/quotes.txt');
    //txtfile stores the entire string of the quotes.txt file

    LineSplitter ls = const LineSplitter(); //make linesplitter
    quotes = ls.convert(txtfile);
    //quotes stores the contents of txtfile separated by new line character
    //  basically is now a list of strings storing contents of quotes.txt file
  }

  addQuote() {
    // add a quote to the quotes list (NOT PERSISTENT)
    setState(() {
      quotes.add(quoteToAdd);
      quoteToDisplay = quoteToAdd; // displays newly created quote automatically
    });
  }

  int newRandom = 0; // stores a new possible random number
  int prevRandom = 0; // stores the previously used random number
  void generateRandomQuote() {
    // chooses a random quote
    // newly selected quote cannot be the same as the last
    setState(() {
      final random = Random();

      // generate a random index based on the list length
      // and use it to retrieve the element
      newRandom = random.nextInt(quotes.length);
      while (newRandom == prevRandom) {
        newRandom = random.nextInt(quotes.length);
      }
      quoteToDisplay = quotes[newRandom];
      prevRandom = newRandom;
    });
  }

  @override
  void initState() {
    super.initState();
    myAudioPlayer = AudioPlayer()
      ..setAsset("assets/audio/ocean-waves.mp3"); //first audio track
    myAudioPlayer.setLoopMode(LoopMode.one); //permaloop audio track
    getData();
    controller = TextEditingController(); // intialize controller
  }

  @override
  void dispose() {
    myAudioPlayer.dispose();
    controller.dispose();
    super.dispose();
  }

  // --------------------TRACK / AUDIO STUFF ------------------------------
  void _incrementCounter() {
    setState(() {
      _counter++; // inc track index
      _counter = _counter % trackCount;
      selectedValue =
          _counter.toString(); // change dropdown track to updated value
      counterHelper(_counter); //update based new track index
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--; // dec track index
      _counter = _counter % trackCount;
      selectedValue =
          _counter.toString(); // change dropdown track to updated value
      counterHelper(_counter); //update based new track index
    });
  }

  void counterHelper(int counterNumber) {
    // sets audio track, picture, and audio message (removed from user view, replaced by dropdown) based on the track index
    //
    //always sets the audio track to loop infinitely
    //
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
    // plays or pauses music based on if it was playing or not
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
    // stops the music if it was playing
    // does nothing if music was stopped
    setState(() {
      if (playing) {
        playing = false;
        myAudioPlayer.pause();
      }
    });
    return playing;
  }

  //------------------- TIMER STUFF ---------------------------
  int secondsRemaining = 30; // default timer value
  Timer? timer; //timer variable
  var timerActive = false; // is timer playing or not
  void _startCountDown() {
    //starts the timer
    //
    // uses a boolean to prevent multiple instances of timers which
    //    would cause the time to tick down faster than normal
    if (!timerActive) {
      setState(() {
        timerActive = true;
      });

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsRemaining > 0) {
          setState(() {
            //remove 1 unit from secondsRemaning for every second that passes
            secondsRemaining--;
          });
        } else {
          //pause audio when the timer hits 0 and stop the timer
          _stopTimer();
          setState(() {
            pauseAudio();
          });
        }
      });
    }
  }

  void _playPauseTimer() {
    //stop timer if active
    //start timer if paused
    if (timerActive) {
      _stopTimer();
    } else if (!timerActive) {
      _startCountDown();
    }
  }

  void _stopTimer() {
    //stop the timer if it is active
    if (timerActive) {
      timer?.cancel();
      setState(() {
        timerActive = false;
      });
    }
  }

  void _resetTimer() {
    //resets the timer back to 30, the original value when booting app
    _stopTimer();
    setState(() {
      secondsRemaining = 30;
    });
  }

  // functions for increasing the seconds remaining by the described unit
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

//functions for decreasing the remaining seconds by the described unit
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

  // ----------------------DROP DOWN VALUES-------------------

  // track dropdown items
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "0", child: Text("Ocean Waves")),
      const DropdownMenuItem(value: "1", child: Text("Nightscapes")),
      const DropdownMenuItem(value: "2", child: Text("Aircraft")),
      const DropdownMenuItem(value: "3", child: Text("Air Conditioner")),
      const DropdownMenuItem(value: "4", child: Text("Arctic Wind")),
      const DropdownMenuItem(value: "5", child: Text("Birds")),
      const DropdownMenuItem(value: "6", child: Text("City")),
      const DropdownMenuItem(value: "7", child: Text("Underwater")),
    ];
    return menuItems;
  }

  //preset dropdown items
  List<DropdownMenuItem<String>> get timeIntervals {
    List<DropdownMenuItem<String>> intervals = [
      const DropdownMenuItem(value: "0", child: Text("0 sec")),
      const DropdownMenuItem(value: "60", child: Text("1 min")),
      const DropdownMenuItem(value: "300", child: Text("5 min")),
      const DropdownMenuItem(value: "1800", child: Text("30 min")),
      const DropdownMenuItem(value: "3600", child: Text("1 hr")),
      const DropdownMenuItem(value: "10800", child: Text("3 hr")),
    ];
    return intervals;
  }

  //functions to isolate the described unit from the remaining seconds
  // used to keep track of the live values of each unit
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

  //--------------------DIALOG BOX STUFF -----------------------
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Add Quote'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter your quote'),
              controller: controller,
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                onPressed: submit,
                child: const Text('Submit'),
              )
            ],
          ));

  void submit() {
    // leave dialog box after hitting submit
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
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(imageLink),
            fit: BoxFit.cover,
          )),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.

            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                quoteToDisplay, // shows the quote selected
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                  // generate random quote button
                  onPressed: generateRandomQuote,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 227, 241, 21))),
                  child: const Text("Random Quote")),
              const SizedBox(height: 50),
              DropdownButton(
                  //track dropdown
                  value: selectedValue,
                  style: const TextStyle(
                      color: Colors.black, //Font color
                      fontSize: 20 //font size on dropdown button
                      ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      _counter = int.parse(selectedValue);
                      counterHelper(_counter);
                    });
                  },
                  items: dropdownItems),
              /*          USED TO SHOW THE TRACK INDEX AND TRACK NAME 
                          REMOVED IN PLACE OF USING ONLY THE DROPDOWN
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
                      onPressed: _decrementCounter, //dec track
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 245, 139, 0))),
                      child: const Text("Prev")),
                  TextButton(
                    onPressed: playButtonAudio, //play and pause audio
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 114, 87, 236))),
                    child: playing == true
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                  TextButton(
                      onPressed: _incrementCounter, // inc track
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 227, 241, 21))),
                      child: const Text("Next")),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Timer Presets: ",
                      selectionColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black, //Font color
                        fontSize: 20,
                      ),
                    ),
                    DropdownButton(
                        //preset dropdown
                        value: selectedTimerValue,
                        style: const TextStyle(
                            color: Colors.indigoAccent, //Font color
                            fontSize: 15 //font size on dropdown button
                            ),
                        onChanged: (String? newVal) {
                          setState(() {
                            //replace the timer with the selected preset value
                            selectedTimerValue = newVal!;
                            secondsRemaining = int.parse(selectedTimerValue);
                          });
                        },
                        items: timeIntervals),
                  ]),
              const SizedBox(
                height: 20,
              ),
              Text(
                // live updated value of each unit of remaining seconds
                // ignore: prefer_interpolation_to_compose_strings
                "Hours: " +
                    _getHours() +
                    "  Minutes: " +
                    _getMinutes() +
                    "  Seconds: " +
                    _getSeconds(),
                style: const TextStyle(
                  color: Colors.black, //Font color
                  fontSize: 40,
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: _decreaseHours, //dec hours button
                      color: Colors.red[900],
                      child: const Text('Hour',
                          style: TextStyle(color: Colors.white)),
                    ),
                    MaterialButton(
                      onPressed: _decreaseMinutes, //dec minutes button
                      color: Colors.red[900],
                      child: const Text('Minute',
                          style: TextStyle(color: Colors.white)),
                    ),
                    MaterialButton(
                      onPressed: _decreaseSeconds, //dec seconds button
                      color: Colors.red[900],
                      child: const Text('Second',
                          style: TextStyle(color: Colors.white)),
                    ),
                    /*MaterialButton(               USED TO BE HARD PAUSE BUTTON
                                        REMOVED IN PLACE OF PLAY/PAUSE BUTTON
                onPressed: _stopTimer,
                child: Text('Pause',
                    style: timerActive
                        ? TextStyle(color: Colors.green)
                        : TextStyle(color: Colors.red)),
                color: Colors.deepPurple,
              ), old    */
                    MaterialButton(
                      onPressed: _playPauseTimer,
                      color: Colors.deepPurple, //play or pause the timer
                      child: Icon(
                        !timerActive == false ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                      onPressed: _increaseSeconds, //inc seconds button
                      color: Colors.lightGreen,
                      child: const Text('Second',
                          style: TextStyle(color: Colors.white)),
                    ),
                    MaterialButton(
                      onPressed: _increaseMinutes, //inc minutes button
                      color: Colors.lightGreen,
                      child: const Text('Minute',
                          style: TextStyle(color: Colors.white)),
                    ),
                    MaterialButton(
                      onPressed: _increaseHours, //inc hours button
                      color: Colors.lightGreen,
                      child: const Text('Hour',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]),
              MaterialButton(
                onPressed: _resetTimer, //reset button
                color: Colors.yellow,
                child:
                    const Text('Reset', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        )),
        // new quote button
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final quoteReceived = await openDialog();
            if (quoteReceived == null || quoteReceived.isEmpty) {
              return;
            }

            quoteToAdd =
                quoteReceived; // store the quote to be added to the quotes bank
            addQuote(); // add to quotes bank
          },
          tooltip: 'Add Quote',
          child: const Icon(Icons.add),
        )); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
