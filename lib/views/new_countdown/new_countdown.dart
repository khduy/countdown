import 'dart:io';

import 'package:countdown/constant/color.dart';
import 'package:countdown/views/new_countdown/provider/new_countdown_provider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:provider/provider.dart';

class NewCountdownPage extends StatefulWidget {
  NewCountdownPage({Key? key}) : super(key: key);

  @override
  _NewCountdownPageState createState() => _NewCountdownPageState();
}

class _NewCountdownPageState extends State<NewCountdownPage> {
  final titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  late final NewCountdownProvider newCountdownProvider;
  late final titleController;
  bool isInit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      isInit = false;
      newCountdownProvider = Provider.of<NewCountdownProvider>(context, listen: false);
      titleController = TextEditingController(text: newCountdownProvider.name);
    }
  }

  final _listColor = [
    MColor.blue,
    MColor.red,
    MColor.orange,
    MColor.yellow,
    MColor.green,
    MColor.darkBlue,
    MColor.purple,
    MColor.grey,
    MColor.darkGrey,
  ];

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  final DateFormat _formatter = DateFormat('dd MMMM, yyyy');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'New Countdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title', style: titleTextStyle),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: titleController,
                    onChanged: (value) {
                      Provider.of<NewCountdownProvider>(context, listen: false).setName = value;
                    },
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color(0xfff5f7f9),
                      filled: true,
                      hintText: 'The title of the countdown',
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Text('Date & Time', style: titleTextStyle),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // date picker ==================
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Color(0xfff5f7f9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Consumer<NewCountdownProvider>(
                                builder: (context, provider, child) {
                                  return Text(
                                    _formatter.format(provider.date),
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ),
                          ),
                          onTap: () async {
                            var date = await DatePicker.showSimpleDatePicker(
                              context,
                              initialDate:
                                  Provider.of<NewCountdownProvider>(context, listen: false).date,
                              firstDate: DateTime.now(),
                              dateFormat: "dd-MMMM-yyyy",
                              looping: true,
                            );
                            if (date != null) {
                              Provider.of<NewCountdownProvider>(context, listen: false)
                                  .pickDate(date);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      // time picker ===================
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Color(0xfff5f7f9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Consumer<NewCountdownProvider>(
                                builder: (context, provider, child) => Text(
                                  '${provider.time.hour}:${provider.time.minute}',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                elevation: 1,
                                is24HrFormat: true,
                                value:
                                    Provider.of<NewCountdownProvider>(context, listen: false).time,
                                onChange: (TimeOfDay value) {
                                  Provider.of<NewCountdownProvider>(context, listen: false)
                                      .pickTime(value);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),
                  Text('Color', style: titleTextStyle),
                  SizedBox(height: 5),
                  // color picker ===================
                  Container(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _listColor.length,
                      itemBuilder: (context, index) {
                        return Consumer<NewCountdownProvider>(
                          builder: (context, provider, child) {
                            return GestureDetector(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _listColor[index],
                                    ),
                                  ),
                                  if (index == provider.pickedColorIndex)
                                    Icon(Icons.check, color: Colors.white),
                                ],
                              ),
                              onTap: () {
                                provider.pickColor(index, _listColor[index]);
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Background photo', style: titleTextStyle),
                  SizedBox(height: 5),
                  // image picker ==================
                  GestureDetector(
                    child: Consumer<NewCountdownProvider>(
                      builder: (context, provider, child) => Container(
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: 180,
                          minWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfff5f7f9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: provider.backgroundPhoto != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  provider.backgroundPhoto!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.add_a_photo_rounded),
                      ),
                    ),
                    onTap: () {
                      _getFromGallery(context);
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text("Loop", style: titleTextStyle),
                      Spacer(),
                      Consumer<NewCountdownProvider>(
                        builder: (context, provider, child) {
                          return CupertinoSwitch(
                            value: provider.isLoop,
                            onChanged: (value) {
                              provider.setLoop(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    "automatically add 7 days at the end of the countdown",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: MColor.blue,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<NewCountdownProvider>(context, listen: false).saveCountdown();
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getFromGallery(BuildContext context) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final size = (await File(image.path).readAsBytes()).lengthInBytes / 1024 / 1024;
      if (size < 2) {
        final photo = File(image.path);
        Provider.of<NewCountdownProvider>(context, listen: false).pickPhoto(photo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('This photo is too big, only photos smaller than 2MB can be saved'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
