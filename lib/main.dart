import 'package:crud_app/Bloc/customer_bloc.dart';
import 'package:crud_app/repo/cust_repo.dart';
import 'package:crud_app/screens/add_customer.dart';
import 'package:crud_app/screens/customer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(CustomerRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Customer CRUD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AddEditCustomerScreen(),
      ),
    );
  }
}
