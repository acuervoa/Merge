//
//  ContactsTableViewController.m
//  Merge
//
//  Created by Andres Cuervo Adame on 29/05/13.
//  Copyright (c) 2013 Andres Cuervo Adame. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailContactViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController

@synthesize listOfContacts;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    listOfContacts = [DBContact MR_findAllSortedBy:@"name" ascending:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [listOfContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactTableCell";
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    DBContact *contact = [self.listOfContacts objectAtIndex:[indexPath row]];
    //cell.imageView.image = [NSURL URLWithString:contact.imageFile];
    cell.textLabel.text = contact.name;
    if (contact.imageFile == nil){
        
        DBFacebook *facebook = [DBFacebook MR_findFirstByAttribute:@"idContact" withValue:contact.idContact];
        
        if (facebook != nil){
            //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,0.0f,100.0f,100.0f)];
            NSURL *url = [[NSURL alloc] initWithString:facebook.imageURL];
            [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        } else {
            
            DBTwitter *twitter = [DBTwitter MR_findFirstByAttribute:@"idContact" withValue:contact.idContact];
            
            if(twitter != nil){
                //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,0.0f,100.0f,100.0f)];
                NSURL *url = [[NSURL alloc] initWithString:twitter.imageURL];
                [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }
        
        
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DBContact *chosenContact = [self.listOfContacts objectAtIndex:indexPath.row];
    [(DetailContactViewController *)[segue destinationViewController] setCurrentContact:chosenContact];
}
@end
