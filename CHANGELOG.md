## 0.0.7

- Add `AtomProvider.listenable` to create a listenable atom.
- Support `{bool listen}` in `Atom.Of<T>(context, {bool listen})` to get without watching for changes.

## 0.0.6

- Update Readme

## 0.0.5

- Added `AtomProvider.readonly`.

## 0.0.4

- New api `Atom.Of<T>(context)` to get the nearest instance of Atom atom.
- `Atom` is now a `ChangeNotifier`, so you can use it with `ListenableBuilder(listenable: atom)`, `atom.addListener()`, `atom.removeListener()`

## 0.0.1

* Initial release
