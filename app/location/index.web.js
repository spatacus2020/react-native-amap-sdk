let src = null;

const setAmapKey = (key, plugin = 'AMap.Geocoder') => {
  src = `//webapi.amap.com/maps?v=1.3&key=${key}&plugin=${plugin}`;
}

const fetchLocation = (callback) => {
  const located = () => {
    let map, geolocation;
    //加载地图，调用浏览器定位服务
    map = new AMap.Map('map-container', { // 'map-container' 可以不存在，即不加载地图
      resizeEnable: true
    });
    map.plugin('AMap.Geolocation', function() {
      geolocation = new AMap.Geolocation({
        enableHighAccuracy: true,//是否使用高精度定位，默认:true
        timeout: 10000,          //超过10秒后停止定位，默认：无穷大
        buttonOffset: new AMap.Pixel(10, 20),//定位按钮与设置的停靠位置的偏移量，默认：Pixel(10, 20)
        zoomToAccuracy: true,      //定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
        buttonPosition:'RB'
      });
      map.addControl(geolocation);
      geolocation.getCurrentPosition();
      AMap.event.addListener(geolocation, 'complete', (data) => typeof callback === 'function' && callback(transData(data)));//返回定位信息
      AMap.event.addListener(geolocation, 'error', (error) => typeof callback === 'function' && callback(null, error));      //返回定位出错信息
    });
  }
  if (!window.AMap) {
    if (src) {
      inserScript(located);
    } else {
      console.error('please use setAmapKey to set key');
    }
  } else if (AMap && !AMap.Map) {
    console.error('please use plugin AMap.Geocoder');
  } else if (AMap && AMap.Map){
    located();
  }
}

const inserScript = (cb) => {
  const attr = {
    name: 'amap_terminus',
    src,
    type: 'text/javascript'
  };
  let parent = document.querySelector('body'); // 容器
  let script = parent && parent.querySelector(`[name=${attr.name}]`);
  if (script) {
    if (typeof cb === 'function') {
      cb();
    }
  } else {
    script = document.createElement('script');
    Object.getOwnPropertyNames(attr).map(name => {
      script.setAttribute(name, attr[name]);//暂时只支持一层object
    });
    parent.appendChild(script).addEventListener('load', () => {
      if (typeof cb === 'function') {
        cb();
      }
    }, false);
  }
}

const transData = (data) => {
  const { addressComponent, formattedAddress, pois, position, POIName, AOIName } = data;
  return {
    latitude: `${position.lat}`, // 转为string，统一格式
    longitude: `${position.lng}`,
    formattedAddress,
    pois,
    province: addressComponent.province,
    city: addressComponent.city,
    district: addressComponent.district,
    citycode: addressComponent.citycode,
    adcode: addressComponent.adcode,
    street: addressComponent.street,

    number: addressComponent.number || addressComponent.streetNumber,  // 没有number，存在streetNumber，与rn不一样
    country: addressComponent.country,  // 没有，与rn不一样
    POIName,  // 没有，与rn不一样
    AOIName,  // 没有，与rn不一样
  }
}

module.exports.setAmapKey = setAmapKey;
module.exports.fetchLocation = fetchLocation;
