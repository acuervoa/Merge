//
//  DetailContactViewController.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "ViewController.h"
#import "DBContact.h"
#import "FacebookClass.h"
#import "TwitterClass.h"

@class DetailContactViewController;
@protocol DetailContactViewControllerDelegate <NSObject>

@end
@interface DetailContactViewController : ViewController<FacebookClassDelegate, TwitterClassDelegate>

@property(strong, nonatomic) DBContact *currentContact;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *fbNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fbImageView;
@property (weak, nonatomic) IBOutlet UITextView *fbPostTextView;
@property (weak, nonatomic) IBOutlet UILabel *fbDatePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbFromPostLabel;

@property (weak, nonatomic) IBOutlet UILabel *twNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *twStatusTextView;
@property (weak, nonatomic) IBOutlet UILabel *twDateStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *twFromPostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *twImageView;

@property (retain, nonatomic) NSDictionary *FBPostDictionary;

@property (retain, nonatomic) ACAccount *twitterAccountSelected;

-(NSDictionary * ) indexKeyedDictionaryFromArray:(NSArray *)array;
@end
