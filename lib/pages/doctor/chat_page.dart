import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_localization_master/constants/colors.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            style: Theme.of(context).textTheme.bodyText1,
            onChanged: (value) {},
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintStyle: Theme.of(context).textTheme.headline2,
              hintText: getTranslated(context, "send_message"),
              border: InputBorder.none,
            ),
          )),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            iconSize: 25.0,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe) {
    final msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : grey,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
      ),
      child: Text(
          "A message is a discrete unit of communication intended by the source for consumption by some recipient or group of recipients",
          style: isMe
              ? Theme.of(context).textTheme.headline5
              : Theme.of(context).textTheme.bodyText1),
    );

    if (isMe) return msg;

    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(
          child: Text(
            "Dr. Name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildMessage("message", true);
                      }),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
