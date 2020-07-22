package io.terminus.rnamap.service;

import android.widget.Toast;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import io.terminus.rnamap.AMapUtils;

/**
 * User : yh
 * Date : 17/8/3
 */

public class MapNavigationManager extends ReactContextBaseJavaModule {
    private static final String REACT_MODULE_NAME = "RNMapNavigationManager";

    private static final String SNAME = "sname";
    private static final String SLAT = "slat";
    private static final String SLON = "slon";
    private static final String DNAME = "dname";
    private static final String DLAT = "dlat";
    private static final String DLON = "dlon";

    public MapNavigationManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return REACT_MODULE_NAME;
    }

    @ReactMethod
    public void mapNavigation(ReadableMap params){
        String sname,dname;
        double slat,slon,dlat,dlon;
        if(!params.hasKey(SNAME)){
            return;
        }
        if(!params.hasKey(DNAME)){
            return;
        }
        if(!params.hasKey(SLAT)){
            return;
        }
        if(!params.hasKey(SLON)){
            return;
        }
        if(!params.hasKey(DLAT)){
            return;
        }
        if(!params.hasKey(DLON)){
            return;
        }
        sname = params.getString(SNAME);
        dname = params.getString(DNAME);
        slat = params.getDouble(SLAT);
        slon = params.getDouble(SLON);
        dlat = params.getDouble(DLAT);
        dlon = params.getDouble(DLON);
        AMapUtils.navigation(this.getReactApplicationContext(),
                sname,
                slat,
                slon,
                dname,
                dlat,
                dlon);
    }
}
