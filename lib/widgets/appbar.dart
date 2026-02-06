import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/material.dart';
import 'package:petsmore_tele_app/screen/notification.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? automaticallyImplyLeading;
  final VoidCallback? onPressed;
  final bool? displaybackbutton;
  final Function()? onback;
  final Icon? icon;

  Appbar({
    Key? key,
    this.automaticallyImplyLeading,
    required this.title,
    this.displaybackbutton,
    this.onPressed,
    this.onback,
    this.icon,
  }) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
        backgroundColor: AppColors.primary,
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          if (widget.icon != null)
            IconButton(
              icon: widget.icon!,
              iconSize: 30,
              onPressed: () {
                widget.onPressed?.call();
              },
            ),
        ]);
  }
}
