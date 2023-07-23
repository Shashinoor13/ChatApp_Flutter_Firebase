import 'package:chats/presentation/screens/Login/login.dart';
import 'package:chats/presentation/screens/home/home_page.dart';
import 'package:chats/presentation/screens/search/search_page.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/ErroPage/error_page.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(settings, const HomePage());
      case '/login':
        return _materialRoute(settings, const Login());
      case '/search':
        return _materialRoute(settings, const SearchPage());
      default:
        return _materialRoute(settings, const ErrorPage());
    }
  }

  static Route<dynamic> _materialRoute(RouteSettings settings, Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
