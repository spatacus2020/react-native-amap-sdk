// @flow
import React from 'react'
import PropTypes from 'prop-types'
import { processColor, requireNativeComponent, ViewPropTypes, Platform } from 'react-native'
import { LatLng, Region } from '../PropTypes'
import Component from '../Component'

export type MapStatus = {
  zoomLevel?: number,
  coordinate?: LatLng,
  titl?: number,
  rotation?: number,
}

export const LocationStyle = PropTypes.shape({
  image: PropTypes.string,
  fillColor: PropTypes.string,
  strokeColor: PropTypes.string,
  strokeWidth: PropTypes.number,
})

const isIos = Platform.OS === 'ios'

export default class MapView extends Component<any> {
  static propTypes = {
    ...ViewPropTypes,

    /**
     * 地图类型
     *
     * - standard: 标准地图
     * - satellite: 卫星地图
     * - navigation: 导航地图
     * - night: 夜间地图
     * - bus: 公交地图
     */
    mapType: PropTypes.oneOf(['standard', 'satellite', 'navigation', 'night', 'bus']),
  /**
   * 是否启用跟踪模式
   * 0: 不跟踪
   * 1: 跟踪用户定位
   * 2: 跟踪用户定位和方向
   */
  userTrackingMode: PropTypes.oneOf(0, 1, 2),
  /**
   * 是否跟踪用户位置
   */
  showsUserLocation: PropTypes.bool,
  /**
   * 缩放尺寸，范围是:[3-19]
   */
  zoomLevel: PropTypes.number,

    /**
     * 设置定位图标的样式
     */
    locationStyle: LocationStyle,

    /**
     * 设置定位模式 默认 LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER
     *
     * @platform android
     */
    locationType: PropTypes.oneOf(['show', 'locate', 'follow', 'map_rotate', 'location_rotate',
      'location_rotate_no_center', 'follow_no_center', 'map_rotate_no_center']),

    /**
     * 是否启用定位
     */
    locationEnabled: PropTypes.bool,

    /**
     * 定位间隔(ms)，默认 2000
     *
     * @platform android
     */
    locationInterval: PropTypes.number,

    /**
     * 定位的最小更新距离
     *
     * @platform ios
     */
    distanceFilter: PropTypes.number,

    /**
     * 是否显示室内地图
     */
    showsIndoorMap: PropTypes.bool,

    /**
     * 是否显示室内地图楼层切换控件
     *
     * TODO: 似乎并不能正常显示
     */
    showsIndoorSwitch: PropTypes.bool,

    /**
     * 是否显示3D建筑
     */
    showsBuildings: PropTypes.bool,

    /**
     * 是否显示文本标签
     */
    showsLabels: PropTypes.bool,

    /**
     * 是否显示指南针
     */
    showsCompass: PropTypes.bool,

    /**
     * 是否显示放大缩小按钮
     *
     * @platform android
     */
    showsZoomControls: PropTypes.bool,

    /**
     * 是否显示比例尺
     */
    showsScale: PropTypes.bool,

    /**
     * 是否显示定位按钮
     *
     * @platform android
     */
    showsLocationButton: PropTypes.bool,

    /**
     * 是否显示路况
     */
    showsTraffic: PropTypes.bool,

    /**
     * 最大缩放级别
     */
    maxZoomLevel: PropTypes.number,

    /**
     * 最小缩放级别
     */
    minZoomLevel: PropTypes.number,

    /**
     * 当前缩放级别，取值范围 [3, 20]
     */
    zoomLevel: PropTypes.number,

    /**
     * 中心坐标
     */
    coordinate: LatLng,

    /**
     * 显示区域
     */
    region: Region,

    /**
     * 限制地图只能显示某个矩形区域
     */
    limitRegion: Region,

    /**
     * 倾斜角度，取值范围 [0, 60]
     */
    tilt: PropTypes.number,

    /**
     * 旋转角度
     */
    rotation: PropTypes.number,

    /**
     * 是否启用缩放手势，用于放大缩小
     */
    zoomEnabled: PropTypes.bool,

    /**
     * 是否启用滑动手势，用于平移
     */
    scrollEnabled: PropTypes.bool,

    /**
     * 是否启用旋转手势，用于调整方向
     */
    rotateEnabled: PropTypes.bool,

    /**
     * 是否启用倾斜手势，用于改变视角
     */
    tiltEnabled: PropTypes.bool,


    /**
     * 是否可以触摸
     */
    touchEnable: PropTypes.bool,

    /**
     * 是否启用定位
     */
    showsUserLocation: PropTypes.bool,

    /**
     * 中心坐标
     */
    centerLocation: LatLng,

    /**
     * 点击事件
     *
     * @param {{ nativeEvent: LatLng }}
     */
    onMapPress: PropTypes.func,

    /**
     * 长按事件
     *
     * @param {{ nativeEvent: LatLng }}
     */
    onLongPress: PropTypes.func,

    /**
     * 定位事件
     *
     * @param {{
     *   nativeEvent: {
     *     timestamp: number,
     *     speed: number,
     *     accuracy: number,
     *     altitude: number,
     *     longitude: number,
     *     latitude: number,
     *   }
     * }}
     */
    onLocation: PropTypes.func,

    /**
     * 动画完成事件
     */
    onAnimateFinish: PropTypes.func,

    /**
     * 动画取消事件
     */
    onAnimateCancel: PropTypes.func,

    /**
     * 地图状态变化事件
     *
     * @param {{
     *   nativeEvent: {
     *     longitude: number,
     *     latitude: number,
     *     rotation: number,
     *     zoomLevel: number,
     *     tilt: number,
     *   }
     * }}
     */
    onStatusChange: PropTypes.func,

    /**
     * 地图状态变化完成事件
     *
     * @param {{
     *   nativeEvent: {
     *     longitude: number,
     *     latitude: number,
     *     longitudeDelta: number,
     *     latitudeDelta: number,
     *     rotation: number,
     *     zoomLevel: number,
     *     tilt: number,
     *   }
     * }}
     */
    onStatusChangeComplete: PropTypes.func,
  }

