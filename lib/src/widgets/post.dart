import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/blocs/CommentBloc.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/widgets/commentItem.dart';
import 'package:se346_project/src/widgets/detailedPost.dart';
import 'package:se346_project/src/utils/convertTime.dart';

const _avatarSize = 40.0;

class Post extends StatelessWidget {
  final PostData postData;

  const Post({
    super.key,
    required this.postData,
  });

  void onLike() {
    // Handle like action
  }

  void onComment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
          child: DetailedPostPage(
              commentBloc: CommentBloc(),
              comments: postData.comments,
              postData: postData),
        ),
      ),
    );
  }

  void onShare() {
    // Handle share action
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (postData.posterAvatarUrl != null)
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    //If img is null or "", use default color
                    backgroundImage: postData.posterAvatarUrl!.isNotEmpty
                        ? NetworkImage(postData.posterAvatarUrl!)
                        : null,
                  )
                else
                  CircleAvatar(
                    radius: _avatarSize / 2,
                    backgroundColor: Colors.primaries[
                        DateTime.now().microsecondsSinceEpoch %
                            Colors.primaries.length],
                  ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String?>(
                      future: postData.getGroupName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(postData.name);
                        } else if (snapshot.hasError) {
                          return Text(postData.name);
                        } else {
                          final groupName = snapshot.data;
                          return RichText(
                            text: TextSpan(
                              text: postData.name,
                              style: DefaultTextStyle.of(context).style,
                              children: groupName != null
                                  ? [
                                      TextSpan(
                                          text: ' > ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          )),
                                      TextSpan(
                                        text: groupName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      convertTime(postData.createdAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(postData.content),
                if (postData.mediaUrl != null)
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: postData.mediaUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${postData.likes?.length ?? 0}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${postData.comments.length} comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${postData.shares?.length ?? 0} shares',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: onLike,
                    ),
                    Text('Like'),
                  ],
                ),
                GestureDetector(
                  onTap: () => onComment(context),
                  child: Row(
                    children: [
                      Icon(Icons.comment),
                      SizedBox(width: 4.0),
                      Text('Comment'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: onShare,
                    ),
                    Text('Share'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
