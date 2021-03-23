import 'package:flutter/material.dart';
import 'package:tembea_kenya/models/destination.dart';
import 'package:tembea_kenya/screens/destinationdetail.dart';
import 'package:tembea_kenya/widgets/custom_tile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DestinationList extends StatelessWidget {
  final List<Destination> destinations;

  const DestinationList(this.destinations);
  @override
  Widget build(BuildContext context) {
    final _devicespecs = MediaQuery.of(context).size;
    final _theme = Theme.of(context);

    return ListView.separated(
      separatorBuilder: (ctx, i) => SizedBox(height: 10),
      itemCount: destinations.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (ctx, i) => Card(
        child: CustomTile(
          ontap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => DestinationDetail(
                  destination: destinations[i],
                ),
              ),
            );
          },
          leading: Container(
            width: _devicespecs.width * 0.2,
            height: _devicespecs.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: destinations[i].title,
                child: Image.network(
                  destinations[i].imageurl,
                  fit: BoxFit.cover,
                  width: _devicespecs.width * 0.2,
                  height: _devicespecs.width * 0.2,
                  frameBuilder: (BuildContext context, Widget child, int frame,
                      bool wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (_, child, progress) {
                    return progress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes
                                  : null,
                            ),
                          );
                  },
                ),
              ),
            ),
          ),
          title: Text(destinations[i].title.trim()),
          subtitle: Row(
            children: [
              RatingBarIndicator(
                rating: double.parse(destinations[i].review),
                itemBuilder: (_, $) =>
                    Icon(Icons.star, color: _theme.accentColor),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              SizedBox(width: 5),
              Text(
                '${destinations[i].review} (${destinations[i].noofreviews})',
              ),
            ],
          ),
          trailing: Icon(
            Icons.navigate_next,
            color: _theme.accentColor,
            size: 25,
          ),
          isthreeline: true,
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}
