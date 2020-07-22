package io.terminus.rnamap.model;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.util.ArrayList;
import java.util.List;

/**
 * io.terminus.rnamap.model
 * Created by Allen.Chiang on 20/01/2017.
 */

public class LocationListDO implements WritableObject {

    private List<LocationDO> list;

    public LocationListDO(List<LocationDO> list) {
        this.list = list;
    }

    public void addLocation(LocationDO locationDO) {
        if (this.list == null) {
            this.list = new ArrayList<>();
        }
        this.list.add(locationDO);
    }

    @Override
    public WritableMap writableMap() {
        WritableArray writableArray = Arguments.createArray();
        if (list != null) {
            for (LocationDO locationDO : list) {
                writableArray.pushMap(locationDO.writableMap());
            }
        }
        WritableMap writableMap = Arguments.createMap();
        writableMap.putArray("list", writableArray);
        return writableMap;
    }
}
