//
//  DBTwitter.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "DBTwitter.h"


@implementation DBTwitter

@dynamic idContact;
@dynamic idTwitter;
@dynamic nickTwitter;
@dynamic imageURL;
@dynamic location;

+(DBTwitter *)createEntityWithDictionary:(NSDictionary *)aDictionary
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create a new message in the local context
    DBTwitter *newEntity = [DBTwitter MR_createInContext:localContext];
    
    // Set the properties
    [newEntity setValuesForKeysWithDictionary:aDictionary];
    
    // Save in the local context
    [localContext MR_saveToPersistentStoreAndWait];
    
    return newEntity;
    
}

+ (DBTwitter *)updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:(NSDictionary *)aDictionary
{
    //Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DBTwitter *contactFounded = [DBTwitter MR_findFirstByAttribute:@"idTwitter" withValue:idTwitter inContext:localContext];
    
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
