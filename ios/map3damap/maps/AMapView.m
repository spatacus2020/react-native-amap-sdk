#import <React/UIView+React.h>
#import "AMapView.h"
#import "AMapMarker.h"
#import "AMapOverlay.h"
#import "LocationStyle.h"

#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@implementation AMapView {
    NSMutableDictionary *_markers;
    MAUserLocationRepresentation *_locationStyle;
}

- (instancetype)init {
    _markers = [NSMutableDictionary new];
    self = [super init];
    return self;
}

- (void)setShowsTraffic:(BOOL)shows {
    self.showTraffic = shows;
}


- (void)setLocationEnabled:(BOOL)enabled {
    self.showsUserLocation = enabled;
}

- (void)setShowCompass:(BOOL)enabled {
    self.showsCompass = enabled;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.centerCoordinate = coordinate;
}


- (void)setLocationStyle:(LocationStyle *)locationStyle {
    if (!_locationStyle) {
        _locationStyle = [MAUserLocationRepresentation new];
    }
    _locationStyle.fillColor = locationStyle.fillColor;
    _locationStyle.strokeColor = locationStyle.strokeColor;
    _locationStyle.lineWidth = locationStyle.strokeWidth;
    _locationStyle.image = locationStyle.image;
    [self updateUserLocationRepresentation:_locationStyle];
}

// 如果在地图未加载的时候调用改方法，需要先将 region 存起来，等地图加载完成再设置
- (void)setRegion:(MACoordinateRegion)region {
    if (self.loaded) {
        super.region = region;
    } else {
        self.initialRegion = region;
    }
}

- (void)didAddSubview:(UIView *)subview {
    if ([subview isKindOfClass:[AMapMarker class]]) {
        AMapMarker *marker = (AMapMarker *) subview;
        marker.mapView = self;
        _markers[[@(marker.annotation.hash) stringValue]] = marker;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addAnnotation:marker.annotation];
        });
    }
    if ([subview isKindOfClass:[AMapOverlay class]]) {
        [self addOverlay:(id <MAOverlay>) subview];
    }
}

- (void)removeReactSubview:(id <RCTComponent>)subview {
    [super removeReactSubview:subview];
    if ([subview isKindOfClass:[AMapMarker class]]) {
        AMapMarker *marker = (AMapMarker *) subview;
        [self removeAnnotation:marker.annotation];
    }
    if ([subview isKindOfClass:[AMapOverlay class]]) {
        [self removeOverlay:(id <MAOverlay>) subview];
    }
}

- (AMapMarker *)getMarker:(id <MAAnnotation>)annotation {
    return _markers[[@(annotation.hash) stringValue]];
}

- (void)setFrame:(CGRect)frame{
    if (CGRectGetWidth(frame) <= [UIScreen mainScreen].bounds.size.width) {
        [super setFrame:frame];
    }
}

@end
