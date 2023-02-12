import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newversity/firestore/model/user.dart';

class FireStoreRepository{
  final users = "Users";

  Future<void> addUserToFireStore(UserData userData) async {
    final db = FirebaseFirestore.instance;
    await db.collection(users).doc(userData.userId).set(userData.toJson());

    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };

    db
        .collection("cities")
        .doc("LA")
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));
  }
}