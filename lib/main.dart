import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo/firebase_options.dart';
import 'package:shamo/pages/cart_page.dart';
import 'package:shamo/pages/checkout_page.dart';
import 'package:shamo/pages/checkout_success_page.dart';
import 'package:shamo/pages/edit_profile_page.dart';
import 'package:shamo/pages/home/main_page.dart';
import 'package:shamo/pages/payment_page.dart';
import 'package:shamo/pages/sign_in_page.dart';
import 'package:shamo/pages/sign_up_page.dart';
import 'package:shamo/pages/splash_page.dart';
import 'package:shamo/pages/video_call/index_page.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/providers/cart_provider.dart';
import 'package:shamo/providers/category_provider.dart';
import 'package:shamo/providers/page_provider.dart';
import 'package:shamo/providers/product_provider.dart';
import 'package:shamo/providers/status_category_provider.dart';
import 'package:shamo/providers/transaction_provider.dart';
import 'package:shamo/providers/wishlist_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'kipli-shamo',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create:(context) => AuthProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create:(context) => ProductProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create:(context) => WishlistProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => CategoryProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => StatusCategoryProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create:(context) => CartProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create:(context) => TransactionProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create:(context) => PageProvider(),
    //     ),
    //   ],
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     routes: {
    //       '/' : (context) => const SplashPage(),
    //       '/sign-in' : (context) =>  const SignInPage(),
    //       '/sign-up' : (context) =>  const SignUpPage(),
    //       '/home' : (context) =>  const MainPage(),
    //       '/edit-profile' :(context) => const EditProfilePage(),
    //       '/cart' : (context) => const CartPage(),
    //       '/checkout' : (context) => const CheckoutPage(),
    //       '/checkout-payment': (context) => const PaymentPage(),
    //       '/checkout-success' : (context) => const CheckoutSuccessPage(),
    //     },
    //   ),
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kipli-Shamo',
      home: const IndexPage(),
    );
  }
}