//
//  FacebookClass.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "FacebookClass.h"

@implementation FacebookClass
@synthesize delegate;

@synthesize facebookAccount;
@synthesize facebookAccountStore;
@synthesize facebookContacts;

@synthesize FBPostDictionary;


-(void)finishLoadAccount
{
    NSLog(@"finishLoadAccount");
    [delegate thisAccountLoadUpdated];
    
}

-(void)finishLoadContacts
{
    NSLog(@"finishLoadContacts");
    [delegate thisLoadContactsFinished];
   
}

-(void)finishSaveContacts
{
    NSLog(@"finishSaveContacts");
    [delegate thisSaveContactsFinished];
   
}

-(void)dealloc{
    delegate = nil;
}

-(void)loadAccount
{
    facebookAccountStore = [[ACAccountStore alloc] init];
    facebookAccount = [[ACAccount alloc]init];
    
    ACAccountType *facebookAccountType = [facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    //Specify App Id an permissions
    NSDictionary *options = @{
                              ACFacebookAppIdKey: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"],
                              ACFacebookPermissionsKey:@[@"email",@"read_stream", @"user_hometown", @"user_location", @"friends_hometown",@"friends_location" ],
                              ACFacebookAudienceKey:ACFacebookAudienceFriends
                              };
    [facebookAccountStore requestAccessToAccountsWithType:facebookAccountType
                                                  options:options
                                               completion:^(BOOL granted, NSError *error) {
                                                   
                                                   if (granted)
                                                   {
                                                       NSArray *accounts = [facebookAccountStore accountsWithAccountType:facebookAccountType];
                                                       if([accounts count]>0)
                                                       {
                                                           facebookAccount = [accounts lastObject];
                                                           [self finishLoadAccount];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       if ([error code] == 6) {
                                                            [self throwAlertWithTitle:@"Error" message:@"Account not found. Please setup your account in settings app."];
                                                       }
                                                       else{
                                                            [self throwAlertWithTitle:@"Error" message:@"Account access denied"];
                                                       }
                                                       
                                                   }
                                                   
                                                   
                                               }];

}

-(void)throwAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
    
}


-(void)loadContacts
{
    NSString *accessToken = [NSString stringWithFormat:@"%@", facebookAccount.credential.oauthToken];
    NSDictionary *parameters = @{@"access_token":accessToken, @"fields": @"id,name,first_name,last_name, picture, email"};
    NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodGET
                                                          URL:feedURL
                                                   parameters:parameters];
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (error){
             [self throwAlertWithTitle:@"Error" message:@"An error ocurred at Facebook connection. Try again."];
         }
         else
         {
             NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
             //NSLog(@"jSonDic %@", jsonDic);
             self.facebookContacts = [[NSArray alloc] initWithArray:[jsonDic objectForKey:@"data"]];
             
         }
         
         
                     
           [self finishLoadContacts];
        }];
}

-(void)saveContacts
{
        NSDictionary *fbContact = [[NSDictionary alloc]init];
    for(fbContact in self.facebookContacts)
    {
        NSString *fbName = [fbContact objectForKey:@"name"];
        NSString *fbFirstName = [fbContact objectForKey:@"first_name"];
        NSString *fbLastName = [fbContact objectForKey:@"last_name"];
        
        
        NSString *formatFBLastName = [[NSString alloc] initWithFormat:@"*%@*", fbLastName];
        NSString *formatFBFirstName = [[NSString alloc] initWithFormat:@"*%@*", fbFirstName];
        NSString *formatFBName = [[NSString alloc] initWithFormat:@"*%@ %@*", fbFirstName,fbLastName];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY lastName LIKE[c] %@ AND ANY firstName LIKE[c] %@) OR (ANY name Like[c] %@)",
                                  formatFBLastName,formatFBFirstName, formatFBName];
        
        DBContact *contact = [DBContact MR_findFirstWithPredicate:predicate];
        NSDictionary *contactDictionary = @{@"firstName":fbFirstName,
                                            @"lastName":fbLastName,
                                            @"name": fbName
                                            };

        if (contact == nil){
                        
            contact = [DBContact createEntityWithDictionary:contactDictionary];
           
        }else{
            [DBContact updateEntityWithIdContact:contact.idContact withDictionary:contactDictionary];
        }
        
        [self saveFBContactsWithFBContact:fbContact andIdContact:contact.idContact];
        
        
    }
    
    [self finishSaveContacts];
}

