import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proiect_chs_r/model/recipe.dart';
import 'package:proiect_chs_r/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> addRecipe(
      String instructions,
      String name,
      String uid,
      Uint8List file,
      String time,
      String portions,
      String difficulty,
      String username,
      ingredients) async {
    String res = "error";
    try {
      print("merge?");
      String photoUrl =
          await StorageMethods().uploadImageToStorage("recipes", file, true);
      print("nu?");
      String recipeId = const Uuid().v1();
      Recipe recipe = Recipe(
          name: name,
          time: time,
          difficulty: difficulty,
          instructions: instructions,
          portions: portions,
          uid: uid,
          recipeId: recipeId,
          recipeUrl: photoUrl,
          username: username,
          likes: [],
          ingredients: ingredients);

      _firebaseFirestore
          .collection("recipes")
          .doc(recipeId)
          .set(recipe.toJson());
      res = "succes";
    } catch (err) {
      res = err.toString();
    }
    print("res");
    return res;
  }

  Future<void> likeRecipe(String recipeId, String uid, List likes) async {
    print('$recipeId' '$uid' '$likes');
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection("recipes").doc('$recipeId').update({
          'likes': FieldValue.arrayRemove(
            [uid],
          ),
        });
      } else {
        await _firebaseFirestore.collection("recipes").doc('$recipeId').update({
          'likes': FieldValue.arrayUnion(
            [uid],
          ),
        });
      }
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> addIngredient(String uid, String ingredient) async {
    DocumentReference userShoppingList =
        _firebaseFirestore.collection("shoppingLists").doc(uid);

    var snapshot = await userShoppingList.get();
    var currentIngredients =
        snapshot.exists ? List<String>.from(snapshot['ingredients']) : [];

    currentIngredients.add(ingredient);

    await userShoppingList.set({'ingredients': currentIngredients});
  }

  Future<void> deleteIngredient(String uid, String ingredient) async {
    DocumentReference userShoppingList =
        _firebaseFirestore.collection("shoppingLists").doc(uid);

    var snapshot = await userShoppingList.get();
    var currentIngredients =
        snapshot.exists ? List<String>.from(snapshot['ingredients']) : [];

    currentIngredients.remove(ingredient);

    await userShoppingList.set({'ingredients': currentIngredients});
  }

  Future<void> clearShoppingList(String uid) async {
    DocumentReference userShoppingList =
        _firebaseFirestore.collection("shoppingLists").doc(uid);

    var snapshot = await userShoppingList.get();
    var currentIngredients =
        snapshot.exists ? List<String>.from(snapshot['ingredients']) : [];

    currentIngredients.clear();

    await userShoppingList.set({'ingredients': currentIngredients});
  }
}
