import 'package:flutter/material.dart';
import 'package:mob_dev_lab2/contacts_page.dart';
import 'package:mob_dev_lab2/oblast_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 2'),
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
  int currentPageIndex = 1;

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => infoDialog(context),)
        ],
      ),
      body: <Widget> [
        const ContactPage(),
        const OblastPage()
      ][currentPageIndex],
      bottomNavigationBar:
      NavigationBar(
        onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.contacts),
            icon: Icon(Icons.contacts_outlined),
            label: 'Contacts',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: 'Oblasts',
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

infoDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Image(image: AssetImage('images/student.jpg'), height: 180.0,),
          const SizedBox(height: 15),
          const SizedBox(width: 250,
            child: Text("Застосунок розробив студент групи ТТП-42 Макаров Дмитро Олексійович в рамках лабораторної роботи 2 з дисципліни 'Розробка ПЗ під мобільні платформи'",
              softWrap: true),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}