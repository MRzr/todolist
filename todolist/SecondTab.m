//
//  SecondTab.m
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import "SecondTab.h"
#import "AppDelegate.h"
#import "AddTask.h"
@interface SecondTab () {
    NSManagedObjectContext *context;
    
}

@end

@implementation SecondTab
@synthesize table;
@synthesize label;
@synthesize editButton, addButton;
@synthesize popoverController;

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
    UISwipeGestureRecognizer *switchTab = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(TabSwitchL:)];
    switchTab.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:switchTab];
    UISwipeGestureRecognizer *switchTab2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(TabSwitchR:)];
    switchTab2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:switchTab2];
    
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView: (UITableView*) tableView{
    return 3;
}
-(NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sss = [NSString stringWithFormat:@"%ld", (long)section];
    
    return [self taskCount: sss];
}
-(UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Month" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"priority" ascending:YES];
    NSString *priority = [NSString stringWithFormat:@"%ld", (long)[indexPath section]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority like %@", priority];
    [request setPredicate:predicate];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
    
    
    int i=0;
    for (NSManagedObject *obj in matchingData) {
        if(i == indexPath.row) {
            cell.textLabel.text = [obj valueForKey:@"name"];
            if ([[obj valueForKey:@"complete"] isEqualToString:@"true"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = [UIColor grayColor];
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textColor = [UIColor blackColor];
                
            }
        }
        i++;
        
        
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check:)];
    [cell addGestureRecognizer:tap];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    
    
    return cell;
    
    
}
-(void)setTitles {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"first_tab_name"] == nil)
        [defaults setObject:@"Today" forKey:@"first_tab_name"];
    if ([defaults objectForKey:@"second_tab_name"] == nil)
        [defaults setObject:@"This Month" forKey:@"second_tab_name"];
    if ([defaults objectForKey:@"third_tab_name"] == nil)
        [defaults setObject:@"This Year" forKey:@"third_tab_name"];
    [defaults synchronize];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:[defaults objectForKey:@"first_tab_name"]];
    
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:[defaults objectForKey:@"second_tab_name"]];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[defaults objectForKey:@"third_tab_name"]];
    
    
}


-(NSInteger) taskCount: (NSString*) sectionIndex {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Month" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority like %@", sectionIndex];
    [request setPredicate:predicate];
    [request setEntity:entitydesc];
    NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
    
    
    return matchingData.count;}

- (IBAction)editTable:(id)sender {
    if (self.popoverController == nil) {
        [self showPopover:@"ClearTask" fromButton:editButton];}
    else {
        [self.popoverController dismissPopoverAnimated:YES];
        
        self.popoverController = nil;
        [self showPopover:@"ClearTask" fromButton:editButton];
    }
    
    
}
-(void) viewDidAppear:(BOOL)animated {
    [self setTitles];
    editButton.title = @"Clear";
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setValue:@"Month" forKey:@"tab"];
}

-(void) check :(UIGestureRecognizer *)sender {
    
    CGPoint p = [sender locationInView:self.table];
    
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Month" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",cell.textLabel.text];
    
    
    [request setPredicate:predicate];
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
    
    
    
    
    if (table.editing == false) {
        
        /*  PRO Long Press
         if (sender.state != UIGestureRecognizerStateBegan) {
         return;
         } else { */
        
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
            for (NSManagedObject *obj in matchingData) {
                [obj setValue:@"false" forKey:@"complete"];
                
            }
        }else if(cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor grayColor];
            for (NSManagedObject *obj in matchingData) {
                [obj setValue:@"true" forKey:@"complete"];
                [table reloadData];
            }
            //}
            
        }
        [context save:&error];
        return;
        // [table reloadData];
    }
}
-(void) TabSwitchL:(UIGestureRecognizer *)sender {
    [self.tabBarController setSelectedIndex:0];
    
}
-(void) TabSwitchR:(UIGestureRecognizer *)sender {
    [self.tabBarController setSelectedIndex:2];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Month" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",cell.textLabel.text];
    
    
    [request setPredicate:predicate];
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *obj in matchingData) {
        [context deleteObject:obj];
    }
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)showPopover: (NSString *) identifier fromButton: (UIBarButtonItem *) button {
    
    if (self.popoverController == nil)
    {
        AddTask *content = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:content];
        self.popoverController = popover;
        
        
        // Listen for the "done" notification which will be posted
        // by the button in the content view controller.
        // When the notification is received,
        // call the contentFooViewControllerDone: method...
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(contentFooViewControllerDone:)
         name:@"contentFooViewControllerDone"
         object:popoverController.contentViewController];
        
    }
    
    // OR
    [self.popoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (IBAction)addTask:(id)sender {
    
    
    if (self.popoverController == nil) {
        
        [self showPopover:@"AddTask" fromButton:addButton];}
    else {
        editButton.style = UIBarButtonItemStyleBordered;
        editButton.title = @"Edit";
        [table setEditing:NO animated:YES];
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        [self showPopover:@"AddTask" fromButton:addButton];
    }
}

- (void)contentFooViewControllerDone:(NSNotification *)notification
{
    // Button in content view controller was tapped, dismiss popover...
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    
    
    //[table numberOfRowsInSection:[self taskCount]];
    //[table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [UIView transitionWithView: self.table
                      duration: 0.25f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     { editButton.style = UIBarButtonItemStyleBordered;
         editButton.title = @"Edit";
         [table setEditing:NO animated:YES];
         
         
         [self.table reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
         
     }];
    
    
}
-(void) uncheckAll {
    /*
     for (int i=0; i<= [self taskCount]; i++) {
     UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
     cell.accessoryType = UITableViewCellAccessoryNone;
     cell.textLabel.textColor = [UIColor blackColor];
     NSLog(@"uncheck all");
     }*/
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(20.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"High priority", @"High");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Normal priority", @"Normal");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Low priority", @"Low");
            break;
        default:
            sectionName = @"";
            break;
    }
	headerLabel.text = sectionName; // i.e. array element
	[customView addSubview:headerLabel];
    
	return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}
@end
