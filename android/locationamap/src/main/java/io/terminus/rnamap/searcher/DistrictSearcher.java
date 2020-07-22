package io.terminus.rnamap.searcher;

/**
 * Created by wenboli on 17/7/12.
 */

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.district.DistrictItem;
import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.api.services.district.DistrictResult;
import com.amap.api.services.district.DistrictSearch;
import com.amap.api.services.district.DistrictSearchQuery;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import java.util.ArrayList;
import java.util.List;

import io.terminus.rnamap.AMapUtils;
import io.terminus.rnamap.model.DistrictResultDO;
import io.terminus.rnamap.model.ErrorDO;
import io.terminus.rnamap.model.LocationDO;
import io.terminus.rnamap.model.LocationListDO;
import io.terminus.rnamap.model.POIDO;

public class DistrictSearcher extends BaseEmitter implements DistrictSearch.OnDistrictSearchListener{

    private static final int RESULT_CODE_SUCCESS = 1000;
    private static final String EVENT_NAME_GEOCODE = "geocode";
    private DistrictSearch search;

    public DistrictSearcher(String requestId, ReactContext reactContext) {
        super(requestId, reactContext);
        search = new DistrictSearch(reactContext);
    }

    public void search(String key){
        DistrictSearchQuery query = new DistrictSearchQuery();
        query.setKeywords(key);
        search.setQuery(query);
        search.setOnDistrictSearchListener(this);
        search.searchDistrictAsyn();
    }

    @Override
    public void onDistrictSearched(DistrictResult districtResult) {

        if (districtResult.getAMapException().getErrorCode() == RESULT_CODE_SUCCESS){
            DistrictItem item = districtResult.getDistrict().get(0);
            DistrictResultDO resultDO = new DistrictResultDO(item);
            sendEvent(EVENT_NAME_GEOCODE, resultDO);
        } else {
            ErrorDO errorDO = new ErrorDO("AMap DistrictSearch error with code:", 0);
            sendEventError(EVENT_NAME_GEOCODE, errorDO);
        }
    }
}
