## Wemotely

[![License](https://img.shields.io/badge/license-Apache%20License%202.0-lightgrey.svg?style=flat)](https://github.com/ChuckJHardy/Wemotely/blob/master/LICENSE)
[![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://github.com/ChuckJHardy/Wemotely)

### Installation

Run Setup Script

```
$ ./bin/setup
```

Update keys within `.env`

```
$ vim .env
export WEMOTELY_BUGSNAG_KEY="REAL_KEY"
```

[Carthage Package Manager](https://github.com/Carthage/Carthage)

```
$ brew install carthage swiftlint sourcery
$ carthage bootstrap --platform ios --no-use-binaries
```

### Useful Commands

Linter Autocorrect

```
swiftlint autocorrect
```

### Resources

* [App Icon Generator](http://appicon.co)

### Troubleshooting

#### Cleaning / Clearing

To clean the build folder, hold down the `Option` key while opening the `Product` menu, then choose `Clean Build Folder…`.

```
$ rm -rf Carthage
$ rm -rf ~/Library/Developer/Xcode/DerivedData
$ carthage update --platform ios; carthage build --platform ios
```

