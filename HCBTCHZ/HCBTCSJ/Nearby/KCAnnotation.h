//
//  KCAnnotation.h
//  HCBTCHZ
//
//  Created by itte on 3/2/16.
//  Copyright © 2016 itte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol xxx <NSObject>


@end

@interface KCAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) UIImage *image;
@end
