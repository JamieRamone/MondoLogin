/***********************************************************************************************************************************
 *
 *	LoginWindow.m
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
#import <AppKit/AppKit.h>

#import "LoginWindow.h"

@implementation LoginWindow

- (id) initWithContentRect: (NSRect) rect styleMask: (NSUInteger) mask backing: (NSBackingStoreType) type defer: (BOOL) flag
{
	self = [super initWithContentRect: rect styleMask: NSBorderlessWindowMask backing: type defer: flag];

	return self;
};

- (BOOL) canBecomeKeyWindow
{
	register BOOL	result = NO;

	result = YES;

	return result;
};
  
- (BOOL) canBecomeMainWindow
{
	register BOOL	result = NO;

	return result;
};

- (void) awakeFromNib
{
	register NSRect	myBox = NSZeroRect;
	register NSSize	size = NSZeroSize;

	myBox = [self frame];
	size = [[NSScreen mainScreen] frame].size;
	myBox.origin.x = ( size.width - myBox.size.width ) / 2;
	myBox.origin.y = ( size.height - myBox.size.height ) / 2;
	[self setFrameOrigin: myBox.origin];
};

@end
