import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_class/core/utils/colors.dart';

class WaitingApprovalScreen extends StatelessWidget {
  final String roomId;
  const WaitingApprovalScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance
        .collection("rooms")
        .doc(roomId)
        .collection("waitingList")
        .where("status", isEqualTo: "waiting")
        .snapshots()
        , builder:  (context, snapshot) {
      //if snapshot has no data yet, show a loading indicator
          if(!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          //get the list of waiting users (documents)
          final waitingUsers = snapshot.data!.docs;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text("List of User Waiting for Approval",

             style: TextStyle(fontSize: 18), ),
            ),
            //if  no users are waiting show a msg
            body: waitingUsers.isEmpty
            ? Center(child: Text("No any user are waiting for Approval")):ListView(
              //map each firestore document into a listTile
              children: waitingUsers.map((doc){

                //convert document data into a map for easy access
                final data = doc.data() as Map<String, dynamic>;


                return ListTile(

                //show the user's name from firestore
                  title: Text(data['name']),
                  //row to action on the right
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //approve button
                      IconButton(onPressed: (){
                        //update the document's status to "approved"
                        doc.reference.update({"status" : "approved"});
                      }, icon: Icon(Icons.check,color: Colors.green,) ),
                      // reject Button
                      IconButton(onPressed: (){
                        //update the document's status to "rejected"
                        doc.reference.update({"status" : "rejected"});
                        },
                          icon: Icon(Icons.close, color: Colors.red,))
                    ],
                  ),
                );
              }).toList()  ,
            ) ,
          );

        }

    ) ;
  }
}
