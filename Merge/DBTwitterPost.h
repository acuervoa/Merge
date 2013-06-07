//
//  DBTwitterPost.h
//  Merge
//
//  Created by Andres Cuervo Adame on 07/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBTwitterPost : NSManagedObject

@property (nonatomic, retain) NSString * idPost;
@property (nonatomic, retain) NSString * idTwitter;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * created_at;

+ (DBTwitterPost *)createEntityWithDictionary:(NSDictionary *)aDictionary;
+ (DBTwitterPost *)updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:(NSDictionary *)aDictionary;
- (void)deleteEntity;

@end
