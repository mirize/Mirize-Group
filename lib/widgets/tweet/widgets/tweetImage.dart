import 'package:flutter/material.dart';
import 'package:mirize/helper/enum.dart';
import 'package:mirize/model/feedModel.dart';
import 'package:mirize/state/feedState.dart';
import 'package:mirize/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class TweetImage extends StatelessWidget {
  const TweetImage(
      {Key key, this.model, this.type, this.isRetweetImage = false})
      : super(key: key);

  final FeedModel model;
  final TweetType type;
  final bool isRetweetImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: model.imagePath == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isRetweetImage ? 0 : 20),
                ),
                onTap: () {
                  if (type == TweetType.ParentTweet) {
                    return;
                  }
                  var state = Provider.of<FeedState>(context, listen: false);
                  state.getpostDetailFromDatabase(model.key);
                  state.setTweetToReply = model;
                  Navigator.pushNamed(context, '/ImageViewPge');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isRetweetImage ? 0 : 20),
                  ),
                  child: Container(
                    width: fullWidth(context) *
                            (type == TweetType.Detail ? 1 : .8) -
                        8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    // child: AspectRatio(
                    //   aspectRatio: 16 / 9,
                    //   child: customNetworkImage(model.imagePath,
                    //       fit: BoxFit.fill),
                    // ),
                    child: Container(
                      width: double.infinity,
                      height: isRetweetImage ? 200 : 600,
                      child: customNetworkImage(model.imagePath,
                          fit: isRetweetImage ? BoxFit.cover : BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
