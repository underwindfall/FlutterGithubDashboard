import 'package:flutter/material.dart';
import 'package:githubdashboard/github/model/event.dart';
import 'package:githubdashboard/github/model/event_payload.dart';

class EventTile extends StatelessWidget {
  final EventModel _eventModel;

  EventTile(this._eventModel);

  @override
  Widget build(BuildContext context) {
    var icon;
    var title;
    switch (_eventModel.type) {
      case EventType.CreateEvent:
        icon = Icons.add;
        title = _buildCreateText(_eventModel);
        break;
      case EventType.DeleteEvent:
        icon = Icons.close;
        title = _buildDeleteText(_eventModel);
        break;
      case EventType.ForkEvent:
        icon = Icons.call_split;
        title = '${_eventModel.actor.login} forked ${_eventModel.repo.name}';
        break;
      case EventType.PullRequestEvent:
        icon =
        _eventModel.payload.action == EventActionType.Opened
            ? Icons.add
            : Icons.close;
        title = _buildPullText(_eventModel);
        break;
      case EventType.PushEvent:
        icon = Icons.call_merge;
        title = _buildPushText(_eventModel);
        break;
      case EventType.MemberEvent:
        icon = Icons.person;
        title = 'Member event';
        break;
      case EventType.WatchEvent:
        icon = Icons.star;
        title = '${_eventModel.actor.login} starred ${_eventModel.repo.name}';
        break;
      default:
        icon = Icons.info;
        title = 'Unknown event with id ${_eventModel.id}';
    }
    var avatar = new CircleAvatar(
        child: new Image.network(_eventModel.actor.avatarUrl)
    );
    return new ListTile(
        leading: avatar,
        trailing: new Icon(icon),
        dense: true,
        isThreeLine: true,
        title: new Text(_eventModel.actor.login),
        subtitle: new Text(title, overflow: TextOverflow.ellipsis, maxLines: 2)

    );
  }


  String _buildCreateText(EventModel event) {
    switch (event.payload.refType) {
      case EventPayloadType.Branch:
        return '${event.actor.login} created branch ${event.payload.ref}';
      default:
        return '${_eventModel.actor.login} created repository ${_eventModel.repo
            .name}';
    }
  }

  String _buildDeleteText(EventModel event) {
    switch (event.payload.refType) {
      case EventPayloadType.Branch:
        return '${event.actor.login} deleted branch ${event.payload.ref}';
      default:
        return 'Unknown event with id ${_eventModel.id}';
    }
  }

  String _buildPullText(EventModel event) {
    switch (event.payload.action) {
      case EventActionType.Closed:
        return '${event.actor.login} '
            'closed pull request #${event.payload.pullRequest.number}: '
            '${event.payload.pullRequest.title}';
      case EventActionType.Opened:
        return '${event.actor.login} '
            'opened pull request #${event.payload.pullRequest.number}: '
            '${event.payload.pullRequest.title}';
      default:
        return 'Unknown event with id ${_eventModel.id}';
    }
  }

  String _buildPushText(EventModel event) {
    return '${event.actor.login} pushed '
        '${event.payload.size} commits to ${event.repo.name}';
  }


}