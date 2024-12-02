# Install
```bash
flutter pub add atomlib
```

# Usage
```dart
import 'package:atomlib/atomlib.dart';
import 'package:flutter/material.dart';

// declare store type
class Account {
  final String id;
  final String email;
  final String name;

  Account(this.id, this.email, this.name);
}

// declare atom
final accountAtom = Atom<Account?>(null);
// an atom has the following methods
// - get from any where: accountAtom.value
// - set from any where: accountAtom.value = newValue
// - atom itself is a ChangeNotifier, so you can use it with ListenableBuilder(listenable: atom), atom.addListener(), atom.removeListener()
// - to get thee nearest instance of Account atom, use Atom.Of<Account?>(context)

// declare provider
class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({super.key, required this.child});

  @override
  build(BuildContext context) {
    // must attach type to AtomProvider
    return AtomProvider<Account?>(
      atom: accountAtom,
      child: child,
    );
  }
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    // wrap your app with AtomProvider
    home: AuthProvider(
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