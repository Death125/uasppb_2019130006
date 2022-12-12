// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math' as math;

import 'admin_viewproduct.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  // text fields' controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _genre = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  bool isUpdate = false;
  bool isImageUpdated = false;

  //access table collection in firestore
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('product');

  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  static String imageUrl = '';
  XFile? image;

  File? _pickedImage;
  static Uint8List webImage = Uint8List(8);

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: _name,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Name',
          hintText: 'Add name'),
      validator: (value) {
        return (value!.isEmpty ? "Description field is empty" : null);
      },
    );
  }

  Widget genreField() {
    return TextFormField(
      controller: _genre,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Genre',
          hintText: 'Add genre'),
      validator: (value) {
        return (value!.isEmpty ? "Genre field is empty" : null);
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      maxLines: 12,
      controller: _description,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Description',
          hintText: 'Add description'),
      validator: (value) {
        return (value!.isEmpty ? "Description field is empty" : null);
      },
    );
  }

  Widget priceField() {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _price,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Price',
          hintText: 'Add price more than 0'),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      validator: (value) {
        return (value!.isEmpty ? "Price field is empty" : null);
      },
    );
  }

  Widget stokField() {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _stock,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Stock',
          hintText: 'Add stock more than 0'),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      validator: (value) {
        return (value!.isEmpty ? "Stock field is empty" : null);
      },
    );
  }

  Widget getURLField() {
    return TextFormField(
      maxLines: 2,
      controller: _url,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'URL',
          hintText: 'Images can be taken from the internet or gallery'),
      validator: (value) {
        return (value!.isEmpty ? "URL is empty" : null);
      },
    );
  }

  String tempUrl = '';
  int pickedImage = 0;

  Future<void> _pickImage() async {
    //Using image picker to pick image
    final ImagePicker _picker = ImagePicker();

    // get a reference to storage root
    final referenceRoot = FirebaseStorage.instance.ref();
    Reference? referenceDirImages = referenceRoot.child('images');

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Buat Android------------------------------------------------------------------------
    if (!kIsWeb) {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;

          if (_url.text.isEmpty) {
            //Store the file
            referenceImageToUpload
                .putFile(selected, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
            });
          } else if (isUpdate == false) {
            FirebaseStorage.instance.refFromURL(_url.text).delete();

            //Store the file
            referenceImageToUpload
                .putFile(selected, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
            });
          } else {
            pickedImage++;
            if (pickedImage == 1) {
              tempUrl = _url.text;
            }

            if (tempUrl.isNotEmpty && _pickedImage != null && pickedImage > 1) {
              FirebaseStorage.instance.refFromURL(_url.text).delete();
            }

            //Store the file
            referenceImageToUpload
                .putFile(selected, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
              isImageUpdated = true;
            });
          }

          if (_pickedImage == null) {
            isImageUpdated = false;
          }

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
      //------------------------------------------------------------------------
      //Buat Web----------------------------------------------------------------
    } else if (kIsWeb) {
      image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var f = await image!.readAsBytes();

        setState(() {
          if (_url.text.isEmpty) {
            webImage = f;
            _pickedImage = File('a');

            //Store the file
            referenceImageToUpload
                .putData(f, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
            });
          } else if (isUpdate == false) {
            FirebaseStorage.instance.refFromURL(_url.text).delete();

            webImage = f;
            _pickedImage = File('a');

            //Store the file
            referenceImageToUpload
                .putData(f, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
            });
          } else {
            pickedImage++;
            if (pickedImage == 1) {
              tempUrl = _url.text;
            }

            if (tempUrl.isNotEmpty && _pickedImage != null && pickedImage > 1) {
              FirebaseStorage.instance.refFromURL(_url.text).delete();
            }

            webImage = f;
            _pickedImage = File('a');

            //Store the file
            referenceImageToUpload
                .putData(f, SettableMetadata(contentType: "image/png"))
                .whenComplete(() async {
              imageUrl = await referenceImageToUpload.getDownloadURL();

              _url.text = imageUrl;
              isImageUpdated = true;
            });
          }

          if (_pickedImage == null) {
            isImageUpdated = false;
          }

          print('success');
        });
      } else {
        print('No Image has been picked');
      }
    } else {
      print('Something went wrong');
    }
    //--------------------------------------------------------------------------
  }

  Widget uploadImage() {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              _pickImage();
            },
            child: const Text('Select Image')),
        Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.0)),
            child: Card(
              child: _pickedImage == null
                  ? _url.text.isEmpty
                      ? const Center(
                          child: Text(
                            'Image',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: _url.text,
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill)),
                          ),
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                  : kIsWeb
                      ? Image.memory(webImage, fit: BoxFit.fill)
                      : Image.file(
                          _pickedImage!,
                          fit: BoxFit.fill,
                        ),
            )),
      ],
    );
  }

  Widget cancelAddButton() {
    return SizedBox(
      height: 50,
      width: 100,
      child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            if (_url.text.isNotEmpty) {
              FirebaseStorage.instance.refFromURL(_url.text).delete();
            }

            _name.text = '';
            _genre.text = '';
            _description.text = '';
            _price.text = '';
            _url.text = '';
            _stock.text = '';

            //After add image, _pickedImage is set to null
            _pickedImage = null;
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Future<void> addProduct([DocumentSnapshot? documentSnapshot]) async {
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
                      genreField(),
                      stokField(),
                      descriptionField(),
                      priceField(),
                      separator(20),
                      getURLField(),
                      separator(20),
                      Center(
                        child: uploadImage(),
                      ),
                      separator(20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cancelAddButton(),
                            const SizedBox(
                              width: 20,
                            ),
                            addButton()
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  Widget addButton() {
    return SizedBox(
      height: 50,
      width: 100,
      child: ElevatedButton(
        child: const Text('Add'),
        onPressed: () async {
          final String name = _name.text;
          final String genre = _genre.text;
          final String description = _description.text;
          final String url = _url.text;
          final int? price = int.tryParse(_price.text);
          final int? stock = int.tryParse(_stock.text);

          String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

          if (_keyForm.currentState!.validate()) {
            // await _products.add({
            //   "name": name,
            //   "genre": genre,
            //   "description": description,
            //   "price": price,
            //   "url": url,
            //   "stock": stock,
            //   "id": 'value',
            // });

            String uidFunction(String uid) {
              // dart unique string generator
              String _randomString = uid.toString() +
                  math.Random().nextInt(9999).toString() +
                  math.Random().nextInt(9999).toString() +
                  math.Random().nextInt(9999).toString();
              return _randomString;
            }

            await _products.doc(uniqueId).set({
              "name": name,
              "genre": genre,
              "description": description,
              "price": price,
              "url": url,
              "stock": stock,
              "id": uniqueId,
            }).catchError(
                (onError) => print("Failed to add new products : $onError"));

            _name.text = '';
            _genre.text = '';
            _description.text = '';
            _price.text = '';
            _url.text = '';
            _stock.text = '';
            //After add or update image, _pickedImage is set to null
            _pickedImage = null;

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product has been added')));
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

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _name.text = documentSnapshot['name'];
      _genre.text = documentSnapshot['genre'];
      _description.text = documentSnapshot['description'];
      _price.text = documentSnapshot['price'].toString();
      _stock.text = documentSnapshot['stock'].toString();
      _url.text = documentSnapshot['url'];
    }

    Widget cancelUpdateButton() {
      return SizedBox(
        height: 50,
        width: 100,
        child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              String s = _url.text;
              String result;
              if (s.length > 7) {
                result = s.substring(8, 23);
              } else {
                result = "";
              }

              if (isImageUpdated == true && result == 'firebasestorage') {
                FirebaseStorage.instance.refFromURL(_url.text).delete();
                _url.text = tempUrl;
                tempUrl = '';
                pickedImage = 0;
              } else {
                print("bukan");
              }

              //After update image, _pickedImage is set to null
              _pickedImage = null;
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
            String s = tempUrl;
            String result;
            if (s.length > 7) {
              result = s.substring(8, 23);
            } else {
              result = "";
            }

            if (isImageUpdated == true && result == 'firebasestorage') {
              FirebaseStorage.instance.refFromURL(tempUrl).delete();
            }

            final String name = _name.text;
            final String genre = _genre.text;
            final String description = _description.text;
            final String url = _url.text;
            final int? price = int.tryParse(_price.text);
            final int? stock = int.tryParse(_stock.text);
            if (_keyForm.currentState!.validate()) {
              //update
              await _products.doc(documentSnapshot!.id).update({
                "name": name,
                "genre": genre,
                "description": description,
                "price": price,
                "url": url,
                "stock": stock,
              });
              _name.text = '';
              _genre.text = '';
              _description.text = '';
              _price.text = '';
              _url.text = '';
              _stock.text = '';
              tempUrl = '';
              pickedImage = 0;
              //After add or update image, _pickedImage is set to null
              _pickedImage = null;

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product has been updated')));
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
                      genreField(),
                      stokField(),
                      descriptionField(),
                      priceField(),
                      getURLField(),
                      separator(20),
                      Center(
                        child: uploadImage(),
                      ),
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

  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Product')),
      backgroundColor: Colors.amber,
      body: StreamBuilder(
        stream: _products.snapshots(), //build connection
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length, //number of rows
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                final price =
                    currencyFormatter.format(documentSnapshot['price']);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      "Title : ${documentSnapshot['name']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        separator(10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Genre : ${documentSnapshot['genre']}",
                            style: const TextStyle(fontFamily: "RobotoMono"),
                          ),
                        ),
                        separator(10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Stock : ${documentSnapshot['stock']}",
                            style: const TextStyle(fontFamily: "RobotoMono"),
                          ),
                        ),
                        separator(10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description : ${documentSnapshot['description']}",
                            style: const TextStyle(fontFamily: "RobotoMono"),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        separator(10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Price : $price",
                            style: const TextStyle(fontFamily: "RobotoMono"),
                          ),
                        ),
                        separator(10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "URL : ${documentSnapshot['url']}",
                            style: const TextStyle(fontFamily: "RobotoMono"),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminViewProduct(
                                  documentSnapshot: documentSnapshot,
                                )),
                      );
                    },
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                isUpdate = true;

                                if (isUpdate == true) {
                                  _update(documentSnapshot);
                                }
                              }),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final action =
                                    await AlertDialogs.yesCancelDialog(
                                        context,
                                        'Delete',
                                        'Do you want to delete this product ?',
                                        Icons.delete);

                                String s = documentSnapshot['url'];
                                String result;
                                if (s.length > 7) {
                                  result = s.substring(8, 23);
                                } else {
                                  result = '';
                                }

                                if (action == DialogsAction.yes) {
                                  setState(() {
                                    //Delete image in firebase storage

                                    if (result == 'firebasestorage') {
                                      FirebaseStorage.instance
                                          .refFromURL(documentSnapshot['url'])
                                          .delete();
                                    }

                                    deleteProduct(documentSnapshot.id);
                                  });
                                } else {
                                  // setState(() => Navigator.pop(context));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isUpdate = false;

          if (isUpdate == false) {
            _name.text = '';
            _genre.text = '';
            _description.text = '';
            _price.text = '';
            _url.text = '';
            _stock.text = '';
            addProduct();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
