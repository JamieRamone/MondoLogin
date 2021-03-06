/***********************************************************************************************************************************
 *
 *	AlertPanelController.h
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
#import <Foundation/NSString.h>

#import <AppKit/NSButton.h>
#import <AppKit/NSImageView.h>
#import <AppKit/NSTextField.h>
#import <AppKit/NSTextView.h>
#import <AppKit/NSWindow.h>

#define AlertPanelInterface	@"AlertPanel"

@interface AlertPanelController : NSObject {
	NSString	* title,
			* message,
			* defaultButtonLabel,
			* alternateButtonLabel,
			* otherButtonLabel;
/*
 * NIB outlets.
 */
	NSButton	* cancelButton,
			* noButton,
			* yesButton;
	NSImageView	* iconImageView;
	NSTextField	* titleTextField;
	NSTextView	* messageTextView;
	NSWindow	* window;
}

+ (NSInteger) alertPanelWithTitle: (NSString *) title message: (NSString *) message defaultButtonLabel: (NSString *) defaultLabel alternateButtonLabel: (NSString *) alternateLabel otherButtonLabel: (NSString *) otherLabel;
/*
 * NIB actions.
 */
- (void) buttonWasPressed: (NSButton *) sender;

@end
