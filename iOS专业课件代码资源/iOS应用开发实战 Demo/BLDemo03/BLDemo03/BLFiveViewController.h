//
//  BLFiveViewController.h
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BLFiveViewController : BLBaseViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    MKMapView           *_mapView;
    UILabel             *_locationLabel;    
    NSMutableArray      *_annotations;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end