-(void)saveFBContactsWithFBContact:(NSDictionary *)fbContact andIdContact:(NSNumber *)idContact
{
    DBFacebook *contactFB = [DBFacebook MR_findFirstByAttribute:@"idContact" withValue:idContact];

    
    NSDictionary *picture = [[NSDictionary alloc] initWithDictionary:[fbContact objectForKey:@"picture"]];
    NSDictionary *dataPicture = [[NSDictionary alloc] initWithDictionary:[picture objectForKey:@"data"]];
    
    NSDictionary *fbDictionary = @{@"idContact":idContact,
                                   @"idFacebook":[fbContact objectForKey:@"id"],
                                   @"imageURL":[dataPicture objectForKey:@"url"]
                                   };
    
    if(contactFB == nil)
        [DBFacebook createEntityWithDictionary:fbDictionary];
    else
        [DBFacebook updateEntityWithIdFacebook:(NSNumber *)contactFB.idFacebook withDictionary:fbDictionary];
    
}

-(NSDictionary *)getFBContactWithId:(NSNumber *)idContact
{
    DBFacebook *contactFB = [DBFacebook  MR_findFirstByAttribute:@"idContact" withValue:idContact];
                             
    NSString *idFBContact = contactFB.idFacebook;
    
    NSString *accessToken = [NSString stringWithFormat:@"%@", facebookAccount.credential.oauthToken];
    NSString *fql=[NSString stringWithFormat:@"SELECT post_id FROM stream WHERE source_id = %@ limit 1", idFBContact];
    NSLog(@"fql %@",fql);
    NSDictionary *parameters = @{@"q":fql,@"access_token":accessToken};
 
    NSURL *feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/fql"]];
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodGET
                                                          URL:feedURL
                                                   parameters:parameters];
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (error){
             [self throwAlertWithTitle:@"Error" message:@"An error ocurred at Facebook connection. Try again."];
         }
         else
         {
             NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
             
             NSArray *test =[[NSArray alloc] initWithArray:[jsonDic objectForKey:@"data"]];
             
             NSDictionary *contact = [[NSDictionary alloc]init];
             
             for(contact in test){
                 [self getPostInfoFromId: [contact objectForKey:@"post_id"]];
             }
         }
         
         
     }];

    return self.FBPostDictionary;
    
}

-(void)getPostInfoFromId:(NSString *)postId
{
    
  
    
    NSString *accessToken = [NSString stringWithFormat:@"%@", facebookAccount.credential.oauthToken];
    NSDictionary *parameters = @{@"access_token":accessToken};
    NSString *formatURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@", postId];
    //NSLog(@"formatURL %@", formatURL);
    NSURL *feedURL = [NSURL URLWithString:formatURL];
    //NSLog(@"feedURL %@",feedURL);
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodGET
                                                          URL:feedURL
                                                   parameters:parameters];
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (error){
             [self throwAlertWithTitle:@"Error" message:@"An error ocurred at Facebook connection. Try again."];
         }
         else
         {
             NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
             NSLog(@"jSonDic %@", jsonDic);
             self.FBPostDictionary = jsonDic;
             
             [self finishLoadContacts];
             
             
         }
         
         
     }];

}

-(void)getLocationFromContact:(NSNumber *)idContact
{
    DBFacebook *contactFB = [DBFacebook  MR_findFirstByAttribute:@"idContact" withValue:idContact];
    
    NSString *idFBContact = contactFB.idFacebook;
    
    NSString *accessToken = [NSString stringWithFormat:@"%@", facebookAccount.credential.oauthToken];
    NSString *fql=[NSString stringWithFormat:@"SELECT message, latitude, longitude FROM location_post WHERE author_uid = %@ limit 10", idFBContact];
    NSLog(@"fql %@",fql);
    NSDictionary *parameters = @{@"q":fql,@"access_token":accessToken};
    
    NSURL *feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/fql"]];
    
    SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodGET
                                                          URL:feedURL
                                                   parameters:parameters];
    
    feedRequest.account = facebookAccount;
    
    [feedRequest performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (error){
             [self throwAlertWithTitle:@"Error" message:@"An error ocurred at Facebook connection. Try again."];
         }
         else
         {
             NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:kNilOptions
                                                                       error:&error];
             NSLog(@"jSonDic %@", jsonDic);
             self.FBPostDictionary = jsonDic;
             
         }
         
         [self finishLoadContacts];
     }];
    
   
}

-(NSString *)formatDateFromCreateDate:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    
    return formattedDateString;
}


@end
