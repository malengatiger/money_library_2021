import 'package:flutter/material.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/avatar.dart';
import 'package:money_library_2021/widgets/round_number.dart';

class AgentClientList extends StatefulWidget {
  final Agent? agent;

  const AgentClientList({Key? key, this.agent}) : super(key: key);

  @override
  _AgentClientListState createState() => _AgentClientListState();
}

class _AgentClientListState extends State<AgentClientList>
    with SingleTickerProviderStateMixin {
  List<String> imageList = [];
  List<Client> clients = [];
  late AnimationController controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    _getClients();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _getClients() async {
    // clients = await agentBloc.getClients(agentId: widget.agent.agentId);
    // imageList = RandomImage.getImageList(clients.length);
    // p(' 🔆 🔆 🔆 ${imageList.length} images in the list');

    controller.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('${widget.agent!.personalKYCFields!.getFullName()}',
            style: Styles.blackSmall),
        backgroundColor: secondaryColor,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Column(
              children: <Widget>[
                Text('Client Management', style: Styles.blackBoldMedium),
                SizedBox(height: 24),
              ],
            )),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  var client = clients.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        p('💙💙💙 client has been tapped: 💙💙 ${client.personalKYCFields!.getFullName()} 💙');
                      },
                      child: RoundWidget(
                        text: client.personalKYCFields!.getFullName(),
                        radius: 48,
                        margin: 12,
                        widget: RoundAvatar(
                            path: imageList.elementAt(index),
                            radius: 48,
                            fromNetwork: false),
                      ),
                    ),
                  );
                }),
          ),
          Positioned(
            right: 20,
            top: 0,
            child: RoundNumberWidget(
              number: clients.length,
              mainColor: Colors.teal[200],
              radius: 48,
              margin: 12,
              marginColor: secondaryColor,
              textStyle: Styles.whiteBoldSmall,
            ),
          )
        ],
      ),
    ));
  }
}

class RoundWidget extends StatelessWidget {
  final Widget widget;
  final double radius, margin;
  final String text;

  const RoundWidget(
      {Key? key,
      required this.text,
      required this.widget,
      required this.radius,
      required this.margin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Container(
            height: radius + margin,
            width: radius + margin,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: customShadow,
                color: Colors.brown[100]),
            child: widget,
          ),
          SizedBox(width: 24),
          Text(text),
        ],
      ),
    );
  }
}
