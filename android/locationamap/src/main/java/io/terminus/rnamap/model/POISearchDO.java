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

public class POISearchDO implements WritableObject {

    private List<POIDO> pois;
    private Integer count;
    private POISuggestion suggestion;

    public POISearchDO() {
        pois = new ArrayList<>();
        count = 0;
        suggestion = new POISuggestion();
    }

    @Override
    public WritableMap writableMap() {
        WritableMap writableMap = Arguments.createMap();
        if (pois != null) {
            WritableArray array = Arguments.createArray();
            for (POIDO poido : pois) {
                array.pushMap(poido.writableMap());
            }
            writableMap.putArray("pois", array);
        }
        writableMap.putInt("count", count);
        writableMap.putMap("suggestion", suggestion == null ? null : suggestion.writableMap());
        return writableMap;
    }

    public List<POIDO> getPois() {
        return pois;
    }

    public void setPois(List<POIDO> pois) {
        this.pois = pois;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public POISuggestion getSuggestion() {
        return suggestion;
    }

    public void setSuggestion(POISuggestion suggestion) {
        this.suggestion = suggestion;
    }

    public static class POISuggestion implements WritableObject {

        private List<String> keywords;

        public List<String> getKeywords() {
            return keywords;
        }

        public void setKeywords(List<String> keywords) {
            this.keywords = keywords;
        }

        @Override
        public WritableMap writableMap() {
            WritableMap writableMap = Arguments.createMap();
            if (keywords != null) {
                WritableArray array = Arguments.createArray();
                for (String keyword : keywords) {
                    array.pushString(keyword);
                }
                writableMap.putArray("keywords", array);
            }
            return writableMap;
        }
    }




}
