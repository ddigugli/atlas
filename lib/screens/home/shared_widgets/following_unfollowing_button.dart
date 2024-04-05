import 'package:atlas/services/database.dart';
import 'package:flutter/material.dart';

class FollowingUnfollowingButton extends StatefulWidget {
  final String userIdCurrUser;
  final String userIdToFollow;

  const FollowingUnfollowingButton({
    super.key,
    required this.userIdCurrUser,
    required this.userIdToFollow,
  });

  @override
  State<FollowingUnfollowingButton> createState() =>
      _FollowingUnfollowingButtonState();
}

class _FollowingUnfollowingButtonState
    extends State<FollowingUnfollowingButton> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    if (widget.userIdCurrUser == widget.userIdToFollow) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<bool?>(
      future: DatabaseService()
          .isFollowing(widget.userIdCurrUser, widget.userIdToFollow),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing
                    ? const Color.fromARGB(255, 51, 51, 51)
                    : const Color.fromARGB(255, 20, 111, 185),
                fixedSize: const Size(100, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
              ),
              child: const Text('Loading...'),
            ),
          );
        }

        _isFollowing = snapshot.data ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ElevatedButton(
            onPressed: () async {
              if (_isFollowing) {
                await DatabaseService()
                    .unfollowUser(widget.userIdCurrUser, widget.userIdToFollow);
              } else {
                await DatabaseService()
                    .followUser(widget.userIdCurrUser, widget.userIdToFollow);
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFollowing
                  ? const Color.fromARGB(255, 51, 51, 51)
                  : const Color.fromARGB(255, 20, 111, 185),
              fixedSize: const Size(100, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
            ),
            child: Text(
              _isFollowing ? 'Unfollow' : 'Follow',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
