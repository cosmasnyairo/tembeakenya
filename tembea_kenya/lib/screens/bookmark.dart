import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/models/destination.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:tembea_kenya/widgets/custom_tile.dart';
import 'package:tembea_kenya/widgets/destination_list.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  bool _isloading = false;
  List<Destination> bookmarkeddestinations = [];
  @override
  void didChangeDependencies() async {
    setState(() {
      _isloading = true;
    });

    bookmarkeddestinations =
        await Provider.of<DestinationProvider>(context, listen: true)
            .getBookmarks();
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _devicespecs = MediaQuery.of(context).size;

    return _isloading
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: _devicespecs.height,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  'You have ${bookmarkeddestinations.length} bookmarked destinations',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                DestinationList(bookmarkeddestinations),
                SizedBox(height: 20),
              ],
            ),
          );
  }
}
