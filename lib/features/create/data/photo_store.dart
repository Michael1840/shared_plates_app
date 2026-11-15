import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';

enum PhotoSource { camera, gallery }

abstract interface class PhotoStore {
  Future<String?> pick(PhotoSource source, {required String recipeId});
}

class DevicePhotoStore implements PhotoStore {
  DevicePhotoStore({
    ImagePicker? picker,
    Future<Directory> Function()? directory,
  }) : _picker = picker ?? ImagePicker(),
       _directory = directory ?? getApplicationSupportDirectory;

  static const maxSide = 1600.0;
  static const quality = 82;

  final ImagePicker _picker;
  final Future<Directory> Function() _directory;

  @override
  Future<String?> pick(PhotoSource source, {required String recipeId}) async {
    try {
      final file = await _picker.pickImage(
        source: source == PhotoSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: maxSide,
        maxHeight: maxSide,
        imageQuality: quality,
        requestFullMetadata: false,
      );
      if (file == null) return null;
      final dir = Directory('${(await _directory()).path}/drafts');
      await dir.create(recursive: true);
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final target = '${dir.path}/$recipeId-$stamp.jpg';
      await File(file.path).copy(target);
      return target;
    } on IOException catch (e, s) {
      ErrorReporter.report('PhotoStore.pick', e, s);
      return null;
    } on Exception catch (e, s) {
      ErrorReporter.report('PhotoStore.pick', e, s);
      return null;
    }
  }
}
