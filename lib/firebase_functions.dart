import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/user_model.dart';

class FirebaseFunctions {
  static CollectionReference<UserModel> getUsersCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (snapshot, _) => UserModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (userModel, _) => userModel.toJson(),
          );
  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      getUsersCollection()
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (snapshot, _) =>
                TaskModel.fromJSON(snapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJSON(),
          );
  static Future<void> addTaskToFirestore(
      TaskModel taskModel, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> docRef = tasksCollection.doc();
    taskModel.id = docRef.id;
    docRef.set(taskModel);
  }

  static Future<List<TaskModel>> getAllTasksFromFireStore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> deleteTaskFromFireStore(
      String taskId, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    tasksCollection.doc(taskId).delete();
  }

  static Future<void> updateTaskInFirestore(
    String userId, {
    required TaskModel taskModel,
  }) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> docRef = tasksCollection.doc(taskModel.id);
    docRef.update(taskModel.toJSON());
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      id: credentials.user!.uid,
      name: name,
      email: email,
    );
    final usersCollection = getUsersCollection();
    await usersCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final usersCollection = getUsersCollection();
    final docSnapShot = await usersCollection.doc(credentials.user!.uid).get();
    return docSnapShot.data()!;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
