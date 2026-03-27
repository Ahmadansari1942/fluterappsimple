import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  // Load .env only for mobile/desktop
  // For web, environment variables come from Amplify
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Note: .env file not found (normal for web). Using Amplify env vars.');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AhmadBlog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const HomePage(),
    );
  }
}
