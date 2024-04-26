import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getImageUrl(String artistId, String imageId) async {
    try {
      DocumentSnapshot imageSnapshot = await _firestore
          .collection('artists')
          .doc(artistId)
          .collection('images')
          .doc(imageId)
          .get();

      if (imageSnapshot.exists && (imageSnapshot.data()! as Map)['imageUrl'] != null ) {
        return imageSnapshot.get('imageUrl');
      } else {
        throw 'Image not found';
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      throw e.toString();
    } catch (e) {
      // Handle other errors
      throw e.toString();
    }
  }
}
