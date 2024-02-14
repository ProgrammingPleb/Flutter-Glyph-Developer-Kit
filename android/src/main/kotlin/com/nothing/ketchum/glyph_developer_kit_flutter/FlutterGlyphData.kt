package com.nothing.ketchum.glyph_developer_kit_flutter

import com.nothing.ketchum.GlyphFrame
import io.flutter.plugin.common.MethodCall

class FlutterGlyphData(call: MethodCall) {
    var period: Int? = null
    var cycles: Int? = null
    var interval: Int? = null
    var progress: Int? = null
    var reverse: Boolean = false
    var channels: List<Int> = emptyList()

    init {
        period = call.argument<Int?>("period")
        cycles = call.argument<Int?>("cycles")
        interval = call.argument<Int?>("interval")
        progress = call.argument<Int?>("progress")
        reverse = call.argument<Boolean?>("reverse") ?: false
        channels = call.argument<List<Int>>("channels")!!
    }

    fun getGlyphFrame(builder: GlyphFrame.Builder): GlyphFrame {
        val baseBuilder: GlyphFrame.Builder = builder

        for (channel in channels) {
            baseBuilder.buildChannel(channel)
        }
        if (period != null) {
            baseBuilder.buildPeriod(period!!)
        }
        if (cycles != null) {
            baseBuilder.buildCycles(cycles!!)
        }
        if (interval != null) {
            baseBuilder.buildInterval(interval!!)
        }

        return baseBuilder.build()
    }
}