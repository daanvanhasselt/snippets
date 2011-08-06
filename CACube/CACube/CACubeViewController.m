//
//  CACubeViewController.m
//  CACube
//
//  Created by Daan on 05-08-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CACubeViewController.h"

@implementation CACubeViewController

#define RECT_SIZE 100


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// setup gesture recognizers
	UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[self.view addGestureRecognizer:singleTapGestureRecognizer];

	UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapGestureRecognizer.numberOfTapsRequired = 2;
	[singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
	[self.view addGestureRecognizer:doubleTapGestureRecognizer];
	
	[singleTapGestureRecognizer release];
	[doubleTapGestureRecognizer release];

	
	// setup sublayerTransform, we use this for 'camera'
	CATransform3D initialSublayerTransform = CATransform3DIdentity;
	initialSublayerTransform.m34 = -1.0 / 800;	// for perspective
	initialSublayerTransform = CATransform3DRotate(initialSublayerTransform, -M_PI / 6.0f, 0, 1, 0);	// initial rotation
	self.view.layer.sublayerTransform = initialSublayerTransform;
	
	
	// setup all the individual layers
	backLayer = [CALayer layer];
	backLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	backLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
	backLayer.backgroundColor = [UIColor redColor].CGColor;
	
	frontLayer = [CALayer layer];
	frontLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	frontLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
	frontLayer.backgroundColor = [UIColor grayColor].CGColor;
	
	leftLayer = [CALayer layer];
	leftLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	leftLayer.position = CGPointMake(self.view.bounds.size.width/2 - RECT_SIZE, self.view.bounds.size.height/2);
	leftLayer.backgroundColor = [UIColor blueColor].CGColor;
	
	rightLayer = [CALayer layer];
	rightLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	rightLayer.position = CGPointMake(self.view.bounds.size.width/2 + RECT_SIZE, self.view.bounds.size.height/2);
	rightLayer.backgroundColor = [UIColor greenColor].CGColor;
	
	upLayer = [CALayer layer];
	upLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	upLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 - RECT_SIZE);
	upLayer.backgroundColor = [UIColor yellowColor].CGColor;
	
	downLayer = [CALayer layer];
	downLayer.bounds = CGRectMake(0, 0, RECT_SIZE, RECT_SIZE);
	downLayer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 + RECT_SIZE);
	downLayer.backgroundColor = [UIColor cyanColor].CGColor;

	// add all sublayers to the main layer
	[self.view.layer addSublayer:backLayer];
	[self.view.layer addSublayer:leftLayer];
	[self.view.layer addSublayer:rightLayer];
	[self.view.layer addSublayer:upLayer];
	[self.view.layer addSublayer:downLayer];
	[self.view.layer addSublayer:frontLayer];
	
	for (CALayer* layer in self.view.layer.sublayers) {	// set some parameters for all layers
		layer.borderWidth = 1;
		layer.borderColor = [UIColor blackColor].CGColor;
		layer.opacity = 0.75;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateCamera) userInfo:nil repeats:YES];		// fire timer for rotating camera
	isFolded = NO;	// not folded yet (single tap to toggle)
	isRotating = NO;	// not rotating yet (double tap to toggle)
}

-(void)rotateCamera{
	if(isRotating)
		self.view.layer.sublayerTransform = CATransform3DRotate(self.view.layer.sublayerTransform, 0.0025, 0, 1, 0);	// rotate sublayerTransform
}


-(void)setNewAnchorPointWithouthChangingFrame:(CGPoint)anchorPoint forLayer:(CALayer*)layer{
	[CATransaction setDisableActions:YES];	// disable implicit animations
	
	// get old and new anchorpoints in layer coordinate space
	CGPoint oldPoint = CGPointMake(layer.bounds.size.width * layer.anchorPoint.x, layer.bounds.size.height * layer.anchorPoint.y);	
	CGPoint newPoint = CGPointMake(layer.bounds.size.width * anchorPoint.x, layer.bounds.size.height * anchorPoint.y);
	
	// take rotation into account
	// ONLY WORKS FOR 2D ROTATION, 3D ROTATION CANNOT BE CONVERTED TO A CGAffineTransform
	newPoint = CGPointApplyAffineTransform(newPoint, CATransform3DGetAffineTransform(layer.transform));
    oldPoint = CGPointApplyAffineTransform(oldPoint, CATransform3DGetAffineTransform(layer.transform));
	
	// change position according to anchorpoint difference
	CGPoint position = layer.position;
	position.x -= oldPoint.x;
	position.y -= oldPoint.y;
	
	position.x += newPoint.x;
	position.y += newPoint.y;
	
	//set anchorpoint and new position
	layer.anchorPoint = anchorPoint;
	layer.position = position;
}

-(void)handleSingleTap:(UITapGestureRecognizer*)gr{
	// set anchor points
	[self setNewAnchorPointWithouthChangingFrame:CGPointMake(1.0, 0.5) forLayer:leftLayer];
	[self setNewAnchorPointWithouthChangingFrame:CGPointMake(0, 0.5) forLayer:rightLayer];
	[self setNewAnchorPointWithouthChangingFrame:CGPointMake(0.5, 1.0) forLayer:upLayer];
	[self setNewAnchorPointWithouthChangingFrame:CGPointMake(0.5, 0.0) forLayer:downLayer];


	[CATransaction setDisableActions:NO];	// enable implicit animation

	if(!isFolded){
		// fold to cube
		leftLayer.transform = CATransform3DRotate(leftLayer.transform, M_PI / 2.0, 0, 1, 0);
		rightLayer.transform = CATransform3DRotate(rightLayer.transform, -M_PI / 2.0, 0, 1, 0);
		upLayer.transform = CATransform3DRotate(upLayer.transform, -M_PI / 2.0, 1, 0, 0);
		downLayer.transform = CATransform3DRotate(downLayer.transform, M_PI / 2.0, 1, 0, 0);

		// translate the front layer
		frontLayer.transform = CATransform3DTranslate(frontLayer.transform, 0, 0, RECT_SIZE);
		isFolded = YES;
		return;
	}
	else{
		// unfold
		leftLayer.transform = CATransform3DRotate(leftLayer.transform, -M_PI / 2.0, 0, 1, 0);
		rightLayer.transform = CATransform3DRotate(rightLayer.transform, M_PI / 2.0, 0, 1, 0);
		upLayer.transform = CATransform3DRotate(upLayer.transform, M_PI / 2.0, 1, 0, 0);
		downLayer.transform = CATransform3DRotate(downLayer.transform, -M_PI / 2.0, 1, 0, 0);
		
		// translate the front layer back
		frontLayer.transform = CATransform3DTranslate(frontLayer.transform, 0, 0, -RECT_SIZE);
		isFolded = NO;
	}
}

-(void)handleDoubleTap:(UITapGestureRecognizer*)gr{
	// toggle rotation
	isRotating = isRotating ? NO : YES;
}

@end
