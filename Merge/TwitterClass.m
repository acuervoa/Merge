//
//  TwitterClass.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "TwitterClass.h"
#import "StatusObject.h"

@implementation TwitterClass
{
    NSArray *availableTwitterAccounts;
}


@synthesize delegate;

@synthesize twitterAccount;
@synthesize twitterAccountStore;
@synthesize twitterContacts;

@synthesize TWStatusDictionary;

+(id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)finishLoadAccount
{
    
    [delegate thisAccountTwitterLoadUpdated];
}

-(void)finishLoadContacts
{
    [delegate thisLoadTwitterContactsFinished];
}

-(void)finishSaveContacts
{
    [delegate thisSaveTwitterContactsFinished];
}

-(void)dealloc{
    delegate = nil;
}

-(void)loadAccount
{
   
    twitterAccountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if(![self twitterAccount]){
    
        [[self twitterAccountStore] requestAccessToAccountsWithType:twitterAccountType
                                                            options:nil
                                                         completion:^(BOOL granted, NSError *error)
         {
             if(granted)
             {
                 availableTwitterAccounts = [twitterAccountStore accountsWithAccountType:twitterAccountType];
                 
                 if(availableTwitterAccounts.count == 0)
                 {
                      [self showAlertView:@"Error" message:@"Twitter account not found."];
                 }
                 else if (availableTwitterAccounts.count == 1)
                 {
                     twitterAccount = [availableTwitterAccounts objectAtIndex:0];
                     [self finishLoadAccount];
                  }else{
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Twitter Account"
                                                                                        message:@"Select the Twitter account you want to use"
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"Cancel"
                                                                              otherButtonTitles:nil];
                                        
                                        for(ACAccount *twitterAccountElement in availableTwitterAccounts)
                                        {
                                            [alert addButtonWithTitle:twitterAccountElement.accountDescription];
                                        }
                                        
                                        [alert show];
                                    });
                     
                 }
             }else{
                 [self showAlertView:@"Error" message:@"Access to Twitter accounts was not granted"];
             }
         }];
    }else{
        [self finishLoadAccount];
    }
}

-(void)showAlertView:(NSString *) title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];

}

-(void)alertViewCancel
{
    [self finishSaveContacts];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0)
    {
        NSInteger indexInAvailableTwitterAccountsArray = buttonIndex - 1;
        twitterAccount = [availableTwitterAccounts objectAtIndex:indexInAvailableTwitterAccountsArray];
    }
    
    [self finishLoadAccount];
}

-(void)loadContacts
{
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/ids.json"];
    SLRequest *tweetRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodGET
                                                           URL:requestURL
                                                    parameters:nil];
    [tweetRequest setAccount:twitterAccount];
    
    [tweetRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if([urlResponse statusCode] == 200)
         {
             NSError *error;
             NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
             self.twitterContacts = [jsonDic objectForKey:@"ids"];
             [self finishLoadContacts];
            }
         else
         {
             [self showAlertView:@"Error" message:@"Error retrieving contacts"];
             
             NSLog(@"HTTP response status: %i\n, %@", [urlResponse statusCode], [urlResponse description]);
             [self finishLoadContacts];
         }
     }];  
}



-(void)saveContacts
{
    NSMutableDictionary *twitterCompleteContacts = [[NSMutableDictionary alloc]init];
    
    int i = 0;
    int quedan = twitterContacts.count;
    
    while (i <= twitterContacts.count) {
        
        NSArray *actualArray;
        NSRange theRange;
        
        theRange.location = i;
        if(quedan > 100)
            theRange.length = 100;
        else
            theRange.length=quedan;
        
        actualArray = [twitterContacts subarrayWithRange:theRange];
        
        NSDictionary *parametros = [NSDictionary dictionaryWithObjectsAndKeys:[actualArray componentsJoinedByString:@","], @"user_id",nil];
        
        
        NSDictionary *retrieveContactsF = [self retrieveContacts:parametros];
        
        twitterCompleteContacts = retrieveContactsF.mutableCopy;
        [self mergeContacts:twitterCompleteContacts]; 
        
        i = i + 100;
        quedan = quedan - theRange.length;
    }

 
    [self finishSaveContacts];
    
}

