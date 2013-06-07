//
//  DBContact.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBContact : NSManagedObject

@property (nonatomic, retain) NSNumber * idContact;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSData * imageFile;

+ (DBContact *)createEntityWithDictionary:(NSDictionary *)aDictionary;
+ (DBContact *)updateEntityWithIdContact:(NSNumber *)idContact withDictionary:(NSDictionary *)aDictionary;
- (void)deleteEntity;

@end
