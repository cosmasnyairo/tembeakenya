import 'package:flutter/material.dart';
import 'package:tembea_kenya/screens/bookmark.dart';
import 'package:tembea_kenya/screens/homepage.dart';
import 'package:tembea_kenya/screens/licences.dart';
import 'package:tembea_kenya/screens/webview.dart';

class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tembea Kenya'),
          bottom: TabBar(
            indicatorWeight: 5,
            onTap: (index) {},
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.bookmark), text: 'Bookmarks'),
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (ctx) => [
                PopupMenuItem(child: Text('Documentation'), value: 0),
                PopupMenuItem(child: Text('Licences'), value: 1),
              ],
              onSelected: (index) {
                switch (index) {
                  case 0:
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MyWebview(
                            title: 'Documentation',
                            url: Uri.encodeFull(
                                "https://cosmasnyairo.medium.com/making-a-places-to-visit-app-using-python-and-flutter-prerequisites-b1449c100ae8"))));
                    break;
                  case 1:
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LicencesUsed()));
                    break;
                }
              },
              icon: Icon(Icons.more_vert),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
        body: TabBarView(children: [HomePage(), BookMarkPage()]),
      ),
    );
  }
}
