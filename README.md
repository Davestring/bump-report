# Bump Report

`Bump Report` is a simple app developed in Flutter with the purpose of report and notify other users where they can find potholes near them.

## Contents

- [Dependencies](#dependencies)
- [Content](#content)
- [Appendices](#appendices)

---

## Dependencies

![Dart 2.10.1](https://img.shields.io/badge/Dart-2.10.1-black.svg)
![Flutter 1.22.1](https://img.shields.io/badge/Flutter-1.22.1-blue.svg)
![GoogleMaps 1.0.2](https://img.shields.io/badge/GoogleMaps-1.0.2-green.svg)
![Firebase 0.5.0](https://img.shields.io/badge/Firebase-0.5.0-yellow.svg)

## Content

### SetUp

Once you have created a key for the Google services, replace it in the following files: 


> ios/Runner/AppDelegate.swift
```swift
GMSServices.provideAPIKey("MAPS_API_KEY")
```

> android/app/src/main/AndroidManifest.xml
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="MAPS_API_KEY" />
```

Finally, run the following command to get all the project dependencies:

```bash
flutter pub get
```

## Appendices

### Appendix A - VSCode

To have all the development environment automated create a _settings.json_ file inside a _.vscode_ folder in the _root_ of the project with the following configuration:

> settings.json - Enables our lint configuration in VS Code.

```json
{
	"debug.openDebug": "openOnDebugBreak",
	"[dart]": {
		"editor.formatOnSave": true,
		"editor.formatOnType": true,
		"editor.rulers": [80],
		"editor.selectionHighlight": false,
		"editor.suggest.snippetsPreventQuickSuggestions": false,
		"editor.suggestSelection": "first",
		"editor.tabCompletion": "onlySnippets",
		"editor.wordBasedSuggestions": false,
		"files.insertFinalNewline": true,
	}
}
