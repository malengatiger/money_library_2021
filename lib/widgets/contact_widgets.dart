import 'package:flutter/material.dart';
import 'package:money_library_2021/widgets/avatar.dart';

class EmailWidget extends StatelessWidget {
  final String? emailAddress;

  const EmailWidget({Key? key, this.emailAddress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12, right: 16),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60,
                child: MyAvatar(
                  icon: Icon(Icons.email),
                ),
              ),
              Expanded(child: Text(emailAddress!))
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneWidget extends StatelessWidget {
  final String? phoneNumber;

  const PhoneWidget({Key? key, this.phoneNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12, right: 16),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60,
                child: MyAvatar(
                  icon: Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                ),
              ),
              Text(phoneNumber!)
            ],
          ),
        ),
      ),
    );
  }
}
