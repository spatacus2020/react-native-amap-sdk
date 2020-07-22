package io.terminus.rnamap.model;

import com.amap.api.services.core.PoiItem;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

/**
 * io.terminus.rnamap.model
 * Created by Allen.Chiang on 23/01/2017.
 */

public class POIDO implements WritableObject {
    private String uid;
    private String name;
    private String type;
    private String address;
    private String adcode;
    private String latitude;
    private String longitude;

    public void setPoiItem(PoiItem poiItem) {
        this.uid = poiItem.getPoiId();
        this.name = poiItem.getTitle();
        this.type = poiItem.getTypeDes();
        this.adcode = poiItem.getAdCode();
        this.address = poiItem.getSnippet();
        if (poiItem.getLatLonPoint() != null) {
            latitude = String.valueOf(poiItem.getLatLonPoint().getLatitude());
            longitude = String.valueOf(poiItem.getLatLonPoint().getLongitude());
        }
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getAdcode() {
        return adcode;
    }

    public void setAdcode(String adcode) {
        this.adcode = adcode;
    }

    @Override
    public WritableMap writableMap() {
        WritableMap writableMap = Arguments.createMap();
        writableMap.putString("uid", uid);
        writableMap.putString("name", name);
        writableMap.putString("type", type);
        writableMap.putString("address", address);
        writableMap.putString("adcode", adcode);
        writableMap.putString("latitude", latitude);
        writableMap.putString("longitude", longitude);
        return writableMap;
    }
}
