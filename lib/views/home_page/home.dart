import 'package:countdown/models/countdown.dart';
import 'package:countdown/services/notification/notification_service.dart';
import 'package:countdown/views/home_page/provider/home_provider.dart';
import 'package:countdown/views/home_page/widgets/floating_model.dart';
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
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Countdown', style: theme.textTheme.headline1),
          centerTitle: false,
          backgroundColor: theme.primaryColor,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 25),
                color: theme.hoverColor,
                child: Icon(Icons.add, color: theme.iconTheme.color),
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
        backgroundColor: theme.backgroundColor,
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.countdowns.length > 0
                ? ListView.separated(
                    itemCount: provider.countdowns.length,
                    padding: const EdgeInsets.all(16),
                    physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (context, index) {
                      return CountDownItem(
                        key: Key(provider.countdowns[index].id.toString()),
                        countdown: provider.countdowns[index],
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
    showFloatingModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: ListTile(
                trailing: Icon(Icons.edit),
                title: Text(
                  "Edit",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
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
            Divider(
              height: 0.2,
              thickness: 0.2,
              indent: 0,
              endIndent: 0,
              color: Theme.of(context).accentColor,
            ),
            InkWell(
              child: ListTile(
                trailing: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  "Delete",
                  style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.red),
                ),
              ),
              onTap: () async {
                await NotificationService().cancelNotification(provider.countdowns[index].id!);
                await provider.deleteCountdown(provider.countdowns[index].id!);
                await provider.getCountdowns();
                Navigator.of(context).pop();
              },
            ),
          ],
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
