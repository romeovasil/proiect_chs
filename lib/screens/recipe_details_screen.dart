import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proiect_chs_r/resources/firestore_methods.dart';
import 'package:proiect_chs_r/utils/colors.dart';
import 'package:proiect_chs_r/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final dynamic snap;

  const RecipeDetailsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          widget.snap["name"],
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/wallpaper.svg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, size: 20.0),
                          SizedBox(width: 4.0),
                          Text(
                            'Portions: ${widget.snap['portions']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.0),
                      Row(
                        children: [
                          Icon(Icons.assessment, size: 20.0),
                          SizedBox(width: 4.0),
                          Text(
                            'Difficulty: ${widget.snap['difficulty']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 20.0),
                          SizedBox(width: 4.0),
                          Text(
                            'Time: ${widget.snap['time']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    widget.snap['recipeUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 8),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        widget.snap['ingredients'].length,
                        (index) => Row(
                          children: [
                            Text(
                              widget.snap['ingredients'][index],
                              style: TextStyle(fontSize: 16.0),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                await FirestoreMethods().addIngredient(
                                    userProvider.getUser!.uid,
                                    widget.snap['ingredients'][index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '${widget.snap['instructions']}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
