import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:yusperabot/screens/cart/cart_screen.dart';
import 'package:yusperabot/screens/catalog/catalog_screen.dart';
import 'package:yusperabot/screens/complete_profile/complete_profile_screen.dart';
import 'package:yusperabot/screens/details/details_screen.dart';
import 'package:yusperabot/screens/forgot_password/forgot_password_screen.dart';
import 'package:yusperabot/screens/home/home_screen.dart';
import 'package:yusperabot/screens/order/order_screen.dart';
import 'package:yusperabot/screens/promo/promo_screen.dart';
import 'package:yusperabot/screens/login_success/login_success_screen.dart';
import 'package:yusperabot/screens/otp/otp_screen.dart';
import 'package:yusperabot/screens/profile/profile_screen.dart';
import 'package:yusperabot/screens/order_status/order_status_screen.dart';
import 'package:yusperabot/screens/registration_success/registration_success_screen.dart';
import 'package:yusperabot/screens/sign_in/sign_in_screen.dart';
import 'package:yusperabot/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(
      user: ModalRoute.of(context)!.settings.arguments as User),
  RegistrationSuccessScreen.routeName: (context) => RegistrationSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  PromoScreen.routeName: (context) => PromoScreen(),
  CatalogScreen.routeName: (context) => CatalogScreen(),
  OrderScreen.routeName: (context) => OrderScreen(),
  OrderStatusScreen.routeName: (context) => OrderStatusScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
