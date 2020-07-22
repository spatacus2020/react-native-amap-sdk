package io.terminus.rnamap.searcher;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.facebook.react.bridge.ReactContext;

import java.util.ArrayList;
import java.util.List;

import io.terminus.rnamap.AMapUtils;
import io.terminus.rnamap.model.ErrorDO;
import io.terminus.rnamap.model.LocationDO;
import io.terminus.rnamap.model.POIDO;
import io.terminus.rnamap.model.POISearchDO;

/**
 * io.terminus.rnamap.service
 * Created by Allen.Chiang on 20/01/2017.
 */

public class POISearcher extends BaseEmitter implements PoiSearch.OnPoiSearchListener, AMapLocationListener {

    private static final int RESULT_CODE_SUCCESS = 1000;
    private static final int POI_SEARCH_PAGE_SIZE = 10;
    private static final String EVENT_NAME_GEOCODE = "geocode";
    public PoiSearch poiSearch = null;

    private Integer pageNum = 0;
    private Integer pageSize = POI_SEARCH_PAGE_SIZE;
    private String keyword;

    public POISearcher(ReactContext reactContext, String requestId) {
        super(requestId, reactContext);
    }

    public void search(String keyword, String cityCode) {
        search(keyword, cityCode, pageNum, pageSize);
    }

    public void search(String keyword, String cityCode, Integer pageNum, Integer pageSize) {
        PoiSearch.Query query = new PoiSearch.Query(keyword, "", cityCode);
        query.setPageNum(pageNum);
        query.setPageSize(pageSize);
        query.setCityLimit(true);

        poiSearch = new PoiSearch(this.getReactContext(), query);
        poiSearch.setOnPoiSearchListener(this);
        poiSearch.searchPOIAsyn();
    }

    @Override
    public void onPoiSearched(PoiResult poiResult, int resultCode) {
        if (RESULT_CODE_SUCCESS == resultCode) {
            POISearchDO searchDO = new POISearchDO();

            // 没有返回总数，只能这么粗略计算了
            searchDO.setCount(poiResult.getPageCount() * poiResult.getPois().size());
            // 建议搜索内容
            searchDO.getSuggestion().setKeywords(poiResult.getSearchSuggestionKeywords());

            if (poiResult.getPois() != null) {
                List<POIDO> pois = new ArrayList<>();
                for (PoiItem poiItem : poiResult.getPois()) {
                    POIDO poido = new POIDO();
                    poido.setPoiItem(poiItem);
                    pois.add(poido);
                }
                searchDO.setPois(pois);
            }
            sendEvent(EVENT_NAME_GEOCODE, searchDO);
        } else {
            ErrorDO errorDO = new ErrorDO("AMap POISearch error with code:" + resultCode, resultCode);
            sendEventError(EVENT_NAME_GEOCODE, errorDO);
        }
    }

    @Override
    public void onPoiItemSearched(PoiItem poiItem, int resultCode) {

    }

    /**
     * 定位的回调方法
     *
     * @param aMapLocation aMapLocation
     */
    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        LocationDO locationDO = AMapUtils.createLocationDO(aMapLocation);
        if (keyword != null) {
            // js没有传入cityCode，自动获取一次定位以后并搜索poi
            search(keyword, locationDO.getCityCode(), pageNum, pageSize);
        }
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
}
