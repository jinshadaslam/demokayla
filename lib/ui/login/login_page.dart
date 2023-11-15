import 'package:demokayla/ui/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../fire_auth/authentication.dart';
import 'phoneotp.dart';
import 'sign_up_page.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<login_page> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Fire_auth firebase = Fire_auth();

  String? emailError;
  bool isPasswordVisible = false;

  void validateEmail(String value) {
    if (!EmailValidator.validate(value)) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Text(
                      'Hello!\nWelcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 280,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                    errorText: emailError,
                  ),
                  controller: email,
                  onChanged: (value) {
                    validateEmail(value);
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 280,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: togglePasswordVisibility,
                    ),
                  ),
                  controller: password,
                  obscureText: !isPasswordVisible,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  firebase.login(
                      context: context, email: email, password: password);
                },
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'forgot password',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 280,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home_page()),
                    );
                  },
                  child: Text(
                    'log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      firebase.signInWithGoogle(context);
                    },
                    child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset('asset/google.png')),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneAuthScreen()));
                    },
                    child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset('asset/otp.png')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
