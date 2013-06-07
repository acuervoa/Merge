//
//  StatusObject.h
//  Merge
//
//  Created by Andres Cuervo Adame on 06/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusObject : NSObject

@property NSString *name;
@property NSString *status;
@property NSString *created_at;
@property NSMutableDictionary *place;

@property NSString *idTwitter;
@property NSString *idPost;
@property NSString *latitudeCoordinates;
@property NSString *longitudeCoordinates;


-(StatusObject *)initWithJSonDict: (NSDictionary *) jsonDict;
-(StatusObject *)initUnique: (NSDictionary *)twitterAccount;
@end
