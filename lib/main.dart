import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foot_gear/screens/homeScreen.dart';
import 'screens/categoriesScreen.dart';
import 'screens/try_on_shoes.dart';
import 'screens/feetSizePrediction.dart';
import 'utils/colors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foot Gear',
      theme: ThemeData(
        primarySwatch: darkBlueSwatch,
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black),
            titleLarge: const TextStyle(
              fontSize: 24,
              fontFamily: 'RobotoCondensed',
            )),
      ),
      // home: const MyHomePage(title: 'Foot Gear'),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Foot Gear'),
        TryOnShoes.routeName: (context) => TryOnShoes(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int myIndex = 0;
  int index = 0;
  List<Widget> widgetList = [
    const MyHome(),
    CategoriesScreen(),
    const SizePrediction(title: 'Check Size')
  ];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      print('Connectivity Result ========>>>>>>>>>> $_connectionStatus');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1976D2),
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(
            () {
              myIndex = index;
            },
          );
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 93, 173, 226)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Try On',
              backgroundColor: Color.fromARGB(255, 93, 173, 226)),
          BottomNavigationBarItem(
              icon: Icon(Icons.straighten),
              label: 'Check Size',
              backgroundColor: Color.fromARGB(255, 93, 173, 226)),
        ],
      ),
    );
  }
}
