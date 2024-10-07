import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(const HalloweenGame());
}

// Halloween Game App
// Developed by: Ali Butt

class HalloweenGame extends StatelessWidget {
  const HalloweenGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _backgroundPlayer =
      AudioPlayer(); // Background music player
  final AudioPlayer _effectsPlayer = AudioPlayer(); // Effects sound player
  bool _showSuccessMessage = false;

  // Background Music Setup
  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  // Correctly play background music using new AudioPlayer API
  void _playBackgroundMusic() async {
    print("Playing background music using AudioPlayer...");
    await _backgroundPlayer
        .setSource(AssetSource('assets/sounds/background.mp3'));
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(1.0);
    _backgroundPlayer.resume(); // Start the background music
  }

  @override
  void dispose() {
    _backgroundPlayer.dispose();
    _effectsPlayer.dispose();
    super.dispose();
  }

  // Function to handle trap interaction
  void _onTrapClick() async {
    print("Trap clicked! Playing jumpscare sound...");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Boo! You clicked on a trap!')),
    );
    try {
      await _effectsPlayer
          .setSource(AssetSource('assets/sounds/jumpscare.mp3'));
      _effectsPlayer.setVolume(1.0);
      _effectsPlayer.resume();
    } catch (e) {
      print("Error playing jumpscare sound: $e");
    }
  }

  // Function to handle winning interaction
  void _onWinningClick() async {
    print("Winning item clicked! Playing success sound...");
    setState(() {
      _showSuccessMessage = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You found the winning item!')),
    );
    try {
      await _effectsPlayer.setSource(AssetSource('assets/sounds/success.mp3'));
      _effectsPlayer.setVolume(1.0);
      _effectsPlayer.resume();
    } catch (e) {
      print("Error playing success sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halloween Game')),
      body: Stack(
        children: [
          _buildBackground(),
          if (_showSuccessMessage) _buildSuccessMessage(),
          _buildAnimatedSpookyCharacters(),
        ],
      ),
    );
  }

  // Background Decoration
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/halloween_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Winning Message Display
  Widget _buildSuccessMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Found It!',
            style: TextStyle(fontSize: 32, color: Colors.orange),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showSuccessMessage = false;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  // Building Animated Characters
  Widget _buildAnimatedSpookyCharacters() {
    List<Widget> characters = [];
    characters.addAll(_buildTraps());
    characters.add(_buildWinningElement());
    characters.addAll(_buildAdditionalElements());

    return Stack(children: characters);
  }

  // Define Traps
  List<Widget> _buildTraps() {
    List<Widget> traps = [];
    traps.add(_buildFloatingCharacter(
        'assets/images/ghost.png', _onTrapClick, 80, 80));
    traps.add(_buildFloatingCharacter(
        'assets/images/bat.png', _onTrapClick, 100, 50));
    return traps;
  }

  // Define the Winning Element
  Widget _buildWinningElement() {
    return _buildFloatingCharacter(
        'assets/images/pumpkin.png', _onWinningClick, 100, 100);
  }

  // Additional Elements: Spider and Witch Hat
  List<Widget> _buildAdditionalElements() {
    List<Widget> additionalElements = [];
    additionalElements.add(_buildFloatingCharacter(
        'assets/images/spider.png', _onTrapClick, 60, 60));
    additionalElements.add(_buildFloatingCharacter(
        'assets/images/witch_hat.png', _onTrapClick, 80, 80));
    return additionalElements;
  }

  // Floating Character Widget
  Widget _buildFloatingCharacter(
      String imagePath, VoidCallback onClick, double width, double height) {
    final random = Random();
    final top = random.nextDouble() * 400;
    final left = random.nextDouble() * 200;

    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      top: top,
      left: left,
      child: GestureDetector(
        onTap: onClick,
        child: Image.asset(
          imagePath,
          width: width, // Set the image width
          height: height, // Set the image height
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
