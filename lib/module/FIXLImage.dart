
import 'dart:io';

import 'package:image/image.dart' as _image;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class FIXLImage
{
    void getImage(ImageSource source,{ Function start, Function success, failed }  ) async {
    start();
    File image = await ImagePicker.pickImage(source: source);
    
    if (image != null) {
      final mimeTypeData = 
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
      List<String> jgp = [ 'jpg', 'JPEG', 'jpeg', 'JPG' ];
      _image.Image imageFile ;
      if( jgp.contains( mimeTypeData[1] ) )
        imageFile = _image.decodeJpg(image.readAsBytesSync());
      else
        imageFile = _image.decodePng(image.readAsBytesSync());

      _image.Image thumbnail = _image.copyResize(imageFile, height : 300);

      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      new Directory(appDocDirectory.path + '/customer').create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        var name = DateTime.now().millisecondsSinceEpoch;
        File(directory.path + '/$name.png')
            .writeAsBytesSync(_image.encodePng(thumbnail));

        File imageThumbnail = File(directory.path + '/$name.png');
        success( imageThumbnail );
      });
    } 
    else
    {
      failed( 'gambar tidak ada' );
    }
  }

  
}

abstract class ImageCallBack
{
    void start();
    void success( File image );
    void failed( String message );
}