import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:petsmore_tele_app/services/get_sharedpreferences.dart';

// final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
// final bottomTabNameProvider = StateProvider<String>((ref) => '');
final initialTabIndexProvider = StateProvider<int>((ref) => 0);

final bottomNavNotifierProvider =
    StateNotifierProvider<BottomNavNotifier, BottomNavState>(
  (ref) => BottomNavNotifier(),
);

class BottomNavState {
  final int index;
  final String tabName;

  BottomNavState({required this.index, required this.tabName});
}

class BottomNavNotifier extends StateNotifier<BottomNavState> {
  BottomNavNotifier() : super(BottomNavState(index: 0, tabName: 'Home'));

  void setIndex(int newIndex) {
    if (state.index != newIndex) {
      state = BottomNavState(index: newIndex, tabName: state.tabName);
    }
  }

  void setBottomTabName(String name) {
    if (state.tabName != name) {
      state = BottomNavState(index: state.index, tabName: name);
    }
  }
}


// class BottomNavNotifier extends StateNotifier<int> {
//   BottomNavNotifier() : super(0);
//   String _bottomTabName = '';

//   void setIndex(int newIndex) {
//     state = newIndex;
//   }

//   void setBottomTabName(String name) {
//     _bottomTabName = name;
//   }

//   String getBottomTabName() {
//     return _bottomTabName;
//   }
// }


