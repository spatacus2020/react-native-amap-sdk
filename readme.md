# RNAMapLocation 此分支为2D地图的分支，3D地图见  master3d 分支

高德api封装使用ReactNative结构，包含定位，地图，地图标注，地理编码，逆地理编码，poi兴趣点，导航等功能


amap 的文档参考https://github.com/qiuxiang/react-native-amap3d， 改了  mapview 组件的一些东西，修改后的内容参考demo

## Version

** v 2.0.4 **

### 安装

- 添加npm依赖

package.json的depencency中添加：

```
  "@spatacus/react-native-amap-sdk": "2.0.4"
```

    或者

    npm install @spatacus/react-native-amap-sdk@2.0.4 --save

    yarn add @spatacus/react-native-amap-sdk@2.0.4

- 项目导入

 1.iOS 建议使用cocoapods依赖方式， `Podfile`文件添加如下

```
  pod 'react-native-amap-sdk/LocationAmap', :path => '../node_modules/@spatacus/react-native-amap-sdk/ios'
  pod 'react-native-amap-sdk/Map3dAmap', :path => '../node_modules/@spatacus/react-native-amap-sdk/ios'
```
然后执行 `pod upodate `方法

  2.安卓集成 

  在settings.gradle 文件中加入如下
  ```
  // 只有poi 和 获取 定位坐标信息的， 没有地图组件
  include ':react-native-amap-sdk'
  project(':react-native-amap-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/@spatacus/react-native-amap-sdk/android/locationamap')

  // 只有地图相关控件（如mark,折线,多边围栏等）
  include ':react-native-3damap-sdk'
  project(':react-native-3damap-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/@spatacus/react-native-amap-sdk/android/map3damap')
  ```

  在application的app模块下的build.gradle 中添加如下
  ```
    compile project(":react-native-amap-sdk")
    compile project(":react-native-3damap-sdk")
  ```

  在MainApplication的代码中加入如下

  ```
  
    import cn.qiuxiang.react.amap3d.AMap3DPackage;
    import io.spatacus.rnamap.AMapReactPackage;

    ......

   @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
            ......
            new AMapReactPackage(),
              new AMap3DPackage()
            ......
      );
    }
  };

  ```

- 应用权限配置

在iOS应用info.plist中添加如下配置

```
  <key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
  <key>NSLocationWhenInUseUsageDescription</key>
	<string>需要使用您的定位信息</string>

```

- 高德AppKey配置

 iOS工程配置

AppDelegate类`-[AppDelegate application:didFinishLaunchingWithOptions:]`方法中添加如下行

```

  #import "RNAMConfig.h"

  ......
  -[AppDelegate application:didFinishLaunchingWithOptions:]
  ......

  [RNAMConfig setAppKey: @"请输入您的用户Key"];
  ......

```

 Android工程配置

`Manifest`文件中添加如下行

```
<meta-data android:name="com.amap.api.v2.apikey" android:value="请输入您的用户Key"/>
```

### 使用

#### 定位模块

1. 获取当前那位置

**  使用说明  **

```
import {fetchLocation} from '@spatacus/react-native-amap-sdk';

···
 fetchLocation((lp, error) => {
      if (error) {
        console.log('location', error.code, error.message)
        return
      }
      // 定位成功 根据定位信息做相关处理
     
    
    });

```

**  参数说明  **

lp ：相关当前定位信息，包含data和requestId,其中，data中即包含当前定位信息，如下所示：

| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
|latitude| gps坐标信息 |string   |
| longitude |gps坐标信息 | string   |
| formattedAddress |格式化地址|  string   |
| country |国家|  string   |
| province |省/直辖市|  string   |
| city |市|  string   |
| district |区|  string   |
| citycode |城市编码|  string   |
| adcode |区域编码|  string   |
| street |街道名称|  string   |
| number |门牌号|  string   |
| POIName |兴趣点名称|  string   |
| AOIName |所属兴趣点名称|  string   |
| pois |poi列表| object   |


#### 地图模块

** 使用说明 **


amap 的文档参考https://github.com/qiuxiang/react-native-amap3d， 改了  mapview 组件的一些东西，修改后的内容参考demo


#### 地图功能模块
1. 地理编码

** 使用说明 **

