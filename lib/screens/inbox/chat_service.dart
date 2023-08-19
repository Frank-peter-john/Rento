import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    Map<String, dynamic> userData = userSnapshot.data()!;
    final String name = userData['name'] ?? 'unknown';
    // Rest of your code

    final Timestamp timestamp = Timestamp.now();

    // create a new messsage
    Message newMessage = Message(
      senderId: uid,
      senderName: name,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // construct a chat room id from current user id and receiver id (sorted to ensure uniquiness)
    List<String> ids = [uid, receiverId];
    ids.sort(); //Sort the ids, to ensure that the id is he same for any two people.
    String chatRoomId =
        ids.join("_"); //Combine the two ids to make a single chat room id.
    //  save message to database
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String uid, String otherUserid) {
    // construct chat room id from user ids (sorted to ensure it matches the id when sending the message)
    List<String> ids = [uid, otherUserid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
