//
//  DBTwitter.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBTwitter : NSManagedObject

@property (nonatomic, retain) NSNumber * idContact;
@property (nonatomic, retain) NSString * idTwitter;
@property (nonatomic, retain) NSString * nickTwitter;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * location;

+ (DBTwitter *)createEntityWithDictionary:(NSDictionary *)aDictionary;
+ (DBTwitter *)updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:(NSDictionary *)aDictionary;
- (void)deleteEntity;


@end
