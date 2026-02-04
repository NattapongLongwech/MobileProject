import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Main_screen.dart';

class Create_List extends StatefulWidget {
  final int userId;

  const Create_List({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Create_ListState();
  }
}

class Create_ListState extends State<Create_List> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ListController = TextEditingController();
  final TextEditingController _AmountController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  Future<void> _create() async {
    final url = Uri.parse('http://localhost:3000/List/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'user_id': widget.userId,
      'Description': _ListController.text,
      'Amount': _AmountController.text,
      'Date': _DateController.text,
    });

    final res = await http.post(url, headers: headers, body: body);
    if (!mounted) return;
    if (res.statusCode == 200 || res.statusCode == 201) {
      jsonDecode(res.body);
      _showSnackBar('Create user success');
      Navigator.pop(context);
    } else {
      _showSnackBar(
        'Error creating user',
      ); // Show error message if creation failed
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create User',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ListController,
                decoration: const InputDecoration(
                  labelText: 'Discription',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Discription';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _AmountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Amount';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _DateController,
                decoration: const InputDecoration(
                  labelText: 'Date(YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date(YYYY-MM-DD)';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _create();
                    }
                  },
                  child: const Text('CREATE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
