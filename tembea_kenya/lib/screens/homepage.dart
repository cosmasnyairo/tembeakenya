import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/models/category.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:tembea_kenya/screens/categorydetail.dart';
import 'package:tembea_kenya/widgets/custom_tile.dart';
import 'package:tembea_kenya/widgets/destination_list.dart';
import 'package:tembea_kenya/widgets/error.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isloading = true;
  bool _erroroccurred = false;

  List<Categories> categories = [];

  @override
  void didChangeDependencies() async {
    await getCategories();
    super.didChangeDependencies();
  }

  Future<void> getCategories() async {
    setState(() => _isloading = true);
    try {
      categories =
          await Provider.of<DestinationProvider>(context, listen: false)
              .getCategories();
    } catch (e) {
      setState(() => _erroroccurred = true);
    }
    setState(() => _isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    final _devicespecs = MediaQuery.of(context).size;
    final _theme = Theme.of(context);
    return _erroroccurred
        ? ErrorPage(
            ontap: () async {
              setState(() => _erroroccurred = false);
              await getCategories();
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
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomTile(
                        leading: Icon(Icons.search, color: _theme.accentColor),
                        title: Text('Search for a destination'),
                        ontap: () => showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(_theme),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Destination Categories', textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (ctx, i) => CustomTile(
                          leading: Icon(
                            categories[i].categoryIcon(),
                            color: _theme.accentColor,
                          ),
                          title: Text(
                            '${categories[i].name[0].toUpperCase()}${categories[i].name.substring(1)}'
                                .replaceAll('_', ' '),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          subtitle: Text(
                              '${categories[i].length} destinations available'),
                          ontap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  CategoryDetail(category: categories[i]),
                            ));
                          }),
                      separatorBuilder: (ctx, $) => Divider(
                          indent: 20,
                          endIndent: 20,
                          color: _theme.primaryColor),
                    ),
                  ],
                ),
              );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final ThemeData _theme;
  CustomSearchDelegate(this._theme);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear, color: _theme.errorColor),
          onPressed: () => query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DestinationProvider>(context, listen: false)
          .searchDestination(query),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  children: [
                      Text(
                        'We have found ${snapshot.data.length} results',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      DestinationList(snapshot.data)
                    ]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Please enter destination details'));
  }
}
