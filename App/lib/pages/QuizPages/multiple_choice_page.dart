import 'package:flutter/material.dart';
import 'package:maestro/Models/multiple_choice.dart';
import 'package:maestro/router/route_constants.dart';
import '../../Models/all_questions.dart';

class MCQBody extends StatefulWidget {
  const MCQBody({super.key});

  @override
  State<MCQBody> createState() => _MCQBodyState();
}

class _MCQBodyState extends State<MCQBody> {
  late PageController _controller;
  int _questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = multipleChoice[_questionNumber - 1];
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  question.quizName,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: OptionsWidget(
                question: question,
                onClickedOption: (option) {
                  if (!_isLocked) {
                    setState(() {
                      _isLocked = true;
                      question.isLocked = true;
                      question.selectedOption = option;
                      if (option.isCorrect) {
                        _score++;
                      }
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _isLocked
                    ? () {
                        if (_questionNumber < multipleChoice.length) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInExpo,
                          );
                          setState(() {
                            _questionNumber++;
                            _isLocked = false;
                            multipleChoice[_questionNumber - 1].isLocked =
                                false;
                          });
                        } else {
                          Navigator.pushNamed(context, resultRoute,
                              arguments: [_score, multipleChoice.length]);
                        }
                      }
                    : null,
                child: Text(_questionNumber < multipleChoice.length
                    ? "Next Question"
                    : "See Results"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final MultipleChoiceQuestion question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    Key? key,
    required this.question,
    required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: question.options
            .map((option) => buildOption(context, option))
            .toList(),
      ),
    );
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Text(
          option.text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Color getColorForOption(Option option, MultipleChoiceQuestion question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }
}
