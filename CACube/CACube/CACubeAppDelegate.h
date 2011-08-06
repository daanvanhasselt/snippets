//
//  CACubeAppDelegate.h
//  CACube
//
//  Created by Daan on 05-08-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CACubeViewController;

@interface CACubeAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CACubeViewController *viewController;

@end
