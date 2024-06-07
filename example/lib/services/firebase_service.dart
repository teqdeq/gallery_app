import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/global_vars.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getImageUrl(String artistId, String imageId) async {
    try {
      //Start off by getting all artists
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

  Future<List<Map<String, String>>> getAllImagesData() async {
    List<Map<String, String>> allImagesData = [];
    try {
      /// Get all the artists' documents
      QuerySnapshot artistsSnapshot = await _firestore
          .collection('artists').get();

      List<QueryDocumentSnapshot> artistDocuments = artistsSnapshot.docs;

      for(var artistDoc in artistDocuments) {
        final artistFirebaseData = artistDoc.data() as Map<String, dynamic>;
        debugPrint("Extracting artist: ${artistDoc.id}");
        /// Get all the images' documents
        QuerySnapshot imagesSnapshot = await _firestore
            .collection('artists').doc(artistDoc.id).collection("images").get();

        List<QueryDocumentSnapshot> imageDocuments = imagesSnapshot.docs;

        for(var imageDoc in imageDocuments) {
          final imageFirebaseData = imageDoc.data() as Map<String, dynamic>;
          final String? artistName = artistFirebaseData["artist_name"];
          final String? imageFilename = imageFirebaseData["image_file"];
          final String? imageName = imageFirebaseData["image_name"];

          debugPrint("Retrieved image data: $artistName, $imageFilename, $imageName");


          allImagesData.add({
            "artist_id" : artistDoc.id,
            "artist_name" : artistFirebaseData["artist_name"]??"",
            "image_id"  : imageDoc.id,
            "image_url" : imageFirebaseData["image_file"]??"",
            "image_name" : imageFirebaseData["image_name"]??""
           });
        }
      }
          // .doc(artistId)
          // .collection('images')
          // .doc(imageId)
          // .get();

      // if (imageSnapshot.exists && (imageSnapshot.data()! as Map)['imageUrl'] != null ) {
      //   return imageSnapshot.get('imageUrl');
      // } else {
      //   throw 'Image not found';
      // }

    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      throw e.toString();
    } catch (e) {
      // Handle other errors
      throw e.toString();
    }

    return allImagesData;
  }


}
