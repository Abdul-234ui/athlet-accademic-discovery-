import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

class ShortlistState {
  final Set<String> academyIds;
  final Set<String> coachIds;
  final bool isSyncing;

  ShortlistState({
    required this.academyIds,
    required this.coachIds,
    this.isSyncing = false,
  });

  ShortlistState copyWith({
    Set<String>? academyIds,
    Set<String>? coachIds,
    bool? isSyncing,
  }) {
    return ShortlistState(
      academyIds: academyIds ?? this.academyIds,
      coachIds: coachIds ?? this.coachIds,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class ShortlistNotifier extends StateNotifier<ShortlistState> {
  final SharedPreferences prefs;
  static const _academiesKey = 'shortlist_academies';
  static const _coachesKey = 'shortlist_coaches';

  ShortlistNotifier(this.prefs) : super(ShortlistState(academyIds: {}, coachIds: {})) {
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final academyList = prefs.getStringList(_academiesKey) ?? [];
    final coachList = prefs.getStringList(_coachesKey) ?? [];
    state = state.copyWith(
      academyIds: academyList.toSet(),
      coachIds: coachList.toSet(),
    );
  }

  void _saveToPrefs() {
    prefs.setStringList(_academiesKey, state.academyIds.toList());
    prefs.setStringList(_coachesKey, state.coachIds.toList());
  }

  void toggleAcademy(String id) {
    final updated = Set<String>.from(state.academyIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(academyIds: updated);
    _saveToPrefs();
  }

  void toggleCoach(String id) {
    final updated = Set<String>.from(state.coachIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(coachIds: updated);
    _saveToPrefs();
  }

  void clearSelection() {
    state = state.copyWith(academyIds: {}, coachIds: {});
    _saveToPrefs();
  }

  Future<void> syncWithCloud(String? email) async {
    if (email == null) return;
    
    // Set syncing state
    state = state.copyWith(isSyncing: true);

    // Simulate network delay for sync
    await Future.delayed(const Duration(seconds: 2));

    // Mock fetched data from cloud (simulate fetching from a database)
    final cloudAcademies = {'1', '2'}; 
    final cloudCoaches = {'c1'};

    // Merge cloud data with local data
    final mergedAcademies = Set<String>.from(state.academyIds)..addAll(cloudAcademies);
    final mergedCoaches = Set<String>.from(state.coachIds)..addAll(cloudCoaches);

    state = state.copyWith(
      academyIds: mergedAcademies,
      coachIds: mergedCoaches,
      isSyncing: false,
    );
    _saveToPrefs();
    
    print('Synced shortlists with cloud for $email');
  }
}

final shortlistProvider = StateNotifierProvider<ShortlistNotifier, ShortlistState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ShortlistNotifier(prefs);
});
