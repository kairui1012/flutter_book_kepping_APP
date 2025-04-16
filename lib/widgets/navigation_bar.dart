import 'package:flutter/material.dart';
import '../pages/add_data_page.dart';
import '../pages/main_page.dart';
import '../pages/record_page.dart';

class CustomizeBottomNavigationBar extends StatelessWidget {
  const CustomizeBottomNavigationBar({super.key});

  final List<Widget> _pages = const [
    main_page(),
    add_data_page(),
    record_page(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            iconSize: 30.0,
            selectedItemColor: Color(0xff353542),
            unselectedItemColor: Color(0xff353542),
            onTap: (index) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _pages[index]),
              );
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'ADD'),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Record',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
