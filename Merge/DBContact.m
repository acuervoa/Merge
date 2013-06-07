//
//  DBContact.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "DBContact.h"


@implementation DBContact

@dynamic idContact;
@dynamic name;
@dynamic firstName;
@dynamic lastName;
@dynamic email;
@dynamic phone;
@dynamic address;
@dynamic imageFile;

+(DBContact *)createEntityWithDictionary:(NSDictionary *)aDictionary
{
    //Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create a new message in the local context
    DBContact *newEntity = [DBContact MR_createInContext:localContext];
    
    // Set the properties
    [newEntity setValuesForKeysWithDictionary:aDictionary];
    NSInteger passedId = [[aDictionary objectForKey:@"idContact"] intValue];
    if (passedId == 0) {
        NSInteger maxId = [[DBContact MR_aggregateOperation:@"max:" onAttribute:@"idContact" withPredicate:nil inContext:localContext] intValue];
        newEntity.idContact = [NSNumber numberWithInt:(maxId + 1)];
    }
    
    // Save in the local context
    [localContext MR_saveToPersistentStoreAndWait];
    
    return newEntity;

    
}

+(DBContact *)updateEntityWithIdContact:(NSNumber *)idContact withDictionary:(NSDictionary *)aDictionary
{
    //Get the local context
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    DBContact *contactFounded = [DBContact MR_findFirstByAttribute:@"idContact" withValue:idContact inContext:localContext];
    
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
