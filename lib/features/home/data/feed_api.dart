import '../../../core/network/api_client.dart';
import '../../../shared/models/post.dart';

/// GET /api/feed
class FeedApi {
  FeedApi(this._client);
  final ApiClient _client;

  Future<List<Post>> getFeed({String? type, int? limit, int? offset}) async {
    final q = <String, String>{
      if (type != null) 'type': type,
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
    };
    final qs = q.isEmpty ? '' : '?${q.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
    final data = await _client.getJson('/feed$qs');
    final list = data is List
        ? data
        : (data is Map && data['data'] is List)
            ? data['data'] as List
            : <dynamic>[];
    return list
        .whereType<Map>()
        .map((e) => Post.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// GET /api/matches
class MatchesApi {
  MatchesApi(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getMatches({String? status}) async {
    final qs = status != null ? '?status=$status' : '';
    final data = await _client.getJson('/matches$qs');
    final list = data is List
        ? data
        : (data is Map && data['data'] is List)
            ? data['data'] as List
            : <dynamic>[];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}

/// GET /api/polls  POST /api/polls/vote
class PollsApi {
  PollsApi(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getPolls() async {
    final data = await _client.getJson('/polls');
    final list = data is List ? data : <dynamic>[];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> vote({required String pollId, required int optionIndex}) async {
    await _client.postJson('/polls/vote', body: {
      'pollId': pollId,
      'optionIndex': optionIndex,
    });
  }
}

/// GET /api/predictions
class PredictionsApi {
  PredictionsApi(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getPredictions() async {
    final data = await _client.getJson('/predictions');
    final list = data is List ? data : <dynamic>[];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
