import 'package:flutter/material.dart';
import 'package:myapp1/database/database_helper.dart';
import './database/userlist.dart';

// ignore: must_be_immutable
class UserScreen extends StatefulWidget {
  UserScreen({Key? key, required this.users, required this.dbHelper})
      : super(key: key);

  List<User> users;
  DatabaseHelper dbHelper;
  
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, List<User>> userByProvince = {};
    for (User user in widget.users) {
      if (userByProvince.containsKey(user.province)) {
        userByProvince[user.province]?.add(user);
      } else {
        userByProvince[user.province] = [user];
      }
    }
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.location_city),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  var result = await ModalUserForm(users: widget.users)
                      .showModalInputForm(context);
                  setState(() {
                    if (result != null) {
                      widget.users = result;
                    }
                  });
                },
                icon: const Icon(Icons.add_comment))
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.users[index].name),
                    subtitle: Text((widget.users[index].province)),
                    trailing: ElevatedButton(
                      child: Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete User'),
                          content: const Text('Are you sure?'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('CANCEL'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                var userdelete = widget.users[index].name;
                                widget.dbHelper
                                    .deleteUser(widget.users[index].name);
                                setState(() {
                                  widget.users.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('DELETE'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(userdetail: widget.users[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: userByProvince.keys.length,
                itemBuilder: (context, provinceIndex) {
                  String province = userByProvince.keys.toList()[provinceIndex];
                  List<User>? usersInProvince = userByProvince[province];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          province,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: usersInProvince?.length,
                        itemBuilder: (context, userIndex) {
                          User? user = usersInProvince?[userIndex];

                          return ListTile(
                            title: Text(user!.name),
                            subtitle: Text(user.province),
                            trailing: ElevatedButton(
                              child: Icon(Icons.delete),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete User'),
                                  content: const Text('Are you sure?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('CANCEL'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      onPressed: () {
                                        var userdelete =
                                            widget.users[provinceIndex].name;
                                        widget.dbHelper.deleteUser(
                                            widget.users[provinceIndex].name);
                                        setState(() {
                                          widget.users.removeAt(provinceIndex);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('DELETE'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(userdetail: user),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.userdetail}) : super(key: key);

  final User userdetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userdetail.name),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text('Name: ${userdetail.name}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text('Age: ${userdetail.age.toString()}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text('Email: ${userdetail.email}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text('Province: ${userdetail.province}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text('idcard: ${userdetail.idcard.toString()}'),
          )
        ],
      ),
    );
  }
}

class ModalUserForm {
  ModalUserForm({Key? key, required this.users});

  List<User> users;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _idcardController = TextEditingController();

  Future<dynamic> showModalInputForm(BuildContext context) {
    int currentStep = 0;
    List<User> users = [];
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    title: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Stepper(
                    currentStep: currentStep,
                    onStepContinue: () async {
                      if (currentStep == 0) {
                        if (_nameController.text.isEmpty ||
                            _ageController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _provinceController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Please complete the information.'),
                                content: Text('Please input the information.'),
                                actions: [
                                  ElevatedButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      } else if (currentStep == 1) {
                        if (_idcardController.text.isEmpty ||
                            _idcardController.text.length != 13 ||
                            !RegExp(r'^\d{13}$')
                                .hasMatch(_idcardController.text)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Please complete the information.'),
                                content: Text(
                                    'The number was incomplete or fill out'),
                                actions: [
                                  ElevatedButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          User newUser = User(
                            name: _nameController.text,
                            age: int.parse(_ageController.text),
                            email: _emailController.text,
                            province: _provinceController.text,
                            idcard: int.parse(_idcardController.text),
                          );

                          users.add(newUser);

                          await DatabaseHelper.instance.insertUser(newUser);
                          users = await DatabaseHelper.instance.fetchUsers();

                          Navigator.pop(context, users);
                        }
                      }
                    },
                    onStepCancel: () {
                      if (currentStep > 0) {
                        setState(() {
                          currentStep -= 1;
                        });
                      } else {
                        Navigator.pop(context, users);
                      }
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      final _isLastStep = currentStep == 1;
                      return Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text(_isLastStep ? 'Confirm' : 'Next'),
                                onPressed: details.onStepContinue,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            if (currentStep != 0)
                              Expanded(
                                child: ElevatedButton(
                                  child: Text('Back'),
                                  onPressed: details.onStepCancel,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Step 1'),
                        isActive: currentStep == 0,
                        content: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Input your name',
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _ageController,
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                  hintText: 'Input age',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Input email',
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _provinceController,
                                decoration: const InputDecoration(
                                  labelText: 'Province',
                                  hintText: 'Input province',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text('Step 2'),
                        isActive: currentStep == 1,
                        content: Container(
                          margin: const EdgeInsets.all(13),
                          child: TextFormField(
                            controller: _idcardController,
                            decoration: const InputDecoration(
                              labelText: 'ID Card',
                              hintText: 'Input ID card',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
