import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/Community/controller/community_controller.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/sign_in_buttons.dart';
import 'package:reddit_clone/core/constants/error_text.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunityScreen(
      BuildContext context, CommunityModel community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding:const EdgeInsets.only(left: 10,top: 10),
            child: Text(isGuest ? 'LogIn to Enjoy More!':'Your Communities',style:const TextStyle(fontFamily: 'carter',fontSize: 17),),
          ),
          isGuest
              ? const Padding(
                padding:  EdgeInsets.all(10),
                child: FittedBox(child:  SignInButtons()),
              )
              : ListTile(
                  onTap: () => navigateToCreateCommunity(context),
                  leading: const Icon(Icons.add,size: 30,),
                  title: const Text('Create a community',style: TextStyle(fontFamily: 'carter'),),
                ),
          if (!isGuest)
            ref.watch(userCommunityProvider(user.uid)).when(
                  data: (communities) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = communities[index];
                          return ListTile(
                            onTap: () =>
                                navigateToCommunityScreen(context, community),
                            title: Text('r/${community.name}',style:const TextStyle(fontFamily: 'carter'),),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
        ],
      )),
    );
  }
}
