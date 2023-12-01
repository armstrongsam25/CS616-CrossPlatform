// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Skywalk/views/main_page/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';

class RouteHistory extends StatefulWidget {
  const RouteHistory({super.key});

  @override
  State<RouteHistory> createState() => _RouteHistoryState();
}

class _RouteHistoryState extends State<RouteHistory> {
  TextEditingController _addressNameTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayTextInputDialog(context);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("User Saved Route"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              for (Address address in MainPageController.to.adressList)
                Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(address.name),
                        subtitle: Text(address.address),
                        onTap: () {},
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
            ]),
          ),
        ));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Address Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addressNameTextController,
                decoration:
                    InputDecoration(hintText: "Write your address name here"),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _addressTextController,
                decoration:
                    InputDecoration(hintText: "Write your full address here"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                //addWarningMark=false;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  MainPageController.to.adressList.add(Address(
                      name: _addressNameTextController.text,
                      address: _addressTextController.text));
                });
                //addWarningMark=true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
