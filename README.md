# Install
```bash
flutter pub add atomlib
```

# Usage 1: Read/Write atom

```dart
import 'package:atomlib/atomlib.dart';
import 'package:flutter/material.dart';

// declare atom value class
class Account {
  final String id;
  final String email;
  final String name;
  Account(this.id, this.email, this.name);
}

// declare atom instance
final accountAtom = Atom<Account?>(null);
// an atom has the following methods
// - get from any where: accountAtom.value
// - set from any where: accountAtom.value = newValue
// - atom itself is a ChangeNotifier, so you can use it with ListenableBuilder(listenable: atom), atom.addListener(), atom.removeListener()
// - to get thee nearest instance of Account atom, use Atom.Of<Account?>(context, {bool listen})

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    // wrap your app with AtomProvider
    home: AtomProvider<Account?>(
      atom: accountAtom,
      child: Builder(
        builder: (context) {
          final account = Atom.of<Account?>(context);
          if (account == null) return Text('Not logged in');
          return Text('Logged in as ${account.name}');
        },
      ),
    ),
  ));
}
```

# Usage 2: Readonly atom

```dart
import 'package:atomlib/atomlib.dart';
import 'package:flutter/material.dart';

class MyController {
  void increment() {
    print('increment');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    // provide value. You can init once, and dispose, but you can't change the value
    home: AtomProvider.readonly<MyController>(
      create: (context) => MyController(), // this function is lazily called, and only called once.
      // dispose: (controller) => controller.dispose(), // this is optional
      child: Builder(
        builder: (context) {
          final myController = Atom.of<MyController>(context); // this `context` value will be passed to `create` function
          return ElevatedButton(
            onPressed: () {
              myController.increment();
            },
            child: Text('Increment'),
          );
        },
      ),
    ),
  ));
}
```

# Usage 3: Listenable atom

```dart
import 'package:atomlib/atomlib.dart';
import 'package:flutter/material.dart';

class MyController extends ChangeNotifier {
  void increment() {
    print('increment');
    notifyListeners(); // notify all listeners, i.e., all widgets that call Atom.of<MyController>(context)
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: AtomProvider.readonly<MyController>(
      create: (context) => MyController(),
      child: Builder(
        builder: (context) {
          final myController = Atom.of<MyController>(context); // will listen to MyController.notifyListeners(). Note: only applicable to subclasses of ChangeNotifier, or precisely, subclass of Listenable
          return ElevatedButton(
            onPressed: () {
              myController.increment();
            },
            child: Text('Increment'),
          );
        },
      ),
    ),
  ));
}
```
