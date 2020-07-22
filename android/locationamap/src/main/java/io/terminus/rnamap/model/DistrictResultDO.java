package io.terminus.rnamap.model;

/**
 * Created by wenboli on 17/7/12.
 */

import com.amap.api.services.district.DistrictItem;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.util.ArrayList;
import java.util.List;

public class DistrictResultDO implements WritableObject {

    private String latitude;
    private String longitude;
    private String adcode;

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }
    public String getLatitude() {
        return latitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }
    public String getLongitude() {
        return longitude;
    }

    public void setAdcode(String adcode) {
        this.adcode = adcode;
    }
    public String getAdcode() {
        return adcode;
    }

    public DistrictResultDO(DistrictItem districtItem) {

        latitude = String.valueOf(districtItem.getCenter().getLatitude());
        longitude = String.valueOf(districtItem.getCenter().getLongitude()) ;
        adcode = districtItem.getAdcode();
    }

    public WritableMap writableMap() {
        WritableMap writableMap = Arguments.createMap();
        writableMap.putString("adCode", adcode);
        writableMap.putString("latitude", latitude);
        writableMap.putString("longitude", longitude);
        return writableMap;
    }

}
