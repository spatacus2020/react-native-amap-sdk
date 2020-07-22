package io.terminus.rnamap.model;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;

import java.util.Map;

/**
 * User : yh
 * Date : 17/3/8
 */

public class MapPointDO {

    public MapPointDO(ReadableMap data){
        if(data.hasKey("latitude")){
            latitude = data.getDouble("latitude");
        }
        if(data.hasKey("longitude")){
            longitude = data.getDouble("longitude");
        }
        if(data.hasKey("title")){
            title = data.getString("title");
        }
        if(data.hasKey("subTitle")){
            subTitle = data.getString("subTitle");
        }
        if(data.hasKey("desc")){
            desc = data.getString("desc");
        }
        if(data.hasKey("iconImageName")){
            iconImageName = data.getString("iconImageName");
        }
        if(data.hasKey("extra")){
            extra = data.getString("extra");
        }
    }
    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getIconImageName() {
        return iconImageName;
    }

    public void setIconImageName(String iconImageName) {
        this.iconImageName = iconImageName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    private double latitude;
    private double longitude;
    private String iconImageName;
    private String title;
    private String subTitle;
    private String desc;
    private String extra;

}
