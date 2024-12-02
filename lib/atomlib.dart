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
    return state.state.value(context);
  }
}

class AtomInheritedWidget<T> extends InheritedWidget {
  final _State<T> state;
  const AtomInheritedWidget({required this.state, super.key, required child}) : super(child: child);
  @override
  updateShouldNotify(oldWidget) => true;
}

class AtomProvider<T> extends StatefulWidget {
  final Widget child;
  final bool _readonly;
  @override
  createState() => _State<T>();
  AtomProvider({super.key, required this.child, required this.atom})
      : create = null,
        _readonly = false,
        dispose = null;
  final Atom<T>? atom;
  AtomProvider.readonly({super.key, required this.child, required this.create, this.dispose})
      : atom = null,
        _readonly = true;
  final void Function(T value)? dispose;
  final T Function(BuildContext context)? create;
}

class _State<T> extends State<AtomProvider<T>> {
  bool _initialized = false;
  late final T _value;
  T value(BuildContext context) {
    if (!widget._readonly) return widget.atom!.value;
    if (!_initialized) {
      _value = widget.create!.call(context);
      _initialized = true;
    }
    return _value;
  }

  @override
  dispose() {
    if (_initialized) widget.dispose?.call(_value);
    super.dispose();
  }

  @override
  build(context) {
    return widget._readonly
        ? AtomInheritedWidget<T>(state: this, child: widget.child)
        : ListenableBuilder(
            listenable: widget.atom!, builder: (_, __) => AtomInheritedWidget<T>(state: this, child: widget.child));
  }
}
