import 'package:flutter/material.dart';

// Class for a custom progress bar
class CustomProgressBar extends StatefulWidget {
  // Constructor for CustomProgressBar
  const CustomProgressBar({
    Key? key,
    required this.level,
    required this.progress,
    this.width = 200,
  }) : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();

  // Level of the progress bar
  final int level;

  // Progress value of the progress bar
  final double progress;

  // Width of the progress bar
  final double width;
}

// State class for CustomProgressBar
class _CustomProgressBarState extends State<CustomProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initializing animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    // Creating animation tween
    _animation =
        Tween<double>(begin: 0, end: widget.progress).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    // Starting animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Disposing animation controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Displaying level of the progress bar
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Level ${widget.level}',
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        // Stack for progress bar and XP label
        Stack(
          children: [
            // Background container for progress bar
            Container(
              width: widget.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            // Animated container representing progress
            Container(
              width:
                  widget.progress > 50 ? 50 : widget.width * _animation.value,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.purple,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            // Positioned XP label
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "XP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
