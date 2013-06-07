//
//  AddressBook.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "AddressBookContact.h"


@implementation AddressBookContact
@synthesize delegate;

-(BOOL)finishLoad{
    [delegate thisLoadUpdated];
    return YES;
}

-(void)dealloc{
    delegate = nil;
}

-(void)loadContacts
{
    CFErrorRef myError = nil;
    ABAddressBookRef *addressBook = ABAddressBookCreateWithOptions(nil, &myError);
    
    if (nil == addressBook)
    {
        NSLog(@"error: %@", myError);
        [self finishLoad];
        
    }    
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i = 0; i < nPeople; i++)
    {
        NSDictionary *peopleDictionary = [[NSDictionary alloc]init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName =(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        NSString *name = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName ];
        NSLog(@"%@", name);
        peopleDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [peopleDictionary setValue:firstName forKey:@"firstName"];
        [peopleDictionary setValue:lastName forKey:@"lastName"];
        [peopleDictionary setValue:name forKey:@"name"];
      
        
        ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(numbers) > 0){
            CFStringRef number = ABMultiValueCopyValueAtIndex(numbers,0);
            [peopleDictionary setValue:(__bridge_transfer NSString *)number forKey:@"phone"];
            CFRelease(number);
        }
        
        ABMultiValueRef addressRecord = ABRecordCopyValue(person, kABPersonAddressProperty);
        if (ABMultiValueGetCount(addressRecord) > 0){
            CFDictionaryRef addressDictionary =ABMultiValueCopyValueAtIndex(addressRecord, 0);
            NSString *city = [NSString stringWithString:(__bridge_transfer NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressCityKey)];
            [peopleDictionary setValue:city forKey:@"address"];
            CFRelease(addressDictionary);
        }
        
        ABMultiValueRef emailRecord = ABRecordCopyValue(person, kABPersonEmailProperty);
        if(ABMultiValueGetCount(emailRecord) > 0){
            CFStringRef email = ABMultiValueCopyValueAtIndex(emailRecord, 0);
            [peopleDictionary setValue:(__bridge_transfer NSString *)email forKey:@"email"];
            CFRelease(email);
        }
        
        NSArray *contact;
        if([peopleDictionary objectForKey:@"email"] != nil)
        {
            contact = [DBContact MR_findFirstByAttribute:@"email" withValue: [peopleDictionary objectForKey:@"email"]];
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY lastName CONTAINS[c] %@", [peopleDictionary objectForKey:@"lastName"]];
            contact = [DBContact MR_findFirstWithPredicate:predicate];
        }
        
        if(contact == nil)
        {
            DBContact *newContact = [DBContact createEntityWithDictionary:peopleDictionary];
            
            
        }else{
            DBContact *newContact = [DBContact updateEntityWithIdContact:[peopleDictionary objectForKey:@"idContact"] withDictionary:peopleDictionary];
        }
        
        

    
    }

    CFRelease(addressBook);
    
    [self finishLoad];
    
}

@end
