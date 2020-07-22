package io.terminus.rnamap.service;

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import io.terminus.rnamap.AMapUtils;
import io.terminus.rnamap.searcher.GeocodeSearcher;
import io.terminus.rnamap.searcher.POISearcher;
import io.terminus.rnamap.searcher.DistrictSearcher;

/**
 * io.terminus.rnamap.service
 * Created by Allen.Chiang on 19/01/2017.
 */

public class GeocodeManager extends ReactContextBaseJavaModule {

    public GeocodeManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void geocode(String requestId, String address, String cityCode) {
        GeocodeSearcher searcher = new GeocodeSearcher(this.getReactApplicationContext(), requestId);
        GeocodeQuery query = new GeocodeQuery(address, cityCode);
        searcher.geocodeSearch.getFromLocationNameAsyn(query);
    }

    @ReactMethod
    public void reGeocode(String requestId, String latitude, String longitude) {
        GeocodeSearcher searcher = new GeocodeSearcher(this.getReactApplicationContext(), requestId);
        LatLonPoint point = new LatLonPoint(Double.parseDouble(latitude), Double.parseDouble(longitude));
        RegeocodeQuery query = new RegeocodeQuery(point, 200, GeocodeSearch.GPS);
        searcher.geocodeSearch.getFromLocationAsyn(query);
    }

    @ReactMethod
    public void reGeocodeByAmap(String requestId, String latitude, String longitude){
        GeocodeSearcher searcher = new GeocodeSearcher(this.getReactApplicationContext(), requestId);
        LatLonPoint point = new LatLonPoint(Double.parseDouble(latitude), Double.parseDouble(longitude));
        RegeocodeQuery query = new RegeocodeQuery(point, 200, GeocodeSearch.AMAP);
        searcher.geocodeSearch.getFromLocationAsyn(query);
    }

    @ReactMethod
    public void poiSearch(String requestId, String keyword, String cityCode) {
        poiSearchWithPage(requestId, keyword, cityCode, 0, 10);
    }

    @ReactMethod
    public void poiSearchWithPage(String requestId, String keyword, String cityCode, Integer pageNum, Integer pageSize) {
        POISearcher searcher = new POISearcher(this.getReactApplicationContext(), requestId);
        if (AMapUtils.isStringBlank(cityCode)) {
            LocationManager locationManager = new LocationManager(this.getReactApplicationContext());
            locationManager.location(searcher);
            searcher.setKeyword(keyword);
            searcher.setPageNum(pageNum);
            searcher.setPageSize(pageSize);
        } else {
            searcher.search(keyword, cityCode, pageNum, pageSize);
        }
    }

    @ReactMethod
    public void district(String requestId, String name) {

        DistrictSearcher searcher = new DistrictSearcher(requestId, this.getReactApplicationContext());
        searcher.search(name);
    }

    @Override
    public String getName() {
        return "RNGeocodeManager";
    }
}
