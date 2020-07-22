package io.terminus.rnamap;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import io.terminus.rnamap.service.GeocodeManager;
import io.terminus.rnamap.service.LocationManager;
import io.terminus.rnamap.service.MapNavigationManager;

/**
 * io.terminus.rnamap
 * Created by Allen.Chiang on 19/01/2017.
 */

public class AMapReactPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new LocationManager(reactContext));
        modules.add(new GeocodeManager(reactContext));
        modules.add(new MapNavigationManager(reactContext));
        return modules;
    }
    
    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        List<ViewManager> modules = new ArrayList<>();
        return modules;
    }
}
