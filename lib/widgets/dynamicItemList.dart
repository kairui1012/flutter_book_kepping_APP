import 'package:flutter/material.dart';
import '../data/bookkeeping_database.dart';

class DynamicItemList extends StatefulWidget {
  @override
  _DynamicItemListState createState() => _DynamicItemListState();
}

class _DynamicItemListState extends State<DynamicItemList> {
  List<BookKeepingData> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await getAllBookkeepingData();
    setState(() {
      items = data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(
            "${item.name} (${item.date}-${item.month}-${item.year})",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          subtitle: Text(
            'Amount: ${item.amount.toString()}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ), // White trash can icon
            onPressed: ()  async {
              await deleteBookkeepingData(item.id);
              setState(() {
                items.removeAt(index); // Remove the item on press
              });
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                  title: const Text("Success"),
                  content: const Text("Data delete successfully!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },

          ),

        );
      },
    );
  }
}
