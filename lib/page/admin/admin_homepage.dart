import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/page/admin/admin_product_page.dart';
import 'package:uasppb_2019130006/page/admin/choose_historyofuser.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final color = const Color(0XFF7C4DFF);
  final user = FirebaseAuth.instance.currentUser!;

  // memanggil nama user : user.email!
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
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 50,
                          ), //put your logo here
                        ),
                        separator(7),
                        const Text(
                          "Sign In As",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        separator(6),
                        Text(
                          user.email!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ))),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.shopping_bag),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "Product",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    'Product Page',
                    'Do you want to go to the product page ?',
                    Icons.shopping_bag);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminProductPage()),
                    );
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
                "Sales History",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    ' History Transaction',
                    'Do you want to go to the Sales History?',
                    Icons.history_edu);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Get.to(() => const ChooseHistoryOfUser());
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
                    setState(() => Navigator.pop(context));
                    FirebaseAuth.instance.signOut();
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(context),
        appBar: AppBar(
          title: const Text('Admin Home'),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: ListView(
            children: const [],
          ),
        ));
  }
}
