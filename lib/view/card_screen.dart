import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ls_visiting_card/Provider/data_provider.dart';
import 'package:provider/provider.dart';

import '../Models/card_ob.dart';
import '../Models/group_ob.dart';
import '../objectbox.g.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({required this.group, required this.store, Key? key}) : super(key: key);

  final Group group;
  final Store store;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final textController = TextEditingController();
  final _cards = <CardModel>[];
  File? selectedImg;
  String? base64Image;

  // void _onSave() async {
  //   final description = textController.text.trim();
  //   if (description.isNotEmpty) {
  //     textController.clear();

  //     final task = CardModel(
  //       description: description,
  //       image: Provider.of<DataProvider>(context, listen: false).base64Img,
  //     );
  //     task.group.target = widget.group;
  //     widget.store.box<CardModel>().put(task);
  //     if (selectedImg == null) return;
  //     setState(() {
  //       selectedImg = null;
  //     });
  //     _reloadTasks();
  //   }
  // }

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);
  //     if (image == null) return;
  //     final img = File(image.path);

  //     setState(() {
  //       selectedImg = img;
  //       Uint8List bytes = selectedImg!.readAsBytesSync();
  //       base64Image = base64Encode(bytes);
  //     });
  //   } on PlatformException catch (e) {
  //     print('failed $e');
  //   }
  // }

  void _reloadTasks() {
    _cards.clear();
    QueryBuilder<CardModel> builder = widget.store.box<CardModel>().query();
    builder.link(CardModel_.group, Group_.id.equals(widget.group.id));
    Query<CardModel> query = builder.build();
    List<CardModel> tasksResult = query.find();
    setState(() {
      _cards.addAll(tasksResult);
    });
    query.close();
  }

  // Uint8List Base64Decode(String base64string) {
  //   var imgbyte = base64Decode(base64string);
  //   return imgbyte;
  // }

  void _onDelete(CardModel card) {
    widget.store.box<CardModel>().remove(card.id);
    _reloadTasks();
  }

  void _onUpdate(int index, bool completed) {
    final task = _cards[index];
    // task.completed = completed;
    widget.store.box<CardModel>().put(task);
    _reloadTasks();
  }

  @override
  void initState() {
    _cards.addAll(List.from(widget.group.cards));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dp, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.group.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Card Description',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Text('Pick Image from Camera'),
                      ),
                      dp.selectedImg == null
                          ? IconButton(
                              onPressed: () async {
                                await dp.pickImage();
                              },
                              // onPressed: pickImage,
                              icon: Icon(Icons.camera),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                dp.selectedImg!,
                                cacheHeight: 40,
                                cacheWidth: 40,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'ADD CARD',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  dp.onSave(
                    textController.text.trim(),
                    textController,
                    widget.group,
                    widget.store,
                  );
                  _reloadTasks();
                },
                // onPressed: _onSave,
              ),
              const SizedBox(height: 10),
              _cards.isEmpty
                  ? Text('No Data Available')
                  : Expanded(
                      child: CarouselSlider.builder(
                        itemCount: _cards.length,
                        itemBuilder: (context, index, realIndex) {
                          final task = _cards[index];
                          return Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                          child: Image.memory(
                                            dp.convertFromBase64(task.image!),
                                            fit: BoxFit.cover,
                                            cacheHeight: MediaQuery.of(context).size.height ~/ 2,
                                            cacheWidth: MediaQuery.of(context).size.width.toInt(),
                                          )),
                                    ),
                                    Positioned(
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              _onDelete(task);
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                            )))
                                  ],
                                ),
                              ),
                              Text(
                                task.description,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ],
                          );
                        },
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.97,
                          //initialPage: 0,
                          //aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                      ),
                    ),
              // Expanded(
              //   child: ListView.builder(
              //    scrollDirection: Axis.horizontal,
              //     itemCount: _cards.length,
              //     itemBuilder: (context, index) {
              //       final task = _cards[index];
              //       return Container(
              //         height: MediaQuery.of(context).size.height / 2,
              //         width: MediaQuery.of(context).size.width,
              //         decoration: BoxDecoration(
              //           color: Colors.amber,
              //            borderRadius: BorderRadius.circular(15),
              //         ),
              //        // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

              //         child: Column(
              //          // crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Expanded(
              //               child: Image.memory(
              //                 Base64Decode(task.image!),

              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 10),
              //               child: Text(task.description,style: TextStyle(
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.w500
              //               ),),
              //             ),
              //           ],
              //         ),
              //       );
              // return Column(
              //   children: [
              //     Image.memory(
              //       Base64Decode(task.image!),
              //       width: 160,
              //       height: 140,
              //       fit: BoxFit.cover,
              //     ),
              //     // Text(task.image ?? ''),
              //     ListTile(
              //       title: Text(
              //         task.description,
              //         style: TextStyle(),
              //       ),
              //       // leading: Checkbox(
              //       //   value: task.completed,
              //       //   onChanged: (val) => _onUpdate(index, val!),
              //       // ),
              //       trailing: IconButton(
              //         icon: const Icon(Icons.close),
              //         onPressed: () => _onDelete(task),
              //       ),
              //     ),
              //   ],
              // );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
