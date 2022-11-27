import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/repositories/user_repo.dart';
import 'package:nps_social/widgets/widget_profile_search_item.dart';

class HomeSearchDelegate extends SearchDelegate<Future<Widget>?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Ionicons.close_circle_outline),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> matchQuery = [];

    if (query.trim().isNotEmpty) {
      return FutureBuilder(
        future: search(query: query.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            matchQuery = snapshot.data ?? [];
            return ListView.builder(
              itemCount: matchQuery.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: WidgetProfileSearchItem(user: matchQuery[index]),
                );
              },
            );
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(color: ColorConst.blue, size: 15),
                );
              },
            );
          }
        },
      );
    }

    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.fullName ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> matchQuery = [];

    if (query.trim().isNotEmpty) {
      return FutureBuilder(
        future: search(query: query.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            matchQuery = snapshot.data ?? [];
            return ListView.builder(
              itemCount: matchQuery.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: WidgetProfileSearchItem(user: matchQuery[index]),
                );
              },
            );
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SpinKitThreeBounce(color: ColorConst.blue, size: 15),
                );
              },
            );
          }
        },
      );
    }

    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.fullName ?? ''),
        );
      },
    );
  }

  Future<List<UserModel>> search({required String query}) async {
    List<UserModel> result = [];
    result = await userRepository.searchUser(query: query) ?? [];
    return result;
  }
}
