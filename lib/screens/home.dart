import 'package:customer_list/bloc/bloc.dart';
import 'package:customer_list/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial_material_design/flutter_speed_dial_material_design.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomerBloc bloc = CustomerBloc();
  SpeedDialController _controller = SpeedDialController();
  String name = '';
  String price = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 10.0),
            child: Container(
              child: Text(
                'Customer List',
                style: TextStyle(
                    fontFamily: 'Raleway', fontSize: 46, color: Theme.of(context).primaryColor),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: Container(
              child: blocView(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    final TextStyle customStyle =
        TextStyle(inherit: false, color: Colors.black);
    final icons = [
      SpeedDialAction(
          child: Icon(Icons.add),
          label: Text('Add Customer', style: customStyle)),
      SpeedDialAction(
          child: Icon(Icons.delete),
          label: Text('Done Delete', style: customStyle)),
    ];

    return SpeedDialFloatingActionButton(
      actions: icons,
      childOnFold: Icon(Icons.more_vert, key: UniqueKey()),
      childOnUnfold: Icon(Icons.add),
      useRotateAnimation: true,
      onAction: _onSpeedDialAction,
      controller: _controller,
      isDismissible: true,
    );
  }

  _onSpeedDialAction(int selectedActionIndex) {
    print('$selectedActionIndex Selected');
    if (selectedActionIndex == 0) {
      _showCreateDialog();
    } else if (selectedActionIndex == 1) {
      bloc.deleteDoneCustomer();
    }
  }

  _showCreateDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (String name) {
                        this.name = name;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      onChanged: (String price) {
                        this.price = price;
                      },
                      keyboardType: TextInputType.number,
                      maxLines: null,
                      decoration: InputDecoration(hintText: 'Price'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                      child: Text('Save'),
                      onPressed: () {
                        saveDB();
                        Navigator.pop(context);
                      }),
                ]));
  }

  Future<void> saveDB() async {
    var fido = Customer(
      name: this.name,
      price: this.price,
    );
    await bloc.addCustomer(fido);
  }
  Widget blocView(){
    return StreamBuilder(
      stream: bloc.customers,
      builder: (BuildContext context, AsyncSnapshot<List<Customer>>snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                //dog의 인자를 전달하여 저장
                Customer item = snapshot.data[index];

                return ListTile(
                  onTap: (){},
                  contentPadding: EdgeInsets.only(left:30.0,right: 20.0),
                  trailing: Checkbox(
                    value: item.status,
                    onChanged: (bool value){
                      bloc.statusCustomer(item);
                    },
                  ),
                  title: Text(item.name,style:
                  item.status ? TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.lineThrough,fontSize: 20.0,color: Colors.grey) :
                  TextStyle(fontStyle: FontStyle.italic,fontSize: 20.0,color: Colors.teal)),
                  subtitle: Text(item.price,style: TextStyle(fontFamily: 'Raleway',fontSize: 15.0,color: item.status ? Colors.grey : Colors.teal)),
                );
              });
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}
