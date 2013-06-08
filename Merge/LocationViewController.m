//
//  LocationViewController.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "LocationViewController.h"
#import "TwitterClass.h"
#import "FacebookClass.h"
#import "LocationAnnotation.h"



@interface LocationViewController ()
{
    @private
        TwitterClass *twitterClass;
        FacebookClass *facebookClass;
    NSMutableDictionary *parsedLocationDictionary;
    NSUInteger totalNumberOfLocations;
    NSUInteger updatesCount;
}
-(void)searchTWLocation;
-(void)searchFBLocation;
-(void)populateMapWithMessage;
-(void)saveData:(NSData *)data;


@end


@implementation LocationViewController
@synthesize mapView;
@synthesize activityIndicator;

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
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = 40.429178;
    region.center.longitude = -3.7025;
    region.span.longitudeDelta = 1.5f;
    region.span.latitudeDelta = 1.5f;
    [self.mapView setRegion:region animated:YES];
    [self.mapView setDelegate:self];
    
    [self searchTWLocation];
    [self searchFBLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Location processing

-(void)searchTWLocation
{
    [self.activityIndicator startAnimating];
    NSMutableArray *locationAnnotations = [[NSMutableArray alloc]init];
    
    NSArray *tweets = [DBTwitterPost MR_findAll];
    
    int i = 0;
    while (i < [tweets count])
    {
        DBTwitterPost *twPost = [tweets objectAtIndex:i];
        
        if(([twPost.latitude doubleValue] != 0.0f) && ([twPost.longitude doubleValue] != 0.0f)){
           

            CLLocationCoordinate2D coord;
            coord.latitude = [twPost.latitude doubleValue];
            coord.longitude = [twPost.longitude doubleValue];
            
            DBTwitter *dbTwitter = [DBTwitter MR_findFirstByAttribute:@"idTwitter" withValue:[twPost valueForKey:@"idTwitter"]];
            LocationAnnotation *location = [[LocationAnnotation alloc] initWithImageURL:[[NSURL alloc] initWithString:dbTwitter.imageURL] title:dbTwitter.nickTwitter coordinate:coord];
            
            [locationAnnotations addObject:location];
        }
        i++;
    }
    
    if(locationAnnotations.count >0)
    {
        [mapView addAnnotations:locationAnnotations];
    }
    
    
}

-(void)searchFBLocation
{
    NSMutableArray *locationAnnotations = [[NSMutableArray alloc]init];
    
    
}

-(void)populateMapWithMessage
{
    
}

-(void)saveData:(NSData *)data
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[LocationAnnotation class]]){
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"LocationAnnotation"];
        
        if(annotationView == nil)
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LocationAnnotation"];
        
        annotationView.image = [UIImage imageNamed:@"BluePin.png"];
        annotationView.canShowCallout = YES;
        
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = disclosureButton;
        
        return annotationView;
    }
    return nil;
}

@end
