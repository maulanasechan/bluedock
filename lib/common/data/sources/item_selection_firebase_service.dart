import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ItemSelectionFirebaseService {
  Future<Either> getItemSelection(ItemSelectionReq req);
}

class ItemSelectionFirebaseServiceImpl extends ItemSelectionFirebaseService {
  final _db = FirebaseFirestore.instance;

  @override
  Future<Either> getItemSelection(ItemSelectionReq req) async {
    try {
      final listData = await _db
          .collection(req.collection)
          .doc(req.document)
          .collection(req.subCollection)
          .orderBy('title')
          .get();
      if (listData.docs.isEmpty) {
        return Left('${req.subCollection} Not Found');
      }

      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }
}
