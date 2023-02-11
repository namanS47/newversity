import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newversity/firestore/model/user.dart';

class FireStoreRepository{
  final users = "USERS";

  Future<void> addUserToFireStore(UserData userData) async {
    print("naman21");
    final db = FirebaseFirestore.instance;
    // final userJson = userData.toJson();
    // print(userJson);
    await db.collection(users).doc("dvdfvdfvdvdv").set(userData.toJson());
    // print("naman22");
    // await db.collection(users).add(userJson);

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