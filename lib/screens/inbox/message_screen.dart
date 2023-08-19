import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/screens/inbox/chat_screen.dart';
import 'package:rento/utils/colors.dart';
import '../../utils/dimensions.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: purpleColor,
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message_outlined,
                  size: Dimensions.iconSize30,
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                const Text(
                  'No messages yet, your messages will appear here. ',
                ),
              ],
            ),
          );
        }

        final chatRooms = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            final chatRoom = chatRooms[index];

            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: chatRoom.reference
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No message'),
                  ); // Skip if there are no messages
                }
                final message = snapshot.data!.docs as Map<String, dynamic>;
                final senderId = message['senderId'];
                final receiverId = message['receiverId'];
                String otherUserId = '';
                const Text('one Mesage found');

                if (senderId == currentUserId) {
                  otherUserId = receiverId;
                } else if (receiverId == currentUserId) {
                  otherUserId = senderId;
                } else {
                  return const Center(
                    child: Text('Ids do not match'),
                  );
                }

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: purpleColor,
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('user not found'),
                      );
                    }

                    final userData = snapshot.data!.data();
                    final firstname = userData!['firstname'];
                    final lastname = userData['lastname'];

                    final name = '$firstname $lastname';
                    final imageUrl = userData['imageUrl'];

                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Dimensions.height10,
                        horizontal: Dimensions.width10,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        title: Text(name),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return ChatScreen(
                              receiverId: otherUserId,
                              receiverName: name,
                            );
                          }));
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
