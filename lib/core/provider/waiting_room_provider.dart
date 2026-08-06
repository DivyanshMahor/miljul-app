 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//a provider that listens to the approval status of a user in a specific room
//if returns real time updates from firestore

final approvalStateProvider =
    StreamProvider.family<
      Map<String, dynamic>?, //the type of the data returned
      (String roomId, String userId) //input arguments
    >((ref, arg) {
      final (roomId, userId) = arg;

      //firestore path
      return FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("waitingList")
          .doc(userId)
          .snapshots()
          .map((doc) => doc.data()); //convert document snapshot to map
    });
