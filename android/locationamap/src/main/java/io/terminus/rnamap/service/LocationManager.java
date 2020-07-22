package io.terminus.rnamap.service;

import android.support.v7.appcompat.BuildConfig;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import javax.annotation.Nullable;

import io.terminus.rnamap.AMapUtils;
import io.terminus.rnamap.model.ErrorDO;
import io.terminus.rnamap.model.LocationDO;
import io.terminus.rnamap.model.ReactResultDO;

/**
 * io.terminus.rnamap
 * Created by Allen.Chiang on 19/01/2017.
 */
public class LocationManager extends ReactContextBaseJavaModule implements AMapLocationListener {

    private static final String REACT_EVENT_NAME = "AMapLocationResultEvent";

    public LocationManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private AMapLocationClient aMapLocationClient = null;

    @Override
    public String getName() {
        return "RNLocationManager";
    }

    /**
     * 开始定位
     *
     * @param locationListener 可以外部传入定位结果的接收者，
     *                         用于poisearch自动获取一次定位的citycode
     */
    public void location(AMapLocationListener locationListener) {
//        if(ContextCompat.checkSelfPermission(getReactApplicationContext(), Manifest.permission.ACCESS_COARSE_LOCATION)
//                != PackageManager.PERMISSION_GRANTED){
//            ReactResultDO resultDO = new ReactResultDO();
//            resultDO.setError(new ErrorDO("", 2));
//            sendEvent(this.getReactApplicationContext(), REACT_EVENT_NAME, resultDO.writableMap());
//            return;
//        }

        AMapLocationClient locationClient = initAMapLocationClient();
        aMapLocationClient = locationClient;
        //设置定位回调监听
        locationClient.setLocationListener(locationListener == null ? this : locationListener);
        locationClient.startLocation();
    }

    /**
     * 开始定位
     */
    @ReactMethod
    public void location() {
        location(null);
    }

    @ReactMethod
    public void stopLocation() {
        if (aMapLocationClient != null) {
            aMapLocationClient.stopLocation();
        }
    }

    private AMapLocationClient initAMapLocationClient() {
        //声明AMapLocationClient类对象
        AMapLocationClient mLocationClient = new AMapLocationClient(getReactApplicationContext());
        //声明AMapLocationClientOption对象
        AMapLocationClientOption mLocationOption = new AMapLocationClientOption();
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        mLocationOption.setOnceLocation(true);              // 仅单次定位
        mLocationOption.setOnceLocationLatest(true);        // 获取最近3s内精度最高的一次定位结果
        mLocationOption.setNeedAddress(true);               // 设置是否返回地址信息（默认返回地址信息）
        mLocationOption.setMockEnable(BuildConfig.DEBUG);           // Debug模式允许mock gps
        mLocationClient.setLocationOption(mLocationOption);
        return mLocationClient;
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (aMapLocation == null) {
            Log.e("AMapLocation error", "return null");
            ReactResultDO resultDO = new ReactResultDO();
            resultDO.setError(new ErrorDO("AMap return nothing", 0));
            sendEvent(this.getReactApplicationContext(), REACT_EVENT_NAME, resultDO.writableMap());
        } else if (aMapLocation.getErrorCode() != 0) {
            Log.e("AMapLocation error", "Code:" + aMapLocation.getErrorCode() + ", Message:" + aMapLocation.getErrorInfo());
            ReactResultDO resultDO = new ReactResultDO();
            // 去掉sdk返回的一堆错误说明，只去空格前面一段字符串
            String errorInfo = (aMapLocation.getErrorInfo()==null)?"":aMapLocation.getErrorInfo().split(" ")[0];
            resultDO.setError(new ErrorDO(errorInfo, aMapLocation.getErrorCode()));
            sendEvent(this.getReactApplicationContext(), REACT_EVENT_NAME, resultDO.writableMap());
        } else {
            LocationDO locationDO = AMapUtils.createLocationDO(aMapLocation);
            ReactResultDO resultDO = new ReactResultDO(null, locationDO);
            sendEvent(resultDO);
        }
    }

    private void sendEvent(@Nullable ReactResultDO resultDO) {
        sendEvent(this.getReactApplicationContext(), REACT_EVENT_NAME,
                resultDO == null ? null : resultDO.writableMap());
    }

    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        if (reactContext != null) {
            reactContext
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        }
    }
}
