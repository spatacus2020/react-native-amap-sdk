package io.terminus.rnamap;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.widget.Toast;

import com.amap.api.location.AMapLocation;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.StreetNumber;

import io.terminus.rnamap.model.LocationDO;

/**
 * io.terminus.rnamap
 * Created by Allen.Chiang on 22/01/2017.
 */

public class AMapUtils {

    public static LocationDO createLocationDO(AMapLocation aMapLocation) {
        LocationDO locationDO = new LocationDO();
        locationDO.setLatitude(String.valueOf(aMapLocation.getLatitude()));
        locationDO.setLongitude(String.valueOf(aMapLocation.getLongitude()));
        locationDO.setAdCode(aMapLocation.getAdCode());
        locationDO.setFormattedAddress(aMapLocation.getAddress());
        locationDO.setCountry(aMapLocation.getCountry());
        locationDO.setProvince(aMapLocation.getProvince());
        locationDO.setCity(aMapLocation.getCity());
        locationDO.setDistrict(aMapLocation.getDistrict());
        locationDO.setCityCode(aMapLocation.getCityCode());
        locationDO.setStreet(aMapLocation.getStreet());
        locationDO.setNumber(aMapLocation.getStreetNum());
        locationDO.setPOIName(aMapLocation.getPoiName());
        locationDO.setAOIName(aMapLocation.getAoiName());
        return locationDO;
    }

    /**
     * 和iOS统一返回格式
     *
     * @param address address
     * @return LocationDO
     */
    public static LocationDO convert2Location(RegeocodeAddress address) {
        LocationDO locationDO = new LocationDO();
        locationDO.setFormattedAddress(address.getFormatAddress());
        locationDO.setCountry(address.getTownship());
        locationDO.setProvince(address.getProvince());
        locationDO.setCityCode(address.getCityCode());
        locationDO.setCity(address.getCity());
        locationDO.setDistrict(address.getDistrict());
        locationDO.setAdCode(address.getAdCode());
        StreetNumber streetNumber = address.getStreetNumber();
        if (streetNumber != null) {
            LatLonPoint point = streetNumber.getLatLonPoint();
            if (point != null) {
                locationDO.setLatitude(String.valueOf(point.getLatitude()));
                locationDO.setLongitude(String.valueOf(point.getLongitude()));
            }
            locationDO.setStreet(streetNumber.getStreet());
            locationDO.setNumber(streetNumber.getNumber());
        }
        return locationDO;
    }


    /**
     * 和iOS统一返回格式
     *
     * @param address address
     * @return LocationDO
     */
    public static LocationDO convert2Location(GeocodeAddress address) {
        LocationDO locationDO = new LocationDO();
        locationDO.setFormattedAddress(address.getFormatAddress());
        locationDO.setCountry(address.getTownship());
        locationDO.setProvince(address.getProvince());
        locationDO.setCity(address.getCity());
        // android这里没有返回citycode，但是ios有返回，这里可能导致不一样
        locationDO.setAdCode(address.getAdcode());
        LatLonPoint point = address.getLatLonPoint();
        if (point != null) {
            locationDO.setLatitude(String.valueOf(point.getLatitude()));
            locationDO.setLongitude(String.valueOf(point.getLongitude()));
        }
        return locationDO;
    }

    public static Boolean isStringBlank(String str) {
        if (str == null || str.length() == 0 || str.trim().length() == 0) {
            return true;
        }
        return false;
    }

    public static void navigation(Context mContext,
                             String sname,
                             double slat,
                             double slon,
                             String dname,
                             double dlat,
                             double dlon){
        if(!isMapInstall(mContext)){
            Toast.makeText(mContext,"请下载安装高德地图",Toast.LENGTH_SHORT).show();
            return;
        }

        String dat = "androidamap://route?sourceApplication="+mContext.getPackageName()+"&slat="+slat+"&slon="+slon+"&sname="+sname+"&dlat="+dlat+"&dlon="+dlon+"&dname="+dname+"&dev=0&t=2";
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        intent.addCategory("android.intent.category.DEFAULT");
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setData(Uri.parse(dat));
        mContext.startActivity(intent);
    }

    public static boolean isMapInstall(Context mContext){
        try {
            ApplicationInfo info = mContext.getPackageManager().getApplicationInfo("com.autonavi.minimap", PackageManager.GET_UNINSTALLED_PACKAGES);
            if(info != null){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }
}
