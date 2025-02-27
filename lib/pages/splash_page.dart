import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/providers/product_provider.dart';
import 'package:shamo/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {

    getInit();    

    super.initState();
  }

  getInit() async{
    await Provider.of<ProductProvider>(context, listen: false).getProducts();
    sessionCheck();
  }

  Future<void> sessionCheck() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    final token = sharedPreferences.getString('token');

    if (token != null) {
      // Login ulang jika token ada
      if (!mounted) return;
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email: email, password: password);

      // Navigasi ke home dengan GoRouter
      if (mounted) {
        context.push('/home');
      }
    } else {
      // Navigasi ke sign-in dengan GoRouter
      if (mounted) {
        context.push('/sign-in');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Center(
        child: Container(
          width: 130,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/image_splash.png'
              ),
            ),
          ),
        ),
      ),
    );
  }
}