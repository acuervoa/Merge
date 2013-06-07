//
//  LocationAnnotation.h
//  Merge
//
//  Created by Andres Cuervo Adame on 06/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationAnnotation : NSObject <MKAnnotation>

//MKAnnotation properties

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//Other properties
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;

-(id)initWithImageURL:(NSURL *)anImageURL title:(NSString *)aTitle coordinate:(CLLocationCoordinate2D) aCoordinate;
-(void)updateSubtitle;
@end
