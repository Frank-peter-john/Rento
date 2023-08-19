import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rento/utils/colors.dart';
import '../../utils/dimensions.dart';
import 'chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final uid = FirebaseAuth.instance.currentUser!.uid;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
      );
      // clear the controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.receiverName),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            size: Dimensions.iconSize30,
          ),
        ),
        centerTitle: true,
        backgroundColor: deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: _chatService.getMessages(uid, widget.receiverId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for data
                return const Center(
                    child: CircularProgressIndicator(
                  color: greenColor,
                ));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final messages = snapshot.data!.docs;
              if (messages.isEmpty) {
                return const Center(child: Text('Start chatting now'));
              }

              return ListView(
                children: snapshot.data!.docs
                    .map((document) => _buildMessage(document))
                    .toList(),
              );
            },
          )),
          const Divider(height: 1.0),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  // build the message item
  Widget _buildMessage(DocumentSnapshot document) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Message alligning
    var alignment = (data['senderId'] == uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width10 / 1.5),
      child: Column(
        crossAxisAlignment: data['senderId'] == uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            alignment: alignment,
            padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: data['senderId'] == uid
                        ? isDark
                            ? deepPurple
                            : deepPurple
                        : darkGrey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height10 / 2),
                    child: Text(
                      data['message'],
                      style: const TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            _getTimeAgo(data['timestamp']),
            style: TextStyle(
              fontSize: Dimensions.font10,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.height10),
      height: 56.0,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // Show emoji picker
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _messageController.text += emoji.emoji;
                    },
                  );
                },
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inDays >= 365) {
      // Return date, month, and year for messages older than one year
      final formattedDate = DateFormat('dd MMM yyyy').format(messageTime);
      return formattedDate;
    } else if (difference.inDays >= 7) {
      // Return day and month for messages older than one week
      final formattedDate = DateFormat('dd MMM').format(messageTime);
      return formattedDate;
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inHours >= 1) {
      // Return hour:minute AM/PM format for messages less than 24 hours
      final formattedTime = DateFormat('h:mm a').format(messageTime);
      return formattedTime;
    } else {
      // Return exact time (hour:minute AM/PM) for messages less than 1 minute ago
      final formattedTime = DateFormat('h:mm a').format(messageTime);
      return formattedTime;
    }
  }
}
