/***********************************************************************************************************************************
 *
 *	LoginApplication.m
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
#import <Foundation/NSProcessInfo.h>

#import "LoginApplication.h"

@implementation NSIconWindow (Login)

- (void) orderWindow: (NSWindowOrderingMode) place relativeTo: (NSInteger) otherWin
{
/*
 * Do nothing so as to window from appearing.
 */
};

- (void) _initDefaults
{
	/*[super _initDefaults];
	[self setExcludedFromWindowsMenu: YES];
	[self setReleasedWhenClosed: NO];
	[self setTitle:[[NSProcessInfo processInfo] processName]];
	_windowLevel = NSDockWindowLevel;*/
};

@end

@implementation LoginApplication

- (void) _appIconInit
{
	;
};

@end
