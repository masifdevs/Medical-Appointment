import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/utils/elevatedbtn.dart';
import 'package:flutter_localization_master/utils/textformfield.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  var email = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: _mainForm(context),
      ),
    );
  }

  Form _mainForm(BuildContext context) {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                child: Text(
                  getTranslated(context, 'forget_password'),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormFieldCustom(
                isPhone: false,
                isEmail: false,
                isPass: false,
                valid: (val) {
                  if (val.isEmpty) {
                    return getTranslated(context, 'required_field');
                  }
                  return null;
                },
                labelText: getTranslated(context, 'email'),
                hintText: getTranslated(context, 'email_hint'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedBtn(
                text: "reset_password",
                onPress: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