  name = 'AMapView'

  isMapFirstLoaded = false
  _isMoveByUser = true
  lastCompleteTime = 0

  _onMoveComplete = (event) => {
    const oldLastCompleteTime = this.lastCompleteTime
    this.lastCompleteTime = new Date().getTime()

    if ((this.lastCompleteTime - oldLastCompleteTime) < 700) {
      this._isMoveByUser = true
      return
    }
    if (isIos && !this.isMapFirstLoaded) {
      this.isMapFirstLoaded = true
      this._isMoveByUser = true
      return
    }

    this.props.onStatusChangeComplete && this.props.onStatusChangeComplete(event, this._isMoveByUser)
    this._isMoveByUser = true
  }


  componentWillReceiveProps({ coordinate }) {
    const oldCoordinate = this.props.coordinate
    if (coordinate && oldCoordinate) {
      const { latitude, longitude } = coordinate
      const oldLatitude = oldCoordinate.latitude
      const oldLongitude = oldCoordinate.longitude
      if ((latitude != oldLatitude) && (longitude != oldLongitude)) {
        this._isMoveByUser = false
      }
    } else if (coordinate) {
      this._isMoveByUser = false
    }
  }

  _onMovingChange = (event) => {
    if (isIos && !this.isMapFirstLoaded) {
      return
    }
    this.props.onStatusChange && this.props.onStatusChange(event, this._isMoveByUser)
  }

  /**
   * 动画过渡到某个状态（坐标、缩放级别、倾斜度、旋转角度）
   */
  animateTo(target: MapStatus, duration?: number = 500) {
    this.sendCommand('animateTo', [target, duration])
  }

  onMapPress = (event) => {
    if (this.props.onMapPress) {
      this.props.onMapPress(event)
    }
  }

  render() {
    const props = { ...this.props }
    const { centerLocation } = this.props
    if (centerLocation) {
      delete props.centerLocation
      props.coordinate = centerLocation
    }

    if (props.locationStyle) {
      if (props.locationStyle.strokeColor) {
        props.locationStyle.strokeColor = processColor(props.locationStyle.strokeColor)
      }
      if (props.locationStyle.fillColor) {
        props.locationStyle.fillColor = processColor(props.locationStyle.fillColor)
      }
    }
    return <AMapView {...props} onMapPress={this.onMapPress} onStatusChange={this._onMovingChange} onStatusChangeComplete={this._onMoveComplete} />
  }
}

const AMapView = requireNativeComponent('AMapView', MapView)
