//
//  AddressBook.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "DBContact.h"

@protocol AddressBookContactDelegate <NSObject>

-(void) thisLoadUpdated;

@end

@interface AddressBookContact : NSObject
{
    id<AddressBookContactDelegate>delegate;
}

@property(nonatomic, retain) id<AddressBookContactDelegate> delegate;

-(void)loadContacts;

@end
