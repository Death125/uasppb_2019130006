// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, avoid_web_libraries_in_flutter, unused_element, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/login_page/auth_page.dart';
import 'package:uasppb_2019130006/main.dart';
import 'package:uasppb_2019130006/page/about_page.dart';
import 'package:uasppb_2019130006/page/shopping/product_history.dart';
import 'package:uasppb_2019130006/page/user_home_page.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CartController controller = Get.find();

  final color = const Color(0XFF7C4DFF);
  final user = FirebaseAuth.instance.currentUser!;

  final double coverHeight = 280;
  final double profileHeight = 144;

//For Update Profile----------------------------------------------------------

  final TextEditingController _username = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _urlp = TextEditingController();
  final TextEditingController _urlbp = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String urlpDefault =
      "https://firebasestorage.googleapis.com/v0/b/uas-ppb-2019130006.appspot.com/o/profileImage%2FDefault.png?alt=media&token=563b0f3b-297a-455f-820f-4c0c9b96c3c3";
  final String urlbpDefault =
      "https://firebasestorage.googleapis.com/v0/b/uas-ppb-2019130006.appspot.com/o/profileImage%2FbpDefault.png?alt=media&token=c790a94b-ad32-4752-8a29-ba2d39d692fb";

  static String imageUrl = '';
  XFile? image;

  File? _pickedImage;
  static Uint8List webImage = Uint8List(8);

  String tempUrl = '';

  //Access table users in firestore
  final CollectionReference _userProfile =
      FirebaseFirestore.instance.collection('Users');
  //-------------------------------------------------------------------------

  Widget nameField() {
    return TextFormField(
      controller: _username,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Username',
          hintText: 'Add your username'),
      validator: (value) {
        return (value!.isEmpty ? "Username field is empty" : null);
      },
    );
  }

  Widget professionField() {
    return TextFormField(
      controller: _profession,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Profession',
          hintText: 'Your profession'),
      validator: (value) {
        return (value!.isEmpty ? "Profession field is empty" : null);
      },
    );
  }

  Widget aboutField() {
    return TextFormField(
      maxLines: 12,
      controller: _about,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'About',
          hintText: 'Explain a little about yourself'),
      validator: (value) {
        return (value!.isEmpty ? "About field is empty" : null);
      },
    );
  }

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(230, 115, 214, 214),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF3366FF),
                        Color(0xFF00CCFF),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("uid", isEqualTo: user.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: streamSnapshot
                                .data!.docs.length, //number of rows
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];

                              return Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: "${documentSnapshot['urlp']}",
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 30,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  separator(7),
                                  const Text(
                                    "Sign In As",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  separator(6),
                                  Text(
                                    user.email!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "About",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    'About page',
                    'Do you want to go to the about page ?',
                    Icons.history_edu);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Get.to(() => const AboutPage());
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "History Transaction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    ' History Transaction',
                    'Do you want to go to the History Transaction?',
                    Icons.history);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Get.to(() => const History());
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context, 'Logout', 'Are you sure ?', Icons.power_off);
                if (action == DialogsAction.yes) {
                  setState(() {
                    if (HomePage.newScreen == false) {
                      if (controller.products.length > 0) {
                        print("Profile a jumlah : $controller.products.length");
                        Get.delete<CartController>();
                      }
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      HomePage.index = 0;
                    } else {
                      if (controller.products.length > 0) {
                        Get.delete<CartController>();
                      }
                      FirebaseAuth.instance.signOut();
                      Get.to(() => const MainPage());

                      HomePage.newScreen = false;
                      HomePage.index = 0;
                    }
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ));
  }

  Future<void> _pickImage([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _urlp.text = documentSnapshot['urlp'];
    }

    // get a reference to storage root
    final referenceRoot = FirebaseStorage.instance.ref();
    Reference? referenceDirImages = referenceRoot.child('profileImage');

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Buat android------------------------------------------------------------------
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;

          //Hapus url sebelumnya
          if (_urlp.text != urlpDefault) {
            FirebaseStorage.instance.refFromURL(_urlp.text).delete();
          }

          //Store the file
          referenceImageToUpload
              .putFile(selected, SettableMetadata(contentType: "image/png"))
              .whenComplete(() async {
            imageUrl = await referenceImageToUpload.getDownloadURL();

            _userProfile.doc(documentSnapshot!.id).update({
              "urlp": _ProfilePageState.imageUrl,
            });
          });

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
    }
    //--------------------------------------------------------------------------
    //Buat web------------------------------------------------------------------
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var f = await image!.readAsBytes();

        setState(() {
          webImage = f;
          _pickedImage = File('a');

          //Hapus url sebelumnya
          if (_urlp.text != urlpDefault) {
            FirebaseStorage.instance.refFromURL(_urlp.text).delete();
          }

          //Store the file
          referenceImageToUpload
              .putData(f, SettableMetadata(contentType: "image/png"))
              .whenComplete(() async {
            imageUrl = await referenceImageToUpload.getDownloadURL();

            _userProfile.doc(documentSnapshot!.id).update({
              "urlp": imageUrl,
            });
          });

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
      //------------------------------------------------------------------------
    } else {
      print('Something went wrong');
    }
  }

  Future<void> _pickImageB([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _urlbp.text = documentSnapshot['urlbp'];
    }

    // get a reference to storage root
    final referenceRoot = FirebaseStorage.instance.ref();
    Reference? referenceDirImages = referenceRoot.child('profileImage');

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Buat android -------------------------------------------------------------
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;

          //Hapus url sebelumnya
          if (_urlbp.text != urlbpDefault) {
            FirebaseStorage.instance.refFromURL(_urlbp.text).delete();
          }

          //Store the file
          referenceImageToUpload
              .putFile(selected, SettableMetadata(contentType: "image/png"))
              .whenComplete(() async {
            imageUrl = await referenceImageToUpload.getDownloadURL();

            _userProfile.doc(documentSnapshot!.id).update({
              "urlbp": imageUrl,
            });
          });

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
    }
    //--------------------------------------------------------------------------
    //Buat web------------------------------------------------------------------
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var f = await image!.readAsBytes();

        setState(() {
          webImage = f;
          _pickedImage = File('a');

          //Hapus url sebelumnya
          if (_urlbp.text != urlbpDefault) {
            FirebaseStorage.instance.refFromURL(_urlbp.text).delete();
          }

          //Store the file
          referenceImageToUpload
              .putData(f, SettableMetadata(contentType: "image/png"))
              .whenComplete(() async {
            imageUrl = await referenceImageToUpload.getDownloadURL();

            _userProfile.doc(documentSnapshot!.id).update({
              "urlbp": imageUrl,
            });
          });

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
      //--------------------------------------------------------------------------
    } else {
      print('Something went wrong');
    }
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon(Color color) {
    return buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
          all: 8,
          color: color,
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                  splashColor: Colors.yellow.shade200,
                  onTap: () => _pickImage(),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  )))),
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _username.text = documentSnapshot['username'];
      _profession.text = documentSnapshot['profession'];
      _about.text = documentSnapshot['about'];
    }

    Widget cancelUpdateButton() {
      return SizedBox(
        height: 50,
        width: 100,
        child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            )),
      );
    }

    Widget updateButton() {
      return SizedBox(
        height: 50,
        width: 100,
        child: ElevatedButton(
          child: const Text('Update'),
          onPressed: () async {
            final String username = _username.text;
            final String profession = _profession.text;
            final String about = _about.text;

            if (_keyForm.currentState!.validate()) {
              //update
              await _userProfile.doc(documentSnapshot!.id).update({
                "username": username,
                "profession": profession,
                "about": about,
              });
              _username.text = '';
              _profession.text = '';
              _about.text = '';

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile has been updated')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Container(
                  padding: const EdgeInsets.all(8),
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text('All fields are not filled'),
                  ),
                ),
              ));
            }
          },
        ),
      );
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                child: Form(
                  key: _keyForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () {
                    state(() {});
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nameField(),
                      professionField(),
                      aboutField(),
                      separator(20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cancelUpdateButton(),
                            const SizedBox(
                              width: 20,
                            ),
                            updateButton()
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        child: Scaffold(
            drawer: drawer(context),
            appBar: AppBar(
              title: const Text("Profile"),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF3366FF),
                        Color(0xFF00CCFF),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where("uid", isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount:
                          streamSnapshot.data!.docs.length, //number of rows
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];

                        return Column(
                          children: <Widget>[
                            //Image------------------------------------
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: bottom),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${documentSnapshot['urlbp']}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: double.infinity,
                                          height: coverHeight,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          height: coverHeight,
                                          child:
                                              const CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 2,
                                      child: buildCircle(
                                        color: Colors.white,
                                        all: 3,
                                        child: buildCircle(
                                            all: 8,
                                            color: color,
                                            child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    splashColor:
                                                        Colors.yellow.shade200,
                                                    onTap: () {
                                                      _pickImageB(
                                                          documentSnapshot);
                                                    },
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 25,
                                                    )))),
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                    top: top,
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                            imageUrl:
                                                "${documentSnapshot['urlp']}",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                                      radius: profileHeight / 2,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                                  radius: profileHeight / 2,
                                                  child:
                                                      const CircularProgressIndicator(),
                                                )),
                                        Positioned(
                                          bottom: 0,
                                          right: 4,
                                          child: buildCircle(
                                            color: Colors.white,
                                            all: 3,
                                            child: buildCircle(
                                                all: 8,
                                                color: color,
                                                child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        splashColor: Colors
                                                            .yellow.shade200,
                                                        onTap: () {
                                                          _pickImage(
                                                              documentSnapshot);
                                                        },
                                                        child: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                          size: 25,
                                                        )))),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )
                            //----------------------------------------
                            ,
                            Column(
                              children: [
                                separator(8),
                                //Username and profession-----------------------
                                Text(
                                  "${documentSnapshot['username']}",
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                separator(8),
                                Text(
                                  "${documentSnapshot['profession']}",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                //---------------------------------------
                                separator(16),
                                const Divider(),
                                separator(16),
                                //About----------------------------------
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 48),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'About',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "${documentSnapshot['about']}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                //--------------------------------------
                                separator(32),
                              ],
                            ),
                            //Update button-----------------------------
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 40,
                                  width: 120,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue),
                                      onPressed: () {
                                        _update(documentSnapshot);
                                      },
                                      child: const Text(
                                        "Update Profile",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                            )
                            //------------------------------------------
                          ],
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}
