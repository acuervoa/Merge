//
//  FacebookClass.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "DBContact.h"
#import "DBFacebook.h"

@protocol FacebookClassDelegate <NSObject>

- (void)thisAccountLoadUpdated;
- (void)thisLoadContactsFinished;
- (void)thisSaveContactsFinished;

@end

@interface FacebookClass : NSObject
{
    id<FacebookClassDelegate> delegate;
}

@property (nonatomic, retain) id<FacebookClassDelegate> delegate;
@property (nonatomic, retain) ACAccountStore *facebookAccountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (nonatomic, retain) NSArray *facebookContacts;
@property (nonatomic, retain) NSDictionary *FBPostDictionary;

-(void)loadContacts;
-(void)loadAccount;
-(void)saveContacts;

-(NSDictionary *)getFBContactWithId:(NSNumber*)idFBContact;
-(void)getLocationFromContact:(NSNumber *)idContact;
-(NSString *)formatDateFromCreateDate:(NSString *)dateString;

@end
