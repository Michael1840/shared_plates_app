import 'package:shared_plates_app/core/sync/remote_store.dart';

import 'fake_remote_store.dart';

JsonRow profileRow(String id, String name, {String? username}) => {
  'id': id,
  'username': username ?? name.toLowerCase().split(' ').first,
  'display_name': name,
  'bio': null,
  'city': null,
};

JsonRow friendCard(
  String id, {
  required String authorId,
  required String authorName,
  String title = 'Bobotie',
  String published = '2026-11-13T10:00:00Z',
  int saves = 0,
}) => {
  'id': id,
  'author_id': authorId,
  'author_name': authorName,
  'author_username': authorName.toLowerCase().split(' ').first,
  'title': title,
  'cover_style': 'stew',
  'base_servings': 4,
  'visibility': 'friends',
  'status': 'published',
  'like_count': 12,
  'save_count': saves,
  'updated_at': published,
  'published_at': published,
};

void seedFriends(FakeRemoteStore remote) {
  remote
    ..seed('profiles', [
      profileRow('lerato', 'Lerato Mokoena'),
      profileRow('sipho', 'Sipho Dlamini'),
      profileRow('megan', 'Megan Botha'),
      profileRow('aisha', 'Aisha Patel'),
    ])
    ..seed(
      'friendships',
      [
        {
          'requester_id': 'u1',
          'addressee_id': 'lerato',
          'status': 'accepted',
          'created_at': '2026-10-01T10:00:00Z',
          'accepted_at': '2026-10-02T10:00:00Z',
        },
        {
          'requester_id': 'aisha',
          'addressee_id': 'u1',
          'status': 'accepted',
          'created_at': '2026-10-05T10:00:00Z',
          'accepted_at': '2026-10-06T10:00:00Z',
        },
        {
          'requester_id': 'sipho',
          'addressee_id': 'u1',
          'status': 'pending',
          'created_at': '2026-11-13T09:00:00Z',
        },
        {
          'requester_id': 'u1',
          'addressee_id': 'megan',
          'status': 'pending',
          'created_at': '2026-11-12T09:00:00Z',
        },
      ],
      key: ['requester_id', 'addressee_id'],
    )
    ..seed('recipe_cards', [
      friendCard(
        'f1',
        authorId: 'lerato',
        authorName: 'Lerato Mokoena',
        title: 'Mom’s bobotie',
        saves: 300,
      ),
      friendCard(
        'f2',
        authorId: 'lerato',
        authorName: 'Lerato Mokoena',
        title: 'Malva pudding',
        published: '2026-11-10T10:00:00Z',
        saves: 31,
      ),
    ])
    ..seed('recipe_tags', [
      {'recipe_id': 'f2', 'tag_id': 13},
    ])
    ..rpcResults['friends_feed'] = [
      friendCard(
        'f1',
        authorId: 'lerato',
        authorName: 'Lerato Mokoena',
        title: 'Mom’s bobotie',
      ),
    ];
}