```
 import {AMapGeocode} from '@spatacus/react-native-amap-sdk';

...
// 根据地址和城市信息进行地理编码
AMapGeocode(address,city).then((data)=>{
      const geocode = data.list[0];
      // 获取到位置信息
      this.setState({
        geocodeResult : `${geocode.latitude},${geocode.longitude}`
      })
    })

```

** 参数说明 **

结果返回为

```
data:list（array类型）
```
其中：list数组中返回的就是相关地理编码信息，
list中的返回对象参数信息如下：


| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
|latitude| gps坐标信息 |string   |
| longitude |gps坐标信息 | string   |
| formattedAddress |格式化地址|  string   |
| country |国家|  string   |
| province |省/直辖市|  string   |
| city |市|  string   |
| district |区|  string   |
| citycode |城市编码|  string   |
| adcode |区域编码|  string   |
| street |街道名称|  string   |
| number |门牌号|  string   |
| POIName |兴趣点名称|  string   |
| AOIName |所属兴趣点名称|  string   |
| pois |poi列表| object   |



2. 逆地理编码

** 使用说明 **
根据经纬度进行逆地理编码

```
import {AMapReGeocode} from '@spatacus/react-native-amap-sdk';
...
  const latitude = '30.179339'  
  const longitude =  '120.14156'

    AMapReGeocode(latitude,longitude).then((data)=>{
    // 获取当前位置信息
    })

```

** 参数说明 **
返回的data即是当前位置信息，详细说明见定位模块中的定位信息列表。


3. poi数据

** 使用说明 ** 

```
import { AMapPOISearchPage,AMapPOISearch
 } from '@spatacus/react-native-amap-sdk';

 ...
 
 // poi搜索
 AMapPOISearch(keywords,city,).then((data) =>{
      if(data.pois){
       
        })
      }
    });

 // poi搜索 (设定搜索页)
 AMapPOISearchPage(keywords,city,pageNum,pageSize).then((data) =>{
      if(data.pois){
      
        })
      }
    });


```

** 参数说明 ** 

 - 传入参数
  
| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
|keywords| poi关键字 |string   |
| city |限定城市（cityName/cityCode/adcode） |string   |
| pageNum |限定页数|  string   |
| pageSize |每页记录数|  string   |

- 搜索结果

返回结果如下所示：

```
data:{
count:0,// poi总数量
pois:[],// poi数据列表
suggestions:[] // 关键字建议列表和城市建议列表
}
```
其中，pois数组中就是所需要的poi数据信息，poi数据中可能的参数信息如下：

| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
|uid | POI全局唯一ID | string|
|name| 名称 |string   |
|type|兴趣点类型 |string   |
|typecode| 类型编码 |string   |
|location| 经纬度 |string   |
|address|地址 |string   |
|tel|电话 |string   |
|distance|距离 |string   |
|parkingType| 停车场类型|string   |
|shopID| 商铺id |string   |
|postcode| 邮编 |string   |
|website| 网址 |string   |
|email| 电子邮件 |string   |
|province| 省 |string   |
|pcode| 省编码 |string   |
|city| 城市名称 |string   |
|citycode| 城市编码 |string   |
|district| 区域名称 |string   |
|adcode| 区域编码 |string   |
|gridcode| 地理格ID |string   |
|enterLocation| 入口经纬度 |string   |
|exitLocation| 出口经纬度 |string   |
|direction| 方向 |string   |
|hasIndoorMap| 是否有室内地图 |bool   |
|businessArea| 所在商圈 |string   |
|indoorData| 室内信息 |string   |
|subPOIs| 子POI列表 |array   |
|images| 图片列表 |array   |


#### 导航功能模块

** 使用说明 ** 

支持使用高德地图导航，iOS可选自带地图导航

```
import {mapNavigation} from '@spatacus/react-native-amap-sdk';

...

mapNavigation(
{sname:'我的位置',
slat:30.179415,
slon:120.138031,
dname:'云栖小镇',
dlat:30.132344,
dlon:120.083468}
)

```

** 参数说明 ** 

导航参数配置说明

| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
|sname| 初始位置描述 |string   |
| slat |出发地gps信息 |string   |
| slon |出发地gps信息|  string   |
| dname |目的地描述|  string   |
| dlat |目的地gps信息|  string   |
| dlon |目的地gps信息|  string   |


#### web使用
支持使用高德地图web获取当前位置

