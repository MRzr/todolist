//
//  Titles.h
//  todolist
//
//  Created by Matt Razor on 21.02.13.
//  Copyright (c) 2013 Quantum Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Titles : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id;

@end
