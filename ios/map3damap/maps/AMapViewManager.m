#import <React/RCTUIManager.h>
#import "AMapView.h"
#import "AMapMarker.h"
#import "AMapOverlay.h"

#pragma ide diagnostic ignored "OCUnusedClassInspection"
#pragma ide diagnostic ignored "-Woverriding-method-mismatch"

@interface AMapViewManager : RCTViewManager <MAMapViewDelegate>
    
@end

@implementation AMapViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    AMapView *mapView = [AMapView new];
    mapView.frame = [UIScreen mainScreen].bounds;
    mapView.centerCoordinate = CLLocationCoordinate2DMake(39.9242, 116.3979);
    mapView.zoomLevel = 10;
    mapView.delegate = self;
    return mapView;
}

RCT_EXPORT_VIEW_PROPERTY(locationEnabled, BOOL)
RCT_REMAP_VIEW_PROPERTY(showsCompass, showCompass, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showsTraffic, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showsBuildings, BOOL)
RCT_EXPORT_VIEW_PROPERTY(zoomLevel, double)
RCT_EXPORT_VIEW_PROPERTY(maxZoomLevel, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(minZoomLevel, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(zoomEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(scrollEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(rotateEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(mapType, MAMapType)
RCT_EXPORT_VIEW_PROPERTY(limitRegion, MACoordinateRegion)
RCT_EXPORT_VIEW_PROPERTY(region, MACoordinateRegion)
RCT_EXPORT_VIEW_PROPERTY(tilt, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(rotation, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(distanceFilter, CLLocationDistance)
RCT_EXPORT_VIEW_PROPERTY(locationStyle, LocationStyle)



RCT_CUSTOM_VIEW_PROPERTY(touchEnable, BOOL, AMapViewManager){
    ((AMapView*)view).userInteractionEnabled = [json boolValue];
}

RCT_EXPORT_VIEW_PROPERTY(onMapPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLongPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLocation, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStatusChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStatusChangeComplete, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(showsUserLocation, BOOL)

RCT_EXPORT_VIEW_PROPERTY(userTrackingMode, NSInteger)


RCT_CUSTOM_VIEW_PROPERTY(coordinate, MKCoordinateRegion, AMapViewManager){
    NSLog(@"RCT_CUSTOM_VIEW_PROPERTY");
    if(json[@"latitude"] && json[@"longitude"]){
        double latitude = ((NSString*)json[@"latitude"]).doubleValue;
        double longitude = ((NSString*)json[@"longitude"]).doubleValue;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        [((AMapView*)view) setCenterCoordinate:location animated:NO];
    }
}

RCT_EXPORT_METHOD(animateTo:(nonnull NSNumber *)reactTag params:(NSDictionary *)params duration:(NSInteger)duration) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        AMapView *mapView = (AMapView *) viewRegistry[reactTag];

        if (params[@"coordinate"]) {
            NSDictionary *coordinate = params[@"coordinate"];
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([coordinate[@"latitude"] doubleValue],
                                                                         [coordinate[@"longitude"] doubleValue]);
            [mapView setCenterCoordinate:location animated:NO];
        }
    }];
}

- (void)mapView:(AMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (mapView.onMapPress) {
            mapView.onMapPress(@{
                              @"latitude": @(coordinate.latitude),
                              @"longitude": @(coordinate.longitude),
                              });
    }
}

- (void)mapView:(AMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if (mapView.onLongPress) {
        mapView.onLongPress(@{
                @"latitude": @(coordinate.latitude),
                @"longitude": @(coordinate.longitude),
        });
    }
}

- (void)mapView:(AMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (mapView.onLocation) {
        mapView.onLocation(@{
                @"latitude": @(userLocation.coordinate.latitude),
                @"longitude": @(userLocation.coordinate.longitude),
                @"accuracy": @((userLocation.location.horizontalAccuracy + userLocation.location.verticalAccuracy) / 2),
                @"altitude": @(userLocation.location.altitude),
                @"speed": @(userLocation.location.speed),
                @"timestamp": @(userLocation.location.timestamp.timeIntervalSince1970),
        });
    }
}

- (MAAnnotationView *)mapView:(AMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        AMapMarker *marker = [mapView getMarker:annotation];
        return marker.annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[AMapOverlay class]]) {
        return ((AMapOverlay *) overlay).renderer;
    }
    return nil;
}

- (void)mapView:(AMapView *)mapView didAnnotationViewTapped:(MAAnnotationView *)view
{
    AMapMarker *marker = [mapView getMarker:view.annotation];
    if (marker.onPress) {
        marker.onPress(nil);
    }
}

- (void)mapView:(AMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view {
    AMapMarker *marker = [mapView getMarker:view.annotation];
    if (marker.onInfoWindowPress) {
        marker.onInfoWindowPress(nil);
    }
}

- (void)mapView:(AMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState
   fromOldState:(MAAnnotationViewDragState)oldState {
    AMapMarker *marker = [mapView getMarker:view.annotation];
    if (newState == MAAnnotationViewDragStateStarting && marker.onDragStart) {
        marker.onDragStart(nil);
    }
    if (newState == MAAnnotationViewDragStateDragging) {
        if (marker.onDrag) {
            marker.onDrag(nil);
        }
    }
    if (newState == MAAnnotationViewDragStateEnding && marker.onDragEnd) {
        marker.onDragEnd(@{
                @"latitude": @(marker.annotation.coordinate.latitude),
                @"longitude": @(marker.annotation.coordinate.longitude),
        });
    }
}

- (void)mapViewRegionChanged:(AMapView *)mapView {
    if (mapView.onStatusChange) {
        
        MACoordinateRegion status = mapView.region;
        mapView.onStatusChange(@{
                @"latitude": @(status.center.latitude),
                @"longitude": @(status.center.longitude),
        });
    }
}

- (void)mapView:(AMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (mapView.onStatusChangeComplete) {
        MACoordinateRegion status = mapView.region;
        

        mapView.onStatusChangeComplete(@{
                @"latitude": @(status.center.latitude),
                @"longitude": @(status.center.longitude),
                @"latitudeDelta": @(status.span.latitudeDelta),
                @"longitudeDelta": @(status.span.longitudeDelta),
        });
    }
}

- (void)mapInitComplete:(AMapView *)mapView {
    mapView.loaded = YES;

    // struct 里的值会被初始化为 0，这里以此作为条件，判断 initialRegion 是否被设置过
    // 但实际上经度为 0 是一个合法的坐标，只是考虑到高德地图只在中国使用，就这样吧
    if (mapView.initialRegion.center.latitude != 0) {
        mapView.region = mapView.initialRegion;
    }
}

@end
