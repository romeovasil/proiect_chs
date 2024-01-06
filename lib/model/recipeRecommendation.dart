import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String name;
  final String name2;
  final String correlation;

  const Recipe(
      {required this.name, required this.name2, required this.correlation});

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Recipe(
        name: snapshot["name"],
        name2: snapshot["name2"],
        correlation: snapshot["correlation"]);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "name2": name2,
        "correlation": correlation,
      };
}
