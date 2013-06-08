//
//  DBFacebookPost.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBFacebookPost : NSManagedObject

@property (nonatomic, retain) NSNumber * idFacebook;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * timestamp;

+ (DBFacebookPost *)createEntityWithDictionary:(NSDictionary *)aDictionary;
+ (DBFacebookPost *)updateEntityWithIdFacebook:(NSNumber *)idFacebook withDictionary:(NSDictionary *)aDictionary;
- (void)deleteEntity;

@end
