import 'package:flutter/material.dart';
import 'package:maestro/pages/QuizPages/random_filter.dart';
import 'package:maestro/slider_design.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

double _value = 0;
const int min = 1;
final int max = getCountOfQuestions();

class SliderWidgetState extends State<SliderWidget> {
  final double sliderHeight = 48;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    return Container(
      width: sliderHeight * 5.5,
      height: sliderHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(sliderHeight * .3),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00c6ff),
            Color(0xFF0072ff),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 1.00),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            sliderHeight * paddingFactor, 2, sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '$min',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),
                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: sliderHeight * .4,
                      min: min,
                      max: max,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    activeTickMarkColor: Colors.white,
                  ),
                  child: Slider(
                    value: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Text(
              '$max',
              style: TextStyle(
                fontSize: sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int getValueFromSlider() {
  return (min + (max - min) * _value).round();
}
