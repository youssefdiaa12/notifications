import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications/constants.dart';
import 'package:notifications/model/msgDao.dart';

class FireBaseData {
  static CollectionReference<msgDao> getMsgsCollection({String? id}) {
    var db;
      db = FirebaseFirestore.instance.collection('msg').doc(id).collection('msgs').withConverter(
          fromFirestore: (snapshot, options) => msgDao.fromFireStore(snapshot.data()!),
          toFirestore: (value, options) => value.toFireStore()
      );
    return db;
  }

  static Future<void> createTask(msgDao msgia) async {
    var dbRef = getMsgsCollection(id: token);
    DocumentReference docRef = await dbRef.add(msgia);
    await docRef.update({'targetToken': docRef.id});
  }

  static Future<List<msgDao>> getTasks(String id) async {
    var dbRef = await getMsgsCollection(id: id).get();
    var taskList = dbRef.docs.map((snapshot) => snapshot.data()).toList();
    return taskList;
  }
  static Future<void> deleteTask(msgDao? taskia, String? id) async {
    await getMsgsCollection(id: id!).doc(taskia?.targetToken).delete();
  }

  static Stream<List<msgDao>> listForTasks(String id) async* {
    var data = getMsgsCollection(id: id).snapshots();
    yield* data.map((snapshot) =>
        snapshot.docs.map((snapshot) => snapshot.data()).toList());
  }

}
