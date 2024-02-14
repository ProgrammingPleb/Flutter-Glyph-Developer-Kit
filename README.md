# Glyph Developer Kit for Flutter

An attempt to porting Nothing's Glyph Developer Kit to Flutter as a plugin.

## Getting Started

Add these lines to your application's `AndroidManifest.xml`:  

1. The Glyph permission (this should be situated in the `<manifest>` tag):
```
<uses-permission android:name="com.nothing.ketchum.permission.ENABLE"/>
```

2. The Glyph API key (this should be situated in the `<application>` tag):
```
<meta-data android:name="NothingKey" android:value="{Your API Key}" />
```
> As of the time of writing, Nothing has not opened API key registrations yet. The website for the API key registrations would most likely [be here](https://nothing.tech/pages/glyph-developer-kit).  
In the meantime, the line below can be used, but comes with [some few caveats](https://github.com/Nothing-Developer-Programme/Glyph-Developer-Kit?tab=readme-ov-file#setup-instructions):

```
<meta-data android:name="NothingKey" android:value="test"/>
```

Afterwards, you will need to enable Glyph Debugging using the ADB command below:

```
adb shell settings put global nt_glyph_interface_debug_enable 1
```

> Glyph Debugging will be disabled by itself after 48 hours.  
After using this command, you will get a notification stating that Glyph Debugging has been enabled.

## Notes

- The example app is still barebones, I want to push this out first so people would be able to try out the Glyph Developer Kit on Flutter as soon as possible.
- Making the documentation for the plugin is planned, but will need to polish out some of the code in here.

## Credits

- Nothing Developer Programme's [Glyph Developer Kit](https://github.com/Nothing-Developer-Programme/Glyph-Developer-Kit)



