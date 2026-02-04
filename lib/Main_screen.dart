import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Create_List.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MainScreen extends StatefulWidget {
  final int userId;

  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? _userDetail;
  List<dynamic>? listDetail = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th_TH', null).then((_) {
      _fetchUserDetail();
      _fetchListDetail();
    });
  }

  Future<void> _fetchListDetail() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/List/${widget.userId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        listDetail = json.decode(response.body);
      });
    } else {
      setState(() {
        listDetail = null;
      });
    }
  }

  Future<void> _fetchUserDetail() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/users/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _userDetail = json.decode(response.body)[0];
      });
    } else {
      setState(() {
        _userDetail = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${_userDetail?['name'] ?? ''}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.teal,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create_List(userId: widget.userId),
                  ),
                ).then((_) => _fetchListDetail());
              },
              child: Text('CREATE'),
            ),
          ),
        ],
      ),

      body:
          listDetail == null
              ? Center(child: Text("Failed to load list"))
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: listDetail!.length,
                itemBuilder: (context, index) {
                  final list = listDetail![index];
                  final rawDate = list['Date'];
                  final dateTime = DateTime.parse(rawDate);
                  final formattedDate = DateFormat(
                    'd MMM yyyy',
                    'th_TH',
                  ).format(dateTime);
                  final amount = list['Amount'];
                  final description = list['Description'] ?? 'No Description';

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      leading: Icon(
                        amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: amount >= 0 ? Colors.green : Colors.red,
                      ),

                      title: Text(
                        '$amount Bath',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: amount >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description),
                          SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
