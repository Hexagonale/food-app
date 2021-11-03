import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodapp/screens/welcome/views/sign_up_view.dart';

import 'widgets/_widgets.dart';
import 'views/_views.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  static Route<Widget> getRoute() {
    return MaterialPageRoute<Widget>(
      builder: (BuildContext context) => const Welcome(),
    );
  }

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  static const BorderRadius _headerRadius = BorderRadius.only(
    bottomLeft: Radius.circular(5.0),
    bottomRight: Radius.circular(5.0),
  );

  late final TabController _controller = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: _headerRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1.0, 7.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 96.0),
          const AnimatedLogo(),
          const SizedBox(height: 50.0),
          _buildTabs(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 66.0,
      child: ClipRRect(
        borderRadius: _headerRadius,
        child: TabBar(
          controller: _controller,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 5,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xffb3b3b3),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const <Widget>[
            Text('Login'),
            Text('Sign Up'),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return TabBarView(
      controller: _controller,
      children: const <Widget>[
        LoginView(),
        SignUpView(),
      ],
    );
  }
}
