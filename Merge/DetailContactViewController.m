//
//  DetailContactViewController.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "DetailContactViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PostObject.h"
#import "StatusObject.h"

@interface DetailContactViewController ()
{
    FacebookClass *fbContact;
    TwitterClass *twContact;
}

@end

@implementation DetailContactViewController

@synthesize currentContact;
@synthesize scrollView;

@synthesize nameLabel;
@synthesize emailLabel;
@synthesize phoneLabel;

@synthesize fbNameLabel;
@synthesize fbImageView;
@synthesize fbPostTextView;
@synthesize fbDatePostLabel;
@synthesize fbFromPostLabel;

@synthesize twNameLabel;
@synthesize twStatusTextView;
@synthesize twDateStatusLabel;
@synthesize twFromPostLabel;
@synthesize twImageView;

@synthesize FBPostDictionary;
@synthesize twitterAccountSelected;

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
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 800)];
	// Do any additional setup after loading the view.
    
    
    [self writeContact];
    
    DBFacebook *dbFacebook = [DBFacebook MR_findFirstByAttribute:@"idContact" withValue:currentContact.idContact];
    if(dbFacebook){
        [self writeFBContact];
    }
    
    DBTwitter *dbTwitter =[DBTwitter MR_findFirstByAttribute:@"idContact" withValue:currentContact.idContact];
    if(dbTwitter){
        [self writeTWContact];
    }
    
    //NSLog(@"%@", currentContact);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)writeContact
{
    nameLabel.text = currentContact.name;
    if(currentContact.email != nil){
        emailLabel.text = currentContact.email;
    }else{
        emailLabel.text = @"Email not found.";
        emailLabel.hidden = YES;
    }
    
    if(currentContact.phone != nil){
        phoneLabel.text = currentContact.phone;
        
    }else{
        phoneLabel.text = @"Telephone number not found.";
        phoneLabel.hidden = YES;
    }
}

-(void)writeFBContact
{
    fbContact = [[FacebookClass alloc]init];
    fbContact.delegate = self;
    [fbContact loadAccount];
   
}

-(void)writeTWContact
{
   
    twContact = [TwitterClass sharedInstance];
    twContact.delegate = self;
    [twContact loadAccount];
    
}

-(void) thisAccountLoadUpdated
{
    [fbContact getFBContactWithId:currentContact.idContact];
}

-(void) thisLoadContactsFinished
{
    [self performSelectorOnMainThread: @selector(writeFBContactInformation) withObject: self waitUntilDone: NO];
}

-(void)thisAccountTwitterLoadUpdated
{
    [self writeTWContactInformation];
}

-(void) thisLoadTwitterContactsFinished
{
    [self performSelectorOnMainThread:@selector(writeTWContactInformation) withObject:self waitUntilDone:NO];
}

-(NSDictionary * )indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey =0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return (NSDictionary *)mutableDictionary;
}

-(void)writeFBContactInformation
{
    
    PostObject *post = [[PostObject alloc] initWithJSonDict:fbContact.FBPostDictionary];
    

    fbPostTextView.text = [[NSString alloc] initWithFormat:@"%@%@%@%@%@",
                           [post.name length] == 0 ? @"" : [[NSString alloc] initWithFormat:@"%@\n",post.name],
                               [post.caption length] == 0 ? @"" : [[NSString alloc] initWithFormat:@"%@\n",post.caption],
                               [post.message length] == 0 ? @"" : [[NSString alloc] initWithFormat:@"%@\n",post.message],
                               [post.description length] == 0 ? @"" : [[NSString alloc] initWithFormat:@"%@\n",post.description],
                           [post.story length] == 0 ? @"" : [[NSString alloc] initWithFormat:@"%@\n",post.story]
                           ];
    fbDatePostLabel.text = [fbContact formatDateFromCreateDate:post.created_time];
    
    NSDictionary *fromPlace = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)post.place];
    
    NSDictionary *fromApplication = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)post.application];
    
    if([fromPlace count] != 0){
        fbFromPostLabel.text =[[NSString alloc] initWithFormat:@"%@",
                               [fromPlace objectForKey:@"location"]];
    }else if ([fromApplication count] != 0){
        fbFromPostLabel.text =[[NSString alloc] initWithFormat:@"%@",
                               [fromApplication objectForKey:@"name"]];
    }else{
        fbFromPostLabel.text = @"";
    }
    
    

  
       
    DBFacebook *dbFacebook = [DBFacebook MR_findFirstByAttribute:@"idContact" withValue:currentContact.idContact];
    
    [fbImageView setImageWithURL:[NSURL URLWithString:dbFacebook.imageURL] ];
    
}

-(NSString *)formatDateFromTimestamp:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];

    NSTimeInterval _interval = [time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}


-(void)writeTWContactInformation
{
    
    DBTwitter *dbTwitter = [DBTwitter MR_findFirstByAttribute:@"idContact" withValue:currentContact.idContact];
    twFromPostLabel.text = dbTwitter.location;
    twNameLabel.text = [[NSString alloc]initWithFormat:@"@%@", dbTwitter.nickTwitter];
    
    DBTwitterPost *dbTwitterPost = [DBTwitterPost MR_findFirstByAttribute:@"idTwitter" withValue:dbTwitter.idTwitter];
    twStatusTextView.text = dbTwitterPost.message;
    twDateStatusLabel.text = dbTwitterPost.created_at;
    
    [twImageView setImageWithURL:[NSURL URLWithString:dbTwitter.imageURL] ];
    
}
@end
