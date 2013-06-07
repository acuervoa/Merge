//
//  DBFacebookPost.h
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBFacebookPost : NSManagedObject

@property (nonatomic, retain) NSString * idFacebook;
@property (nonatomic, retain) NSString * idPost;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * idFacebookPost;

@end
