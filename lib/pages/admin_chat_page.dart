import 'package:flutter/material.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/services/message_service.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/chat_bubble.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({Key? key}) : super(key: key);

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  TextEditingController messageController = TextEditingController();

  void handleSendMessage(MessageModel lastMessage) async {
    if (messageController.text.isNotEmpty) {
      await MessageService().addAdminMessage(
        message: messageController.text,
        userId: lastMessage.userId,
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        title: Text(
          'Admin Chat',
          style: primaryTextStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: MessageService().getAllMessages(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            var messages = snapshot.data!;
            if (messages.isEmpty) {
              return Center(
                child: Text(
                  'No messages yet',
                  style: secondaryTextStyle,
                ),
              );
            }

            var lastMessage = messages.last;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return ChatBubble(
                        isSender: message.isFromUser,
                        text: message.message,
                        product: message.product,
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: subtitleTextStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: primaryColor),
                        onPressed: () => handleSendMessage(lastMessage),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
