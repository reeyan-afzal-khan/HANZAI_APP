import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:move_to_background/move_to_background.dart';

import 'package:hanzai_app/pages/home_main.dart';
import 'package:hanzai_app/pages/home_orc.dart';
import 'package:hanzai_app/pages/home_user.dart';
import 'package:hanzai_app/model/theme_model.dart';

import 'package:showcaseview/showcaseview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer(builder: ((context, ThemeModel themeNotifier, child) {
          return MaterialApp(
              theme: themeNotifier.isDark
                  ? FlexThemeData.dark(scheme: FlexScheme.hippieBlue)
                  : FlexThemeData.light(scheme: FlexScheme.hippieBlue),
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale("en", "US"),
                Locale(
                    "ur", "PK"), // OR Locale('ar', 'AE') OR Other RTL locales
              ],
              home: const TabSel());
        })));
  }
}

class TabSel extends StatefulWidget {
  const TabSel({Key? key}) : super(key: key);

  @override
  State<TabSel> createState() => _TabSelState();
}

class _TabSelState extends State<TabSel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabList = ["کریکٹر ریکگنیشن", "ہانزی حروف", "یوزر مینو"];
  final List<IconData> _tabIcons = [
    Icons.camera_alt,
    Icons.border_color,
    Icons.assignment_ind
  ];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabList.length);
    _tabController.animation?.addListener(() {
      setState(() {
        _currentIndex = (_tabController.animation!.value).round();
      });
    });
    _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return WillPopScope(
          onWillPop: () async {
            if (_tabController.index == 0 || _tabController.index == 2) {
              setState(() {
                _tabController.index = 1;
                _currentIndex = 1;
              });
            } else {
              MoveToBackground.moveTaskToBack();
            }
            return false;
          },
          child: DefaultTabController(
              length: 3,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Scaffold(
                      endDrawer: Drawer(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              buildHeader(context),
                              buildMenuItems(context, themeNotifier)
                            ],
                          ),
                        ),
                      ),
                      appBar: AppBar(
                          backgroundColor: themeNotifier.isDark == false
                              ? Colors.lightBlue[800]
                              : Colors.grey[800],
                          title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () => {},
                                    icon: const Icon(Icons.attach_money,
                                        size: 30)),
                                IconButton(
                                    onPressed: () {
                                      if (_tabController.index == 0) {
                                      } else if (_tabController.index == 1) {
                                        setState(() {
                                          homeKey.currentState?.pageInfo();
                                        });
                                      } else {}
                                    },
                                    icon: const Icon(Icons.info_rounded,
                                        size: 30)),
                                const Spacer(flex: 1),
                                Text(
                                  _tabList[_currentIndex],
                                  style: const TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                const Spacer(flex: 1),
                              ]),
                          shadowColor: themeNotifier.isDark == false
                              ? Colors.grey[800]
                              : Colors.black,
                          elevation: 5),
                      body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            OCR(),
                            ShowCaseWidget(
                                builder: Builder(
                                    builder: (_) => Home(key: homeKey))),
                            User()
                          ]),
                      bottomNavigationBar: ConvexAppBar(
                        controller: _tabController,
                        height: 45,
                        items: [
                          TabItem(icon: _tabIcons[0]),
                          TabItem(icon: _tabIcons[1]),
                          TabItem(icon: _tabIcons[2]),
                        ],
                        backgroundColor: themeNotifier.isDark == false
                            ? Colors.lightBlue[800]
                            : Colors.grey[800],
                        disableDefaultTabController: true,
                        initialActiveIndex: 1,
                      )))));
    });
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );

  Widget buildMenuItems(BuildContext context, ThemeModel themeNotifier) =>
      Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(runSpacing: 16, children: <Widget>[
            ListTile(
              trailing: Icon(
                  themeNotifier.isDark ? Icons.nightlight : Icons.light_mode,
                  size: 30,
                  color: themeNotifier.isDark == false
                      ? Colors.lightBlue[800]
                      : Colors.white),
              title: Text(themeNotifier.isDark ? " ڈارک موڈ" : "لائٹ موڈ",
                  style: TextStyle(fontSize: 32),
                  textDirection: TextDirection.rtl),
              onTap: (() => setState(() {
                    if (themeNotifier.isDark) {
                      themeNotifier.isDark = false;
                    } else {
                      themeNotifier.isDark = true;
                    }
                  })),
            ),
            Divider(),
            ListTile(
              trailing: Icon(_tabIcons[1],
                  size: 30,
                  color: themeNotifier.isDark == false
                      ? Colors.lightBlue[800]
                      : Colors.white),
              title: Text(_tabList[1],
                  style: TextStyle(fontSize: 32),
                  textDirection: TextDirection.rtl),
              onTap: (() => setState(() {
                    _tabController.index = 1;
                    _currentIndex = 1;
                    Navigator.of(context).pop();
                  })),
            ),
            ListTile(
              trailing: Icon(_tabIcons[0],
                  size: 30,
                  color: themeNotifier.isDark == false
                      ? Colors.lightBlue[800]
                      : Colors.white),
              title: Text(_tabList[0],
                  style: TextStyle(fontSize: 26),
                  textDirection: TextDirection.rtl),
              onTap: (() => setState(() {
                    _tabController.index = 0;
                    _currentIndex = 0;
                    Navigator.of(context).pop();
                  })),
            ),
            ListTile(
              trailing: Icon(_tabIcons[2],
                  size: 30,
                  color: themeNotifier.isDark == false
                      ? Colors.lightBlue[800]
                      : Colors.white),
              title: Text(_tabList[2],
                  style: TextStyle(fontSize: 32),
                  textDirection: TextDirection.rtl),
              onTap: (() => setState(() {
                    _tabController.index = 2;
                    _currentIndex = 2;
                    Navigator.of(context).pop();
                  })),
            ),
            Divider()
          ]));
}