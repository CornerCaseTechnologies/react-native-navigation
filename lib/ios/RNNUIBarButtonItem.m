#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNNUIBarButtonItem.h"
#import "RCTConvert+UIBarButtonSystemItem.h"

@interface RNNUIBarButtonItem ()

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) RNNReactComponentRegistry *componentRegistry;

@end

@implementation RNNUIBarButtonItem

-(instancetype)init:(NSString*)buttonId withIcon:(UIImage*)iconImage {
	self = [super initWithImage:iconImage style:UIBarButtonItemStylePlain target:self action:@selector(onButtonPressed)];
  	self.buttonId = buttonId;
	return self;
}

-(instancetype)init:(NSString*)buttonId withTitle:(NSString*)title {
	self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
	self.buttonId = buttonId;
	return self;
}

-(instancetype)init:(NSString*)buttonId withCustomView:(RCTRootView *)reactView componentRegistry:(RNNReactComponentRegistry *)componentRegistry {
	self = [super initWithCustomView:reactView];
	
	self.componentRegistry = componentRegistry;
	reactView.sizeFlexibility = RCTRootViewSizeFlexibilityWidthAndHeight;
	reactView.delegate = self;
	reactView.backgroundColor = [UIColor clearColor];
	reactView.hidden = YES;
	
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:reactView
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationEqual
														   toItem:nil
														attribute:NSLayoutAttributeNotAnAttribute
													   multiplier:1.0
														 constant:1.0];
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:reactView
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
														   	toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
													   	multiplier:1.0
														  constant:1.0];
	[NSLayoutConstraint activateConstraints:@[self.widthConstraint, self.heightConstraint]];
	self.buttonId = buttonId;
	return self;
}
	
- (instancetype)init:(NSString*)buttonId withSystemItem:(NSString *)systemItemName {
	UIBarButtonSystemItem systemItem = [RCTConvert UIBarButtonSystemItem:systemItemName];
	self = [super initWithBarButtonSystemItem:systemItem target:nil action:nil];
	self.buttonId = buttonId;
	return self;
}

- (void)rootViewDidChangeIntrinsicSize:(RCTRootView *)rootView {
	rootView.hidden = NO;
	self.widthConstraint.constant = rootView.intrinsicContentSize.width;
	self.heightConstraint.constant = rootView.intrinsicContentSize.height;
	[rootView setNeedsUpdateConstraints];
	[rootView updateConstraintsIfNeeded];
}

- (void)onButtonPressed {
	[self.target performSelector:self.action
					  withObject:self
					  afterDelay:0];
}

- (void)dealloc {
	if ([self.customView isKindOfClass:[RNNReactView class]]) {
		RNNReactView* customView = self.customView;
		[self.componentRegistry removeChildComponent:customView.componentId];
	}
}

@end
