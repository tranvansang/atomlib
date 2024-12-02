library atomlib;

import 'package:flutter/widgets.dart';

class Atom<T> extends ChangeNotifier {
  Atom(T value) : _value = value;
  T _value;
  T get value => _value;
  set value(T value) {
    _value = value;
    notifyListeners();
  }

  static T of<T>(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<AtomInheritedWidget<T>>();
    if (state == null) throw Exception('Must be used within an AtomContainer');
    return state.state.value;
  }
}

class AtomInheritedWidget<T> extends InheritedWidget {
  final _State<T> state;
  const AtomInheritedWidget({required this.state, super.key, required child}) : super(child: child);
  @override
  updateShouldNotify(oldWidget) => true;
}

class AtomProvider<T> extends StatefulWidget {
  const AtomProvider({super.key, required this.child, required this.atom});
  final Atom<T> atom;
  final Widget child;
  @override
  createState() => _State<T>();
}

class _State<T> extends State<AtomProvider<T>> {
  T get value {}
  @override
  build(context) {
    return ListenableBuilder(
        listenable: widget.atom, builder: (_, __) => AtomInheritedWidget<T>(state: this, child: widget.child));
  }
}
