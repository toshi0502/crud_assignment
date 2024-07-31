import 'package:crud_app/models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomerRepository {
  static const String _customersKey = 'customers';

  Future<List<Customer>> loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson = prefs.getString(_customersKey);
    if (customersJson != null) {
      final List decoded = json.decode(customersJson);
      return decoded.map((e) => Customer.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> addCustomer(Customer customer) async {
    final customers = await loadCustomers();
    customers.add(customer);
    await _saveCustomers(customers);
  }

  Future<void> updateCustomer(Customer customer) async {
    final customers = await loadCustomers();
    final index = customers.indexWhere((c) => c.pan == customer.pan);
    if (index != -1) {
      customers[index] = customer;
      await _saveCustomers(customers);
    }
  }

  Future<void> deleteCustomer(String pan) async {
    final customers = await loadCustomers();
    final updatedCustomers = customers.where((c) => c.pan != pan).toList();
    await _saveCustomers(updatedCustomers);
  }

  Future<void> _saveCustomers(List<Customer> customers) async {
    final prefs = await SharedPreferences.getInstance();
    final customersJson =
        json.encode(customers.map((e) => e.toJson()).toList());
    await prefs.setString(_customersKey, customersJson);
  }
}
