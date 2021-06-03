import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  //final String uid;

  DatabaseService(
   // required this.uid
  );

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  // update userdata
  // Future updateUserData(String fullName, String email, String password) async {
  //   return await userCollection.document(uid).setData({
  //     'fullName': fullName,
  //     'email': email,
  //     'password': password,
  //     'groups': [],
  //     'profilePic': ''
  //   });
  // }


  // create group

  Future createGroup(String userName, String groupName, String loggeInUserId) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
        'members': FieldValue.arrayUnion([loggeInUserId + '_' + userName]),
        'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(loggeInUserId);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }

  Future createUser(User user) async {
    return await userCollection.add({

       'name': user.displayName,
       'userName':user.displayName,
       'email': user.email,
       'profilePic': user.photoURL,
       'pics': [],
       'videos': [],
       'numFollowers': 0,
       'followers':[],
       'numFollowing': 0,
       'following': []
     });
  }


  // toggling the user group join
  // Future togglingGroupJoin(String groupId, String groupName, String userName) async {
  //
  //   DocumentReference userDocRef = userCollection.document(uid);
  //   DocumentSnapshot userDocSnapshot = await userDocRef.get();
  //
  //   DocumentReference groupDocRef = groupCollection.document(groupId);
  //
  //   List<dynamic> groups = await userDocSnapshot.data['groups'];
  //
  //   if(groups.contains(groupId + '_' + groupName)) {
  //     //print('hey');
  //     await userDocRef.updateData({
  //       'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
  //     });
  //
  //     await groupDocRef.updateData({
  //       'members': FieldValue.arrayRemove([uid + '_' + userName])
  //     });
  //   }
  //   else {
  //     //print('nay');
  //     await userDocRef.updateData({
  //       'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
  //     });
  //
  //     await groupDocRef.updateData({
  //       'members': FieldValue.arrayUnion([uid + '_' + userName])
  //     });
  //   }
  // }


  // has user joined the group
 /* Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.get('groups');

    
    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }
*/

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();

    print(snapshot.docs[0].data()['name']);
    return snapshot;
  }

  getUsers() {
    return  userCollection.snapshots();
  }


  // get chats of a particular group
  getChats(String groupId)  {
    return FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').orderBy('time').snapshots();
  }

  // get user groups
  /*getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }*/


  // send message
  sendMessage(String groupId, chatMessageData) {
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // search groups
  searchByName(String groupName) async {
    return await FirebaseFirestore.instance.collection("groups").where('groupName', isEqualTo: groupName).get();
  }
}