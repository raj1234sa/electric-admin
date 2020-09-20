import 'package:flutter/material.dart';

Future<bool> showSimpleDialogue({
  @required BuildContext context,
  String title,
  @required String message,
  bool showTwoActions = true,
}) {
  return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: title == null ? null : Text(title),
          content: Text(message),
          contentPadding: EdgeInsets.all(20),
          actions: <Widget>[
            if (showTwoActions)
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: showTwoActions ? Text("YES") : Text('OK'),
            ),
          ],
        ),
      ) ??
      false;
}


// Future<bool> showFullScreenDialogue(
//     {@required BuildContext context, @required String title}) async {
//   bool result = await Navigator.of(context).push(
//         new MaterialPageRoute<bool>(
//           builder: (BuildContext context) {
//             return FullScreenDialogue(
//               title: title,
//             );
//           },
//           fullscreenDialog: true,
//         ),
//       ) ??
//       false;
//
//   return result;
// }



void showErrorDialog({String message, BuildContext context}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('An Error Occurred!'),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}