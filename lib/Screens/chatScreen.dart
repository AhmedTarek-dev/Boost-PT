// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import '../Components/Components.dart';
import '../FirebaseAuth/firestore_services.dart';

class ChatScreen extends StatefulWidget {
  final Trainee? trainee;
  final Users? currentUser;
  const ChatScreen({this.trainee, this.currentUser, Key? key})
      : super(key: key);
  static const String id = "ChatScreen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  Users? _currentUser;
  Trainee? _trainee;
  final TextEditingController messageTextController = TextEditingController();

  getUserInfo() async {
    _trainee = await FireStoreServices().getTraineeInformation();
    _currentUser = await FireStoreServices().getUserInformation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _currentUser = widget.currentUser;
    if (_currentUser!.isTrainer == "false") {
      getUserInfo();
    }
    _trainee = widget.trainee;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return _currentUser?.isTrainer == "true"
            ? true
            : () {
                ZoomDrawer.of(context)!.toggle();
                return false;
              }();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF050B48),
          leading: _currentUser?.isTrainer == "true"
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 40,
                  ),
                  onPressed: () {
                    ZoomDrawer.of(context)!.toggle();
                  },
                ),
          title: _currentUser?.isTrainer == "false"
              ? Text(
                  "MessageMe",
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MessageMe",
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Trainee")
                          .doc(_trainee?.ID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                              snapshot.data!["Status"] == "Online"
                                  ? "Online"
                                  : "Offline",
                              style: TextStyle(fontSize: 13));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
        ),
        body: SafeArea(
          child: _currentUser!.isTrainer == "true" ||
                  _trainee!.AssignedTrainer != "NoTrainer"
              ? SingleChildScrollView(
                  child: SizedBox(
                    height: size.height * 0.898,
                    width: size.width * 0.999,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage('assets/chatBackground.png'),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Trainee")
                                .doc(_trainee!.ID)
                                .collection("Messages")
                                .orderBy('time')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              List<MessageLine> messageWidgets = [];

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              }

                              if (snapshot.data != null) {
                                final messages = snapshot.data!.docs.reversed;
                                for (var message in messages) {
                                  final messageTime = message.get("time");
                                  final messageText = message.get("text");
                                  final messageSender = message.get("sender");
                                  final currentUserSending =
                                      _currentUser?.Email;

                                  if (messageTime != null &&
                                      messageSender != null &&
                                      messageText != null) {
                                    final messageWidget = MessageLine(
                                      sender: messageSender,
                                      text: messageText,
                                      time: messageTime.toDate(),
                                      isMe: currentUserSending == messageSender,
                                    );
                                    messageWidgets.add(messageWidget);
                                  }
                                }
                              }
                              return Expanded(
                                child: ListView(
                                  reverse: true,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 5),
                                  children: messageWidgets,
                                ),
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, bottom: size.height * 0.02),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                      onFieldSubmitted: (value) async {
                                        if (messageTextController
                                            .text.isNotEmpty) {
                                          messageTextController.clear();

                                          await FireStoreServices()
                                              .addMessageToTrainee(
                                                  messageText.toString(),
                                                  _currentUser!.Email
                                                      .toString(),
                                                  _trainee!.ID.toString(),
                                                  FieldValue.serverTimestamp());
                                        }
                                      },
                                      controller: messageTextController,
                                      onChanged: (value) {
                                        setState(() {
                                          messageText = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Write your message here...",
                                        hintStyle: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (messageTextController.text.isNotEmpty) {
                                    messageTextController.clear();

                                    await FireStoreServices()
                                        .addMessageToTrainee(
                                            messageText.toString(),
                                            _currentUser!.Email.toString(),
                                            _trainee!.ID.toString(),
                                            FieldValue.serverTimestamp());
                                  }
                                },
                                child: Text(
                                  'send',
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                  width: size.width * 0.8,
                  child: Text(
                    "You need to be assigned to a trainer to chat with!!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                )),
        ),
      ),
    );
  }
}

class MessageLine extends StatefulWidget {
  const MessageLine(
      {this.text, this.sender, this.time, required this.isMe, Key? key})
      : super(key: key);
  final String? text;
  final String? sender;
  final DateTime? time;
  final bool isMe;

  @override
  State<MessageLine> createState() => _MessageLineState();
}

class _MessageLineState extends State<MessageLine> {
  String? text;
  String? sender;
  DateTime? time;
  bool? isMe;

  @override
  void initState() {
    super.initState();
    getInfo();
    setState(() {});
  }

  getInfo() {
    setState(() {
      text = widget.text;
      sender = widget.sender;
      time = widget.time;
      isMe = widget.isMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.sender} ',
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFF050B48),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          Material(
            elevation: 5,
            borderRadius: widget.isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: widget.isMe ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.text} ',
                    style: TextStyle(
                        fontSize: 15,
                        color: widget.isMe ? Colors.white : Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    DateFormat('hh:mm').format(widget.time!),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isMe ? Colors.white : Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
