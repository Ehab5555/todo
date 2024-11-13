import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/task_model.dart';

class FirebaseFunctions {
  static CollectionReference<TaskModel> getTasksCollection() =>
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
            fromFirestore: (snapshot, _) =>
                TaskModel.fromJSON(snapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJSON(),
          );
  static Future<void> addTaskToFirestore(TaskModel taskModel) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> docRef = tasksCollection.doc();
    taskModel.id = docRef.id;
    docRef.set(taskModel);
  }

  static Future<List<TaskModel>> getAllTasksFromFireStore() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> deleteTaskFromFireStore(String taskId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    tasksCollection.doc(taskId).delete();
  }

  static Future<void> updateTaskInFirestore({
    required TaskModel taskModel,
  }) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> docRef = tasksCollection.doc(taskModel.id);
    docRef.update(taskModel.toJSON());
    print(taskModel.isDone);
  }
}
