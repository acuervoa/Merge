//
//  PostObject.m
//  Merge
//
//  Created by Andres Cuervo Adame on 03/06/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "PostObject.h"

@implementation PostObject

@synthesize message;
@synthesize picture;
@synthesize link;
@synthesize name;
@synthesize caption;
@synthesize description;
@synthesize source;
@synthesize privacy;
@synthesize type;
@synthesize place;
@synthesize application;
@synthesize created_time;
@synthesize updated_time;
@synthesize include_hidden;
@synthesize status_type;
@synthesize story;

-(PostObject *)initWithJSonDict: (NSDictionary *) jsonDict{
    
    message = [jsonDict objectForKey:@"message"];
    picture = [jsonDict objectForKey:@"picture"];
    link = [jsonDict objectForKey:@"link"];
    name = [jsonDict objectForKey:@"name"];
    caption = [jsonDict objectForKey:@"caption"];
    description = [jsonDict objectForKey:@"description"];
    source = [jsonDict objectForKey:@"source"];
    privacy = [jsonDict objectForKey:@"privacy"];
    type = [jsonDict objectForKey:@"type"];
    place = [jsonDict objectForKey:@"place"];
    application = [jsonDict objectForKey:@"application"];
    created_time = [jsonDict objectForKey:@"created_time"];
    updated_time = [jsonDict objectForKey:@"updated_time"];
    //    include_hidden = jsonDict objectForKey:@"include_hidden"];
    status_type = [jsonDict objectForKey:@"status_type"];
    story = [jsonDict objectForKey:@"story"];
   
    return self;
}

- (PostObject *)readPost
{
    return nil;
}
- (NSString *)writePost
{
    NSString *post = [[NSString alloc]initWithFormat:@"message %@ \n picture %@ \n link %@ \n name %@ \n caption %@ \n description %@ \n source %@ \n created_time %@ \n",message, picture, link, name, caption, description, source, created_time ];
    return post;
}

@end
