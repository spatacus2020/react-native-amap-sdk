package io.terminus.rnamap.model;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

import java.util.Map;

/**
 * io.terminus.rnamap.model
 * Created by Allen.Chiang on 19/01/2017.
 */

public class ErrorDO implements WritableObject {

    private String message;
    private Integer code;
    private Map<String, String> userInfo;

    public ErrorDO(String message, Integer code) {
        this.message = message;
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public Map<String, String> getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(Map<String, String> userInfo) {
        this.userInfo = userInfo;
    }

    @Override
    public WritableMap writableMap() {
        WritableMap map = Arguments.createMap();
        map.putString("message", message);
        map.putInt("code", code);
        if (null != userInfo) {
            WritableMap userInfoMap = Arguments.createMap();
            for (Map.Entry<String, String> entry : userInfo.entrySet()) {
                userInfoMap.putString(entry.getKey(), entry.getValue());
            }
            map.putMap("userInfo", userInfoMap);
        }
        return map;
    }
}
