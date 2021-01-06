# Developer instructions

# Version numbering
Version numbers are `major.minor.incremental`.
- *Major* releases are drastic changes to the functionality and appearance of the app.
- *Minor* releases are incremental improvements to functionality and appearance which remains largely similar.
- *Incremental* releases are for bug fixes to existing behaviour.

# Creating a release
1. Set the version number in `pubspec.yaml`. In addition to the public release [version number](#version-numbering), the value is suffixed with `+<n>`, where `<n>` is a simple incrementing integer. This number is used by the Google play store to prevent downgrading. After updating, run `flutter pub get`.

2. Build the release
See [here](https://flutter.dev/docs/deployment/android) for more information.

Run `flutter build appbundle`. This will create `build/app/outputs/bundle/release/app-release.aab`.

3. Use this to publish the release on the Google play store.

4. Commit the current state to git: `git add -u && git commit -m "..."`

5. Create a tag for this commit: `git tag -af vX.Y.Z -m "..."`

6. Push the commit and the tag: `git push && git push --tags`