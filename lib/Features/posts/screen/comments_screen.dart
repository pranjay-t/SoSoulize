import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Features/auths/controller/auth_controller.dart';
import 'package:reddit_clone/Resposive/responsive.dart';
import 'package:reddit_clone/Features/posts/controller/post_controller.dart';
import 'package:reddit_clone/Features/posts/widgets/comment_card.dart';
import 'package:reddit_clone/Theme/pallete.dart';
import 'package:reddit_clone/core/commons/loader.dart';
import 'package:reddit_clone/core/commons/post_card.dart';
import 'package:reddit_clone/core/constants/error_text.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(String postId) {
    final comment = commentController.text.trim();
    if (comment.isEmpty) return;
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: comment,
          postId: postId,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 30,
          ),
        ),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Responsive(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        PostCard(post: post),
                        if (!isGuest)
                        TextField(
                          onSubmitted: (val) => addComment(post.id),
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment your thoughts!',
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: theme == ThemeMode.dark
                                      ? Pallete.appColorDark
                                      : Pallete.appColorLight,
                                )),
                          ),
                        ),
                        ref.watch(getPostCommentProvider(widget.postId)).when(
                              data: (data) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final comment = data[index];
                                    return CommentCard(comment: comment);
                                  },
                                );
                              },
                              error: (error, stackTrace) {
                                return ErrorText(
                                  error: error.toString(),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                        
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}

// if (!isGuest)
//                           TextField(
//                             onSubmitted: (val) => addComment(post.id),
//                             controller: commentController,
//                             decoration:  InputDecoration(
//                               hintText: 'Comment your thoughts!',
//                               filled: true,
//                               border:const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(Radius.circular(10)),
                                
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius:const BorderRadius.all(Radius.circular(10)),
//                                 borderSide: BorderSide(
//                                   color: theme == ThemeMode.dark ? Pallete.appColorDark : Pallete.appColorLight,
//                                 )
//                               ),
//                             ),
//                           ),