import 'package:ls_visiting_card/Models/group_ob.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CardModel {
  int id = 0;
  String description;
  String? image;

  final group = ToOne<Group>();

  CardModel({required this.description, this.image});
  
}