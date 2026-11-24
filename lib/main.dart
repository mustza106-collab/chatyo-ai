import 'package:flutter/material.dart';

void main() => runApp(const ChatYoApp());

class ChatYoApp extends StatelessWidget {
  const ChatYoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int coins = 200;

  // شخصيات ذكاء اصطناعي - ماشي بنات حقيقيين
  final List<Map<String, dynamic>> characters = [
    {
      'name': 'Yasmin AI',
      'type': 'رفيقة رومانسية - AI',
      'desc': 'شخصية ذكاء اصطناعي رومانسية',
      'price': 15,
      'color': 0xFFFF6B9D,
    },
    {
      'name': 'Sara AI',
      'type': 'صديقة مرحة - AI',
      'desc': 'شخصية ذكاء اصطناعي مرحة',
      'price': 15,
      'color': 0xFF8B5CF6,
    },
    {
      'name': 'Hana AI',
      'type': 'رفيقة هادئة - AI',
      'desc': 'شخصية ذكاء اصطناعي هادئة',
      'price': 20,
      'color': 0xFF4ECDC4,
    },
    {
      'name': 'Lina AI',
      'type': 'صديقة جريئة - AI',
      'desc': 'شخصية ذكاء اصطناعي جريئة',
      'price': 20,
      'color': 0xFFFFA500,
    },
  ];