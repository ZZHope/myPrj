//
//  SJBAnotation.h
//  mapTest
//
//  Created by SJB on 15/3/13.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SJBAnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

//大头针
@property(nonatomic, strong) NSString *icon;


@end
