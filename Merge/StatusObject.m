//
//  StatusObject.m
//  Merge
//
//  Created by Andres Cuervo Adame on 06/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "StatusObject.h"

@implementation StatusObject

@synthesize name;
@synthesize status;
@synthesize created_at;
@synthesize place;

@synthesize idTwitter;
@synthesize idPost;
@synthesize longitudeCoordinates;
@synthesize latitudeCoordinates;

-(StatusObject *)initWithJSonDict: (NSDictionary *) jsonDict
{
    
    NSLog(@"%@",jsonDict);
    for (NSDictionary *twitterAccount in jsonDict) {
       self = [self initUnique:twitterAccount];
    }
    
    
    return self;
}

-(StatusObject *)initUnique: (NSDictionary *) twitterAccount
{
    name = [twitterAccount valueForKey:@"name"];
    status = [twitterAccount valueForKeyPath:@"status.text"];
    created_at = [twitterAccount valueForKeyPath:@"status.created_at"];
    // place = [twitterAccount valueForKeyPath:@"status.place"];
    idTwitter = [twitterAccount valueForKeyPath:@"user.id_str"];
    idPost = [twitterAccount valueForKey:@"id"];
    
    NSArray *coordinates = [twitterAccount valueForKey:@"coordinates"];
    
    longitudeCoordinates = [coordinates objectAtIndex:0];
    latitudeCoordinates = [coordinates objectAtIndex:1];
    
    return self;
}
@end
