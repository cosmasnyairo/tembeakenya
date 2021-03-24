import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/models/category.dart';
import 'package:tembea_kenya/models/destination.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:tembea_kenya/widgets/destination_list.dart';
import 'package:tembea_kenya/widgets/error.dart';

class CategoryDetail extends StatefulWidget {
  final Categories category;

  const CategoryDetail({Key key, this.category}) : super(key: key);
  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  bool _isloading = false;
  bool _nextdata = false;
  bool _erroroccurred = false;

  List<Destination> destinations = [];
  var controller = ScrollController();
  // fetch first 10
  int limit = 9;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    fetchDestination();
    controller.addListener(
      () {
        if (controller.position.atEdge &&
            controller.position.pixels != 0 &&
            destinations.length < widget.category.length) {
          fetchnextDestination();
        }
      },
    );
  }

  Future<void> fetchDestination() async {
    
    setState(() => _isloading = true);
    final provider = Provider.of<DestinationProvider>(context, listen: false);
    try {
      await provider.getDestination(widget.category.name);
    } catch (e) {
      setState(() => _erroroccurred = true);
    }
    destinations = provider.destinations;
    setState(() => _isloading = false);
    super.didChangeDependencies();
  }

  Future<void> fetchnextDestination() async {
    final provider = Provider.of<DestinationProvider>(context, listen: false);
    setState(() {
      _nextdata = true;
      offset = offset + 10;
    });
    try {
      await provider.getNextDestination(widget.category.name, offset);
    } catch (e) {
      setState(() => _erroroccurred = true);
    }
    destinations = provider.destinations;
    setState(() => _nextdata = false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _devicespecs = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category.name[0].toUpperCase()}${widget.category.name.substring(1)}'
              .replaceAll('_', ' '),
        ),
      ),
      body: _erroroccurred
          ? ErrorPage(
              ontap: () async {
                setState(() => _erroroccurred = false);
                await fetchDestination();                   
              },
              devicespecs: _devicespecs,
            )
          : _isloading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: _devicespecs.height,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20),
                    controller: controller,
                    children: [
                      Text(
                        'We have ${widget.category.length} available destinations',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      DestinationList(destinations),
                      SizedBox(height: 20),
                      Text(
                        destinations.length >= widget.category.length
                            ? 'All ${widget.category.length} destinations fetched'
                            : '${destinations.length} of ${widget.category.length} destinations fetched. Swipe up to load more',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _theme.accentColor),
                      ),
                      SizedBox(height: 20),
                      _nextdata
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
