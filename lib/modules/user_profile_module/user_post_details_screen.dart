import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../util/global_variables.dart';
import '../news_feed_module/user_post_item.dart';

class UserPostDetailsScreen extends StatelessWidget {
  final userID;
  UserPostDetailsScreen({required this.userID});
  static const routeName = './User_Post_Details_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: GlobalV.firestore
            .collection('userPosts')
            .where('uID', isEqualTo: userID)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              return UserPostItem(
                snapshot.data!.docs[index].data(),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
