import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petsmore_tele_app/widgets/text_style_global.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DialogGlobal extends StatelessWidget {
  const DialogGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  getToastMsg() {
    return Fluttertoast.showToast(
      msg: "Press back again to exit!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  getSnackBar(context, text) {
    return SnackBar(
      backgroundColor: Colors.black.withOpacity(0.7),
      content: Text(text, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      margin: EdgeInsets.fromLTRB(Adaptive.sp(30), Adaptive.sp(0),
          Adaptive.sp(30), MediaQuery.of(context).size.height / 2),
      duration: const Duration(seconds: 3),
    );
  }

  //logout confirm dialog
  logOutDialog(BuildContext context, scaffoldKey, path) {
    var alert = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: logOutdialogContent(context, scaffoldKey, path),
    );
    return showDialog(context: context, builder: (_) => alert);
  }

  Widget logOutdialogContent(BuildContext context, scaffoldKey, path) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      width: Adaptive.px(350),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            margin: const EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text("Log Out ", style: TextStyleGlobal().dialogMainText),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Confirm to logout?",
                            textAlign: TextAlign.center,
                            style: TextStyleGlobal().dialogSubsText),
                      ),
                    ],
                  ),
                )),
                Divider(color: Colors.grey[400], thickness: 1.0),
                InkWell(
                  splashColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      "Yes",
                      style: TextStyleGlobal().dialogMainText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    var response;
                  },
                ),
                Divider(color: Colors.grey[400], thickness: 1.0),
                InkWell(
                  splashColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 10.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0)),
                    ),
                    child: Text(
                      "No",
                      style: TextStyleGlobal().dialogMainText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
