import 'package:crud_app/screens/add_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_app/Bloc/customer_bloc.dart';
import 'package:crud_app/Bloc/customer_event.dart';
import 'package:crud_app/Bloc/customer_state.dart';
import 'package:crud_app/models/customer.dart';

class CustomerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoaded) {
            if (state.customers.isEmpty) {
              return Center(child: Text('No customers added.'));
            } else {
              return ListView.builder(
                itemCount: state.customers.length,
                itemBuilder: (context, index) {
                  final customer = state.customers[index];
                  return ListTile(
                    title: Text(customer.fullName),
                    subtitle: Text(customer.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditCustomerScreen(customer: customer),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<CustomerBloc>()
                                .add(DeleteCustomer(customer.email));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          } else if (state is CustomerError) {
            return Center(
                child: Text('Failed to load customers: ${state.message}'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditCustomerScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
