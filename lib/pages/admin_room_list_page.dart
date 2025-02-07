import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/services/message_service.dart';
import 'package:shamo/theme.dart';

import 'admin_chat_detail_page.dart';

class AdminChatRoomListPage extends StatelessWidget {
  const AdminChatRoomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        title: Text(
          'Chat Rooms',
          style: primaryTextStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: MessageService().getAllMessages(), // Stream untuk mendapatkan semua pesan
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var messages = snapshot.data!;
            // Ambil daftar unik berdasarkan `userId`
            var uniqueUsers = messages.map((m) => m.userId).toSet().toList();

            if (uniqueUsers.isEmpty) {
              return Center(
                child: Text(
                  'No chat rooms available',
                  style: secondaryTextStyle,
                ),
              );
            }

            return ListView.builder(
              itemCount: uniqueUsers.length,
              itemBuilder: (context, index) {
                // Ambil pesan pertama untuk user tersebut (sebagai contoh)
                var userMessages = messages.where((m) => m.userId == uniqueUsers[index]).toList();
                var firstMessage = userMessages.first;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(firstMessage.userImage),
                  ),
                  title: Text(
                    firstMessage.userName,
                    style: TextStyle(color: Colors.black),

                  ),
                  subtitle: Text(
                    firstMessage.message,
                    style: secondaryTextStyle,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigasi ke halaman chat detail
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AdminChatDetailPage(userId: firstMessage.userId),
                    //   ),
                    // );
                    context.push('/admin-chat-detail/${firstMessage.userId}');
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: secondaryTextStyle,
              ),
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
