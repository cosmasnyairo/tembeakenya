import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/models/destination.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:tembea_kenya/screens/webview.dart';
import 'package:tembea_kenya/widgets/custom_tile.dart';

class DestinationDetail extends StatefulWidget {
  final Destination destination;
  const DestinationDetail({Key key, this.destination}) : super(key: key);
  @override
  _DestinationDetailState createState() => _DestinationDetailState();
}

class _DestinationDetailState extends State<DestinationDetail> {
  bool _isbookmarked = false;
  bool _isloading;
  bool _expandabout = false;

  @override
  Widget build(BuildContext context) {
    final _devicespecs = MediaQuery.of(context).size;
    final _theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: _devicespecs.height * 0.3,
              floating: true,
              pinned: true,
              snap: true,
              iconTheme: IconThemeData(color: Colors.black),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Hero(
                      tag: widget.destination.title,
                      child: Image.network(
                        widget.destination.imageurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: [
            Text(
              widget.destination.title.trim(),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.destination.about.trim(),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                RatingBarIndicator(
                  rating: double.parse(widget.destination.review),
                  itemBuilder: (_, $) =>
                      Icon(Icons.star, color: _theme.accentColor),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                SizedBox(width: 10),
                Text(
                  '${widget.destination.review} (${widget.destination.noofreviews})',
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Summary of destination',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              widget.destination.summary.length != 0
                  ? widget.destination.summary.trim()
                  : 'We have no summary of the destination in our records',
              maxLines: _expandabout ? null : 10,
              style: TextStyle(),
            ),
            widget.destination.summary.length != 0
                ? Center(
                    child: TextButton.icon(
                        icon:
                            Icon(Icons.unfold_more, color: _theme.accentColor),
                        label: Text(_expandabout ? 'Collapse' : 'Read more'),
                        onPressed: () =>
                            setState(() => _expandabout = !_expandabout)))
                : SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showmodal(widget.destination, _theme),
        label: Text('More actions'),
        icon: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> showmodal(Destination destination, ThemeData _theme) async {
    final provider = Provider.of<DestinationProvider>(context, listen: false);
    setState(() => _isloading = true);
    _isbookmarked = await provider.isBookmarked(destination);
    setState(() => _isloading = false);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: ($) => Container(
        child: _isloading
            ? Center(child: CircularProgressIndicator())
            : Wrap(
                children: <Widget>[
                  SizedBox(height: 10),
                  modalItem(
                      title: _isbookmarked
                          ? 'Remove from bookmarks'
                          : 'Add to bookmarks',
                      icon: Icons.bookmark,
                      color: _isbookmarked
                          ? _theme.primaryColor
                          : _theme.accentColor,
                      ontap: () async => await provider
                              .bookmarkDestination(
                                  destination, _isbookmarked ? false : true)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 500),
                                content: Text(
                                  _isbookmarked
                                      ? 'Bookmark removed'
                                      : 'Bookmark added',
                                ),
                                backgroundColor: _isbookmarked
                                    ? _theme.accentColor
                                    : _theme.primaryColor,
                              ),
                            );
                            Navigator.pop(context);
                          })),
                  SizedBox(height: 10),
                  modalItem(
                      title: 'Explore destination',
                      icon: Icons.explore,
                      color: _theme.accentColor,
                      ontap: () async => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (ctx) => MyWebview(
                                  title: 'Explore destination',
                                  url: Uri.encodeFull(
                                      "http://maps.google.co.in/maps?q=${destination.title}"))))
                          .then((value) => Navigator.of(context).pop())),
                  SizedBox(height: 10),
                  destination.wikipediaurl.isEmpty
                      ? SizedBox()
                      : modalItem(
                          title: 'View wikipedia site',
                          icon: Icons.track_changes,
                          color: _theme.accentColor,
                          ontap: () => Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (ctx) => MyWebview(
                                        title: 'Wikipedia page',
                                        url: destination.wikipediaurl.trim(),
                                      )))
                              .then((value) => Navigator.of(context).pop())),
                  SizedBox(height: 10),
                ],
              ),
      ),
    );
  }

  modalItem({String title, IconData icon, Color color, Function ontap}) =>
      CustomTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        ontap: ontap,
      );
}
