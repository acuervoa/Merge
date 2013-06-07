//
//  LoadProgressViewController.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "ViewController.h"
#import "AddressBookContact.h"
#import "FacebookClass.h"
#import "TwitterClass.h"

@interface LoadProgressViewController : ViewController<UIAlertViewDelegate, AddressBookContactDelegate, FacebookClassDelegate, TwitterClassDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, atomic) IBOutlet NSString *optionMenuSelected;

@end
