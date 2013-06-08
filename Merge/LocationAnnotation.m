//
//  LocationAnnotation.m
//  Merge
//
//  Created by Andres Cuervo Adame on 06/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize image;
@synthesize imageURL;
@synthesize contact;

-(id)initWithImageURL:(NSURL *)anImageURL title:(NSString *)aTitle coordinate:(CLLocationCoordinate2D)aCoordinate contact:(DBContact *)dbContact
{
    if(self = [super init]){
        self.imageURL = anImageURL;
        self.title = aTitle;
        self.coordinate =aCoordinate;
        self.contact = dbContact;
    }
    return self;
}

-(UIImage *)image
{
    if(!image && self.imageURL)
    {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        self.image = [UIImage imageWithData:imageData];
    }
    return image;
}

-(NSString *)placemarkToString:(CLPlacemark *)placemark
{
    NSMutableString *placemarkString = [[NSMutableString alloc]init];
    if(placemark.locality){
        [placemarkString appendString:placemark.locality];
    }
    
    if(placemark.administrativeArea){
        if(placemarkString.length > 0)
            [placemarkString appendString:@", "];
        [placemarkString appendString:placemark.administrativeArea];
    }
    
    if(placemarkString.length == 0 && placemark.name)
        [placemarkString appendString:placemark.name];
    
    return placemarkString;
}

-(void)updateSubtitle
{
    if(self.subtitle != nil)
        return;
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude
                                                     longitude:self.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
        if(placemarks.count >0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.subtitle = [self placemarkToString:placemark];
        }
    }];
}
@end

