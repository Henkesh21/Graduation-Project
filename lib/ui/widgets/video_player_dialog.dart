import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerDialog extends StatefulWidget {
  final videoUrl;
  VideoPlayerDialog({
    Key key,
    this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  // VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;

  YoutubePlayerController _controller;
  String videoId;

  @override
  void initState() {
    // _controller = VideoPlayerController.network(
    //   widget.videoUrl,
    // );

    // _initializeVideoPlayerFuture = _controller.initialize();
    // Screen.keepOn(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AlertDialog(
      // contentPadding: EdgeInsets.all(
      //  0,
      //   // horizontal:  mediaQuery.size.height / 60,
      // ),
      // insetPadding:  EdgeInsets.all(
      //  0,
      //   // horizontal:  mediaQuery.size.height / 60,
      // ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      backgroundColor: Theme.of(context).canvasColor,
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ),
          ),
          // Center(
          //   child:
          SingleChildScrollView(
            child: ConditionalBuilder(
              condition: widget.videoUrl == '',
              builder: (context) {
                return Container(
                  // width: mediaQuery.size.width * 0.5,
                  height: mediaQuery.size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        'assets/images/waiting.png',
                      ),
                    ),
                  ),
                );
              },
              fallback: (context) {
                videoId = YoutubePlayer.convertUrlToId(
                  widget.videoUrl,
                  // trimWhitespaces: true,
                );
                print(videoId);

                _controller = YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: true,
                  ),
                );
                return Container(
                  // width: mediaQuery.size.width * 0.75,
                  // height: mediaQuery.size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // FutureBuilder(
                          //   future: _initializeVideoPlayerFuture,
                          //   builder: (context, snapshot) {
                          // if (snapshot.connectionState ==
                          //     ConnectionState.done) {
                          // return
                          // AspectRatio(
                          // aspectRatio: _controller.value.aspectRatio,
                          // child:
                          YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            bottomActions: [
                              CurrentPosition(),
                              ProgressBar(isExpanded: true),
                              // TotalDuration(),
                            ],
                          ),
                          // ;
                          // );
                          // } else {
                          //   return Center(
                          //     child: CircularProgressIndicator(),
                          //   );
                          // }
                          //   },
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 0,
                          //     vertical: mediaQuery.size.width / 20,
                          //   ),
                          // ),
                          // FloatingActionButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       if (_controller.value.isPlaying) {
                          //         _controller.pause();
                          //       } else {
                          //         _controller.play();
                          //       }
                          //     });
                          //   },
                          //   child: Icon(
                          //     _controller.value.isPlaying
                          //         ? Icons.pause
                          //         : Icons.play_arrow,
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 0,
                          //     vertical: mediaQuery.size.width / 20,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // )
        ],
      ),
    );
  }
}
