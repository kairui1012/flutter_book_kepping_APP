import 'package:bookkepping/ultis/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/bookkeeping_database.dart';
import '../widgets/navigation_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class add_data_page extends StatefulWidget {
  const add_data_page({super.key});

  @override
  State<add_data_page> createState() => _add_data_pageState();

  void onDateSelected(DateTime selectedDate) {}
}

class _add_data_pageState extends State<add_data_page> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff353542),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputBookkeepingDataName(
                BookkeepingDataNameController: _nameController,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                indent: MediaQuery.of(context).size.width * 0.1,
                endIndent: MediaQuery.of(context).size.width * 0.1,
              ),
              InputAmount(InputAmountController: _amountController),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              Center(
                child: Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width * 0.90,
                child: DatePicker(
                  slidersColor: Colors.white,
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  initialDate: DateTime.now(),
                  minDate: DateTime(1999, 12, 31),
                  maxDate: DateTime(2099, 12, 31),
                  currentDateTextStyle: const TextStyle(
                    color: Color(0xffFF7966),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  currentDateDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  leadingDateTextStyle: const TextStyle(
                    color: Color(0xffFF7966),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  daysOfTheWeekTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  enabledCellsTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  onDateSelected: (selectedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                    widget.onDateSelected(selectedDate);
                  },
                  selectedCellDecoration: const BoxDecoration(
                    color: Color(0xffFF7966),
                    shape: BoxShape.circle,
                  ),
                  selectedCellTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  final name = _nameController.text.trim();
                  final amount = _amountController.text.trim();

                  if (name.isEmpty || amount.isEmpty || _selectedDate == null) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Incomplete Data"),
                            content: const Text(
                              "Please enter name, amount, and select a date.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    );
                    return;
                  }

                  InsertData(
                    name: name,
                    amountText: amount,
                    selectedDate: _selectedDate,
                  );

                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Success"),
                          content: const Text("Data added successfully!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                  );
                },

                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF7966),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomizeBottomNavigationBar(),
    );
  }
}

void InsertData({
  required String name,
  required String amountText,
  required DateTime selectedDate,
}) async {
  final id = '${selectedDate.microsecondsSinceEpoch}';

  final data = BookKeepingData(
    id: id,
    amount: double.tryParse(amountText) ?? 0.0,
    year: selectedDate.year.toString(),
    month: selectedDate.month.toString().padLeft(2, '0'),
    date: selectedDate.day.toString().padLeft(2, '0'),
    name: name,
  );

  await insertBookkeepingData(data);
}

class InputBookkeepingDataName extends StatelessWidget {
  final TextEditingController BookkeepingDataNameController;

  const InputBookkeepingDataName({
    required this.BookkeepingDataNameController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          const Text(
            "Name",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextFormField(
            controller: BookkeepingDataNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              contentPadding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.02,
              ),
              hintText: 'Enter Your Record Name',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 2,
                  color: Color(0xffFF7966),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputAmount extends StatelessWidget {
  final TextEditingController InputAmountController;

  const InputAmount({required this.InputAmountController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          const Text(
            "Amount",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextFormField(
            controller: InputAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              contentPadding: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.02,
              ),
              hintText: 'Enter Your Amount',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 2,
                  color: Color(0xffFF7966),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
