import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_socialmedia/components/my_drawer.dart';
import 'package:my_socialmedia/components/my_list_tile.dart';
import 'package:my_socialmedia/components/my_post_button.dart';
import 'package:my_socialmedia/components/my_textfield.dart';
import 'package:my_socialmedia/database/firesetore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FireStoreDatabase database = FireStoreDatabase();

  final TextEditingController newPostController = TextEditingController();
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('W A L L'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDarawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: 'Say Something.. ',
                      obscureText: false,
                      controller: newPostController),
                ),
                PostButton(onTap: postMessage)
              ],
            ),
          ),
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // get all posts
                final posts = snapshot.data!.docs;

                // no data
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No Posts.. Post Something!'),
                    ),
                  );
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];

                          String message = post['PostMessage'];
                          String userEmail = post['UserEmail'];
                          // ignore: unused_local_variable
                          Timestamp timestamp = post['TimeStamp'];
                          return MyListTile(
                              title: message, subtitle: userEmail);
                        }));
              })
        ],
      ),
    );
  }
}
