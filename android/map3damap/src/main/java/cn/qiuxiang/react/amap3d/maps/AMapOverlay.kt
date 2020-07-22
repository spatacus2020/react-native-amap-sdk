package cn.qiuxiang.react.amap3d.maps

import com.amap.api.maps2d.AMap


interface AMapOverlay {
    fun add(map: AMap)
    fun remove()
}