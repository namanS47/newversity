// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CampusTab extends StatefulWidget {
  const CampusTab({Key? key}) : super(key: key);

  @override
  State<CampusTab> createState() => _CampusTabState();
}

class _CampusTabState extends State<CampusTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: ListView(
          children: [
            _getContainer(),
            _getContainer(),
            _getContainer(),
            _getContainer(),
            _getContainer(),
          ],
        ),
      ),
    );
  }

  Widget _getContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                ),
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "I want to pursue my career as an android developer, I am currently in my 3rd year of college and my streem is chemical engineer, what path should I folloe",
                      style: TextStyle(),
                    ),
                    SizedBox(height: 30,),
                    Text(
                        "Start doing android development and take a career counselling session on NewVersity"
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(color: Colors.red,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () async {

                  // final user = FirebaseAuth.instance.currentUser;
                  // if(user!= null){
                  //   final idToken = await user.getIdToken();
                  //   print("naman ${idToken}");
                  //   print(user.uid);
                  // }

              }, child: Text("Like")),
              Text("Comment"),
              Text("Share")
            ],
          )
        ],
      ),
    );
  }
}
