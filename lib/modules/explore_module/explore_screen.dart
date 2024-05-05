import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../cash/cash_helper.dart';
import '../../models/user_model.dart';
import '../../models/user_post_model.dart';
import '../../shared/primary_InputField.dart';
import '../../util/global_variables.dart';
import 'explore_post_item.dart';
import 'searched_user_item.dart';


class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentModeDark = CashHelper.getSavedCashData(
      key: 'userLatestThemeMode',
    );
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 10),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: primaryInputField(
            autoFocusKeyboard: false,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            focusBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            context: context,
            controller: _searchController,
            hintText: 'search',
            contentPadding: EdgeInsets.only(top: 5, left: 15),
            prefixIcon: Icon(Icons.search),
            inputStyle: isCurrentModeDark
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
            onFieldSubmitted: (value) {},
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: _searchController.text.isNotEmpty
          ? FutureBuilder(
              future: GlobalV.firestore
                  .collection('users')
                  .where(
                    'userName',
                    isGreaterThanOrEqualTo: _searchController.text,
                  )
                  .get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 0.4,
                    ),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    UserModel user = UserModel.getJson(
                      snapshot.data.docs[index].data(),
                    );
                    return SearchedUserItem(searchedUser: user);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 0.0);
                  },
                  itemCount: (snapshot.data as dynamic).docs.length,
                );
              },
            )
          : FutureBuilder(
              future: GlobalV.firestore.collection('userPosts').get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 0.4,
                    ),
                  );
                }
                return AlignedGridView.count(
                  padding: EdgeInsets.only(top: 10),
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 2,
                  itemBuilder: (context, index) {
                    UserPostModel post = UserPostModel.getJson(
                      snapshot.data!.docs[index].data(),
                    );
                    return ExplorePostItem(post: post);
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
    );
  }
}
