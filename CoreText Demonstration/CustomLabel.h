//
//  CustomLabel.h
//  CoreText Demonstration
//
//  Created by Robert Ryan on 4/17/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat fontSize;

@end
