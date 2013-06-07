//
//  PostObject.h
//  Merge
//
//  Created by Andres Cuervo Adame on 03/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostObject : NSObject

@property NSString *message;
@property NSString *picture;
@property NSString *link;
@property NSString *name;
@property NSString *caption;
@property NSString *description;
@property NSString *source;
@property NSData *privacy;
@property NSString *type;
@property NSObject *place;
@property NSObject *application;
@property NSString *created_time;
@property NSString *updated_time;
@property BOOL *include_hidden;
@property NSString *status_type;
@property NSString *story;

-( PostObject *)initWithJSonDict: (NSDictionary *) jsonDict;
- (PostObject *)readPost;
- (NSString *)writePost;


@end
