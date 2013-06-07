//
//  DBFacebook.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "DBFacebook.h"


@implementation DBFacebook

@dynamic idContact;
@dynamic idFacebook;
@dynamic imageURL;


+ (DBFacebook *)createEntityWithDictionary:(NSDictionary *)aDictionary
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create a new message in the local context
    DBFacebook *newEntity = [DBFacebook MR_createInContext:localContext];
    
    // Set the properties
    [newEntity setValuesForKeysWithDictionary:aDictionary];
    
    // Save in the local context
    [localContext MR_saveToPersistentStoreAndWait];
    
    return newEntity;

}

+ (DBFacebook *)updateEntityWithIdFacebook:(NSNumber *)idFacebook withDictionary:(NSDictionary *)aDictionary
{
    //Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DBFacebook *contactFounded = [DBFacebook MR_findFirstByAttribute:@"idFacebook" withValue:idFacebook inContext:localContext];
    
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