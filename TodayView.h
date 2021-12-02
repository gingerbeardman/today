//
//  TodayView.h
//  Today
//
//  Created by Matt Sephton on 08/04/2009.
//  Copyright (c) 2009, Boowoop Limited. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>


@interface TodayView : ScreenSaverView 
{
	IBOutlet id configSheet;
	IBOutlet id showDateOption;
	IBOutlet id showTimeOption;
	IBOutlet id showTimeShortOption;
	IBOutlet id showDayOption;
	IBOutlet id colorComboOption;
	IBOutlet id randomCheckOption;
	IBOutlet id colorWellOption;
	IBOutlet id hyperlinkTextField;
	IBOutlet id versionTextField;

	NSInteger bgcolor;

	NSTimer *animationTimer;
}

@property (nonatomic, readwrite) NSTimer *animationTimer;

- (BOOL)loadLocalFonts:(NSError **)err requiredFonts:(NSArray *)fontnames;
- (void)drawToday;

- (IBAction)updateSelection:(id)sender;
- (IBAction)updateColorWell:(id)sender;
- (IBAction)cancelClick:(id)sender;
- (IBAction)okClick:(id)sender;
@end

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end

