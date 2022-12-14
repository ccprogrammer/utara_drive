import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Consumer<AuthProvider>(builder: (context, provider, _) {
          return SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration:  const BoxDecoration(
              color: MyTheme.colorDarkPurple,
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
                          color: MyTheme.colorGrey,
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
                      color: MyTheme.colorBlueGrey,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(23, 31, 23, 27),
                        width: double.infinity,
                        color: MyTheme.colorBlueGrey,
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
                                style: TextStyle(color: MyTheme.colorDarkGrey),
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
                                      color: MyTheme.colorDarkGrey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: provider.isLogin ? 'here' : 'log in',
                                    style: const TextStyle(
                                      color: MyTheme.colorCyan,
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
      ),
    );
  }
}
