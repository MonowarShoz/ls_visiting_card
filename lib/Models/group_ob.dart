import 'package:ls_visiting_card/Models/card_ob.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Group {
  int id = 0;
  String name;
  String category;

  @Backlink()
  final cards = ToMany<CardModel>();

  Group({required this.name,required this.category});

}