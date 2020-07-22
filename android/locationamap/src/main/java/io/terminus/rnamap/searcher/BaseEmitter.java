package io.terminus.rnamap.searcher;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import io.terminus.rnamap.model.ErrorDO;
import io.terminus.rnamap.model.ReactResultDO;
import io.terminus.rnamap.model.WritableObject;

/**
 * io.terminus.rnamap.service
 * Created by Allen.Chiang on 20/01/2017.
 */

public class BaseEmitter {

    private String requestId;
    private ReactContext reactContext;

    public BaseEmitter(String requestId, ReactContext reactContext) {
        this.requestId = requestId;
        this.reactContext = reactContext;
    }

    public ReactContext getReactContext() {
        return reactContext;
    }

    public void sendEvent(String eventName, WritableMap writableMap) {
        if (this.reactContext != null) {
            writableMap.putString("requestId", requestId);
            this.reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, writableMap);
        }
    }

    public void sendEvent(String eventName, WritableObject writableObject) {
        ReactResultDO resultDO = new ReactResultDO(requestId, writableObject);
        this.sendEvent(eventName, resultDO.writableMap());
    }

    public void sendEventError(String eventName, ErrorDO errorDO) {
        ReactResultDO resultDO = new ReactResultDO(requestId, errorDO);
        sendEvent(eventName, resultDO.writableMap());
    }
}
