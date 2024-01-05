import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proiect_chs_r/utils/colors.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final snap;

  const RecipeDetailsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          snap["name"],
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
                            'Portions: ${snap['portions']}',
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
                            'Difficulty: ${snap['difficulty']}',
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
                            'Time: ${snap['time']}',
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
                    snap['recipeUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 8),
                SizedBox(height: 8),
                Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '${snap['instructions']}',
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
