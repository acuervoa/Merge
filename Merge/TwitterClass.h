//
//  TwitterClass.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "DBContact.h"
#import "DBTwitter.h"
#import "DBTwitterPost.h"


@protocol TwitterClassDelegate <NSObject>

-(void)thisAccountTwitterLoadUpdated;
-(void)thisLoadTwitterContactsFinished;
-(void)thisSaveTwitterContactsFinished;

@end

@interface TwitterClass : NSObject<UIAlertViewDelegate>
{
    id<TwitterClassDelegate> delegate;
}

@property (nonatomic, retain) id<TwitterClassDelegate> delegate;
@property (nonatomic, retain) ACAccountStore *twitterAccountStore;
@property (nonatomic, retain) ACAccount *twitterAccount;
@property (nonatomic, retain) NSArray *twitterContacts;
@property (nonatomic, retain) NSDictionary *TWStatusDictionary;


+(id)sharedInstance;
-(void)loadContacts;
-(void)loadAccount;
-(void)saveContacts;

-(void)getTWContactWithId:(NSNumber*)idContact;// twitterAccount:(ACAccount *) twitterAccountSelected;
-(void)getLocationFromContact:(NSNumber *)idContact;
-(NSString *)formatDateFromCreateDate:(NSString *)dateString;
-(NSData *)loadLocations;
@end
