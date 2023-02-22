import 'package:flutter/material.dart';

import '../Models/group_ob.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
 // Color selectedColor = Colors.primaries.first;
  final textController = TextEditingController();
   final textController2 = TextEditingController();
  String? errorMessage;

  void _onSave() {
    final name = textController.text.trim();
    final category = textController2.text.trim();
    if (name.isEmpty || category.isEmpty) {
      setState(() {
        errorMessage = 'Name is required';
      });
      return;
    } else {
      setState(() {
        errorMessage = null;
      });
    }
    final result = Group(name: name, category: category);
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: textController2,
                        
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        decoration:  InputDecoration(
                          hintText: 'Group category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23)
                          ),
                        ),
                      ),
                    ),
                    // const Icon(
                    //   Icons.group,
                    //   size: 60,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                      child: TextField(
                        controller: textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        decoration:  InputDecoration(
                          hintText: 'Group name',
                         border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          errorMessage ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 20,
                    //     vertical: 15,
                    //   ),
                    //   child: Text('SELECT COLOR'),
                    // ),
                    // Expanded(
                    //   child: GridView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //     ),
                    //     itemCount: Colors.primaries.length,
                    //     itemBuilder: (context, index) {
                    //       final color = Colors.primaries[index];
                    //       return Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 15.0, vertical: 5),
                    //         child: InkWell(
                    //           onTap: () {
                    //             // setState(() {
                    //             //   selectedColor = color;
                    //             // });
                    //           },
                    //           child: CircleAvatar(
                    //             backgroundColor: color,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: MaterialButton(
                        color: Colors.blue,
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Create Group',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: _onSave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
