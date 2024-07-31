import 'package:crud_app/Bloc/customer_bloc.dart';
import 'package:crud_app/Bloc/customer_event.dart';
import 'package:crud_app/models/customer.dart';
import 'package:crud_app/screens/customer_list.dart';
import 'package:crud_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  AddEditCustomerScreen({this.customer});

  @override
  _AddEditCustomerScreenState createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  List<Address> _addresses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _panController.text = widget.customer!.pan;
      _fullNameController.text = widget.customer!.fullName;
      _emailController.text = widget.customer!.email;
      _mobileController.text = widget.customer!.mobile;
      _addresses = widget.customer!.addresses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _panController,
                  decoration: InputDecoration(labelText: 'PAN'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PAN';
                    }
                    if (value.length != 10) {
                      return 'PAN must be 10 characters';
                    }
                    return null;
                  },
                  onChanged: (value) async {
                    if (value.length == 10) {
                      setState(() {
                        _isLoading = true;
                      });
                      final response = await ApiService.verifyPan(value);
                      setState(() {
                        _isLoading = false;
                        if (response['isValid']) {
                          _fullNameController.text = response['fullName'];
                        }
                      });
                    }
                  },
                ),
                if (_isLoading) CircularProgressIndicator(),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration:
                      InputDecoration(labelText: 'Mobile', prefixText: '+91 '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text('Addresses',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    return _buildAddressForm(index);
                  },
                ),
                TextButton(
                  onPressed: () {
                    if (_addresses.length < 10) {
                      setState(() {
                        _addresses.add(Address(
                          addressLine1: '',
                          addressLine2: '',
                          postcode: '',
                          state: '',
                          city: '',
                        ));
                      });
                    }
                  },
                  child: Text('Add Address'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final customer = Customer(
                        pan: _panController.text,
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        mobile: _mobileController.text,
                        addresses: _addresses,
                      );
                      final customerBloc = context.read<CustomerBloc>();
                      if (widget.customer == null) {
                        customerBloc.add(AddCustomer(customer));
                      } else {
                        customerBloc.add(UpdateCustomer(customer));
                      }
                      customerBloc.add(LoadCustomers());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerListScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Text(widget.customer == null
                      ? 'Add Customer'
                      : 'Edit Customer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          initialValue: _addresses[index].addressLine1,
          decoration: InputDecoration(labelText: 'Address Line 1'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address line 1';
            }
            return null;
          },
          onChanged: (value) {
            _addresses[index].addressLine1 = value;
          },
        ),
        TextFormField(
          initialValue: _addresses[index].addressLine2,
          decoration: InputDecoration(labelText: 'Address Line 2'),
          onChanged: (value) {
            _addresses[index].addressLine2 = value;
          },
        ),
        TextFormField(
          initialValue: _addresses[index].postcode,
          decoration: InputDecoration(labelText: 'Postcode'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter postcode';
            }
            if (value.length != 6) {
              return 'Postcode must be 6 digits';
            }
            return null;
          },
          onChanged: (value) async {
            if (value.length == 6) {
              setState(() {
                _isLoading = true;
              });
              final response = await ApiService.getPostcodeDetails(value);
              setState(() {
                _isLoading = false;
                _addresses[index].city = response['city'][0]['name'];
                _addresses[index].state = response['state'][0]['name'];
              });
            }
          },
        ),
        DropdownButtonFormField<String>(
          value: _addresses[index].state.isNotEmpty
              ? _addresses[index].state
              : null,
          decoration: InputDecoration(labelText: 'State'),
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem(value: 'Maharashtra', child: Text('Maharashtra')),
            // Add more states as necessary
          ],
          onChanged: (value) {
            setState(() {
              _addresses[index].state = value!;
            });
          },
        ),
        DropdownButtonFormField<String>(
          value:
              _addresses[index].city.isNotEmpty ? _addresses[index].city : null,
          decoration: InputDecoration(labelText: 'City'),
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem(value: 'Pune', child: Text('Pune')),
          ],
          onChanged: (value) {
            setState(() {
              _addresses[index].city = value!;
            });
          },
        ),
      ],
    );
  }
}
