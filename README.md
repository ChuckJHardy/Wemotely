## Wemotely

[![Build Status](https://www.bitrise.io/app/d6336a05ac3d18e8/status.svg?token=NbiHC7raPaifR6JzVza_fA&branch=master)](https://www.bitrise.io/app/d6336a05ac3d18e8)

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
$ carthage bootstrap
```

### Useful Commands

Linter Autocorrect

```
swiftlint autocorrect
```

### Troubleshooting

#### Cleaning / Clearing

To clean the build folder, hold down the `Option` key while opening the `Product` menu, then choose `Clean Build Folder…`.

```
$ rm -rf Carthage
$ rm -rf ~/Library/Developer/Xcode/DerivedData
$ carthage update
```

