## Wemotely

[![Build Status](https://www.bitrise.io/app/d6336a05ac3d18e8/status.svg?token=NbiHC7raPaifR6JzVza_fA&branch=splitview)](https://www.bitrise.io/app/d6336a05ac3d18e8)

### Installation

[Carthage Package Manager](https://github.com/Carthage/Carthage)

```
$ brew install carthage swiftlint
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

