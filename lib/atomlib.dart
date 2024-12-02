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
    return state.value(context);
  }
}

class AtomInheritedWidget<T> extends InheritedWidget {
  final T Function(BuildContext) value;
  const AtomInheritedWidget({required this.value, super.key, required super.child});
  @override
  updateShouldNotify(oldWidget) => true;
}

class AtomProvider<T> extends StatelessWidget {
  AtomProvider({super.key, required this.child, required this.atom});
  final Widget child;
  final Atom<T> atom;
  static readonly<T>({Key? key, required child, required create, dispose}) =>
      _Readonly<T>(key: key, child: child, create: create, dispose: dispose);
  @override
  build(_) {
    return ListenableBuilder(
        listenable: atom, builder: (_, __) => AtomInheritedWidget<T>(value: (_) => atom.value, child: child));
  }
}

class _Readonly<T> extends StatefulWidget {
  _Readonly({super.key, required this.child, required this.create, this.dispose});
  final Widget child;
  final void Function(T value)? dispose;
  final T Function(BuildContext context) create;
  @override
  createState() => _State<T>();
}

class _State<T> extends State<_Readonly<T>> {
  bool _initialized = false;
  late final T _value;

  @override
  dispose() {
    if (_initialized) widget.dispose?.call(_value);
    super.dispose();
  }

  @override
  build(context) {
    return AtomInheritedWidget<T>(
        value: (context) {
          if (!_initialized) {
            _value = widget.create.call(context);
            _initialized = true;
          }
          return _value;
        },
        child: widget.child);
  }
}
