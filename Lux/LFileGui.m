//
//  LFileGui.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LFileGui.h"
#import "LFileController.h"
#import "LExtension.h"
#import "LPlayerController.h"
#import "LPlaylistController.h"
#import "Lux.h"
#import "NSArrayCategory.h"

#define controller [LFileController sharedInstance]
#define kFILES_COUNT_TEXT @"%d Files"
#define kFILE_COUNT_TEXT @"%d File"
#define kMARGIN_SIZE 4

@implementation LFileGui
@synthesize visibleFiles;

- (id)init
{
    self = [super init];
    if (self) {
		visibleFiles = [[NSArray alloc] init];
		
		[controller addGui:self];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) awakeFromNib
{	
	[fileList setDataSource:self];
	[fileList setTarget:self];
	[fileList setDelegate:self];
	[fileList setDoubleAction:@selector(doubleClickAction)];
	
	[self setupColumns];
}

#pragma mark Data Source Methods

- (NSInteger) numberOfRowsInTableView: (NSTableView *) aTableView
{
	return [visibleFiles count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	LFile * f = [visibleFiles objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqualToString:kINDEX])
	{
		return [NSNumber numberWithLong:row + 1];
	} else {
		NSString * attr = [tableColumn identifier];
		return [f attributeForIdentifier:attr];
	}
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
	NSArray * selectedFiles = [visibleFiles objectsAtIndexes:[fileList selectedRowIndexes]];
	
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	[visiblePlaylist setSelectedFiles:selectedFiles];
	[[LInputOutputController sharedInstance] setNeedsSaved:YES];
}

- (void) tableView: (NSTableView *) tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	LPlaylist * playlist = [[LPlaylistController sharedInstance] visiblePlaylist];
	[playlist setSort:[tableColumn identifier]];
	[self reloadData];
}

- (void) doubleClickAction
{
	NSInteger clickedIndex = [fileList clickedRow];
	if (clickedIndex == -1) // Clicked item is a column heading
	{
		return;
	}	
	
	id clickedItem = [visibleFiles objectAtIndex:clickedIndex];
	if ([clickedItem isKindOfClass:[LFile class]])
	{
		[[LPlayerController sharedInstance] playFile:clickedItem];
	}
}

- (void) selectCorrectFiles
{
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	NSArray * selectedFiles = [visiblePlaylist selectedFiles];
	
	NSIndexSet * indexSet = [visibleFiles indexesForObjects:selectedFiles];
	
	[fileList selectRowIndexes:indexSet byExtendingSelection:NO];
	[fileList scrollRowToVisible:[indexSet firstIndex]];
}

- (void) reloadData
{
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	visibleFiles = [[visiblePlaylist members] retain];
	
	[fileList reloadData];
	[self selectCorrectFiles];
	
	[self updateTotalFiles];
	[self updateColumns];
}

- (void) setupColumns
{
	NSMutableArray * columns = [NSMutableArray arrayWithObject:kINDEX];
	
	[columns addObjectsFromArray:kKEEPER_ATTRIBUTES];
	
	for (NSString * col in columns)
	{
		NSTableColumn * column = [[[NSTableColumn alloc] initWithIdentifier:col] autorelease];
		if ([col isEqualToString:kINDEX])
		{
			[[column headerCell] setStringValue:@""];
			[column setEditable:NO];
			[column setResizingMask:NSTableColumnNoResizing];
		} else {	
			[[column headerCell] setStringValue:[col capitalizedString]];
		}
		[fileList addTableColumn:column];
	}
	[self updateColumns];
}

- (void) updateColumns
{
	NSMutableArray * columns = [NSArray arrayWithArray:[[[LPlaylistController sharedInstance] visiblePlaylist] columns]];
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	for (NSTableColumn * column in [fileList tableColumns])
	{
		NSString * ID = [column identifier];
		[column setHidden:(! [columns containsObject:ID])];
		if ([ID isEqualToString:kINDEX])
		{
			NSUInteger total = [visibleFiles count];
			NSString * totalString = [NSString stringWithFormat:@"%d", total];
			
			NSFont * font = [[[[fileList tableColumns] objectAtIndex:0] dataCell] font]; 	
			NSDictionary * fontDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
			
			NSSize charSize = [totalString sizeWithAttributes:fontDictionary];
			[column setWidth:charSize.width + kMARGIN_SIZE];
		}

		if ([ID isEqualToString:[visiblePlaylist sort]])
		{
			NSImage * indicatorImage;
			if ([visiblePlaylist descending])
			{
				indicatorImage = [NSImage imageNamed:@"NSDescendingSortIndicator"];
			} else {
				indicatorImage = [NSImage imageNamed:@"NSAscendingSortIndicator"];
			}
			[fileList setIndicatorImage:indicatorImage inTableColumn:column];
		} else {
			[fileList setIndicatorImage:nil inTableColumn:column];
		}
	}
}

- (void) updateTotalFiles
{
	NSInteger total = [visibleFiles count];
	
	NSString * files;
	if (total == 1)
	{
		files = kFILE_COUNT_TEXT;
	} else { 
		files = kFILES_COUNT_TEXT;
	}
	
	[totalFiles setStringValue:[NSString stringWithFormat:files, total]]; 
}

- (NSMenu *) menuForEvent: (NSEvent *) event
{
	NSPoint where = [fileList convertPoint:[event locationInWindow] fromView:nil];
	NSInteger row = [fileList rowAtPoint:where];
	
	if (row < 0) return nil;
	
	NSIndexSet * selectedRows = [fileList selectedRowIndexes];
	NSArray * files;
	if ([selectedRows containsIndex:row])
	{
		files = [visibleFiles objectsAtIndexes:selectedRows];
	} else {
		files = [NSArray arrayWithObject:[visibleFiles objectAtIndex:row]];
	}
		
	return [[LFileController sharedInstance] menuForFiles: files];
}
@end
