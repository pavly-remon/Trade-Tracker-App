import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_app/models/auth.dart';
import 'package:resolution_app/models/bill.dart';
import 'package:resolution_app/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _pw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.4,
                child: Image.asset('assets/images/logo/logo_white.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildPasswordBar(size),
              )
            ],
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
              child: TextField(
                obscureText: true,
                controller: _pw,
                onSubmitted: (text) {
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
      Provider.of<Bills>(context, listen: false).importData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Password"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
