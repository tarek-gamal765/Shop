import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  bool isUpperCase = true,
  double radius = 0,
  required VoidCallback onPressed,
  required String textButton,
}) =>
    Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? textButton.toUpperCase() : textButton,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  TextStyle? style,
  required String text,
  required VoidCallback onPressed,
  required Color color,
  required bool isUpperCase,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: color,
          fontSize: 18,
        ),
      ),
    );

Widget defaultFormField({
  VoidCallback? onTap,
  String? labelText,
  String? hintText,
  bool isPassword = false,
  IconButton? suffixIcon,
  required Icon? prefixIcon,
  required TextEditingController? controller,
  required TextInputType? type,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? onChanged,
}) =>
    TextFormField(
      obscureText: isPassword,
      onChanged: onChanged,
      keyboardType: type,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.black,),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black,),
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validate,
      controller: controller,
      onTap: onTap,
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    );

void navigateTo({required context, required widget}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

void navigateAndReplacement({required context, required widget}) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates states) {
  Color color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

buildToast({
  required String message,
  required ToastStates? toastStates,
}) =>
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: chooseToastColor(toastStates!),
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );

defaultAppBar({
  String? title,
  List<Widget>? actions,
  required BuildContext context,
}) =>
    AppBar(
      title: Text(
        title.toString(),
      ),
      actions: actions,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

Widget defaultIconButton({
  required VoidCallback onPressed,
  required IconData icon,
  double? iconSize,
  required Color color,
}) =>
    IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
      ),
      color: color,
    );