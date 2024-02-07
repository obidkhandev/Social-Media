import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_socialmedia/components/my_back_buttons.dart';
import 'package:my_socialmedia/components/my_list_tile.dart';

import '../helper/helper_functions.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            displayMessageToUser('Something went wrong', context);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Text('No Data');
          }
          final users = snapshot.data!.docs;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 50.0,
                  left: 20,
                ),
                child: Row(
                  children: [
                    const MyBackButton(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: users.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final user = users[index];

                      // get data from each user
                      String username = user['username'];
                      String email = user['email'];
                      return MyListTile(title: username, subtitle: email);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
