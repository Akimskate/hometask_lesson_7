import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/database/database.dart';
import 'package:test_db/datasource/ds_users.dart';
import 'package:test_db/model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _userAge = TextEditingController();

  var listitems = [];

  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BlocConsumer

    return BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
      if (state is UsersLoadedState) {
        listitems = state.users;
      }
    }, builder: (context, state) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _userName,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value != null && value.length <= 1) {
                          return 'Enter min. 3 characters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _userAge,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter valid user age';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: const Text('Add User'),
                  ),
                  ElevatedButton(
                    onPressed: _cleanDatabase,
                    child: const Text('Clean database'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _printUsers,
              child: const Text('Print users'),
            ),
            Container(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView.separated(
                    itemCount: listitems.length,
                    itemBuilder: (context, index) {
                      final item = listitems[index];
                      return ListTile(title: Text(item.toString()));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _printUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
  }

  void _addUser() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(
      AddUserEvent(
        User(
          name: _userName.text,
          age: int.parse(_userAge.text),
        ),
      ),
    );
  }

  void _cleanDatabase() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(DeleteUsersEvent());
  }
}
