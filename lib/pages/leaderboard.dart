import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  // Dummy data for now
  final List<Map<String, dynamic>> players = const [
    {"name": "Player 1", "score": 5700},
    {"name": "Player 2", "score": 4500},
    {"name": "Player 3", "score": 3200},
    {"name": "Player 4", "score": 2900},
    {"name": "Player 5", "score": 2600},
    {"name": "Player 6", "score": 2400},
    {"name": "Player 7", "score": 2200},
    {"name": "Player 8", "score": 1800},
  ];

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'LEADERBOARD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            _buildTopThree(),
            const SizedBox(height: 20),
            _buildRestOfLeaderboard(),
          ],
        ),
      ),
    );
  }

  // Building the top 3 players
  Widget _buildTopThree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTopPlayer(players[1], 2),
        _buildTopPlayer(players[0], 1, isFirst: true),
        _buildTopPlayer(players[2], 3),
      ],
    );
  }

  // Building the top 3 player card
  Widget _buildTopPlayer(Map<String, dynamic> player, int rank,
      {bool isFirst = false}) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amberAccent,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.person,
            size: isFirst ? 60 : 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          player['name'],
          style: TextStyle(
            fontSize: isFirst ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          player['score'].toString(),
          style: TextStyle(
            fontSize: isFirst ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 5),
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.yellow,
          child: Text(rank.toString(),
              style: const TextStyle(color: Colors.black)),
        )
      ],
    );
  }

  // Building the rest of the leaderboard
  Widget _buildRestOfLeaderboard() {
    return Column(
      children: players.sublist(3).asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> player = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amberAccent,
              child: Text((index + 4).toString(),
                  style: const TextStyle(color: Colors.black)),
            ),
            title: Text(player['name']),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                player['score'].toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
