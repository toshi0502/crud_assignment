import 'package:crud_app/models/customer.dart';

abstract class CustomerEvent {
  @override
  List<Object> get props => [];
}

class LoadCustomers extends CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final Customer customer;

  AddCustomer(this.customer);

  @override
  List<Object> get props => [customer];
}

class UpdateCustomer extends CustomerEvent {
  final Customer customer;

  UpdateCustomer(this.customer);

  @override
  List<Object> get props => [customer];
}

class DeleteCustomer extends CustomerEvent {
  final String pan;

  DeleteCustomer(this.pan);

  @override
  List<Object> get props => [pan];
}
