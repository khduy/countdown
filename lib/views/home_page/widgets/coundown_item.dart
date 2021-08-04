import 'dart:ui';

import 'package:countdown/models/countdown.dart';
import 'package:flutter/material.dart';

class CountDownItem extends StatelessWidget {
  CountDownItem({
    Key? key,
    required this.countdown,
    this.onLongPress,
  }) : super(key: key);

  final Countdown countdown;
  final Function()? onLongPress;

  final titleTextStyle = TextStyle(
    fontFamily: 'Voltaire',
    fontSize: 22,
    letterSpacing: 0.2,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final numberTextStyle = TextStyle(
    fontFamily: 'PassionOne',
    fontSize: 55,
    color: Colors.white,
  );

  final unitTextStyle = TextStyle(
    fontFamily: 'Voltaire',
    fontSize: 15,
    height: 0.6,
    color: Colors.white,
  );

  final dateTimeTextStyle = TextStyle(
    fontFamily: 'Voltaire',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          image: countdown.photo != null
              ? DecorationImage(
                  image: MemoryImage(countdown.photo!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: countdown.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.black26,
            splashColor: Colors.transparent,
            onLongPress: onLongPress,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    countdown.title,
                    style: titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${countdown.days}", style: numberTextStyle),
                          Text(
                            'DAYS',
                            style: unitTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${countdown.hours}', style: numberTextStyle),
                          Text(
                            'HOURS',
                            style: unitTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${countdown.mins}', style: numberTextStyle),
                          Text(
                            'MINS',
                            style: unitTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${countdown.secs}', style: numberTextStyle),
                          Text(
                            'SECS',
                            style: unitTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          indent: 50,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        '  UNTIL  ',
                        style: TextStyle(
                          fontFamily: 'Voltaire',
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          endIndent: 50,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    countdown.dateToString() + " - " + countdown.timeToString(),
                    style: dateTimeTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
