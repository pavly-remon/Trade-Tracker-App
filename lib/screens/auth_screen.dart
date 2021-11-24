import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/account.dart';
import 'package:resolution_app/models/auth.dart';
import 'package:resolution_app/models/bill.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _firstTransition = true;
  final _pw = TextEditingController();
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        BillRepository();
        Provider.of<Accounts>(context, listen: false).importAccounts();
        _firstTransition = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const ImageProvider logo = AssetImage("assets/images/logo/logo_white.png");
    const ImageProvider background = AssetImage("assets/images/background.jpg");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: background,
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.6,
                  child: const Image(image: logo),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                AnimatedCrossFade(
                  firstChild: Image.asset(
                    'assets/images/proton.png',
                    scale: 10,
                  ),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.1),
                    child: _buildPasswordBar(size),
                  ),
                  crossFadeState: _firstTransition
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(seconds: 1),
                  firstCurve: Curves.ease,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordBar(Size size) {
    return Container(
        width: size.width * 0.2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Center(
              child: TextFormField(
                obscureText: true,
                autofocus: true,
                controller: _pw,
                onFieldSubmitted: (text) {
                  _submitPW();
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submitPW();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  void _submitPW() {
    if (Authentication.checkPW(_pw.text)) {
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Password"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
