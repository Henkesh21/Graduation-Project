import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healthy_lifestyle_app/ui/widgets/video_player_dialog.dart';

class ExerciseItem extends StatefulWidget {
  final String name;
  final String description;
  final String animatedPhotoUrl;
  final String videoUrl;
  final rate;

  const ExerciseItem({
    Key key,
    this.name,
    this.description,
    this.animatedPhotoUrl,
    this.videoUrl,
    this.rate,
  }) : super(key: key);

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return
        // InkWell(
        //   onTap: () => () {},
        // selectMeal(context),
        // child:
        Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 10,
      margin: EdgeInsets.all(mediaQuery.size.width / 30),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'View video',
            color: Theme.of(context).secondaryHeaderColor,
            icon: Icons.video_label,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VideoPlayerDialog(videoUrl: widget.videoUrl);
                  });
            },
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 3.0,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(
              mediaQuery.size.width / 60,
            ),
            leading: Container(
              // width: mediaQuery.size.width * 0.25,
              // height: mediaQuery.size.height * 0.5,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                radius: 30,

                child: ConditionalBuilder(
                  condition: widget.animatedPhotoUrl == '',
                  builder: (context) {
                    return Container(
                      // width: mediaQuery.size.width,
                      // height: mediaQuery.size.height,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(7.0),
                        shape: BoxShape.circle,
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
                    return Container(
                      // width: mediaQuery.size.width,
                      // height: mediaQuery.size.height,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(7.0),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.animatedPhotoUrl,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // ),
              ),
            ),
            // ),
            title: Padding(
              padding: EdgeInsets.only(
                bottom: mediaQuery.size.width / 90,
              ),
              child: Text(
                '${widget.name}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConditionalBuilder(
                  condition: widget.description == '',
                  builder: (context) {
                    return FittedBox(
                      child: Text(
                        'No description added yet',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12,
                            ),
                      ),
                    );
                  },
                  fallback: (context) {
                    return 
                    // FittedBox(
                    //   child: 
                      Text(
                        '${widget.description}',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12,
                            ),
                      // ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
