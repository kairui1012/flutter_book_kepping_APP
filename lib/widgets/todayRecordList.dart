import 'package:flutter/material.dart';

import '../data/bookkeeping_database.dart';

class TodayRecordList extends StatelessWidget {
  const TodayRecordList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookKeepingData>>(
      future: getTodayBookkeepingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Today haven't record", style: TextStyle(color: Colors.white)));
        }

        final records = snapshot.data!;

        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text("RM ${record.amount}", style: TextStyle(color: Colors.white)),
              subtitle: Text("${record.year}-${record.month}-${record.date}", style: TextStyle(color: Colors.white70)),
              trailing: Text("ID: ${record.id}", style: TextStyle(color: Colors.white)),
            );
          },
        );
      },
    );
  }
}