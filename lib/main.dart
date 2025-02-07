import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shamo/firebase_options.dart';
import 'package:shamo/pages/admin_chat_detail_page.dart';
import 'package:shamo/pages/admin_room_list_page.dart';
import 'package:shamo/pages/cart_page.dart';
import 'package:shamo/pages/checkout_page.dart';
import 'package:shamo/pages/checkout_success_page.dart';
import 'package:shamo/pages/detail_chat_page.dart';
import 'package:shamo/pages/edit_profile_page.dart';
import 'package:shamo/pages/home/home_page.dart';
import 'package:shamo/pages/home/main_page.dart';
import 'package:shamo/pages/payment_page.dart';
import 'package:shamo/pages/product_page.dart';
import 'package:shamo/pages/sign_in_page.dart';
import 'package:shamo/pages/sign_up_page.dart';
import 'package:shamo/pages/splash_page.dart';
import 'package:shamo/pages/transaction_history_page.dart';
import 'package:shamo/pages/video_call/call_dart.dart';
import 'package:shamo/pages/video_call/index_page.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/providers/cart_provider.dart';
import 'package:shamo/providers/category_provider.dart';
import 'package:shamo/providers/page_provider.dart';
import 'package:shamo/providers/product_provider.dart';
import 'package:shamo/providers/status_category_provider.dart';
import 'package:shamo/providers/transaction_provider.dart';
import 'package:shamo/providers/wishlist_provider.dart';

import 'models/product_model.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => StatusCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Kipli-Shamo',
    //   home: const IndexPage(),
    // );
  }


}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/checkout-payment',
      builder: (context, state) => const PaymentPage(),
    ),
    GoRoute(
      path: '/checkout-success',
      builder: (context, state) => const CheckoutSuccessPage(),
    ),
    GoRoute(
      path: '/admin-chat-rooms',
      builder: (context, state) => const AdminChatRoomListPage(),
    ),
    GoRoute(
      path: '/transaction-history',
      builder: (context, state) => TransactionHistoryPage(),
    ),
    GoRoute(
      path: '/index-page',
      builder: (context, state) => const IndexPage(),
    ),
    GoRoute(
      path: '/admin-chat-detail/:userId',
      builder: (BuildContext context, GoRouterState state) {
        // Tangkap parameter userId dari URL
        final String userId = state.params['userId']!;
        return AdminChatDetailPage(userId: int.parse(userId));
      },
    ),
    GoRoute(
      path: '/detail-chat',
      builder: (BuildContext context, GoRouterState state) {
        // Ambil product dari state.extra
        final product = state.extra as ProductModel;

        return DetailChatPage(product);
      },
    ),
    GoRoute(
      path: '/product',
      builder: (BuildContext context, GoRouterState state) {
        // Ambil product dari state.extra
        final product = state.extra as ProductModel;

        return ProductPage(product);
      },
    ),
    GoRoute(
      path: '/call',
      builder: (BuildContext context, GoRouterState state) {
        // Ambil data dari state.extra
        final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
        final String clientName = extraData['clientName'];
        final dynamic role = extraData['role']; // Sesuaikan tipe Role Anda

        return CallPage(clientName: clientName, role: role);
      },
    ),
  ],
);