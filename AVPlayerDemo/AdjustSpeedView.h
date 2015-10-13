//
//  AdjustSpeedView.h
//  AVPlayerDemo
//
//  Created by apple on 3/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustSpeedView : UIView
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIStepper *speedStepper;

@end
