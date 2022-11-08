import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utara_drive/providers/auth_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/custom_button_gradient.dart';
import 'package:utara_drive/ui/Components/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.colorCyan,
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/image_background.png"),
              //   fit: BoxFit.cover,
              // ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff56CCF2),
                  Color(0xff2F80ED),
                ],
              ),
            ),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/image_logo.png',
                      width: 140,
                      height: 140,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      provider.isLogin ? 'Log In' : 'Sign Up',
                      style: const TextStyle(
                        color: MyTheme.colorWhite,
                        fontSize: 42,
                        fontWeight: MyTheme.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(23, 31, 23, 27),
                      width: double.infinity,
                      color: MyTheme.colorWhite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // username field
                          CustomTextField(
                            label: 'EMAIL',
                            controller: provider.emailC,
                          ),

                          // username field
                          if (!provider.isLogin)
                            CustomTextField(
                              label: 'USERNAME',
                              controller: provider.usernameC,
                            ),

                          // password field
                          CustomTextField(
                            label: 'PASSWORD',
                            controller: provider.passwordC,
                            obscureText: true,
                          ),

                          // button
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Custombutton(
                              label: provider.isLogin ? 'log in' : 'sign up',
                              isLoading: provider.isLoading,
                              onPressed: () {
                                provider.isLogin
                                    ? provider.logIn(context)
                                    : provider.signUp(context);
                              },
                              radius: 50,
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 6),
                            child: Text(
                              'OR',
                              style: TextStyle(color: MyTheme.colorGrey),
                            ),
                          ),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: provider.isLogin
                                      ? 'Create new account '
                                      : 'Have an account? Cool! ',
                                  style: const TextStyle(
                                    color: MyTheme.colorBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: provider.isLogin ? 'here' : 'log in',
                                  style: const TextStyle(
                                    color: MyTheme.colorBlue,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => provider.switchLogin(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
