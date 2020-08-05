import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/database/DatabaseProvider.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class UsersBloc {
  final _userRepository = UserRepository();

  final _userFetcher = PublishSubject<UserModel>();
  final _contactsFetcher = PublishSubject<List<UserModel>>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  Stream<List<UserModel>> get getContacts => _contactsFetcher.stream;

  initUsers() {
    var firestoreDB = Firestore.instance;
    firestoreDB.collection('users').getDocuments().then((value) => {
      value.documents.forEach((element) {
        DatabaseProvider.db.insertData('users', element.data);
      }),
    });
  }

  fetchCurrentUser() async {
    var userId = await _userRepository.getCurrentUserId();
    var user = await _userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  getUserById(String userId) async {
    var user = await _userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  fetchContacts() async {
    var userId = await _userRepository.getCurrentUserId();
    var contacts = await DatabaseProvider.db.getContacts(userId);
    _contactsFetcher.sink.add(contacts);
  }

  dispose() {
    _userFetcher.close();
  }
}
