import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' as Path;

final key = new GlobalKey<StorageServiceState>();

class StorageService extends StatefulWidget {
  final File file;
  final String dir;
  final String extention;
  // final String  imageUrl;

  StorageService({
    Key key,
    @required this.file,
    @required this.dir,
    @required this.extention,
  }) : super(key: key);

  @override
  StorageServiceState createState() => StorageServiceState();
}

class StorageServiceState extends State<StorageService> {
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://healthy-lifestyle-application.appspot.com');
  StorageUploadTask _uploadTask;
  String _fileUrl;
  // String get fileUrl => _fileUrl;

  _startUpload() async {
    String filePath = '${widget.dir}${DateTime.now()}.${widget.extention}';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    await _uploadTask.onComplete;

    _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
      setState(() {
        _fileUrl = fileURL;
        //// String get fileUrl => _fileUrl;

        // _fileUrl = key.currentState.fileUrl;
      });
      print('Done >>>>>>>>>>>>>>>>>>>>>>>>>>>> URL is $_fileUrl');
      return _fileUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: [
              if (_uploadTask.isComplete)
                Text(
                  'Uploaded successfully',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 14,
                      ),
                ),
              Padding(
                padding: EdgeInsets.all(mediaQuery.size.width / 90),
              ),
              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),
              if (_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: _uploadTask.pause,
                ),
              CircularProgressIndicator(
                value: progressPercent,
              ),
              Padding(
                padding: EdgeInsets.all(mediaQuery.size.width / 90),
              ),
              Text(
                '${(progressPercent * 100).toStringAsFixed(2)} % ',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 14,
                    ),
              ),
            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
        icon: Icon(Icons.cloud_upload),
        label: Text(
          'Upload',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 14,
              ),
        ),
        onPressed: _startUpload,
      );
    }
  }
}
