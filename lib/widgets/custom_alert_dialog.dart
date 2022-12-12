import 'package:flutter/material.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
    IconData? icon,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.yellow.shade100,
          iconColor: Colors.red,
          icon: Icon(icon),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            title,
            style: const TextStyle(fontFamily: "SuperBowl", fontSize: 20),
          ),
          content: Text(
            body,
            style: const TextStyle(
                color: Colors.black, fontFamily: "RobotoMono", fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: const Text(
                'Confirm',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.w700),
              ),
            )
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
