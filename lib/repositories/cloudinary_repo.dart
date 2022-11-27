import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/models/image_model.dart';

final cloudinaryRepository = _CloudinaryRepository();

class _CloudinaryRepository {
  // final _dio = Dio();
  final cloudinary = CloudinaryPublic(
    AppKey.CLOUDINARY_NAME,
    AppKey.CLOUDINARY_UPDATE_PRESET,
    cache: false,
  );

  Future<List<ImageModel>?> uploadImages(
      {required List<File> imageFiles}) async {
    List<ImageModel>? uploadedImages = [];

    for (File e in imageFiles) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            e.path,
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        // debugPrint("${response.publicId}");
        // debugPrint("${response.secureUrl}");

        uploadedImages.add(ImageModel(
          public_id: response.publicId,
          url: response.secureUrl,
        ));
      } on CloudinaryException catch (e) {
        debugPrint("${e.message}");
        debugPrint("${e.request}");
        return null;
      }
      // var formData = FormData.fromMap({
      //   "upload_preset": "sql40th0",
      //   "cloud_name": "drvvgmc2p",
      //   "file": MultipartFile.fromFile(e.path),
      // });

      //   try {
      //     var result = await _dio.post(
      //       'https://api.cloudinary.com/v1_1/drvvgmc2p/upload',
      //       data: formData,
      //     );

      //     if (result.data != null) {
      //       uploadedImages?.add(ImageModel.fromJson(result.data));
      //     }
      //   } catch (e) {
      //     debugPrint("${e.toString()}");
      //     if (e is DioErrorType) {
      //       debugPrint("${e.name}");
      //     } else {}
      //   }
    }

    return uploadedImages;
  }
}
