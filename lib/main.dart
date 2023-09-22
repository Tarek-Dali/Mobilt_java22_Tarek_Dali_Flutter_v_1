import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shake/shake.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();

  String name = '';
  String text = '';
  int counter = 0;
  Color color = Color.fromRGBO(253, 254, 254, 1);
  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    loadData();

    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          counter += 10;
          saveCounter(counter);
        });
      },
    );
  }

  Future<void> saveName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
  }

  Future<void> saveInput(String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedText', newText);
  }

  Future<void> saveCounter(int newCounter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedCounter', newCounter);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      text = prefs.getString('savedText') ?? '';
      counter = prefs.getInt('savedCounter') ?? 0;
      nameController.text = text;
      int colorValue = prefs.getInt('color') ?? Color.fromRGBO(253, 254, 254, 1).value;
      color = Color(colorValue);
    });
  }

  @mustCallSuper
  @protected
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text('First page'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        actions: [
          IconButton(
            color: Colors.cyanAccent,
            icon: const Icon(Icons.accessibility_new_outlined),
            tooltip: 'Say hi',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hello there!')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  onChanged: (text) {
                    saveInput(text);
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: ('Name'),
                  ),
                ),
              ),
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  saveName(name);
                });
              },
              child: Text('Enter'),
            )),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 28),
              ),
            ),
            SizedBox(height: 50,),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    counter++;
                    saveCounter(counter);
                  });
                },
                child: Text(
                    'Click me (+) \n\n        ${counter}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                  'On phone shake to get 10 points',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    counter = 0;
                    saveCounter(counter);
                  });
                },
                child: Text(
                    'Reset',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => secondPage()),
          );
        },
        child: Text('Next'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}



class secondPage extends StatefulWidget {
  const secondPage({super.key});

  @override
  State<secondPage> createState() => _secondPageState();
}

List<String> options = ['Option 1', 'Option 2'];

class _secondPageState extends State<secondPage> {
  String currentOption = options[0];

  Color color = Color.fromRGBO(253, 254, 254, 1);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveColorOption(String newOption, Color newColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('option', newOption);
    await prefs.setInt('color', newColor.value);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentOption = prefs.getString('option') ?? 'Option 1';
      int colorValue = prefs.getInt('color') ?? Color.fromRGBO(253, 254, 254, 1).value;
      color = Color(colorValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text('Second page'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        actions: [
          IconButton(
            color: Colors.cyanAccent,
            icon: const Icon(Icons.accessibility_new_outlined),
            tooltip: 'Say hi',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hello there!')));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RadioListTile(
                  title: Text('Light Mode'),
                  value: options[0],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      color = Color.fromRGBO(253, 254, 254, 1);
                      saveColorOption(
                          currentOption, Color.fromRGBO(253, 254, 254, 1));
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Dark Mode'),
                  value: options[1],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      color = Color.fromRGBO(153, 163, 164, 1);
                      saveColorOption(
                          currentOption, Color.fromRGBO(153, 163, 164, 1));
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.black, // Change this to your desired color
                child: Text(
                  'You have dragon blood in you',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[300],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Image(
                image: NetworkImage('https://t3.ftcdn.net/jpg/05/66/09/54/360_F_566095454_YRWcyvfmcagT6wlZB5DBnU5QaxOcExOW.jpg'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        child: Text('Back'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}
