import 'package:countdown/models/countdown.dart';
import 'package:countdown/service/notification/notification_service.dart';
import 'package:countdown/views/home_page/provider/home_provider.dart';
import 'package:countdown/views/new_countdown/new_countdown.dart';
import 'package:countdown/views/home_page/widgets/coundown_item.dart';
import 'package:countdown/views/new_countdown/provider/new_countdown_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  var isInited = false;

  @override
  void didChangeDependencies() async {
    if (!isInited) {
      isInited = true;
      await Provider.of<HomeProvider>(context, listen: false).getCountdowns();
      Provider.of<HomeProvider>(context, listen: false).initTimer();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Logo(),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 25),
                color: Colors.grey[400],
                child: Icon(Icons.add),
                onPressed: () async {
                  bool? rs = await showSheetNewCountdown(context);
                  if (rs ?? false) {
                    Provider.of<HomeProvider>(context, listen: false).getCountdowns();
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.countdowns.length > 0
                ? ListView.separated(
                    itemCount: provider.countdowns.length,
                    padding: const EdgeInsets.all(16),
                    physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: CountDownItem(
                          key: Key(provider.countdowns[index].id.toString()),
                          countdown: provider.countdowns[index],
                        ),
                        onLongPress: () {
                          showOptionsSheet(context, provider, index);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "You don't have any countdown. Let's create one.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  showOptionsSheet(BuildContext context, HomeProvider provider, int index) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                ),
                onTap: () async {
                  bool? rs = await showSheetNewCountdown(
                    context,
                    provider.countdowns[index],
                  );

                  if (rs ?? false) {
                    Navigator.of(context).pop();
                    await provider.getCountdowns();
                  }
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                ),
                onTap: () async {
                  await NotificationService().cancelNotification(provider.countdowns[index].id!);
                  await provider.deleteCountdown(provider.countdowns[index].id!);
                  await provider.getCountdowns();

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showSheetNewCountdown(BuildContext context, [Countdown? countdown]) {
    return showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => NewCountdownProvider()..setData(countdown),
        child: NewCountdownPage(),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Countdown',
      style: TextStyle(
        fontFamily: 'Anton',
        fontSize: 30,
        color: Colors.black,
      ),
    );
  }
}
