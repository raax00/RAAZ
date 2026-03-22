import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'reading.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/cover.jpg', fit: BoxFit.cover),
            ),
            leading: IconButton(
              icon: const CircleAvatar(backgroundColor: Colors.white70, child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const ReadingPage())),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B4D9B), minimumSize: const Size(double.infinity, 56)),
                    child: const Text('Start Reading', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  const SizedBox(height: 24),
                  const Text("Zozo's Wish", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text("Why do giraffes have such long necks? What would happen if, for one day only, all animals could have necks just as long?", style: TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
