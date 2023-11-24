import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/models/session.dart';
import '/services/injection.dart';

part 'session_state.g.dart';
part 'session_state.freezed.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    required List<Session> sessionList,
    required Session? activeSession,
  }) = _SessionState;
}

@riverpod
class SessionStateNotifier extends _$SessionStateNotifier {
  // 从网络获取数据
  Future<List<Session>> _fetchData() async {
    return await db.sessionDao.findAllSessions();
  }

  // 生成 state 里面的数据
  @override
  Future<SessionState> build() async {
    final sessionList = await _fetchData();
    return SessionState(
      sessionList: sessionList,
      activeSession: null,
    );
  }

  Future<void> deleteSession(Session session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.sessionDao.deleteSession(session);
      return SessionState(
        sessionList: await _fetchData(),
        activeSession: state.valueOrNull?.activeSession
      );
    });
  }

  Future<void> setActiveSession(Session? session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return SessionState(
        sessionList: state.valueOrNull?.sessionList ?? [],
        activeSession: session
      );
    });
  }

  Future<Session> upsertSession(Session session) async {
    var active = session;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final id = await db.sessionDao.upsertSession(session);
      active = active.copyWith(id: id);
      return SessionState(
        sessionList: await _fetchData(),
        activeSession: active,
      );
    });

    return active;
  }
}

@riverpod
Session? activeSession(ActiveSessionRef ref) {
  final state = ref.watch(sessionStateNotifierProvider).valueOrNull;
  return state?.activeSession;
}