//
//  FirstTab.m
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import "FirstTab.h"
#import "AppDelegate.h"

@interface FirstTab () {
    NSManagedObjectContext *context;
}

@end

@implementation FirstTab
@synthesize table;
@synthesize label;
@synthesize editButton;
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
    UISwipeGestureRecognizer *switchTab = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(TabSwitch:)];
    switchTab.direction = UISwipeGestureRecognizerDirectionRight;
                [self.view addGestureRecognizer:switchTab];
                           
	// Do any additional setup after loading the view.
    [self setTitles];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView: (UITableView*) tableView{
    return 1;
}
-(NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section{
    return [self taskCount];
}
-(UITableViewCell *) tableView: (UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];        
    }
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
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
                      }}
                  i++;;
                  
       
    }
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(check:)];
swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(check:)];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
      swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeR];
        [cell addGestureRecognizer:swipeL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    
    
    
    return cell;
    
    
}
-(void)setTitles {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Titles" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"viewId like '1' or name like 'Today'"];
    [request setPredicate:predicate];
        NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
    if (matchingData.count <= 0) {
      
        NSManagedObject *new =[[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
        NSManagedObject *new2 =[[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
        NSManagedObject *new3 =[[NSManagedObject alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:context];
        NSError *error;
        [new setValue:@"1" forKey:@"viewId"];
        [new setValue:@"Today" forKey:@"name"];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Today"];
        [context save:&error];
        [new2 setValue:@"2" forKey:@"viewId"];
        [new2 setValue:@"This Month" forKey:@"name"];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"This Month"];
        [context save:&error];
        [new3 setValue:@"3" forKey:@"viewId"];
        [new3 setValue:@"This Year" forKey:@"name"];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"This Year"];
        [context save:&error];
   
    } 
       
        
        
        predicate = [NSPredicate predicateWithFormat:@"viewId like '1'"];
        [request setPredicate:predicate];
        matchingData = [context executeFetchRequest:request error:&error];
        for (NSManagedObject *obj in matchingData) {
            
            [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:[obj valueForKey:@"name"]];
            label.text = [obj valueForKey:@"name"];
        }
        predicate = [NSPredicate predicateWithFormat:@"viewId like '2'"];
        [request setPredicate:predicate];
        matchingData = [context executeFetchRequest:request error:&error];
        for (NSManagedObject *obj in matchingData) {
            
            [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:[obj valueForKey:@"name"]];
        }
        
        predicate = [NSPredicate predicateWithFormat:@"viewId like '3'"];
        [request setPredicate:predicate];
        matchingData = [context executeFetchRequest:request error:&error];
        for (NSManagedObject *obj in matchingData) {
            
            [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[obj valueForKey:@"name"]];
   
        
        
    }

}
-(NSInteger) taskCount {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
       NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
    return matchingData.count;}

- (IBAction)editTable:(id)sender {
    if (table.editing == true) {
        editButton.style = UIBarButtonItemStyleBordered;
        editButton.title = @"Edit";
         [table setEditing:NO animated:YES];
    } else  {
         editButton.style = UIBarButtonItemStyleDone;
           editButton.title = @"Done";
        [table setEditing:YES animated:YES];

    }   
}
-(void) viewDidAppear:(BOOL)animated {
  
    [table numberOfRowsInSection:[self taskCount]];
//[table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [UIView transitionWithView: self.table
                      duration: 0.25f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.table reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
     }];
    
}

-(void) check :(UIGestureRecognizer *)sender { 
    
    CGPoint p = [sender locationInView:self.table];
    
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",cell.textLabel.text];
  
    
    [request setPredicate:predicate];
    [request setEntity:entitydesc];
    
    NSError *error;
    NSArray *matchingData  = [context executeFetchRequest:request error:&error];
   
    
   
  
    if (table.editing == false) {
        
   
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
        for (NSManagedObject *obj in matchingData) {
            [obj setValue:@"false" forKey:@"complete"];

        }
    }else if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor grayColor]; for (NSManagedObject *obj in matchingData) {
            [obj setValue:@"true" forKey:@"complete"];
 
        }
       
    }  [context save:&error];
     // [table reloadData];
     }
        }
-(void) TabSwitch:(UIGestureRecognizer *)sender {
      [self.tabBarController setSelectedIndex:1];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
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
@end
