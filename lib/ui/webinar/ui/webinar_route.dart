import 'package:flutter/material.dart';

class WebinarTab extends StatefulWidget {
  const WebinarTab({Key? key}) : super(key: key);

  @override
  State<WebinarTab> createState() => _WebinarTabState();
}

class _WebinarTabState extends State<WebinarTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          _getWebinarContainer(),
          _getWebinarContainer(),
          _getWebinarContainer(),
          _getWebinarContainer(),
          _getWebinarContainer()
        ],
      ),
    );
  }

  Widget _getWebinarContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.green,
            ),
            width: double.infinity,
            height: 100,
            child: const Center(child: Text("Image will come here"),),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jee Mock Councelling session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text("7:00 PM Today"),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green)),
                      child: Center(child: Text("Book Now", style: TextStyle(color: Colors.green),),),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
