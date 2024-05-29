import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se346_project/src/app-screens/profile/profile_screen.dart';
import 'package:se346_project/src/widgets/post.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:se346_project/src/data/types.dart';
import 'package:se346_project/src/api/generalAPI.dart';

class OtherProfile extends StatefulWidget {
  final UserProfileData profileData;
  const OtherProfile({super.key, required this.profileData});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  Future<UserProfileData?> _loadUser() async {
    try {
      if (widget.profileData.id != null) {
        final UserProfileData? user =
            await GeneralAPI().loadProfile(widget.profileData.id);
        if (user != null) {
          return user;
        } else {
          throw 'User not found';
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  //Todo implement edit profile
                },
              ),
            ],
            expandedHeight: 50.0,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: _loadUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error loading user profile. Error: ${snapshot.error}.'),
                  );
                } else {
                  UserProfileData user = snapshot.data as UserProfileData;
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        //If no background img is provided, make it transparent
                        decoration: BoxDecoration(
                            color: Colors.green,
                            image: user.profileBackground != null &&
                                    user.profileBackground!.isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(user.profileBackground!),
                                    fit: BoxFit.cover)
                                : null),

                        child: ClipPath(
                          clipper: BezierClipper(),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: user.avatarUrl ?? '')
                                    .image,
                              ),
                              Text(user.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text(user.bio ?? '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                      //Posts label
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Posts',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      if (user.posts != null)
                        for (var post in user.posts!)
                          Post(
                            postData: post,
                          ),

                      SizedBox(height: 20),
                      Center(
                        child: Text('No more post available',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
