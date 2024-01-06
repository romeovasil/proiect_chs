import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String name;
  final String time;
  final String difficulty;
  final String instructions;
  final String portions;
  final String uid;
  final String username;
  final String recipeUrl;
  final String recipeId;
  final likes;
  final ingredients;

  const Recipe(
      {required this.name,
      required this.time,
      required this.difficulty,
      required this.instructions,
      required this.portions,
      required this.uid,
      required this.username,
      required this.recipeUrl,
      required this.recipeId,
      required this.likes,
      required this.ingredients});

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Recipe(
      name: snapshot["name"],
      uid: snapshot["uid"],
      time: snapshot["time"],
      difficulty: snapshot["difficulty"],
      instructions: snapshot["instructions"],
      portions: snapshot["portions"],
      username: snapshot["username"],
      recipeUrl: snapshot["recipeUrl"],
      recipeId: snapshot["recipeId"],
      likes: snapshot["likes"],
      ingredients: snapshot["ingredients"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "difficulty": difficulty,
        "instructions": instructions,
        "portions": portions,
        "time": time,
        "name": name,
        "username": username,
        "recipeUrl": recipeUrl,
        "recipeId": recipeId,
        "likes": likes,
        "ingredients": ingredients,
      };
}
