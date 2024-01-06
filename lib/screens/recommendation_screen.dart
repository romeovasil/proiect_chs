import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proiect_chs_r/utils/colors.dart';
import 'package:proiect_chs_r/widgets/recipe_card.dart';
import 'package:searchfield/searchfield.dart';

class SearchFieldSample extends StatefulWidget {
  const SearchFieldSample({Key? key}) : super(key: key);

  @override
  State<SearchFieldSample> createState() => _SearchFieldSampleState();
}

class _SearchFieldSampleState extends State<SearchFieldSample> {
  int suggestionsCount = 12;
  final focus = FocusNode();
  String _selected_recipe = '';
  List<String> recipeRecommendations = [];
  @override
  void dispose() {
    _searchController.dispose();
    focus.dispose();
    super.dispose();
  }

  final _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool containsRecipe(String text) {
    final String? result = suggestions.firstWhere(
        (String x) => x.toLowerCase() == text.toLowerCase(),
        orElse: () => '');

    if (result!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    getRecipeStream();
    super.initState();
  }

  Future<void> getRecipeStream() async {
    var data = await FirebaseFirestore.instance
        .collection('recipeRecommendations')
        .get();

    Set<String> uniqueNames = Set<String>();

    data.docs.forEach((doc) {
      var name = doc.get('name')
          as String; // Replace 'name' with the actual field name
      uniqueNames.add(name);
    });

    setState(() {
      suggestions = uniqueNames.toList();
      print(suggestions);
    });
  }

  Future<void> getRecipeRecommendationStream() async {
    var data = await FirebaseFirestore.instance
        .collection('recipeRecommendations')
        .get();

    Set<String> uniqueNames = Set<String>();

    data.docs.forEach((doc) {
      if (doc.get('name') == _selected_recipe) {
        var name = doc.get('name2')
            as String; // Replace 'name' with the actual field name
        uniqueNames.add(name);
      }
    });

    setState(() {
      recipeRecommendations = uniqueNames.toList();
      print(recipeRecommendations);
    });
  }

  var suggestions = <String>[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text('RecipeRecommendations'),
            ),
            body: Stack(children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/wallpaper.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: SearchField(
                        focusNode: focus,
                        suggestions: suggestions
                            .map((x) => SearchFieldListItem(x, item: x))
                            .toList(),
                        suggestionState: Suggestion.hidden,
                        controller: _searchController,
                        hint: 'Search by country name',
                        maxSuggestionsInViewPort: 4,
                        itemHeight: 45,
                        textCapitalization: TextCapitalization.words,
                        validator: (x) {
                          if (x!.isEmpty || !containsRecipe(x)) {
                            return 'Please Enter a valid Country';
                          }
                          return null;
                        },
                        inputType: TextInputType.text,
                        onSuggestionTap: (SearchFieldListItem<String> x) {
                          setState(() {
                            _selected_recipe = x.item!;
                          });
                          _formKey.currentState!.validate();
                          getRecipeRecommendationStream();
                          focus.unfocus();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _selected_recipe.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .blue, // Set the background color of the outer container
                                    borderRadius: BorderRadius.circular(
                                        8), // Set border radius for rounded corners
                                  ),
                                  child: Text(
                                    'Select Recipe',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Recommendations(
                              selectedRecipe: _selected_recipe,
                              suggestions: recipeRecommendations,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              )
            ])));
  }
}

class Recommendations extends StatefulWidget {
  final String selectedRecipe;
  List<String> suggestions;

  Recommendations(
      {Key? key, required this.selectedRecipe, List<String>? suggestions})
      : suggestions =
            suggestions ?? [], // Initialize suggestions or use an empty list
        super(key: key);

  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget dataWidget(String key, List<String> values) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors
            .blueAccent, // Set the background color of the outer container
        borderRadius:
            BorderRadius.circular(10), // Set border radius for rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$key:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors
                      .orange, // Set the background color of the inner container
                  borderRadius: BorderRadius.circular(
                      8), // Set border radius for rounded corners
                ),
                child: Row(
                  children: [
                    Icon(Icons.food_bank,
                        color: Colors.white), // Use food-related icon
                    SizedBox(width: 8),
                    Text(
                      '${values[index]}',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                Colors.blue, // Set the background color of the outer container
            borderRadius: BorderRadius.circular(
                8), // Set border radius for rounded corners
          ),
          child: Text(
            widget.selectedRecipe,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        dataWidget('Recommendations', widget.suggestions)
      ],
    );
  }
}
