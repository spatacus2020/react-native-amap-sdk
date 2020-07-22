#import "RNAMNavigationManager.h"
#import <MapKit/MapKit.h>
#import "RNAMConfig.h"

@interface RNMapNavigation()

@property(nonatomic,strong) NSString *sname;
@property(nonatomic,strong) NSString *dname;
@property(nonatomic) double slat;
@property(nonatomic) double slon;
@property(nonatomic) double dlat;
@property(nonatomic) double dlon;

@end

@implementation RNMapNavigation

RCT_EXPORT_MODULE(RNMapNavigationManager);
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(mapNavigation:(id)data)
{
    if(![data isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSDictionary *params = data;
    if([params objectForKey:@"sname"] == nil){
        return;
    }
    if([params objectForKey:@"dname"] == nil){
        return;
    }
    if([params objectForKey:@"slat"] == nil){
        return;
    }
    if([params objectForKey:@"slon"] == nil){
        return;
    }
    if([params objectForKey:@"dlat"] == nil){
        return;
    }
    if([params objectForKey:@"dlon"] == nil){
        return;
    }
    _sname = params[@"sname"];
    _dname = params[@"dname"];
    _slat = [(NSNumber *) params[@"slat"] doubleValue];
    _slon = [(NSNumber *) params[@"slon"] doubleValue];
    _dlat = [(NSNumber *) params[@"dlat"] doubleValue];
    _dlon = [(NSNumber *) params[@"dlon"] doubleValue];
    [self navigationSelect];
}

- (void)navigationSelect {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择导航软件"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self navigationAMap];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self navigationApple];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController
                                                                                   animated:YES
                                                                                 completion:nil];
}

- (void)navigationApple {
    CLLocationCoordinate2D locationCoordinate2D = CLLocationCoordinate2DMake(_dlat, _dlon);
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:locationCoordinate2D
                                                                                       addressDictionary:nil]];
    toLocation.name = _dname;
    
    CLLocationCoordinate2D currentCoordinate2D = CLLocationCoordinate2DMake(_slat,_slon);
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:currentCoordinate2D postalAddress:nil]];
    currentLocation.name = _sname;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
}

- (void)navigationAMap {
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *appScheme = [[RNAMConfig shareInstance] appScheme];
    NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0", appName,_slat,_slon,_sname,_dlat,_dlon,_dname];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"请先安装高德APP"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController
                                                                                       animated:YES
                                                                                     completion:nil];
        return;
    }
    
}


@end
