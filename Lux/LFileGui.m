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

#define controller [LFileController sharedInstance]

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
	NSIndexSet * indexSet = [fileList selectedRowIndexes];
	
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	[visiblePlaylist setSelectedIndexSet: indexSet];
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

- (void) reloadData
{
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	visibleFiles = [[[visiblePlaylist members] allValues] retain];
	[self showCorrectColumns];
	
	[fileList reloadData];
	
	NSIndexSet * indexSet = [visiblePlaylist selectedIndexSet];
	[fileList selectRowIndexes:indexSet byExtendingSelection:NO];
	[fileList scrollRowToVisible:[indexSet firstIndex]];
	
	[self updateTotalFiles];
}

- (void) setupColumns
{
	NSMutableArray * columns = kKEEPER_ATTRIBUTES;
	
	for (NSString * col in columns)
	{
		NSTableColumn * column = [[[NSTableColumn alloc] initWithIdentifier:col] autorelease];
		[[column headerCell] setStringValue:[col capitalizedString]];
		[fileList addTableColumn:column];
	}
	[self showCorrectColumns];
}

- (void) updateTotalFiles
{
	NSInteger total = [visibleFiles count];
	
	[totalFiles setIntegerValue: total];
}

- (void) showCorrectColumns
{
	NSMutableArray * columns = [NSArray arrayWithArray:[[[LPlaylistController sharedInstance] visiblePlaylist] columns]];
	for (NSTableColumn * column in [fileList tableColumns])
	{
		[column setHidden:(! [columns containsObject:[column identifier]])];
	}
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
