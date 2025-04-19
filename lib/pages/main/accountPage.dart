import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wormsup_dev/viewModel/login_view_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

late User? currentUser;
final users = FirebaseFirestore.instance.collectionGroup('users');

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    currentUser = LoginViewModel().currUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),

      body:
          // ignore: unnecessary_null_comparison
          currentUser!.uid == null
              ? const Center(child: Text("User not found"))
              : StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUser!.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40),

                          CircleAvatar(
                            backgroundColor: const Color.fromARGB(
                              125,
                              156,
                              156,
                              156,
                            ),
                            radius: 80,
                          ),

                          SizedBox(height: 25),

                          Text(
                            userData['username'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),

                          Text(
                            userData['email'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
    );
  }
}
