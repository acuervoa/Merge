//
//  DBTwitterPost.m
//  Merge
//
//  Created by Andres Cuervo Adame on 07/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "DBTwitterPost.h"


@implementation DBTwitterPost

@dynamic idPost;
@dynamic idTwitter;
@dynamic message;
@dynamic longitude;
@dynamic latitude;
@dynamic created_at;



+(DBTwitterPost *)createEntityWithDictionary:(NSDictionary *)aDictionary
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create a new message in the local context
    DBTwitterPost *newEntity = [DBTwitterPost MR_createInContext:localContext];
    
    // Set the properties
    [newEntity setValuesForKeysWithDictionary:aDictionary];
    
    // Save in the local context
    [localContext MR_saveToPersistentStoreAndWait];
    
    return newEntity;
    
}

+ (DBTwitterPost *)updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:(NSDictionary *)aDictionary
{
    //Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DBTwitterPost *contactFounded = [DBTwitterPost MR_findFirstByAttribute:@"idTwitter" withValue:idTwitter inContext:localContext];
    
    if (contactFounded) {
        [contactFounded setValuesForKeysWithDictionary:aDictionary];
        [localContext MR_saveToPersistentStoreAndWait];
    }
    
    return contactFounded;
}

-(void)deleteEntity
{
    // Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Delete the contact
    [self MR_deleteInContext:localContext];
    
    // Save the modification in the local context
    [localContext MR_saveToPersistentStoreAndWait];
}


@end
