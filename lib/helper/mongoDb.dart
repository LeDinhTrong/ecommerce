import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Db db;
  static DbCollection collection;
  List<Map<String, dynamic>> data;
  static connect() async {
    db = await Db.create(AppConstants.MONGO_CONN_URL);
    await db.open();
    inspect(db);
    collection = db.collection(AppConstants.USER_COLLECTION);
  }

  find() async {
    await collection.find().toList().then((value) => data = value);
    return data;
  }

  insert({Map<String, dynamic> info, String previousHash}) async {
    await collection.insert({
      '_id': sha256.convert(utf8.encode(info.toString() + previousHash)).toString(),
      'info': info,
      'previousHash': previousHash,
    });
  }

  findById(String id) async {
    await collection.find().toList().then((value) => data = value);
    data.removeAt(0);
    int index = data.indexWhere((element) => id == element['info']['order_id'].toString());
    print(index);
    if (index != -1) return data[index]['_id'].toString();
  }
}
