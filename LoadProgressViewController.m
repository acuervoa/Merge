//
//  LoadProgressViewController.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "LoadProgressViewController.h"

@interface LoadProgressViewController ()

@end

@implementation LoadProgressViewController
{
    FacebookClass *facebookClass;
    TwitterClass *twitterClass;
}

@synthesize loadActivityIndicator;
@synthesize infoLabel;
@synthesize optionMenuSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLoadContacts];
    
	// Do any additional setup after loading the view.
    if([optionMenuSelected isEqualToString:@"loadAddressBook"])
    {
        AddressBookContact *addressBook = [[AddressBookContact alloc]init];
        addressBook.delegate = self;
        
        [addressBook loadContacts];
    }
    
    if ([optionMenuSelected isEqualToString:@"loadFacebookContacts"])
    {
        
        facebookClass = [[FacebookClass alloc]init];
        facebookClass.delegate = self;
        [facebookClass loadAccount];
    }
    
    if([optionMenuSelected isEqualToString:@"loadTwitterContacts"])
    {
        //        twitterClass = [[TwitterClass alloc]init];
        twitterClass = [TwitterClass sharedInstance];
        
        twitterClass.delegate = self;
        [twitterClass loadAccount];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) thisLoadUpdated{
    
    [self thisSaveContactsFinished];
    
}

-(void) thisAccountLoadUpdated{
    
    [self startLoadContacts];
    [facebookClass loadContacts];
}

-(void) startLoadContacts
{
    [loadActivityIndicator startAnimating];
    infoLabel.text = @"Start saving contacts. Wait a moment.";
    
}

-(void) thisLoadContactsFinished
{
    [facebookClass saveContacts];
    
}

-(void) thisSaveContactsFinished
{
    [loadActivityIndicator stopAnimating];
    infoLabel.text = @"Contacts saved.";
}

-(void)thisAccountTwitterLoadUpdated
{
    [self startLoadContacts];
    [twitterClass loadContacts];
}

-(void)thisLoadTwitterContactsFinished
{
    [twitterClass saveContacts];
}

-(void)thisSaveTwitterContactsFinished
{
    [self thisSaveContactsFinished];
}

@end
