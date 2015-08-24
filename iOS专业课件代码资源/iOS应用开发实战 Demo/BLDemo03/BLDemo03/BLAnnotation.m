//
//  BLAnnotations.m
//  BLDemo03
//
//  Created by derek on 7/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLAnnotation.h"

@implementation BLAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                   title:(NSString *)title
                subtitle:(NSString *)subtitle
                   index:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.index = index;
    }
    return self;
}

@end