-(NSDictionary *)retrieveContacts:(NSDictionary *)idContacts{
    
    NSURL *urlResponse = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json"];
    __block NSDictionary *contacts;
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:urlResponse
                                               parameters:idContacts];
    [request setAccount:twitterAccount];
   
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if ([urlResponse statusCode] == 200) {
             NSError *error;
             NSDictionary *jsondic =  [NSJSONSerialization JSONObjectWithData:responseData
                                                                      options:kNilOptions
                                                                        error:&error];
             
             contacts = [self finishRetrieveContacts:jsondic];
         }
         else{
             [self showAlertView:@"Error" message:@"Error saving contacts"];
             NSLog(@"HTTP response status: %i\n", [urlResponse statusCode]);
         }
         dispatch_semaphore_signal(sema);
  
     }];
    
   dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
   
   return contacts;
}


-(NSDictionary *)finishRetrieveContacts:(NSDictionary *) retrieveContacts
{
    return retrieveContacts;
}

-(void)mergeContacts:(NSDictionary *)twitterCompleteContacts
{
  
        for(NSDictionary *twitterContact in twitterCompleteContacts)
        {
            NSString *twName = [twitterContact objectForKey:@"name"];
            if(twName){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@", twName];
                
                DBContact *contact = [DBContact MR_findFirstWithPredicate:predicate];
                
                if (contact == nil){
                    NSDictionary *contactDictionary = @{@"name":twName};
                    contact = [DBContact createEntityWithDictionary:contactDictionary];
                }
               
                
                [self saveTWContactsWithTWContact:twitterContact andIdContact:contact.idContact];
            }
            
        }

}

-(void)saveTWContactsWithTWContact:(NSDictionary *)twitterContact andIdContact:(NSNumber *)idContact
{
    //NSLog(@"%@", idContact);
    @try
    {
    DBTwitter *contactTW = [DBTwitter MR_findFirstByAttribute:@"idContact" withValue:idContact];
    
    NSString *picture = [twitterContact objectForKey:@"profile_image_url"];
    NSString *nick = [twitterContact objectForKey:@"screen_name"];
    NSString *idTwitter = [twitterContact objectForKey:@"id_str"];
    NSString *location = [twitterContact objectForKey:@"location"];

    if((NSNull*) location ==  [NSNull null]){
        location = @"";
    }
    
    NSDictionary *twDictionary = @{@"idContact":idContact,
                                   @"idTwitter":idTwitter,
                                   @"imageURL":picture,
                                   @"nickTwitter": nick,
                                   @"location": location
                                   };
    
    if(contactTW == nil){
        [DBTwitter createEntityWithDictionary:twDictionary];
    }else{
        [DBTwitter updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:twDictionary];
    }
    
    DBTwitterPost *twPost = [DBTwitterPost MR_findFirstByAttribute:@"idTwitter" withValue:idTwitter];
    
    NSDictionary *status = [twitterContact objectForKey:@"status"];
    
    if((NSNull *) status != [NSNull null]){
        NSString *idPost = [status objectForKey:@"id_str"];
        NSString *message = [status objectForKey:@"text"];
        NSNumber *latitude;
        NSNumber *longitude;
        
        NSDictionary *coordinates = [status objectForKey:@"coordinates"];
        if((NSNull *) coordinates != [NSNull null]){
            latitude = [[coordinates objectForKey:@"coordinates"] objectAtIndex:0];
            longitude = [[coordinates objectForKey:@"coordinates"] objectAtIndex:1];
        }else{
            latitude = 0;
            longitude = 0;
        }
        
        NSString *created_at = [status objectForKey:@"created_at"];
        
        NSString *fechaFormateada = [self formatDateFromCreateDate:created_at];
    
        NSDictionary *twPostDictionary = [NSDictionary dictionaryWithObjectsAndKeys:idPost, @"idPost",
                                          idTwitter, @"idTwitter",
                                          message, @"message",
                                          (NSNumber *)latitude, @"latitude",
                                          (NSNumber *)longitude, @"longitude",
                                          fechaFormateada, @"created_at", nil];
        if (twPost == nil)
            [DBTwitterPost createEntityWithDictionary:twPostDictionary];
        else
            [DBTwitterPost updateEntityWithIdTwitter:(NSNumber *)idTwitter withDictionary:twPostDictionary];
    }
    }@catch(NSException *ex){
        //NSLog(@"exception %@", ex);
    }@finally{
        //NSLog(@"finally %@", idContact);
    }
}



-(NSString *)formatDateFromCreateDate:(NSString *)dateString
{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date=[df dateFromString:dateString];
    [df setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
    NSString *dateStr = [df stringFromDate:date];
    
    return dateStr;
}

@end
