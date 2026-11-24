import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatYoApp());
}

class ChatYoApp extends StatelessWidget {
  const ChatYoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasData) return const PeopleScreen();
        return const AuthScreen();
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final cityC = TextEditingController();
  bool isLogin = true;
  bool isAdult = false;
  String error = '';

  Future<void> submit() async {
    try {
      if (!isLogin && !isAdult) {
        setState(() => error = 'خاصك تكون +18 باش تدخل');
        return;
      }
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailC.text.trim(), password: passC.text.trim());
      } else {
        final cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailC.text.trim(), password: passC.text.trim());
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'name': nameC.text.trim(),
          'email': emailC.text.trim(),
          'city': cityC.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      setState(() => error = 'خطأ: $e');
    }
  }   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatYo - ناس حقيقيين 💜')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isLogin) ...[
              TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                      labelText: 'السمية الحقيقية')),
              const SizedBox(height: 10),
              TextField(
                  controller: cityC,
                  decoration:
                      const InputDecoration(labelText: 'المدينة')),
              const SizedBox(height: 10),
            ],
            TextField(
                controller: emailC,
                decoration:
                    const InputDecoration(labelText: 'الإيميل')),
            const SizedBox(height: 10),
            TextField(
                controller: passC,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'كلمة السر')),
            const SizedBox(height: 10),
            if (!isLogin)
              Row(
                children: [
                  Checkbox(
                      value: isAdult,
                      onChanged: (v) =>
                          setState(() => isAdult = v ?? false)),
                  const Expanded(
                      child: Text(
                          'أنا +18 سنة وكنأكد بلي المعلومات ديالي حقيقية')),
                ],
              ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  minimumSize: const Size(double.infinity, 50)),
              child: Text(isLogin ? 'دخول' : 'صايب حساب حقيقي'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? 'ماعندكش حساب؟ صايب حساب'
                  : 'عندك حساب؟ دخول'),
            ),
            const SizedBox(height: 10),
            const Text(
              'هاد التطبيق للناس الحقيقيين فقط.\nممنوع الحسابات المزيفة والتصاور المسروقة.\nإلا شفتي شي حساب مزيف، ديرو سينيال وبلوك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}// صفحة الناس الحقيقيين
class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatYo - ناس حقيقيين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs =
              snap.data!.docs.where((d) => d.id != myUid).toList();
          if (docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'مازال حتى واحد مسجل من غيرك.\nبارتاجي التطبيق مع صحابك باش يبانو هنا.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF8B5CF6),
                  child: Text((data['name'] ?? '?')[0].toUpperCase()),
                ),
                title: Text(data['name'] ?? 'مستخدم'),
                subtitle: Text(data['city'] ?? ''),
                trailing: const Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RealChatScreen(
                        otherId: docs[i].id,
                        otherName: data['name'] ?? 'مستخدم',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// شات حقيقي بين جوج ناس
class RealChatScreen extends StatefulWidget {
  final String otherId;
  final String otherName;
  const RealChatScreen(
      {super.key, required this.otherId, required this.otherName});
  @override
  State<RealChatScreen> createState() => _RealChatScreenState();
}

class _RealChatScreenState extends State<RealChatScreen> {
  final _controller = TextEditingController();
  String get chatId {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final ids = [myUid, widget.otherId]..sort();
    return ids.join('_');
  }

  Future<void> send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': myUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = snap.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i].data() as Map<String, dynamic>;
                    final isMe = m['senderId'] == myUid;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFF1E1E2F),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(m['text'] ?? ''),
                      ),
                    );
                  },
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
                  icon: const Icon(Icons.send,
                      color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}