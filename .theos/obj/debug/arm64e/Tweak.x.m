#line 1 "Tweak.x"
@interface CKNavbarCanvasViewController : UIViewController
-(UINavigationController *)proxyNavigationController;
-(id)conversation;
@end

@interface CKNavigationBarCanvasView : UIView
@property (nonatomic, retain) UIView *leftItemView;
@property (nonatomic, retain) UIView *rightItemView;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL isFlooding;
-(CKNavbarCanvasViewController *)delegate;
-(void)sendString:(NSString *)arg1;
-(void)updateRightItem;
-(void)stopPressed;
@end

@interface CKMessagesSpammerViewController : UIViewController
@end

@interface CKChatController : UIViewController
-(void)sendCompositionWithoutThrow:(id)arg1 inConversation:(id)arg2;
-(id)conversation;
@end

@interface CKComposition : NSObject
-(id)initWithText:(id)arg1 subject:(id)arg2;
@end

@interface CKConversation : NSObject
@end

@implementation CKMessagesSpammerViewController
{
	NSInteger _mode;

	UILabel *_description;
	UITextView *_textView;
	UITextField *textField;
}


-(void)viewDidLoad {
	[super viewDidLoad];

	UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    	[tapBackground setNumberOfTapsRequired:1];
    	[self.view addGestureRecognizer:tapBackground];

	self.title = @"Message Flood";

	_mode = 0;

	
	
	
		self.view.backgroundColor = UIColor.blackColor;

	self.navigationItem.leftBarButtonItem.target = self;
	self.navigationItem.leftBarButtonItem.action = @selector(back);

	UILayoutGuide *margins = self.view.layoutMarginsGuide;

	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Fixed", @"Words", @"Count"]];
	[segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	segment.translatesAutoresizingMaskIntoConstraints = NO;
	segment.selectedSegmentIndex = _mode;
	[self.view addSubview:segment];

	[segment.topAnchor constraintEqualToAnchor:margins.topAnchor constant:self.navigationController.navigationBar.frame.size.height - 10].active = YES;
	[segment.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[segment.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;

	_description = [[UILabel alloc] init];
	_description.translatesAutoresizingMaskIntoConstraints = NO;
	_description.font = [UIFont systemFontOfSize:12];
	_description.textColor = UIColor.grayColor;
	[self.view addSubview:_description];

	[_description.topAnchor constraintEqualToAnchor:segment.bottomAnchor constant:10].active = YES;
	[_description.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:10].active = YES;
	[_description.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:10].active = YES;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Start Flooding" forState:UIControlStateNormal];
	[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[button setTitleColor:UIColor.lightGrayColor forState:UIControlStateHighlighted];
	button.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	button.layer.cornerRadius = 20;
	[self.view addSubview:button];

	[button.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[button.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
	[button.bottomAnchor constraintEqualToAnchor:margins.bottomAnchor].active = YES;
	[button.heightAnchor constraintEqualToConstant:100].active = YES;

	_textView = [[UITextView alloc] init];
	_textView.translatesAutoresizingMaskIntoConstraints = NO;
	_textView.layer.borderColor = UIColor.grayColor.CGColor;
	_textView.layer.borderWidth = 1;
	_textView.layer.cornerRadius = 10;
	[self.view addSubview:_textView];

	[_textView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[_textView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
	[_textView.topAnchor constraintEqualToAnchor:_description.bottomAnchor constant:10].active = YES;
	[_textView.bottomAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:10].active = YES;

	UILabel *limitDescription = [[UILabel alloc] init];
	limitDescription.text = @"Message Limit (0 for no limit)";
	limitDescription.translatesAutoresizingMaskIntoConstraints = NO;
	limitDescription.font = [UIFont systemFontOfSize:12];
	limitDescription.textColor = UIColor.grayColor;
	[self.view addSubview:limitDescription];

	[limitDescription.topAnchor constraintEqualToAnchor:_textView.bottomAnchor constant:10].active = YES;
	[limitDescription.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor constant:10].active = YES;
	[limitDescription.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor constant:10].active = YES;

	textField = [[UITextField alloc] init];
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	textField.text = @"0";
	[textField setKeyboardType:UIKeyboardTypeNumberPad];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:textField];

	[textField.topAnchor constraintEqualToAnchor:limitDescription.bottomAnchor constant:10].active = YES;
	[textField.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
	[textField.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
	[textField.bottomAnchor constraintEqualToAnchor:textField.topAnchor constant:25].active = YES;


	[self updateView];
}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


-(void)updateView {
	[UIView animateWithDuration:0.3f animations:
	^{
		switch (_mode)
		{
			case 0:
			{
				_description.text = @"Spam a fixed message.";
				_textView.alpha = 1;
				textField.alpha = 1;
				break;
			}

			case 1:
			{
				_description.text = @"Spam each word of a message individually.";
				_textView.alpha = 1;
				textField.alpha = 1;
				break;
			}

			case 2:
			{
				_description.text = @"Spam numbers counting up from 1.";
				_textView.alpha = 0;
				textField.alpha = 1;
				break;
			}
		}
	}];
}


-(void)segmentChanged:(UISegmentedControl *)arg1 {
	_mode = arg1.selectedSegmentIndex;
	[_textView resignFirstResponder];
	[self updateView];
}


-(void)startPressed:(UIButton *)arg1 {
	[self back];

	NSDictionary *info =
	@{
		@"message" : _textView.text ?: @"",
		@"mode" : @(_mode),
		@"limit": textField.text ?: @""
	};

	[NSNotificationCenter.defaultCenter postNotificationName:@"iFlooder.startFlooding" object:nil userInfo:info];
}


-(void)back {
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;

    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
	[self.navigationController popViewControllerAnimated:NO];
}
@end

static UIImage *UIKitImage(NSString *name)
{
    NSString *artworkPath = @"/System/Library/PrivateFrameworks/UIKitCore.framework/Artwork.bundle";
    NSBundle *artworkBundle = [NSBundle bundleWithPath:artworkPath];
    if (!artworkBundle)
    {
        artworkPath = @"/System/Library/Frameworks/UIKit.framework/Artwork.bundle";
        artworkBundle = [NSBundle bundleWithPath:artworkPath];
    }
    UIImage *img = [UIImage imageNamed:name inBundle:artworkBundle compatibleWithTraitCollection:nil];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CKComposition; @class CKNavigationBarCanvasView; @class CKChatController; 
static void (*_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview)(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$startFlooding$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL, NSNotification *); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$timerFired$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL, NSTimer *); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$stopPressed(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$updateRightItem(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$)(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL, UIView *); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL, UIView *); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$buttonPressed(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CKNavigationBarCanvasView$sendString$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST, SEL, NSString *); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CKComposition(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CKComposition"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CKChatController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CKChatController"); } return _klass; }
#line 221 "Tweak.x"

__attribute__((used)) static NSString * _logos_method$_ungrouped$CKNavigationBarCanvasView$message(CKNavigationBarCanvasView * __unused self, SEL __unused _cmd) { return (NSString *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$CKNavigationBarCanvasView$message); }; __attribute__((used)) static void _logos_method$_ungrouped$CKNavigationBarCanvasView$setMessage(CKNavigationBarCanvasView * __unused self, SEL __unused _cmd, NSString * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$CKNavigationBarCanvasView$message, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$_ungrouped$CKNavigationBarCanvasView$isFlooding(CKNavigationBarCanvasView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$CKNavigationBarCanvasView$isFlooding); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$CKNavigationBarCanvasView$setIsFlooding(CKNavigationBarCanvasView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$CKNavigationBarCanvasView$isFlooding, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static void _logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview(self, _cmd);

	self.isFlooding = NO;
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(startFlooding:) name:@"iFlooder.startFlooding" object:nil];
	[self updateRightItem];
}

static void _logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow(self, _cmd);

	[self updateRightItem];
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$startFlooding$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification * arg1) {

	self.isFlooding = YES;

	[self updateRightItem];

	self.message = arg1.userInfo[@"message"];
	NSInteger mode = [arg1.userInfo[@"mode"] intValue];
	NSInteger limit = [arg1.userInfo[@"limit"] intValue];

	void (^operation)() = nil;

	switch (mode)
	{
		case 0:
		{
			
			operation = ^()
			{
				static NSInteger runNum = 0;

				if(runNum < limit) {
					runNum = runNum + 1;
					[self sendString:self.message];
				}
				else if(limit == 0) {
					[self sendString:self.message];
				}
				else {
					[self stopPressed];
				}
				
			};

			break;
		}

		case 1:
		{
			operation = ^()
			{
				static NSInteger index = 0;
				static NSArray *words;
				static NSInteger runNum = 0;

				if(runNum < limit) {
					runNum = runNum + 1;
					if (!words) {
						words = [self.message componentsSeparatedByString:@" "];
					}

					[self sendString:words[index]];
					index = (++index == words.count) ? 0 : index;
				}
				else if(limit == 0) {
					if (!words) {
						words = [self.message componentsSeparatedByString:@" "];
					}

					[self sendString:words[index]];
					index = (++index == words.count) ? 0 : index;
				}
				else {
					[self stopPressed];
				}

			};

			break;
		}

		case 2:
		{
			operation = ^()
			{
				static NSUInteger count = 0;
				static NSInteger runNum = 0;

				if(runNum < limit) {
					runNum = runNum + 1;
					[self sendString:@(++count).stringValue];
				}
				else if(limit == 0) {
					[self sendString:@(++count).stringValue];
				}
				else {
					[self stopPressed];
				}

			};

			break;
		}
	}

	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:operation repeats:YES];
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$timerFired$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSTimer * arg1) {
	if (!self.isFlooding)
	{
		[arg1 invalidate];
		return;
	}

	void (^operation)() = arg1.userInfo;
	operation();
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$stopPressed(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	self.isFlooding = NO;

	[self updateRightItem];
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$updateRightItem(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	CGFloat width = self.leftItemView.frame.size.width;

	if (self.isFlooding)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self action:@selector(stopPressed) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:UIKitImage(@"UIButtonBarPause") forState:UIControlStateNormal];
		button.frame = CGRectMake(0, 0, width, width);
		self.rightItemView = button;
	}
	else
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:UIKitImage(@"UIButtonBarFastForward") forState:UIControlStateNormal];
		button.frame = CGRectMake(0, 0, width, width);
		self.rightItemView = button;
	}
}


static void _logos_method$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIView * arg1) {
	_logos_orig$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$(self, _cmd, arg1);

	if (!arg1)
	{
		self.rightItemView = nil;
		return;
	}

	[self updateRightItem];
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$buttonPressed(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	self.isFlooding = NO;
	CKMessagesSpammerViewController *vc = [[CKMessagesSpammerViewController alloc] init];

	CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;

    [self.delegate.proxyNavigationController.view.layer addAnimation:transition forKey:kCATransition];
	[self.delegate.proxyNavigationController pushViewController:vc animated:NO];
}



static void _logos_method$_ungrouped$CKNavigationBarCanvasView$sendString$(_LOGOS_SELF_TYPE_NORMAL CKNavigationBarCanvasView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * arg1) {	
	static CKChatController *controller;

	if (!controller)
	{
		controller = self.delegate.proxyNavigationController.childViewControllers.firstObject;

		if (![controller isKindOfClass:_logos_static_class_lookup$CKChatController()])
			controller = nil;
	}

	CKComposition *composition = [[_logos_static_class_lookup$CKComposition() alloc] initWithText:[[NSAttributedString alloc] initWithString:arg1] subject:nil];
	[controller sendCompositionWithoutThrow:composition inConversation:self.delegate.conversation];
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CKNavigationBarCanvasView = objc_getClass("CKNavigationBarCanvasView"); MSHookMessageEx(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(didMoveToSuperview), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview, (IMP*)&_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToSuperview);MSHookMessageEx(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(didMoveToWindow), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow, (IMP*)&_logos_orig$_ungrouped$CKNavigationBarCanvasView$didMoveToWindow);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(startFlooding:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$startFlooding$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(timerFired:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$timerFired$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(stopPressed), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$stopPressed, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(updateRightItem), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$updateRightItem, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(setLeftItemView:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$, (IMP*)&_logos_orig$_ungrouped$CKNavigationBarCanvasView$setLeftItemView$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(buttonPressed), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$buttonPressed, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(sendString:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$sendString$, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(NSString *)); class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(message), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$message, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(NSString *)); class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(setMessage:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$setMessage, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(isFlooding), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$isFlooding, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$CKNavigationBarCanvasView, @selector(setIsFlooding:), (IMP)&_logos_method$_ungrouped$CKNavigationBarCanvasView$setIsFlooding, _typeEncoding); } } }
#line 430 "Tweak.x"
