import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../data/bookkeeping_database.dart';
import '../ultis/color.dart';
import '../widgets/customArcPainter.dart';
import '../widgets/currentStatusButton.dart';
import '../widgets/navigation_bar.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import '../widgets/todayRecordList.dart';

class main_page extends StatefulWidget {
  const main_page({super.key});

  @override
  State<main_page> createState() => mainPageState();
}

class mainPageState extends State<main_page> {
  double thisMonthTotal = 0.0;
  double thisMonthAvg = 0.0;
  double thisTodayTotalAmount = 0.0;
  double budgetLimit = 0.0;
  final TextEditingController _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await _initializeConfig();
    double today_total = await getTodayTotalAmount();
    double total = await getThisMonthTotalAmount();
    double avg = await getThisMonthAverageDailyAmount();

    final configFile = await _getWritableConfigFile();
    final configContent = await configFile.readAsString();
    budgetLimit = _parseLimitFromConfig(configContent);

    setState(() {
      thisMonthTotal = total;
      thisMonthAvg = avg;
      thisTodayTotalAmount = today_total;
      budgetLimit = budgetLimit;
    });
  }

  Future<void> _updateConfigFile(double newLimit) async {
    if (newLimit == 0.0) return;

    final configFile = await _getWritableConfigFile();
    String configContent = await configFile.readAsString();

    final lines = configContent.split('\n');
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('amount_limit:')) {
        lines[i] = 'amount_limit: $newLimit';
      }
    }

    await configFile.writeAsString(lines.join('\n'));
  }

  Future<File> _getWritableConfigFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/configuration.txt');
  }

  Future<void> _initializeConfig() async {
    final configFile = await _getWritableConfigFile();
    if (!await configFile.exists()) {
      final defaultConfig = await rootBundle.loadString('assets/configuration.txt');
      await configFile.writeAsString(defaultConfig);
    }
  }


  Future<void> _showLimitDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Monthly Limit'),
          content: TextField(
            controller: _limitController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter amount"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () async {
                String input = _limitController.text;
                if (input.isNotEmpty) {
                  double newLimit = double.tryParse(input) ?? 0.0;
                  await _updateConfigFile(newLimit);
                  setState(() {
                    budgetLimit = newLimit;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingBalance = (budgetLimit - thisMonthTotal).toStringAsFixed(2);
    return Scaffold(
      backgroundColor: Color(0xff353542),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.53,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: CustomPaint(
                      painter: CustomArcPainter(
                        thisMonthTotal: thisMonthTotal,
                        budgetLimit: budgetLimit,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Remaining Balance',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        "\$ $remainingBalance",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      GestureDetector(
                        onTap: _showLimitDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: gray60,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Set Monthly Limit Amount",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: CurrentStatusButton(
                                title: "Daily Spending",
                                value: thisMonthAvg.toStringAsFixed(2),
                                statusColor: secondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CurrentStatusButton(
                                title: "Today Spending",
                                value: thisTodayTotalAmount.toStringAsFixed(2),
                                statusColor: primary10,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CurrentStatusButton(

                                title: "This Month",
                                value: thisMonthTotal.toStringAsFixed(2),
                                statusColor: secondaryG,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              "Today Spending",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: TodayRecordList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomizeBottomNavigationBar(),
    );
  }
}

class options extends StatelessWidget {
  final String text;
  final String colour;

  const options({super.key, required this.text, required this.colour});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

double _parseLimitFromConfig(String content) {
  final lines = content.split('\n');
  for (var line in lines) {
    if (line.startsWith('amount_limit:')) {
      return double.tryParse(line.split(':')[1].trim()) ?? 0.0;
    }
  }
  return 0.0;
}

Future<File> _getWritableConfigFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/configuration.txt');
}

Future<void> _initializeConfig() async {
  final configFile = await _getWritableConfigFile();
  if (!await configFile.exists()) {
    final defaultConfig = await rootBundle.loadString(
      'assets/configuration.txt',
    );
    await configFile.writeAsString(defaultConfig);
  }
}
