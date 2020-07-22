import { NativeModules, NativeEventEmitter, DeviceEventEmitter, Platform } from 'react-native';

const locationManager = NativeModules.RNLocationManager;
const geocodeManager = NativeModules.RNGeocodeManager;
const mapNavigationManager = NativeModules.RNMapNavigationManager;
const geocodeManagerEmitter = new NativeEventEmitter(geocodeManager)

let lastId = "", promiseQueue = {}
const requestIdGenerator = (type = "geocode") => {
  let requestId = `${type}-${+new Date}-${Math.ceil(Math.random() * 100000)}`
  if (requestId == lastId) {
    return requestIdGenerator(type)
  }
  lastId = requestId;
  return lastId;
}

const searchRequestFactory = (type) => (...args) => {
  if (geocodeManager[type]) {
    let resolve, reject, promise = new Promise((res, rej) => {
      resolve = res, reject = rej
    }),
      requestId = requestIdGenerator(type)

    args = [requestId, ...args]

    geocodeManager[type].apply(null, args)
    promiseQueue[requestId] = { resolve, reject }
    return promise
  }
}

// const emitter = Platform.OS == 'ios' ? NativeAppEventEmitter : DeviceEventEmitter
geocodeManagerEmitter.addListener(
  'geocode',
  (reminder) => {
    let {data, error, requestId} = reminder
    if (requestId && promiseQueue[requestId]) {
      let promise = promiseQueue[requestId];
      if (error) {
        promise.reject(error)
      } else {
        promise.resolve(data)
      }
      delete promiseQueue[requestId];
    }
  }
)

const fetchLocation = (handler) => {
  if (Platform.OS === 'ios') {
    locationManager.location().then(handler, (error) => {
      handler(null, error);
    })
  }
  else if (Platform.OS === 'android') {
    locationManager.location();
    var locationListener = DeviceEventEmitter.addListener(
      'AMapLocationResultEvent',
      (data) => {
        var error = data.error || {}
        if(error.code === 12){
          // 和iOS统一`没有权限`的错误码返回
          data.error.code = 'authorized_deny'
        }
        if (typeof handler === 'function') {
          handler(data, data.error);
        }
        locationManager.stopLocation();
        locationListener.remove();
      }
    );
  }
}

const mapNavigation = (info)=>{
  mapNavigationManager.mapNavigation(info)
}

module.exports.fetchLocation = fetchLocation;
module.exports.searchRequestFactory = searchRequestFactory;
module.exports.mapNavigation = mapNavigation;