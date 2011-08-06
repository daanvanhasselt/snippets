//
//  CACubeViewController.h
//  CACube
//
//  Created by Daan on 05-08-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CACubeViewController : UIViewController {
    CALayer *backLayer;
    CALayer *leftLayer;
	CALayer *rightLayer;
    CALayer *upLayer;
    CALayer *downLayer;
    CALayer *frontLayer;
	
	NSTimer *timer;
	bool isFolded;
	bool isRotating;
}

-(void)setNewAnchorPointWithouthChangingFrame:(CGPoint)aPoint forLayer:(CALayer*)layer;
-(void)handleSingleTap:(UITapGestureRecognizer*)gr;
-(void)handleDoubleTap:(UITapGestureRecognizer*)gr;

@end
