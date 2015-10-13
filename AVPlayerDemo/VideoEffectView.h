//
//  VideoEffectView.h
//  AVPlayerDemo
//
//  Created by apple on 3/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoEffectView : UIView
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *contrastSlider;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;

@end
