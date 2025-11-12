import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
Future<void> main() async { // 2. CHANGE THIS LINE
  WidgetsFlutterBinding.ensureInitialized(); // 3. ADD THIS LINE

  await dotenv.load(fileName: ".env"); // 4. ADD THIS LINE

  runApp( MyApp()); // This line stays

}

class MyApp extends StatelessWidget {
  // This line reads the key provided in the 'run' command
  final String apiKey = const String.fromEnvironment('API_KEY');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: '/login',
      routes: {
        '/login':(context)=> LoginScreen(),
        '/signup':(context)=>SignupScreen(),
        '/chat': (context) =>chatScreen(),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body:Column(

      )

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
