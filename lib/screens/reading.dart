import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  
  final String storyText = "One day, when he was munching the leaves of his favorite tree, Zozo noticed something. He looked at the lion, the zebra, the elephant, the monkey, the hippopotamus, and the rhinoceros. Then, he turned to look at his mom.";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.2); // Kids voice pitch
    flutterTts.setCompletionHandler(() {
      setState(() => isPlaying = false);
    });
  }

  void _playPauseAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() => isPlaying = false);
    } else {
      setState(() => isPlaying = true);
      await flutterTts.speak(storyText);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE28B5E),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/reading_bg.jpg', fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.black, size: 30)),
                      
                      // Audio Play/Stop Button
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.deepPurple, size: 40),
                        onPressed: _playPauseAudio,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFFBE385), borderRadius: BorderRadius.circular(30)),
                    child: Text(storyText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.4)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
