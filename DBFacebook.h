//
//  DBFacebook.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBFacebook : NSManagedObject

@property (nonatomic, retain) NSNumber * idContact;
@property (nonatomic, retain) NSString * idFacebook;
@property (nonatomic, retain) NSString * imageURL;


+ (DBFacebook *)createEntityWithDictionary:(NSDictionary *)aDictionary;
+ (DBFacebook *)updateEntityWithIdFacebook:(NSNumber *)idFacebook withDictionary:(NSDictionary *)aDictionary;
- (void)deleteEntity;

@end
