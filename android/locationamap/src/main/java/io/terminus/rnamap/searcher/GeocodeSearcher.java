package io.terminus.rnamap.searcher;

import android.text.TextUtils;
import android.util.Log;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.geocoder.AoiItem;
import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.geocoder.StreetNumber;
import com.facebook.react.bridge.ReactContext;

import java.util.ArrayList;
import java.util.List;

import io.terminus.rnamap.AMapUtils;
import io.terminus.rnamap.model.ErrorDO;
import io.terminus.rnamap.model.LocationDO;
import io.terminus.rnamap.model.LocationListDO;
import io.terminus.rnamap.model.POIDO;

/**
 * io.terminus.rnamap
 * Created by Allen.Chiang on 20/01/2017.
 */

public class GeocodeSearcher extends BaseEmitter implements GeocodeSearch.OnGeocodeSearchListener {

    private static final int RESULT_CODE_SUCCESS = 1000;
    private static final String EVENT_NAME_GEOCODE = "geocode";

    public GeocodeSearch geocodeSearch = null;

    public GeocodeSearcher(ReactContext context, String requestId) {
        super(requestId, context);
        this.geocodeSearch = new GeocodeSearch(context);
        geocodeSearch.setOnGeocodeSearchListener(this);
    }

    @Override
    public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int resultCode) {
        if (RESULT_CODE_SUCCESS == resultCode) {
            LocationDO locationDO = AMapUtils.convert2Location(regeocodeResult.getRegeocodeAddress());
            List<PoiItem> poiItems = regeocodeResult.getRegeocodeAddress().getPois();
            List<AoiItem> aoiItems = regeocodeResult.getRegeocodeAddress().getAois();
            String adCode = regeocodeResult.getRegeocodeAddress().getAdCode();
            if (poiItems != null) {
                List<POIDO> pois = new ArrayList<>();
                for (PoiItem poiItem : poiItems) {

                    POIDO poido = new POIDO();
                    poido.setPoiItem(poiItem);
                    if(!TextUtils.isEmpty(adCode)){
                        if(TextUtils.isEmpty(poido.getAdcode())){
                            poido.setAdcode(adCode);
                        }
                    }
                    pois.add(poido);
                }
                locationDO.setPoidoList(pois);
//                locationDO.setAoidoList();
            }
            if (aoiItems != null) {
                List<String> aois = new ArrayList<>();
                for (AoiItem aoiItem : aoiItems) {
                    aois.add(aoiItem.getAoiName());
                }
                locationDO.setAoidoList(aois);
            }

            this.sendEvent(EVENT_NAME_GEOCODE, locationDO);
        } else {
            ErrorDO errorDO = new ErrorDO("AMap ReGeocode error with code:" + resultCode, resultCode);
            this.sendEventError(EVENT_NAME_GEOCODE, errorDO);
        }
    }

    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int resultCode) {
        if (RESULT_CODE_SUCCESS == resultCode && !geocodeResult.getGeocodeAddressList().isEmpty()) {
            List<LocationDO> locations = new ArrayList<>();
            for (GeocodeAddress address : geocodeResult.getGeocodeAddressList()) {
                LocationDO locationDO = AMapUtils.convert2Location(address);
                locations.add(locationDO);
            }
            LocationListDO listDO = new LocationListDO(locations);
            this.sendEvent(EVENT_NAME_GEOCODE, listDO);
        } else {
            ErrorDO errorDO = null;
            if (geocodeResult.getGeocodeAddressList().isEmpty()) {
                errorDO = new ErrorDO("AMap ReGeocode success but result is empty", resultCode);
            } else {
                errorDO = new ErrorDO("AMap ReGeocode error with code:" + resultCode, resultCode);
            }
            this.sendEventError(EVENT_NAME_GEOCODE, errorDO);
        }
    }
}
