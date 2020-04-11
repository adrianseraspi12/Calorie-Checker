import 'package:calorie_counter/data/model/list_of_food.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter/bloc/bloc_provider.dart';
import 'package:calorie_counter/bloc/search_food_query_bloc.dart';

class SearchFoodScreen extends StatefulWidget {
  
  @override
  _SearchFoodScreenState createState() => _SearchFoodScreenState();

}

class _SearchFoodScreenState extends State<SearchFoodScreen> with SingleTickerProviderStateMixin {

  TextEditingController _textEditingController = TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = SearchFoodQueryBloc();
    bloc.setUpClient();

    return BlocProvider<SearchFoodQueryBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Food',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                  onEditingComplete: () {
                    final query = _textEditingController.text;
                    bloc.submitQuery(query);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ),

          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'Common Foods',),
              Tab(text: 'Branded Foods',)
            ],
            
            ),

        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget> [
            _buildCommonFoodResults(bloc),
            _buildBrandedFoodResults(bloc),
          ],
          )

      ),
    );
  }

  Widget _buildCommonFoodResults(SearchFoodQueryBloc bloc) {
    return StreamBuilder<List<CommonFood>>(
      stream: bloc.commonFoodStream,
      builder: (context, snapshot) {

        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('Search A Food'));
        }

        if (results.isEmpty) {
          return Center(child: Text('No Food Found'));
        }

        return ListView.separated(
          itemBuilder: (context, index) {

            final commonFood = results[index];
        
            return ListTile(
              title: Text(commonFood.foodName)
            );

        }, 
        separatorBuilder: (BuildContext context, int index) => Divider(), 
        itemCount: results.length);

      });
  }

  Widget _buildBrandedFoodResults(SearchFoodQueryBloc bloc) {
    return StreamBuilder<List<BrandedFood>>(
      stream: bloc.brandedFoodStream,
      builder: (context, snapshot) {

        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('Search A Food'));
        }

        if (results.isEmpty) {
          return Center(child: Text('No Food Found'));
        }

        return ListView.separated(
          itemBuilder: (context, index) {

            final commonFood = results[index];
        
            return ListTile(
              title: Text(commonFood.foodName)
            );

        }, 
        separatorBuilder: (BuildContext context, int index) => Divider(), 
        itemCount: results.length);

      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    super.dispose();
  }

}