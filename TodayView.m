//
//  TodayView.m
//  Today
//
//  Created by Matt Sephton on 08/04/2009.
//  Copyright (c) 2009, Boowoop Limited. All rights reserved.
//

#import "TodayView.h"

@implementation TodayView

@synthesize animationTimer;

static NSString * const MyModuleName = @"com.gingerbeardman.today";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		ScreenSaverDefaults *defaults;
		defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	    [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"showDate", @"YES", @"showTime", @"NO", @"showTimeShort", @"NO", @"showDay", @"5", @"colorCombo", @"YES", @"randomCheck", nil]];

		NSError *err = nil;
//		NSString *fontName = @"AvantGarGotItcT-Medi";
		NSString *fontName = @"TodayAG";
		if (![self loadLocalFonts:&err requiredFonts:[NSArray arrayWithObject:fontName]] && err) {
			NSBeep();
		}
//		NSLog(@"fonts: %@", [[NSFontManager sharedFontManager] availableFonts]);
		
		if ([defaults boolForKey:@"randomCheck"] == YES) {
			bgcolor = (arc4random() % 12);
		} else {
			bgcolor = [defaults integerForKey:@"colorCombo"];
		}
		
		[self setAnimationTimeInterval:1];	// every second, was 1/30.0

		[self startAnimation];
    }
	
    return self;
}

- (void)startAnimation
{
    [super startAnimation];

	if (self.animationTimer == nil) {
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
			[self setNeedsDisplay: true];
		}];
		[self.animationTimer fire];
	}
}

- (void)stopAnimation
{
    [super stopAnimation];

	if (self.animationTimer != nil) {
		[self.animationTimer invalidate];
	}
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];

	[self drawToday];
}

//- (BOOL)isOpaque {
//	// this keeps Cocoa from unneccessarily redrawing our superview
//	return YES;
//}

- (void)animateOneFrame
{
//	[self drawToday];
}

