package com.nothing.ketchum.glyph_developer_kit_flutter

import android.content.ComponentName
import android.content.Context
import android.util.Log
import com.nothing.ketchum.Common
import com.nothing.ketchum.GlyphException
import com.nothing.ketchum.GlyphManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** GlyphDeveloperKitFlutterPlugin */
class GlyphDeveloperKitFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var applicationContext: Context? = null
  private val TAG = "NothingGlyphs";
  private var glyphManager: GlyphManager? = null;
  private var glyphCallback: GlyphManager.Callback? = null;

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.applicationContext = flutterPluginBinding.applicationContext;
    channel = MethodChannel(flutterPluginBinding.binaryMessenger,
      "com.nothing.ketchum/glyphs")
    channel.setMethodCallHandler(this)
    initGlyphs()
    glyphManager = GlyphManager.getInstance(applicationContext)
    glyphManager?.init(glyphCallback)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method.equals("isNothingPhone1") -> {
        checkIs20111(result)
      }
      call.method.equals("isNothingPhone2") -> {
        checkIs22111(result)
      }
      call.method.equals("toggleGlyph") -> {
        toggleGlyph(call, result)
      }
      call.method.equals("animateGlyph") -> {
        animateGlyph(call, result)
      }
      call.method.equals("displayGlyphProgress") -> {
        displayGlyphProgress(call, result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    try {
      glyphManager?.closeSession()
    } catch (e: GlyphException) {
      e.message?.let { Log.e(TAG, it) }
    }
  }

  // Flutter Calls
  private fun checkIs20111(result: MethodChannel.Result) {
    result.success(Common.is20111())
  }

  private fun checkIs22111(result: MethodChannel.Result) {
    result.success(Common.is22111())
  }

  private fun toggleGlyph(call: MethodCall, result: MethodChannel.Result) {
    if (glyphManager != null) {
      val glyphData = FlutterGlyphData(call)
      if (glyphManager!!.glyphFrameBuilder == null) {
        result.error("GlyphPermissionsMissing",
          "The GlyphManager was not able to be registered.\n" +
                  "Check the `AndroidManifest.xml` and make sure that the steps in the link below" +
                  " are followed:\n" +
                  "https://github.com/ProgrammingPleb/Flutter-Glyph-Developer-Kit?tab=readme-ov-file#getting-started",
          null)
        return
      }
      glyphManager!!.toggle(glyphData.getGlyphFrame(glyphManager!!.glyphFrameBuilder))
      result.success(null)
      return
    }
    result.error("GlyphNotInit", "The GlyphManager has not been init().",
      null)
  }

  private fun animateGlyph(call: MethodCall, result: MethodChannel.Result) {
    if (glyphManager != null) {
      val glyphData = FlutterGlyphData(call)
      if (glyphManager!!.glyphFrameBuilder == null) {
        result.error("GlyphPermissionsMissing",
          "The GlyphManager was not able to be registered.\n" +
                  "Check the `AndroidManifest.xml` and make sure that the steps in the link below" +
                  " are followed:\n" +
                  "https://github.com/ProgrammingPleb/Flutter-Glyph-Developer-Kit?tab=readme-ov-file#getting-started",
          null)
        return
      }
      glyphManager!!.animate(glyphData.getGlyphFrame(glyphManager!!.glyphFrameBuilder))
      result.success(null)
      return
    }
    result.error("GlyphNotInit", "The GlyphManager has not been init().",
      null)
  }

  private fun displayGlyphProgress(call: MethodCall, result: MethodChannel.Result) {
    if (glyphManager != null) {
      val glyphData = FlutterGlyphData(call)
      if (glyphManager!!.glyphFrameBuilder == null) {
        result.error("GlyphPermissionsMissing",
          "The GlyphManager was not able to be registered.\n" +
                  "Check the `AndroidManifest.xml` and make sure that the steps in the link below" +
                  " are followed:\n" +
                  "https://github.com/ProgrammingPleb/Flutter-Glyph-Developer-Kit?tab=readme-ov-file#getting-started",
          null)
        return
      }
      glyphManager!!.displayProgress(
        glyphData.getGlyphFrame(glyphManager!!.glyphFrameBuilder),
        glyphData.progress?: 0,
        glyphData.reverse
      )
      result.success(null)
      return
    }
    result.error("GlyphNotInit", "The GlyphManager has not been init().",
      null)
  }

  // Platform-specific Functions
  private fun initGlyphs() {
    glyphCallback = object : GlyphManager.Callback {
      override fun onServiceConnected(componentName: ComponentName?) {
        Log.d(TAG, "Glyph Service Connected")
        if (Common.is20111()) glyphManager?.register(Common.DEVICE_20111)
        if (Common.is22111()) glyphManager?.register(Common.DEVICE_22111)
        try {
          glyphManager?.openSession()
        } catch (e: GlyphException) {
          e.message?.let { Log.e(TAG, it) }
        }
      }

      override fun onServiceDisconnected(componentName: ComponentName?) {
        glyphManager?.closeSession()
      }
    }
  }
}
