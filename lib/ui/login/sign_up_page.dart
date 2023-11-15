import 'package:flutter/material.dart';
import '../../fire_auth/authentication.dart';
import 'package:email_validator/email_validator.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<sign_up> {
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
      resizeToAvoidBottomInset: true,
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
                      'Create an accound',
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
              Container(
                width: 280,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    firebase.register(
                        context: context,
                        email: email.text,
                        password: password.text);
                  },
                  child: Text(
                    'Sign Up',
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
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'log in',
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
                    onTap: () {},
                    child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset('asset/google.png')),
                  ),
                  InkWell(
                    onTap: () {},
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