```
import { setAmapKey, fetchLocation } from '@spatacus/react-native-amap-sdk';

setAmapKey('xxxx', 'AMap.Geocoder') // 如果没有引入地图script，则必须先设置 地图的key

fetchLocation((lp, error) => {
  if (error) {
    console.log('location', error.code, error.message)
    return
  }
  // 定位成功 根据定位信息做相关处理
  
});

```

**  参数说明  **

lp ：相关当前定位信息，与react-native的相关参数并不完全一致, data中即包含当前定位信息，缺失的信息如下所示：

| 参数名 | 描述       | 类型  |
|:-------------: |:-------------: |:-----:|
| country |国家|  string   |
| POIName |兴趣点名称|  string   |
| AOIName |所属兴趣点名称|  string   |


### mapview模块


## 功能

- 地图模式切换（常规、卫星、导航、夜间）
- 3D 建筑、路况、室内地图
- 内置地图控件的显示隐藏（指南针、比例尺、定位按钮、缩放按钮）
- 手势交互控制（平移、缩放、旋转、倾斜）
- 中心坐标、缩放级别、倾斜度的设置，支持动画过渡
- 地图事件（onPress、onLongPress、onLocation、onStatusChange）
- 地图标记（Marker）
  - 自定义信息窗体
  - 自定义图标
- 折线绘制（Polyline）
- 多边形绘制（Polygon）
- 圆形绘制（Circle）
- 热力图（HeatMap）
- 海量点（MultiPoint）
- 离线地图

<img src="https://user-images.githubusercontent.com/1709072/40894475-907865ea-67dc-11e8-83f3-09ac73c95434.jpg" width="215"> <img src="https://user-images.githubusercontent.com/1709072/40894476-90ac38d4-67dc-11e8-9667-a4c36ef897bc.jpg" width="215"> <img src="https://user-images.githubusercontent.com/1709072/40894477-90dd258e-67dc-11e8-8809-e8f4e3198cee.jpg" width="215"> <img src="https://user-images.githubusercontent.com/1709072/40894478-91a87720-67dc-11e8-9135-c64680ad70eb.jpg" width="215">

## 用法

### 导入地图模块
```jsx
import { MapView } from  '@spatacus/react-native-amap-sdk';
```

### 基本用法
```jsx
<MapView
  coordinate={{
    latitude: 39.91095,
    longitude: 116.37296,
  }}
/>
```

### 启用定位并监听定位事件
```jsx
<MapView
  locationEnabled
  onLocation={({ nativeEvent }) =>
    console.log(`${nativeEvent.latitude}, ${nativeEvent.longitude}`)}
/>
```

### 添加可拖拽的地图标记
```jsx
<MapView>
  <MapView.Marker
    draggable
    title='这是一个可拖拽的标记'
    onDragEnd={({ nativeEvent }) =>
      console.log(`${nativeEvent.latitude}, ${nativeEvent.longitude}`)}
    coordinate={{
      latitude: 39.91095,
      longitude: 116.37296,
    }}
  />
</MapView>
```

### 自定义标记图片及信息窗体
```jsx
const coordinate = {
  latitude: 39.706901,
  longitude: 116.397972,
}

<MapView.Marker image='flag' coordinate={coordinate}>
  <View style={styles.customInfoWindow}>
    <Text>自定义信息窗体</Text>
  </View>
</MapView.Marker>
```


## 接口

请参考注释文档：
- [MapView](app/amap3d/maps/MapView.js)   位置: app/amap3d/maps/MapView.js
- [Marker](app/amap3d/maps/Marker.js)   位置: app/amap3d/maps/Marker.js
- [Polyline](app/amap3d/maps/Polyline.js)   位置: app/amap3d/maps/Polyline.js
- [Polygon](app/amap3d/maps/Polygon.js)   位置: app/amap3d/maps/Polygon.js
- [Circle](app/amap3d/maps/Circle.js)   位置: app/amap3d/maps/Circle.js
- [HeatMap](app/amap3d/maps/HeatMap.js)   位置: app/amap3d/maps/HeatMap.js
- [MultiPoint](app/amap3d/maps/MultiPoint.js)   位置: app/amap3d/maps/MultiPoint.js

### 更改react-native.config.js

    module.exports = {
    dependencies: {
      '@spatacus/react-native-amap-sdk': {
        platforms: {
          android: null
        },
      },
    }