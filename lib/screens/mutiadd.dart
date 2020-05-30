import 'package:customer_list/bloc/bloc.dart';
import 'package:customer_list/model/model.dart';
import 'package:flutter/material.dart';

class MutiAddPage extends StatefulWidget {
  @override
  _MutiAddPageState createState() => _MutiAddPageState();
}

class _MutiAddPageState extends State<MutiAddPage> {
  final CustomerBloc bloc = CustomerBloc();

  String name = '';
  String price = '';
  List<String> items = List<String>.generate(0, (index) {
    return "Item - $index";
  });

  final teController = TextEditingController(
    text: "",
  );

  @override
  void dispose() {
    teController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              setState(() {
                for(int i = 0; i <items.length; i++){
                  this.price = items[i];
                  saveDB();
                }
              });
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('write kind page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String name){
                this.name = name;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item),
                    direction: DismissDirection.startToEnd,
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () {
                          setState(() {
                            items.removeAt(index);
                          });
                        },
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 5,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  Text("목록 추가:"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: teController,
                        onSubmitted: (text) {
                          setState(() {
                            if (teController.text != "") {
                              items.add(teController.text);
                            }
                          });
                          teController.clear();
                        },
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("추가"),
                    onPressed: () {
                      setState(() {
                        if (teController.text != "") {
                          items.add(teController.text);
                        }
                      });
                      teController.clear();
                      print(items);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> saveDB() async {
    var fido = Customer(
      name: this.name,
      price: this.price,
    );
    await bloc.addCustomer(fido);
  }

}
