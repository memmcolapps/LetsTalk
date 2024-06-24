import 'package:flutter/material.dart';

class JhButton extends StatelessWidget {
  const JhButton({
    required Key key,
    this.text: '',
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,

//      textColor: Colors.white,
//      color: Theme.of(context).primaryColor ,
      //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 18, color: Colors.white)),
         foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              //获取焦点时的颜色
              return  Theme.of(context).primaryColor;
            } else if (states.contains(MaterialState.pressed)) {
              //按下时的颜色
              return Colors.white54;
            }
            //默认状态使用灰色
            return Colors.grey;
          },
        ),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Color(0xa03BB815);
          }
          //默认不使用背景颜色
          return Color(0xFF3BB815);
        }),
      ),
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
