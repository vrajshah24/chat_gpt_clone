import 'dart:async';

import 'package:chat_gpt_clone/widgets/message.dart';
import 'package:chat_gpt_clone/widgets/screenSize.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isTyping = false;
  List<Message> _messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = ChatGPT.instance;
    _messages.insert(
        0,
        const Message(
          sender: 0,
          text: "Hey there, Ask Me a Question! Test my capabilities",
          isImage: false,
        ));
    final request = CompleteReq(
        prompt: question.text, model: kTranslateModelV3, max_tokens: 200);
    _subscription = chatGPT!
        .builder('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',
            orgId: "")
        .onCompleteStream(request: request)
        .listen((event) {
      Message m = Message(
        sender: 0,
        text: event!.choices[0].text,
        isImage: false,
      );
      setState(() {
        _messages.insert(0, m);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatGPT!.close();
    _subscription!.cancel();
  }

  ChatGPT? chatGPT;
  StreamSubscription? _subscription;

  sendMessage() {
    Message m;
    setState(() {
      _messages.insert(
          0,
          Message(
            sender: 1,
            text: question.text,
            isImage: false,
          ));
      isTyping = true;
    });

    if (isImage) {
      final request = GenerateImage(question.text, 1, size: "512x512");
      _subscription = chatGPT!
          .generateImageStream(request)
          .asBroadcastStream()
          .listen((event) {
        m = Message(
          sender: 0,
          text: event.data!.last!.url!,
          isImage: true,
        );
        setState(() {
          isTyping = false;
          _messages.insert(0, m);
        });
      });
    } else {
      final request = CompleteReq(
          prompt: question.text, model: kTranslateModelV3, max_tokens: 200);
      _subscription = chatGPT!
          .builder('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',
              orgId: "")
          .onCompleteStream(request: request)
          .listen((event) {
        m = Message(
          sender: 0,
          text: event!.choices[0].text,
          isImage: false,
        );
        setState(() {
          isTyping = false;
          _messages.insert(0, m);
        });
      });
    }
  }

  bool isImage = false;
  TextEditingController question = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000814),
      body: Column(
        children: [
          Flexible(
            child: Container(
              height: getHeight(context),
              child: ListView.separated(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: isTyping,
            replacement: SizedBox(
              height: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset('assets/loading.json',
                    fit: BoxFit.fitHeight, height: 60),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                SizedBox(width: 10),
                Container(
                    width: getWidth(context) * 0.5,
                    child: TextField(
                      controller: question,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          hintText: "Send a message",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          )),
                    )),
                InkWell(
                  onTap: () {
                    setState(() {
                      isImage = !isImage;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isImage ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: isImage ? Color(0xff89c2d9) : Colors.white)),
                    child: Center(
                      child: Text(
                        'Generate Image',
                        style: TextStyle(
                            color: isImage ? Color(0xff89c2d9) : Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      sendMessage();
                      question.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Color(0xff89c2d9),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
