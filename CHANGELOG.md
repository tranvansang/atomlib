## 0.0.5

- Added `AtomProvider.readonly`.

## 0.0.4

- New api `Atom.Of<T>(context)` to get the nearest instance of Atom atom.
- `Atom` is now a `ChangeNotifier`, so you can use it with `ListenableBuilder(listenable: atom)`, `atom.addListener()`, `atom.removeListener()`

## 0.0.1

* Initial release