- (void)drawToday
{
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	
	NSSize screenSize = [self bounds].size;
	
	//background colour
	NSRect bg = NSMakeRect(0,0, screenSize.width,screenSize.height);
	switch (bgcolor) {
		case 0:		//black
			[[NSColor colorWithCalibratedRed:8/255.0 green:8/255.0 blue:8/255.0 alpha:1.0] set];
			break;
		case 1:		//blue
			[[NSColor colorWithCalibratedRed:8/255.0 green:16/255.0 blue:56/255.0 alpha:1.0] set];
			break;
		case 2:		//brown
			[[NSColor colorWithCalibratedRed:128/255.0 green:86/255.0 blue:48/255.0 alpha:1.0] set];
			break;
		case 3:		//cyan
			[[NSColor colorWithCalibratedRed:8/255.0 green:128/255.0 blue:128/255.0 alpha:1.0] set];
			break;
		case 4:		//dark gray
			[[NSColor colorWithCalibratedRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0] set];
			break;
		case 5:		//gray
			[[NSColor colorWithCalibratedRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0] set];
			break;
		case 6:		//green
			[[NSColor colorWithCalibratedRed:8/255.0 green:64/255.0 blue:16/255.0 alpha:1.0] set];
			break;
		case 7:		//light gray
			[[NSColor colorWithCalibratedRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0] set];
			break;
		case 8:		//mauve taupe
			[[NSColor colorWithCalibratedRed:145/255.0 green:95/255.0 blue:109/255.0 alpha:1.0] set];
			break;
		case 9:		//orange
			[[NSColor colorWithCalibratedRed:196/255.0 green:96/255.0 blue:8/255.0 alpha:1.0] set];
			break;
		case 10:	//purple
			[[NSColor colorWithCalibratedRed:96/255.0 green:8/255.0 blue:96/255.0 alpha:1.0] set];
			break;
		case 11:	//red
			[[NSColor colorWithCalibratedRed:128/255.0 green:8/255.0 blue:8/255.0 alpha:1.0] set];
			break;
		case 12:	//yellow
			[[NSColor colorWithCalibratedRed:192/255.0 green:192/255.0 blue:8/255.0 alpha:1.0] set];
			break;
		case 13:	//custom
			break;
		default:	//gray, 5
			[[NSColor colorWithCalibratedRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0] set];
			break;
	}
	NSRectFill(bg);
	
	// grab date
	NSCalendarDate *today = [NSCalendarDate date];
	
	// 12/24 format
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
	
	// mode
	if ([defaults boolForKey:@"showDate"]) {
		[today setCalendarFormat:@"%b.%e,%Y"];
	} else if ([defaults boolForKey:@"showTime"]) {
		if (is24h) {
			[today setCalendarFormat:@"%H:%M:%S"];
		} else {
			[today setCalendarFormat:@"%I:%M:%S%p"];
		}
	} else if ([defaults boolForKey:@"showTimeShort"]) {
		if (is24h) {
			[today setCalendarFormat:@"%H:%M"];
		} else {
			[today setCalendarFormat:@"%I:%M%p"];
		}
	} else if ([defaults boolForKey:@"showDay"]) {
		[today setCalendarFormat:@"%a.%b.%e"];
	}
	
	NSString *displayString = [[NSString stringWithFormat:@"%@", today] uppercaseString];
	
	//	NSString *fontName = @"AvantGarGotItcT-Medi";
	NSString *fontName = @"TodayAG";
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:fontName size:screenSize.height/6.0], NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName, nil];
	NSAttributedString *currentText=[[NSAttributedString alloc] initWithString:displayString attributes:attributes];
	
	if ([attributes count] == 0)
	{
		NSLog( @"Failed to set font." );
		NSBeep();
	}
	
	NSSize attrSize = [currentText size];
	NSInteger offsetWidth;
	//	if ([defaults boolForKey:@"showTime"]) {
	//		offsetWidth = (NSInteger)(attrSize.width/2);
	//	} else {
	offsetWidth = (NSInteger)(attrSize.width/2);
	//	}
	[currentText drawAtPoint:NSMakePoint((screenSize.width/2)-offsetWidth, (screenSize.height/2)-(attrSize.height/2)+(attrSize.height/10))];

	return;
}

- (BOOL)hasConfigureSheet
{
	return YES;
}

- (NSWindow *)configureSheet
{ 
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	
	if (!configSheet)
	{
		if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) 
		{
			NSLog( @"Failed to load configure sheet." );
			NSBeep();
		}
	}
	
	[showDateOption setState:[defaults boolForKey:@"showDate"]];
	[showTimeOption setState:[defaults boolForKey:@"showTime"]];
	[showTimeShortOption setState:[defaults boolForKey:@"showTimeShort"]];
	[showDayOption setState:[defaults boolForKey:@"showDay"]];
	[colorComboOption selectItemAtIndex:[defaults integerForKey:@"colorCombo"]];
	[randomCheckOption setState:[defaults boolForKey:@"randomCheck"]];
	[colorComboOption setEnabled:![randomCheckOption state]];

	[versionTextField setStringValue:[NSString stringWithFormat:@"version %@", [[[NSBundle bundleForClass:[TodayView class]] infoDictionary] objectForKey:@"CFBundleVersion"]]];
	//	NSLog(@"%@", [[[NSBundle bundleForClass:[TodayView class]] infoDictionary] objectForKey:@"CFBundleVersion"]);
	
	// both are needed, otherwise hyperlink won't accept mousedown
    [hyperlinkTextField setAllowsEditingTextAttributes: YES];
    [hyperlinkTextField setSelectable: YES];
	
	//make kyperlink string
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString: [NSAttributedString hyperlinkFromString:@"www.gingerbeardman.com/today/" withURL:[NSURL URLWithString:@"http://www.gingerbeardman.com/today/"]]];
	
    // set the attributed string to the NSTextField
    [hyperlinkTextField setAttributedStringValue: string];
	
	return configSheet;
}

