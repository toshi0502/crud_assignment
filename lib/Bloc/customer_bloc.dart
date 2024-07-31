import 'package:crud_app/Bloc/customer_event.dart';
import 'package:crud_app/Bloc/customer_state.dart';
import 'package:crud_app/repo/cust_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc(this.customerRepository) : super(CustomerInitial());

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is LoadCustomers) {
      yield CustomerLoading();
      try {
        final customers = await customerRepository.loadCustomers();
        yield CustomerLoaded(customers: customers, Customer: []);
      } catch (e) {
        yield CustomerError(message: e.toString());
      }
    } else if (event is AddCustomer) {
      yield CustomerLoading();
      try {
        await customerRepository.addCustomer(event.customer);
        final customers = await customerRepository.loadCustomers();
        yield CustomerLoaded(customers: customers, Customer: []);
      } catch (e) {
        yield CustomerError(message: e.toString());
      }
    } else if (event is UpdateCustomer) {
      yield CustomerLoading();
      try {
        await customerRepository.updateCustomer(event.customer);
        final customers = await customerRepository.loadCustomers();
        yield CustomerLoaded(customers: customers, Customer: []);
      } catch (e) {
        yield CustomerError(message: e.toString());
      }
    } else if (event is DeleteCustomer) {
      yield CustomerLoading();
      try {
        await customerRepository.deleteCustomer(event.pan);
        final customers = await customerRepository.loadCustomers();
        yield CustomerLoaded(customers: customers, Customer: []);
      } catch (e) {
        yield CustomerError(message: e.toString());
      }
    }
  }
}
