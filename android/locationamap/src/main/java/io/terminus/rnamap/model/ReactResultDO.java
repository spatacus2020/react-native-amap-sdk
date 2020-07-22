package io.terminus.rnamap.model;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

/**
 * io.terminus.rnamap.model
 * Created by Allen.Chiang on 19/01/2017.
 */

public class ReactResultDO implements WritableObject {

    private String requestId;
    private WritableObject data;
    private WritableObject error;

    public ReactResultDO() {
    }

    public ReactResultDO(String requestId) {
        this.requestId = requestId;
    }

    public ReactResultDO(String requestId, WritableObject data) {
        this.requestId = requestId;
        this.data = data;
    }

    public WritableMap writableMap() {
        WritableMap map = Arguments.createMap();
        map.putString("requestId", requestId);
        map.putMap("data", data == null ? null : data.writableMap());
        map.putMap("error", error == null ? null : error.writableMap());
        return map;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public WritableObject getData() {
        return data;
    }

    public void setData(WritableObject data) {
        this.data = data;
    }

    public WritableObject getError() {
        return error;
    }

    public void setError(WritableObject error) {
        this.error = error;
    }
}
