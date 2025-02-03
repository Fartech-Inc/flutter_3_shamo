import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/models/product_model.dart';
import 'package:shamo/models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessagesByUserId({int? userId}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
            var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
              print(message.data().toString());
              return MessageModel.fromJson(message.data() as Map<String, dynamic>);
            }).toList();

            result.sort((MessageModel a, MessageModel b) =>
                a.createdAt.compareTo(b.createdAt),
            );

            return result;
          });
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> getAllMessages() {
    try {
      return firestore.collection('messages').snapshots().map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          print(message.data().toString());
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort((MessageModel a, MessageModel b) => a.createdAt.compareTo(b.createdAt));
        return result;
      });
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }


  Future<void> addMessage(
      {UserModel? user,
      bool? isFromUser,
      String? message,
      ProductModel? product}) async {
    try {
      firestore.collection('messages').add({
        'userId': user!.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product':
            product is UninitializedProductModel ? {} : product!.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then((value) => print('Pesan Berhasil Dikirim!'));
    } catch (e) {
      print(e);
      throw Exception('Pesan Gagal Dikirim!');
    }
  }

  Future<void> addAdminMessage({
    required String message,
    required int userId,
    String? adminName = 'Admin',
    String? adminImage = 'https://example.com/admin-avatar.png', // Gambar avatar admin
  }) async {
    try {
      firestore.collection('messages').add({
        'userId': userId,
        'userName': adminName,
        'userImage': adminImage,
        'isFromUser': false,
        'message': message,
        'product': {}, // Menambahkan properti product dengan map kosong
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then((value) => print('Pesan Admin Berhasil Dikirim!'));
    } catch (e) {
      print(e);
      throw Exception('Pesan Admin Gagal Dikirim!');
    }
  }

}
