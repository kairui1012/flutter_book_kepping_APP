import 'package:flutter/material.dart';

import '../widgets/dynamicItemList.dart';
import '../widgets/navigation_bar.dart';

class record_page extends StatelessWidget {
  const record_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff353542),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Record",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,

                child: DynamicItemList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomizeBottomNavigationBar(),
    );
  }
}
