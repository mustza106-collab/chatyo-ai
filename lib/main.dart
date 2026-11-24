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
  ];  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatYo AI 💜'),
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$coins 💰'),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'اختار شخصية AI باش تهضر معاها\nكلهم شخصيات ذكاء اصطناعي',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: characters.length,
              itemBuilder: (_, i) {
                final c = characters[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          character: c,
                          onSpend: () {
                            setState(() {
                              if (coins >= c['price']) coins -= c['price'];
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2F),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(c['color'] as int),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18)),
                            ),
                            child: Center(
                              child: Text(
                                (c['name'] as String)[0],
                                style: const TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(c['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(c['type'],
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('${c['price']} 💰 / رسالة',
                                  style: const TextStyle(
                                      color: Colors.amber)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> character;
  final VoidCallback onSpend;
  const ChatScreen({super.key, required this.character, required this.onSpend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    messages.add({
      'who': 'ai',
      'text':
          'سلام! أنا ${widget.character['name']}، شخصية ذكاء اصطناعي. شنو بغيتي نهضرو عليه اليوم؟'
    });
  }

  String getReply(String text) {
    final name = widget.character['name'] as String;
    if (text.contains('سلام') || text.contains('salam')) {
      return 'سلام! فرحانة نهضر معاك. كيداير نهارك؟';
    }
    if (text.contains('شكون نتا') || text.contains('شكون انت')) {
      return 'أنا $name، شخصية ذكاء اصطناعي، ماشي إنسان حقيقي. هنا باش نعاونك ونهضر معاك.';
    }
    if (text.contains('ملل') || text.contains('مليت')) {
      return 'إلا مليتي، نلعبو لعبة ديال الأسئلة؟ سولني أي حاجة ولا قولي ليا شنو كيعجبك.';
    }
    if (text.contains('ضحك') || text.contains('نكتة')) {
      return 'هههه، عرفتي شنو قال التيليفون للشارجور؟ بلا بيك أنا طافي 😄';
    }
    return 'فهمتك، زوين هادشي اللي قلتي. زيد حكي ليا كثر، أنا كنسمع ليك.';
  }

  void send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'who': 'me', 'text': text});
      messages.add({'who': 'ai', 'text': getReply(text)});
    });
    _controller.clear();
    widget.onSpend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.character['name']),
            const Text('شخصية ذكاء اصطناعي - AI',
                style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                final isMe = m['who'] == 'me';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF1E1E2F),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(m['text']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'كتب رسالتك...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onSubmitted: (_) => send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: send,
                  icon: const Icon(Icons.send, color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}