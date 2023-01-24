import 'package:chat_gpt_clone/widgets/screenSize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class Message extends StatelessWidget {
  const Message(
      {super.key,
      required this.sender,
      required this.text,
      required this.isImage});

  //0 = AI 1=user
  final int sender;
  final String text;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return sender == 0
        ? Row(
            children: [
              Container(
                width: getWidth(context) * 0.8,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child: Text('AI'),
                      radius: 20,
                      backgroundColor: Color(0xff89c2d9),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Card(
                      color: Color(0xff89c2d9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Container(
                          padding: EdgeInsets.all(12),
                          width: getWidth(context) * 0.60,
                          child: !isImage
                              ? Text(text)
                              : Image.network(
                                  text,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return loadingProgress == null
                                        ? child
                                        : Lottie.asset("assets/imgLoad.json");
                                  },
                                  width: getWidth(context) * 0.4,
                                )),
                    )
                  ],
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getWidth(context) * 0.7,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Card(
                      color: Color(0xffcaf0f8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(15))),
                      child: Container(
                          padding: EdgeInsets.all(12),
                          width: getWidth(context) * 0.6,
                          child: Text(text)),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
