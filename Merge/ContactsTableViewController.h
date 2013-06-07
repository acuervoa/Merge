//
//  ContactsTableViewController.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBContact.h"
#import "DBFacebook.h"
#import "DBTwitter.h"
#import "ContactsTableViewCell.h"


@interface ContactsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *listOfContacts;

@end
