//
//  GlossyButton.m
//  nommit
//
//  Created by Lucy Guo on 10/5/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "GlossyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation GlossyButton

- (id)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor*)backgroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeButtonShiny:self withBackgroundColor:backgroundColor];
        [[self titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        
    }
    return self;
}

- (void)makeButtonShiny:(GlossyButton*)button withBackgroundColor:(UIColor*)backgroundColor
{
    // Get the button layer and give it rounded corners with a semi-transparant button
    CALayer *layer = button.layer;
    layer.cornerRadius = 4.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    // Create a shiny layer that goes on top of the button
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    // Set the gradient colors
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    // Set the relative positions of the gradien stops
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.3f],
                            [NSNumber numberWithFloat:0.6f],
                            [NSNumber numberWithFloat:0.7f],
                            [NSNumber numberWithFloat:0.9f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    // Add the layer to the button
    [button.layer addSublayer:shineLayer];
    
    [button setBackgroundColor:backgroundColor];
    
//    if (self.state == UIControlStateHighlighted) {
//        [button setBackgroundColor: [UIColor redColor]];
//        [button setHighlighted: YES];
//    }
//    
//    else {
//        [button setBackgroundColor: [UIColor blueColor]];
//    }

}

// Add the following methods to the bottom
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}


@end
