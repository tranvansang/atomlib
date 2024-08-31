library atomlib;

import 'dart:async';

import 'package:flutter/widgets.dart';

class Atom<T> {
  Atom(T value) : _value = value;
  final _streamController = StreamController<T>.broadcast();
  T _value;

  T get value => _value;

  set value(T value) {
    _value = value;
    _streamController.add(value);
  }

  Stream<T> get stream => _streamController.stream;

  T of(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<AtomInheritedWidget<T>>();
    if (state == null) {
      throw Exception('Must be used within a AtomContainer');
    }
    return state.value;
  }
}

class AtomInheritedWidget<T> extends InheritedWidget {
  final T value;

  const AtomInheritedWidget({required this.value, super.key, required child}) : super(child: child);

  @override
  updateShouldNotify(oldWidget) => true;
}

class AtomProvider<T> extends StatefulWidget {
  final Atom<T> atom;

  const AtomProvider({super.key, required this.child, required this.atom});

  final Widget child;

  @override
  createState() => _State<T>();
}

class _State<T> extends State<AtomProvider<T>> {
  late StreamSubscription<T> _subscription;

  @override
  void initState() {
    _subscription = widget.atom.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  build(context) {
    return AtomInheritedWidget<T>(
      value: widget.atom.value,
      child: widget.child,
    );
  }
}
