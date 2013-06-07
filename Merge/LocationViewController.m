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
	
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = 40.429178;
    region.center.longitude = -3.7025;
    region.span.longitudeDelta = 1.5f;
    region.span.latitudeDelta = 1.5f;
    [self.mapView setRegion:region animated:YES];
    [self.mapView setDelegate:self];
    
    [self searchTWLocation];
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //twitterClass = [[TwitterClass alloc] init];
        twitterClass = [TwitterClass sharedInstance];
        NSData *data = [twitterClass loadLocations];
        [self performSelectorOnMainThread:@selector(saveData:) withObject:data waitUntilDone:YES];
        
    });
    
}

-(void)searchFBLocation
{
    
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
