import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getImageUrls() async {
    try {
      final Reference storageRef = _storage.ref().child('artists_images/512px');
      final ListResult result = await storageRef.listAll();

      final List<String> urls = await Future.wait(result.items.map((ref) async {
        final String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      }));

      return urls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return [];
    }
  }
}
