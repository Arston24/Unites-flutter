import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/di/injection.config.dart';
import 'package:unites_flutter/domain/interactors/chat_interactor.dart';
import 'package:unites_flutter/domain/interactors/user_interactor.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/domain/models/message_model.dart';
import 'package:unites_flutter/data/repository/chat_repository_impl.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';


@injectable
class ChatsBloc {

  var chatInteractor = getIt<ChatInteractor>();

  var userInteractor = getIt<UserInteractor>();

  final _messageFetcher = PublishSubject<List<MessageModel>>();

  Stream<List<MessageModel>> get getMessages => _messageFetcher.stream;

  void sendNewMessage(String userId, String text) {
    chatInteractor.sendMessage(userId, text);
  }

  void fetchAllMessages(String userId) async {
    var messages = await chatInteractor.getChatMessages(userId);
    _messageFetcher.sink.add(messages);
  }

  void addMessagesListener(String userId) async {
    var currentUserId = await userInteractor.getCurrentUserId();
    var firestoreDB = Firestore.instance;
    var user = await firestoreDB.collection('users').document(currentUserId);
    await user
        .collection('chats')
        .where('chatWith', isEqualTo: userId)
        .getDocuments()
        .then((value) => {
              value.documents[0].reference
                  .collection('messages')
                  .snapshots()
                  .listen((event) {
                event.documentChanges.forEach((element) {
                  print('changes ${element.type}');
                  fetchAllMessages(userId);
                });
              })
            });
  }
}
