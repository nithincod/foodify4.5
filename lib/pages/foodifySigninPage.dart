import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodify2o/pages/foodify2oHomePage.dart';
import 'package:foodify2o/pages/foodify2oLoginPage.dart';
import 'package:provider/provider.dart';
import '../services/AuthServices.dart';
import '../utils/Colors.dart';
import '../utils/images/imageurls.dart';

class Foodify2oSignUpView extends StatefulWidget {
  const Foodify2oSignUpView({super.key});
  
  @override
  State<Foodify2oSignUpView> createState() => _Foodify2oSignUpViewState();
}

class _Foodify2oSignUpViewState extends State<Foodify2oSignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void SignUp(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  final authService = Provider.of<AuthService>(context, listen: false);

  try {
    print("Signing up user...");
    await authService.signupwithemailPassword(
      _emailController.text,
      _passwordController.text,
    );
    print("Signup successful! Logging in...");

    // Log in immediately after signing up
    await authService.signinwithEmailPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Foodify2oHomePage()),
      );
    }
  } catch (e) {
    print("Signup failed: $e");
    if (context.mounted) {
      String errorMessage = "An error occurred. Please try again.";

      if (e.toString().contains("email-already-in-use")) {
        errorMessage = "Your account created successfully please Go back";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoginAppColors.kWhite,
      appBar: AppBar(
          backgroundColor: LoginAppColors.kWhite,
          elevation: 0,
          leading: const BackButton(color: LoginAppColors.kPrimary)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const Text('Create Account',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 5),
                const Text('Lorem ipsum dolor sit amet, consectetur',
                    style: TextStyle(fontSize: 14, color: LoginAppColors.kGrey60)),
                const SizedBox(height: 30),
                AuthField(
                  title: 'Full Name',
                  hintText: 'Enter your name',
                  controller: _nameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthField(
                  title: 'E-mail',
                  hintText: 'Enter your email address',
                  controller: _emailController,
                  // validator: (value) =>
                  //     value == null || value.isEmpty
                  //         ? 'Email is required'
                  //         : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$')
                  //                 .hasMatch(value)
                  //             ? 'Please enter a valid email'
                  //             : null,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthField(
                  title: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : value.length < 8
                          ? 'Password should be at least 8 characters long'
                          : null,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  onTap: () => SignUp(context),
                  text: 'Create An Account',
                ),
                const SizedBox(height: 30),
                const TextWithDivider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomSocialButton(
                      onTap: () {},
                      icon: LoginAppAssets.kGoogle,
                    ),
                    CustomSocialButton(
                      onTap: () {},
                      icon: LoginAppAssets.kApple,
                    ),
                    CustomSocialButton(
                      onTap: () {},
                      icon: LoginAppAssets.kFacebook,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AgreeTermsTextCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgreeTermsTextCard extends StatefulWidget {
  const AgreeTermsTextCard({super.key});

  @override
  State<AgreeTermsTextCard> createState() => _AgreeTermsTextCardState();
}

class _AgreeTermsTextCardState extends State<AgreeTermsTextCard> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() => _isChecked = value!);
                },
                activeColor: LoginAppColors.kPrimary,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'By signing up you agree to our ',
                    style: const TextStyle(fontSize: 14, color: LoginAppColors.kGrey70),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print('Terms clicked'),
                        style: const TextStyle(fontSize: 14, color: LoginAppColors.kGrey100),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Conditions of Use',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print('Conditions clicked'),
                        style: const TextStyle(fontSize: 14, color: LoginAppColors.kGrey100),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
