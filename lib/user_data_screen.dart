import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydata/config/size-config.dart';
import 'package:mydata/constants/app_colors.dart';
import 'package:mydata/constants/app_fonts.dart';
import 'package:mydata/constants/widgets/custom_button.dart';
import 'package:mydata/constants/widgets/custom_error_dialog.dart';

import 'constants/widgets/custom_input.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _getUserDataFormKey = GlobalKey<FormState>();
  bool obsecurePassword = true;
  bool obsecureConfirmPassword = true;

  Map<String, dynamic> userData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'phoneNumber': '',
    'password': '',
    'confirmPassword': '',
  };

  String? _emailValidator(value) {
    if (value.isEmpty) {
      return 'Please enter email';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid Email';
    }
    return null;
  }

  String? _passwordValidator(value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8';
    }
    return null;
  }

  String? _phoneValidator(value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? _nameValidator(value) {
    if (value.isEmpty) {
      return 'Please enter name';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        child: ErrorView(message),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showUserDataDialog(BuildContext context) {
    if (!_getUserDataFormKey.currentState!.validate()) {
      // Invalid
      return;
    }
    _getUserDataFormKey.currentState!.save();

    if (userData['password'] != userData['confirmPassword']) {
      _showErrorDialog('Passwords don\'t match!');
    } else {
      setState(() {
        obsecurePassword = true;
        obsecureConfirmPassword = true;
      });

      // button
      Widget confirmButton = Center(
        child: TextButton(
          child: Text('Close',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: SizeConfig.textMultiplier! * 2.3,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Ubuntu')),
          onPressed: () {
            _getUserDataFormKey.currentState!.reset();
            Navigator.pop(context, true);
          },
        ),
      );

      // title
      Widget title = Center(
          child: Text(
        'My Data',
        style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.textMultiplier! * 2.2,
            fontFamily: 'Ubuntu'),
      ));

      // content
      Widget content = Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier! * 3),
          child: SizedBox(
            height: SizeConfig.heightMultiplier! * 30,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataColumn(title: 'First Name', value: userData['firstName']),
                  DataColumn(title: 'Last Name', value: userData['lastName']),
                  DataColumn(title: 'Email Address', value: userData['email']),
                  DataColumn(
                      title: 'Phone Number', value: userData['phoneNumber']),
                ],
              ),
            ),
          ));

      // set up the AlertDialog
      dynamic alert = Platform.isIOS
          ? CupertinoAlertDialog(
              title: title,
              content: content,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    confirmButton,
                    // cancelButton,
                  ],
                )
              ],
            )
          : AlertDialog(
              title: title,
              content: content,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    confirmButton,
                    // cancelButton,
                  ],
                )
              ],
            );

      // show the dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/shape.png',
                  fit: BoxFit.cover, width: size.width * 0.4),
              Center(
                child: Text(
                  'My Info',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier! * 3,
                      fontFamily: 'Ubuntu'),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier! * 2,
              ),
              SizedBox(
                height: size.height * 0.8,
                child: Form(
                  key: _getUserDataFormKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier! * 4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 3,
                          ),
                          CustomInput(
                            hint: 'Celine',
                            label: 'First Name',
                            onSaved: (value) {
                              userData['firstName'] = value!;
                            },
                            validator: _nameValidator,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 3,
                          ),
                          CustomInput(
                            hint: 'Dion',
                            label: 'Last Name',
                            onSaved: (value) {
                              userData['lastName'] = value!;
                            },
                            validator: _nameValidator,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 3,
                          ),
                          CustomInput(
                            hint: 'celine@gmail.com',
                            label: 'Email',
                            validator: _emailValidator,
                            onSaved: (value) {
                              userData['email'] = value!;
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.textMultiplier! * 3,
                          ),
                          CustomInput(
                            label: 'Phone Number',
                            type: 'number',
                            onSaved: (value) {
                              userData['phoneNumber'] = value!;
                            },
                            validator: _phoneValidator,
                          ),
                          SizedBox(
                            height: SizeConfig.textMultiplier! * 3,
                          ),
                          CustomInput(
                            obsecure: obsecurePassword,
                            hint: '*********',
                            label: 'Password',
                            onSaved: (value) {
                              userData['password'] = value!;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                obsecurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  obsecurePassword = !obsecurePassword;
                                });
                              },
                            ),
                            validator: _passwordValidator,
                          ),
                          SizedBox(
                            height: SizeConfig.textMultiplier! * 3,
                          ),
                          CustomInput(
                            obsecure: obsecureConfirmPassword,
                            hint: '*********',
                            label: 'Confirm Password',
                            onSaved: (value) {
                              userData['confirmPassword'] = value!;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                obsecureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  obsecureConfirmPassword =
                                      !obsecureConfirmPassword;
                                });
                              },
                            ),
                            validator: _passwordValidator,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 5,
                          ),
                          CustomButton(
                              text: 'Show Data',
                              onpressed: () {
                                _showUserDataDialog(context);
                              },
                              width: size.width * 0.9),
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataColumn extends StatelessWidget {
  const DataColumn({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.body1),
        Text(value, style: AppFonts.valueStyle),
        SizedBox(
          height: SizeConfig.heightMultiplier! * 2,
        ),
      ],
    );
  }
}