- (IBAction)updateSelection:(id)sender
{
	[colorComboOption setEnabled:![randomCheckOption state]];
}

- (IBAction)cancelClick:(id)sender
{
	[[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)updateColorWell:(id)sender
{
	NSColor *cw;
	cw = [[sender color] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (IBAction)okClick:(id)sender
{
	ScreenSaverDefaults *defaults;
	
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	
	// Update our defaults
	[defaults setBool:[showDateOption state] forKey:@"showDate"];
	[defaults setBool:[showTimeOption state] forKey:@"showTime"];
	[defaults setBool:[showTimeShortOption state] forKey:@"showTimeShort"];
	[defaults setBool:[showDayOption state] forKey:@"showDay"];
	[defaults setInteger:[colorComboOption indexOfSelectedItem] forKey:@"colorCombo"];
	[defaults setBool:[randomCheckOption state] forKey:@"randomCheck"];
//	NSLog(@"color: %d", [colorComboOption indexOfSelectedItem]);

	// Save the settings to disk
	[defaults synchronize];
	
	// Close the sheet
	[[NSApplication sharedApplication] endSheet:configSheet];
}

- (BOOL)loadLocalFonts:(NSError **)err requiredFonts:(NSArray *)fontnames {
	NSString *resourcePath, *fontsFolder,*errorMessage;
	NSURL *fontsURL;
	resourcePath = [[NSBundle bundleForClass:[TodayView class]] resourcePath];
	if (!resourcePath) 
	{
		errorMessage = @"Failed to load fonts! No resource path...";
		NSLog( @"Failed to load fonts! No resource path..." );
		if (err != NULL) {
			NSString *localizedMessage = NSLocalizedString(errorMessage, @"");
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedMessage forKey:NSLocalizedDescriptionKey];
			*err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
		}

		return NO;
	}
	fontsFolder = [[NSBundle bundleForClass:[TodayView class]] resourcePath];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if (![fm fileExistsAtPath:fontsFolder])
	{
		errorMessage = @"Failed to load fonts! Font folder not found...";
		NSLog( @"Failed to load fonts! Font folder not found..." );
		if (err != NULL) {
			NSString *localizedMessage = NSLocalizedString(errorMessage, @"");
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedMessage forKey:NSLocalizedDescriptionKey];
			*err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
		}

		return NO;
	}
	if( (fontsURL = [NSURL fileURLWithPath:fontsFolder]) )
	{
		OSStatus status;
		FSRef fsRef;
		CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);
		status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);
//		if (status != noErr)
//		{
//			errorMessage = @"Failed to acivate fonts!";
//			NSLog( @"Failed to activate fonts!" );
//			if (err != NULL) {
//				NSString *localizedMessage = NSLocalizedString(errorMessage, @"");
//				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedMessage forKey:NSLocalizedDescriptionKey];
//				*err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
//			}
//
//			return NO;
//		}
	}
	if (fontnames != nil)
	{
		NSFontManager *fontManager = [NSFontManager sharedFontManager];
		for (NSString *fontname in fontnames)
		{
			BOOL fontFound = [[fontManager availableFonts] containsObject:fontname]; 
			if (!fontFound)
			{
//				errorMessage = [NSString stringWithFormat:@"Required font not found: %@",fontname];
//				NSLog( [NSString stringWithFormat:@"Required font not found: %@",fontname] );
				if (err != NULL) {
					NSString *localizedMessage = NSLocalizedString(errorMessage, @"");
					NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedMessage forKey:NSLocalizedDescriptionKey];
					*err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
				}

				return NO;
			}
		}
	}
	return YES;
}



@end

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
	
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
	
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];

	// make font standard UI typeface and size
    [attrString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Lucida Grande" size:13.0] range:range];
	
    // next make the text appear with an underline
    [attrString addAttribute:
	 NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
	
    [attrString endEditing];
	
    return attrString;
}
@end

