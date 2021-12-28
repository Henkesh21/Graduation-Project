// import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart' as Path;

final key = new GlobalKey<FileUploadState>();

class FileUpload extends StatefulWidget {
  final StorageUploadTask uploadTask;
  final Function startUpload;

  FileUpload({
    Key key,
    @required this.uploadTask,
    @required this.startUpload,
  }) : super(key: key);

  @override
  FileUploadState createState() => FileUploadState();
}

class FileUploadState extends State<FileUpload> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (widget.uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: widget.uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: [
              if (widget.uploadTask.isComplete)
                Text(
                  'Uploaded successfully',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 14,
                      ),
                ),
              Padding(
                padding: EdgeInsets.all(mediaQuery.size.width / 90),
              ),
              if (widget.uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: widget.uploadTask.resume,
                ),
              if (widget.uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: widget.uploadTask.pause,
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
        onPressed: widget.startUpload,
      );
    }
  }
}
