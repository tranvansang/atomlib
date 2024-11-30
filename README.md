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
// - get and listen from a descendant of AtomProvider: accountAtom.of(context)
// - watch for changes from any where: accountAtom.stream.listen((newValue) => print(newValue))

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
          final account = accountAtom.of(context);
          if (account == null) {
            return Text('Not logged in');
          }
          return Text('Logged in as ${account.name}');
        },
      ),
    ),
  ));
}
```