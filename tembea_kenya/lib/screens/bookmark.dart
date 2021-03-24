import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/models/destination.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
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
    setState(() => _isloading = true);

    bookmarkeddestinations =
        await Provider.of<DestinationProvider>(context, listen: true)
            .getBookmarks();
    setState(() => _isloading = false);
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
                bookmarkeddestinations.isEmpty
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text('Clear'),
                          onPressed: () async {
                            setState(() => _isloading = true);
                            await Provider.of<DestinationProvider>(context,
                                    listen: false)
                                .clearBookmarks();
                            setState(() => _isloading = false);
                          },
                        ),
                      ),
                Text(
                    bookmarkeddestinations.length == 0
                        ? 'No bookmarked destination'
                        : bookmarkeddestinations.length == 1
                            ? '${bookmarkeddestinations.length} bookmarked destination'
                            : '${bookmarkeddestinations.length} bookmarked destinations',
                    textAlign: TextAlign.center),
                SizedBox(height: 10),
                DestinationList(bookmarkeddestinations),
                SizedBox(height: 20),
              ],
            ),
          );
  }
}
