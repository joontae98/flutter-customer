import 'dart:async';
import 'package:customer_list/model/model.dart';
import 'package:customer_list/model/db.dart';

class CustomerBloc{

  CustomerBloc() {
    getCustomers();
  }
  final _customerController = StreamController<List<Customer>>.broadcast();
  get customers =>_customerController.stream;

  dispose(){
    _customerController.close();
  }

  deleteDoneCustomer() async{
    await DB().deleteAllCustomers();
    _customerController.sink.add(await DB().getAllCustomers());
  }
  getCustomers() async{
    _customerController.sink.add(await DB().getAllCustomers());
  }

  addCustomer(Customer customer) async{
    await DB().createCustomer(customer);
    getCustomers();
  }

  deleteCustomer(int id) async{
    await DB().deleteCustomer(id);
    getCustomers();
  }

  statusCustomer(Customer customer) async{
    await DB().statusCustomer(customer);
    getCustomers();
  }

}

