/***********************************************************************************************************************************
 *
 *	ShutdownPanelController.m
 *
 * This file is an part of The Mondo Login Application.
 *
 *	Copyright (C) 2020 Mondo Megagames.
 * 	Author: Jamie Ramone <sancombru@gmail.com>
 *	Date: 20-4-2020
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program. If not, see
 * <http://www.gnu.org/licenses/>
 *
 **********************************************************************************************************************************/
#import <AppKit/NSNibLoading.h>

#import "aux.h"
#import "ShutdownPanelController.h"

@implementation ShutdownPanelController

- (ShutdownPanelController *) initWithMessage: (NSString *) aMessage
{
	register void	* target = NULL;
	register BOOL	criteria = NO;

	self = [super init];
	criteria = ( self != NULL );
	target = Choose ( criteria, && in, && out );
	goto * target;
in:	[aMessage retain];
	message = aMessage;
	[NSBundle loadNibNamed: ShutdownPanelInterface owner: self];

out:	return self;
};

- (void) showWindow
{
	//NSLog ( @"Showing shutdown message window." );
	[window orderFront: self];
};

- (void) hideWindow
{
	//NSLog ( @"Showing shutdown message window." );
	[window close];
};
/*
 * NSObject overrides.
 */
- (void) awakeFromNib
{
	[messageTextField setStringValue: message];
};

- (void) dealloc
{
	[message release];
	[super dealloc];
};

@end
