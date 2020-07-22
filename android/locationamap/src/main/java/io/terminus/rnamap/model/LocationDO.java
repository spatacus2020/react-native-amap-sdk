package io.terminus.rnamap.model;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.util.List;

/**
 * io.terminus.rnamap.model
 * Created by Allen.Chiang on 19/01/2017.
 */

public class LocationDO implements WritableObject {

    // gps坐标信息，纬度
    private String latitude;
    // gps坐标信息，经度
    private String longitude;
    // 格式化地址
    private String formattedAddress;
    // 国家
    private String country;
    // 省
    private String province;
    // 市
    private String city;
    // 区
    private String district;
    // 城市编码
    private String cityCode;
    // 区域编码
    private String adCode;
    // 街道名称
    private String street;
    // 门牌号
    private String number;
    // 兴趣点名称
    private String POIName;
    // 所属兴趣点名称
    private String AOIName;
    // 周边兴趣点
    private List<POIDO> poidoList;
    // 周边兴趣点所属
    private List<String> aoidoList;

    public WritableMap writableMap() {
        WritableMap map = Arguments.createMap();
        map.putString("latitude", latitude);
        map.putString("longitude", longitude);
        map.putString("formattedAddress", formattedAddress);
        map.putString("country", country);
        map.putString("province", province);
        map.putString("city", city);
        map.putString("district", district);
        map.putString("cityCode", cityCode);
        map.putString("adCode", adCode);
        map.putString("street", street);
        map.putString("number", number);
        map.putString("POIName", POIName);
        map.putString("AOIName", AOIName);

        WritableArray pois = Arguments.createArray();
        if (poidoList != null) {
            for (POIDO poido : poidoList) {
                pois.pushMap(poido.writableMap());
            }
        }
        WritableArray aois = Arguments.createArray();
        if (aoidoList != null) {
            for (String aoido : aoidoList) {
                aois.pushString(aoido);
            }
        }
        map.putArray("aois", aois);
        map.putArray("pois", pois);
        return map;
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

    public String getFormattedAddress() {
        return formattedAddress;
    }

    public void setFormattedAddress(String formattedAddress) {
        this.formattedAddress = formattedAddress;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public String getAdCode() {
        return adCode;
    }

    public void setAdCode(String adCode) {
        this.adCode = adCode;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getPOIName() {
        return POIName;
    }

    public void setPOIName(String POIName) {
        this.POIName = POIName;
    }

    public String getAOIName() {
        return AOIName;
    }

    public void setAOIName(String AOIName) {
        this.AOIName = AOIName;
    }

    public List<POIDO> getPoidoList() {
        return poidoList;
    }

    public void setPoidoList(List<POIDO> poidoList) {
        this.poidoList = poidoList;
    }

    public List<String> getAoidoList() {
        return aoidoList;
    }

    public void setAoidoList(List<String> aoidoList) {
        this.aoidoList = aoidoList;
    }
}
