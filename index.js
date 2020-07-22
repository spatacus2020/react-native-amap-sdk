import { searchRequestFactory, fetchLocation, mapNavigation } from './app/location';

export const AMapGeocode = searchRequestFactory('geocode')
export const AMapReGeocode = searchRequestFactory('reGeocode')
export const AMapReGeocodeByAmap = searchRequestFactory('reGeocodeByAmap')
export const AMapPOISearch = searchRequestFactory('poiSearch')
export const AMapPOISearchPage = searchRequestFactory('poiSearchWithPage')
export const AMapDistrict = searchRequestFactory('district')


module.exports.fetchLocation = fetchLocation
module.exports.mapNavigation = mapNavigation

export * from './app/amap3d'
