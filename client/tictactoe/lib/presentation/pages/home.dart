import 'package:flutter/material.dart';

import '../widgets/game_cell.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<List<String>> board;
  String currentPlayer = 'X';
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      gameOver = false;
    });
  }

  void _handleCellTap(int row, int col) {
    if (board[row][col].isEmpty && !gameOver) {
      setState(() => board[row][col] = currentPlayer);

      if (_checkWin(currentPlayer)) {
        _showGameOverSnackBar('$currentPlayer wins!', Colors.green);
        gameOver = true;
      } else if (_checkDraw()) {
        _showGameOverSnackBar("It's a draw!", Colors.blue);
        gameOver = true;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    }
  }

  bool _checkWin(String player) {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == player &&
          board[i][1] == player &&
          board[i][2] == player) {
        return true;
      }
      if (board[0][i] == player &&
          board[1][i] == player &&
          board[2][i] == player) {
        return true;
      }
    }
    // Check diagonals
    if (board[0][0] == player &&
        board[1][1] == player &&
        board[2][2] == player) {
      return true;
    }
    if (board[0][2] == player &&
        board[1][1] == player &&
        board[2][0] == player) {
      return true;
    }
    return false;
  }

  bool _checkDraw() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showGameOverSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  color == Colors.green ? Icons.celebration : Icons.handshake,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        )
        .closed
        .then((_) => resetGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Current Player: $currentPlayer",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 9,
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return GameCell(
                  value: board[row][col],
                  onTap: () => _handleCellTap(row, col),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

