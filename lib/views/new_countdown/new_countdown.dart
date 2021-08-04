import 'dart:io';

import 'package:countdown/constant/color.dart';
import 'package:countdown/views/new_countdown/provider/new_countdown_provider.dart';
import 'package:countdown/views/new_countdown/widgets/color_picker.dart';
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

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  final DateFormat _formatter = DateFormat('dd MMMM, yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text('New Countdown', style: theme.textTheme.headline2),
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
                  Text('Title', style: theme.textTheme.bodyText1),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: titleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      newCountdownProvider.setName = value;
                    },
                    style: theme.textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: theme.hoverColor,
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
                  Text('Date & Time', style: theme.textTheme.bodyText1),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // ======================== date picker ==================
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.hoverColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Consumer<NewCountdownProvider>(
                                builder: (context, provider, child) {
                                  return Text(
                                    _formatter.format(provider.date),
                                    style: theme.textTheme.bodyText2,
                                  );
                                },
                              ),
                            ),
                          ),
                          onTap: () async {
                            var date = await DatePicker.showSimpleDatePicker(
                              context,
                              initialDate: newCountdownProvider.date,
                              firstDate: DateTime.now(),
                              dateFormat: "dd-MMMM-yyyy",
                              looping: true,
                              backgroundColor: theme.primaryColor,
                              textColor: theme.accentColor,
                              itemTextStyle: theme.textTheme.bodyText1,
                            );
                            if (date != null) {
                              newCountdownProvider.pickDate(date);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      // ========================== time picker ===================
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.hoverColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Consumer<NewCountdownProvider>(
                                builder: (context, provider, child) {
                                  var hour = provider.time.hour < 10
                                      ? "0${provider.time.hour}"
                                      : "${provider.time.hour}";
                                  var mins = provider.time.minute < 10
                                      ? "0${provider.time.minute}"
                                      : "${provider.time.minute}";
                                  return Text(
                                    '$hour:$mins',
                                    style: theme.textTheme.bodyText2,
                                  );
                                },
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                elevation: 1,
                                is24HrFormat: true,
                                value: newCountdownProvider.time,
                                accentColor: MColor.blue,
                                onChange: newCountdownProvider.pickTime,
                                okCancelStyle: TextStyle(
                                  color: theme.accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // ========================= color picker ===================
                  SizedBox(height: 15),
                  Text('Color', style: theme.textTheme.bodyText1),
                  SizedBox(height: 5),
                  MColorPicker(
                    initColor: newCountdownProvider.color,
                    onPick: newCountdownProvider.pickColor,
                  ),
                  // ========================== image picker ==================
                  SizedBox(height: 15),
                  Text('Background photo', style: theme.textTheme.bodyText1),
                  SizedBox(height: 5),
                  GestureDetector(
                    child: Consumer<NewCountdownProvider>(
                      builder: (context, provider, child) => Container(
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: 180,
                          minWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          color: theme.hoverColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: provider.backgroundPhoto != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.memory(
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
                      Text("Loop", style: theme.textTheme.bodyText1),
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
                    "Automatically add 7 days at the end of the countdown",
                    style: theme.textTheme.subtitle2,
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
      final size = (await File(image.path).readAsBytes()).lengthInBytes / 1024 / 1024; // to mb
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
