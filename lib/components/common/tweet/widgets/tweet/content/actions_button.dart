import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:intl/intl.dart';

class TweetActionsButton extends StatelessWidget {
  const TweetActionsButton(
    this.tweet, {
    this.padding = const EdgeInsets.all(8),
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final EdgeInsets padding;
  final double sizeDelta;

  bool _shouldShowReply(BuildContext context) {
    return ModalRoute.of(context).settings?.name != ComposeScreen.route;
  }

  bool _isAuthenticatedUser(TweetBloc bloc, AuthenticationBloc authBloc) {
    return bloc.tweet.userData.idStr == authBloc.authenticatedUser.idStr;
  }

  String _dateFormat(BuildContext context, DateTime dateTime) {
    return DateFormat.Hm(Localizations.localeOf(context).languageCode)
        .add_yMMMd()
        .format(dateTime)
        .toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TweetBloc bloc = TweetBloc.of(context);
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);
    final HomeTimelineBloc homeTimelineBloc = context.watch<HomeTimelineBloc>();

    return ViewMoreActionButton(
      padding: padding,
      onTap: () => showHarpyBottomSheet<void>(
        context,
        children: <Widget>[
          BottomSheetHeader(
            child: Column(
              children: <Widget>[
                Text('tweet from ${tweet.userData.name}'),
                defaultSmallVerticalSpacer,
                Text(
                  '${_dateFormat(context, tweet.createdAt.toLocal())}',
                ),
              ],
            ),
          ),
          if (_isAuthenticatedUser(bloc, authBloc))
            ListTile(
              leading: Icon(CupertinoIcons.delete, color: theme.errorColor),
              title: Text(
                'delete',
                style: TextStyle(
                  color: theme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                bloc.add(DeleteTweet(onDeleted: () {
                  homeTimelineBloc
                      .add(RemoveFromHomeTimeline(tweet: bloc.tweet));
                }));
                app<HarpyNavigator>().state.maybePop();
              },
            ),
          if (_shouldShowReply(context))
            ListTile(
              leading: const Icon(CupertinoIcons.reply),
              title: const Text('reply'),
              onTap: () async {
                await app<HarpyNavigator>().state.maybePop();
                app<HarpyNavigator>().pushComposeScreen(
                  inReplyToStatus: tweet,
                );
              },
            ),
          ListTile(
            leading: const Icon(CupertinoIcons.square_arrow_left),
            title: const Text('open tweet externally'),
            onTap: () {
              bloc.add(OpenTweetExternally(tweet: tweet));
              app<HarpyNavigator>().state.maybePop();
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.square_on_square),
            title: const Text('copy tweet text'),
            enabled: bloc.tweet.hasText,
            onTap: () {
              bloc.add(CopyTweetText(tweet: tweet));
              app<HarpyNavigator>().state.maybePop();
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.share),
            title: const Text('share tweet'),
            onTap: () {
              bloc.add(ShareTweet(tweet: tweet));
              app<HarpyNavigator>().state.maybePop();
            },
          ),
        ],
      ),
    );
  }
}
