import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: _BottomNavigation(
        onSelect: (int i) {},
      ),
      body: Stack(
        children: [
          _HomePage(),
        ],
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello again,',
          style: TextStyle(),
        ),
        Text(
          'Pathumzoo',
          style: TextStyle(),
        ),
      ],
    );
  }
}

class _BottomNavigation extends StatefulWidget {
  const _BottomNavigation({
    required this.onSelect,
  });

  final Function(int i) onSelect;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<_BottomNavigation> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => _select(0),
            child: SvgPicture.asset(
              'assets/img/home.svg',
              color: selected == 0 ? Theme.of(context).primaryColor : Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () => _select(1),
            child: SvgPicture.asset(
              'assets/img/search.svg',
              color: selected == 1 ? Theme.of(context).primaryColor : Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () => _select(4),
            child: Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(9.7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    offset: Offset(1, 7),
                    blurRadius: 5,
                  )
                ],
              ),
              child: SvgPicture.asset('assets/img/plus.svg'),
            ),
          ),
          GestureDetector(
            onTap: () => _select(2),
            child: SvgPicture.asset(
              'assets/img/cart.svg',
              color: selected == 2 ? Theme.of(context).primaryColor : Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () => _select(3),
            child: SvgPicture.asset(
              'assets/img/user.svg',
              color: selected == 3 ? Theme.of(context).primaryColor : Color(0xff999999),
            ),
          )
        ],
      ),
    );
  }

  void _select(int i) {
    widget.onSelect(i);
    setState(() => selected = i);
  }
}
