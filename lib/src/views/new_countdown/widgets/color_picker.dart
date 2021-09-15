import '../../../../config/color.dart';




import 'package:flutter/material.dart';

class MColorPicker extends StatefulWidget {
  const MColorPicker({Key? key, 
    required this.onPick,
    this.initColor,
    this.height = 50,
  }) : super(key: key);

  final int height;
  final Function(Color) onPick;
  final Color? initColor;

  @override
  _MColorPickerState createState() => _MColorPickerState();
}

class _MColorPickerState extends State<MColorPicker> {
  int pickedIndex = 0;
  final listColors = [
    MColor.red,
    MColor.orange,
    MColor.yellow,
    MColor.green,
    MColor.blue,
    MColor.darkBlue,
    MColor.purple,
    MColor.grey,
    MColor.darkGrey,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initColor != null) {
      pickedIndex = listColors.indexWhere((color) => widget.initColor == color);
    }
    widget.onPick(listColors[pickedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listColors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listColors[index],
                  ),
                ),
                if (index == pickedIndex) const Icon(Icons.check, color: Colors.white),
              ],
            ),
            onTap: () {
              widget.onPick(listColors[index]);
              setState(() {
                pickedIndex = index;
              });
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
      ),
    );
  }
}
