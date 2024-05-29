import 'package:se346_project/src/api/groupAPI.dart';

class UserProfileData {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final List<PostData>? posts;
  final String? profileBackground;
  final List<String>? followers;
  //Created at / updated at
  final DateTime? createdAt;
  final DateTime? updatedAt;
  UserProfileData(
      {required this.id,
      required this.name,
      required this.email,
      this.phone,
      this.avatarUrl,
      this.bio,
      this.posts,
      this.profileBackground,
      this.followers,
      this.createdAt,
      this.updatedAt});
}

//Same as user profile data, all user wall posts are public and can be viewed by anyone
//Only check if they are following the user to view their profile
// Returned for search results
class OtherPeopleProfileData {
  final String id;
  final String name;
  final String? bio;
  final String? phone;
  final String? email;
  final List<PostData>? posts;
  final String? avatarUrl;
  final String? profileBackground;
  final String? followers;
  final bool? isFollowing;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  OtherPeopleProfileData({
    required this.id,
    required this.name,
    this.bio,
    this.phone,
    this.email,
    this.posts,
    this.avatarUrl,
    this.profileBackground,
    this.isFollowing,
    this.followers,
    this.createdAt,
    this.updatedAt,
  });
}

//Returned on home
//Can query group name if post is in a group
//Can query user profile for related user info
class PostData {
  final String id;
  final String posterId;
  final String name; // poster name
  final String content;
  final List<CommentData> comments;
  // List of user ids who liked the post
  final List<String>? likes;
  //List of user ids who shared the post
  final List<String>? shares;
  final String? posterAvatarUrl;
  final String? mediaUrl;
  final String? groupId;
  final String? sharePostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? userIsPoster;
  final bool? userLiked;
  final bool isEdited;

  PostData({
    required this.id,
    required this.posterId,
    required this.name,
    required this.content,
    this.comments = const [],
    this.posterAvatarUrl,
    this.mediaUrl,
    this.groupId,
    this.sharePostId,
    this.likes,
    this.shares,
    required this.createdAt,
    required this.updatedAt,
    this.isEdited = false,
    this.userIsPoster,
    this.userLiked,
  });

  Future<void> addComment(CommentData comment) async {
    // Implementation to add a comment
  }

  Future<void> deleteComment(String commentId) async {
    // Implementation to delete a comment
  }

  Future<void> likePost() async {
    // Implementation to like the post
  }

  Future<void> unlikePost() async {
    // Implementation to unlike the post
  }

  Future<void> deletePost() async {
    // Implementation to delete the post
  }

  Future<void> reportPost() async {
    // Implementation to report the post
  }

  Future<void> sharePost() async {
    // Implementation to share the post
  }

  Future<GroupData> getGroup() async {
    // Implementation to get group details
    return GroupData(id: '', name: '', description: '');
  }

  Future<String?> getGroupName() async {
    // Implementation to get group name
    if (groupId != null) {
      return GroupAPI().getGroupName(groupId!);
    }
    return null;
  }

  Future<OtherPeopleProfileData> getPosterProfile() async {
    // Implementation to get poster profile
    return OtherPeopleProfileData(
        id: '', name: '', createdAt: DateTime.now(), updatedAt: DateTime.now());
  }
}

class CommentData {
  final String id;
  final String postId;
  final String commenterId;
  final String commenterName;
  final String? commenterAvatarUrl;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentData({
    required this.id,
    required this.postId,
    required this.commenterId,
    required this.commenterName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.commenterAvatarUrl,
    this.mediaUrl,
  });
}

class GroupData {
  final String id;
  final String name;
  final String description;
  final String? bannerImgUrl;
  final List<String>? postIds; // Changed to List of IDs for simplicity
  final List<GroupMemberData>? members;
  final List<GroupMemberData>? admins;
  final List<String>? followers; // Assuming followers are just user IDs
  bool isMember; // To track if the current user is a member
  bool isAdmin;

  GroupData({
    required this.id,
    required this.name,
    required this.description,
    this.bannerImgUrl,
    this.postIds,
    this.members,
    this.admins,
    this.followers,
    this.isMember = false,
    this.isAdmin = false,
  });

  // Method to join the group
  Future<void> joinGroup() async {
    bool result = await GroupAPI().joinGroup(id);
    if (result) {
      isMember = true;
    }
  }

  // Method to leave the group
  Future<void> leaveGroup() async {
    bool result = await GroupAPI().leaveGroup(id);
    if (result) {
      isMember = false;
    }
  }

  // Method to get group posts
  Future<List<PostData>> getGroupPosts() async {
    //Todo: implement get group posts
    List<PostData> posts = await GroupAPI().getGroupPosts(id);

    return posts;
  }

  // Method to get member list
  Future<List<GroupMemberData>> getMembers() async {
    // Implementation to retrieve member list
    return members ?? [];
  }

  // Method to get admin list
  Future<List<GroupMemberData>> getAdmins() async {
    // Implementation to retrieve admin list
    return admins ?? [];
  }

  // Method to check if a user is following the group
  bool isFollowing(String userId) {
    return followers?.contains(userId) ?? false;
  }
}

// Only have name, id, and avatar url for quick access
class GroupMemberData {
  final String id;
  final String name;
  final String? avatarUrl;

  GroupMemberData({required this.id, required this.name, this.avatarUrl});
}
