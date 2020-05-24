/***********************************************************************************************************************************
 *
 *	LoginDelegate.m
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
#define GNU_SOURCE

#include <stdio.h>
#include <pwd.h>
#include <utmp.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <math.h>

#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#import <AppKit/NSAlert.h>
#import <AppKit/NSApplication.h>
#import <AppKit/NSCursor.h>
#import <AppKit/NSEvent.h>
#import <AppKit/NSRunningApplication.h>
#import <AppKit/NSSecureTextField.h>
#import <AppKit/NSScreen.h>
#import <AppKit/NSWorkspace.h>

#import "aux.h"
#import "AlertPanelController.h"
#import "ShutdownPanelController.h"
#import "LoginCurtainView.h"
#import "LoginDelegate.h"

@interface LoginDelegate (Pivate)

- (void) _reset;
- (void) _launchLoginCommand;
- (void) _closeWindow;

@end

@implementation LoginDelegate (Pivate)
/*
 * Get 'total' number of random bytes from the system's RNG device and sequentially store them in 'number'.
 */
static inline void _random ( register const char * numbers, register const int total )
{
        register int	randomFile = -1;
	register void	* target = NULL;
	register BOOL	criteria = NO;

	//NSLog ( @"_random ( void ) called." );
	randomFile = open ( "/dev/random", O_RDONLY );
	criteria = ( randomFile != -1 );
	target = Choose ( criteria, && in, && out );
	goto * target;
in:	read ( randomFile, (char *) numbers, sizeof ( char ) * total );
	//NSLog ( @"random number: %d.", result );
	//NSLog ( @"_random ( void ) ended." );

out:	return;
};
/*
 * Encrypt the given string using the standard libc crypt routine, algorithm 6 (SHA-512).
 */
static inline char * _encrypt ( register NSString * original )
{
        register NSString	* saltSet = nil;
	register char		* result = NULL;
	register int		i = -1;
	register unsigned int	index = -1;
	char			numbers [ 16 ] = { -1 },
				salt [] = "$6$................";

	//NSLog ( @"_encrypt ( register NSString * ) called." );
	_random ( numbers, 16 );
	saltSet = @"./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	for ( i = 0; i < 16; i++ ) {
		index = numbers [ i ] & 0x0000003F;
		//NSLog ( @"Next character index: %u (%d).", index, index );
		salt [ 3 + i ] = [saltSet characterAtIndex: index];
	}

	//NSLog ( @"Salt: %s", salt + 3 );
	result = crypt ( [original cString], salt );
	//NSLog ( @"full encrypted string: %s", salt );
	//NSLog ( @"_encrypt ( register NSString * ) ended." );

	return result;
};
/*
 * Reset the interface (clear the text fields) and shake the window left to right 3 times really fast.
 */
- (void) _reset
{
	register NSPoint	o = NSZeroPoint,
				p = NSZeroPoint;
	register int		i = -1,
				j = -1,
				r = -1;
	register double		step = -1;

	[username release];
	[password release];
	[usernameTextField setStringValue: nil];
	[passwordTextField setStringValue: nil];
	[passwordTextField resignFirstResponder];
	[usernameTextField becomeFirstResponder];
	o = [window frame].origin;
	p = o;
	r = [window frame].size.width / 3.0;
	step = M_PI / 6.0;

	for ( i = 0; i < 3; i++ ) {
		for ( j = 0; j < 3; j++ ) {
			o.x = p.x + r * sin ((double) j * step );
			[window setFrameOrigin: o];
		}

		for ( j = 2; -3 < j; j-- ) {
			o.x = p.x + r * sin ((double) j * step );
			[window setFrameOrigin: o];
		}

		for ( j = -3; j < 0; j++ ) {
			o.x = p.x + r * sin ((double) j * step );
			[window setFrameOrigin: o];
		}
	}

	[window setFrameOrigin: p];
	NSLog ( @"Interface reset." );
};
/*
 * launch the given command and wait for it to finish, kill all processes its group, end all GNUstep apps, and exit.
 */
- (void) _launchAndWaitForLoginCommand: (NSString *) command
{
	register NSArray	* apps = nil;
	register NSEnumerator	* dispenser = nil;
	register NSDictionary	* app = nil;
	register void		* target = NULL;
	register pid_t		pid = -1;
	register BOOL		criteria = NO;
/*
 * Create new process group.
 */
	pid = setsid ();
	pid = getpid ();
	setpgid ( pid, pid );
/*
 * Fork and launch given command.
 */
	pid = fork ();
	criteria = ( pid == 0 );
	target = Choose ( criteria, && child, && parent );
	goto * target;
/*
 * In the child, just exec the command, no arguments.
 */
child:	execl ( [command cString], [command cString], NULL );
/*
 * In the parent, wait for it to finish (check for error first).
 */
parent:	criteria = ( 0 < pid );
	target = Choose ( criteria, && resume, && error );
	goto * target;
resume:	waitpid ( pid, NULL, 0 );
/*
 * Now kill all GNUstep ones by getting the list from NSWorkspace and iterating over it.
 */
	pid = getpid ();
	apps = [[NSWorkspace sharedWorkspace] launchedApplications];
	NSLog ( @"There are %d applications running, terminating them...", [apps count], apps );
	dispenser = [apps objectEnumerator];
	app = [dispenser nextObject];
	criteria = ( app != nil );
/*
 * {NSApplicationName = Terminal; NSApplicationPath = "/MondoApps/Terminal.app"; NSApplicationProcessIdentifier = 5371; }
 */
	while ( criteria ) {
		pid = [[app objectForKey: @"NSApplicationProcessIdentifier"] integerValue];
		criteria = ( pid != getpid ());
		target = Choose ( criteria, && terminate, && next );
		goto * target;
/*
 * Skip over this one, so as to make sure all others are terminated.
 */
terminate:	NSLog ( @"Terminating application %@...", [app objectForKey: @"NSApplicationName"] );
		kill ( pid, SIGQUIT );
next:		app = [dispenser nextObject];
		criteria = ( app != nil );
	}
/*
 * This kills all descentants of the task that ara in the same process group as this one (UI apps that aren't GNUstep ones and DON'T
 * fiddle around with their pgid e.g. creting new ones).
 */
	NSLog ( @"Killing all processes in group %d...", pid );
	killpg ( pid, SIGQUIT );
/*
 * Ok, NOW we can exit.
 */
	exit ( 0 );
error:	NSLog ( @"Failed to launch login command %@.", command );
	exit ( -1 );
};
/*
 * Exec the command given in the user's NSGlobalDomain dictionary, under the key "LoginCommand".
 */
- (void) _launchLoginCommand
{
	register NSDictionary	* domain = nil;
	register NSString	* command = nil;
	register NSUserDefaults	* defaults = nil;
	register BOOL		criteria = NO;

	[self _closeWindow];
	defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	domain = [defaults persistentDomainForName: NSGlobalDomain];
	command = (NSString *) [domain objectForKey: @"LoginCommand"];
	criteria = ( command != nil );
	command = Choose ( criteria, command, HardCodedDefaultLoginCommand );
	[self _launchAndWaitForLoginCommand: command];
};
/*
 * Close the window with "closing the curtins" effect.
 */
- (void) _closeWindow
{
	register LoginCurtainView	* background = nil;
	register NSColor		* color = nil;
	register NSWindow		* leftCurtain = nil,
					* rightCurtain = nil;
	register NSRect			box = NSZeroRect;
	register int			i = -1,
					steps = -1,
					step = -1;

	box = [window frame];
	box.size.width *= 2;
	box.origin.x -= box.size.width;
	leftCurtain = [[NSWindow alloc] initWithContentRect: box styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO];
	[leftCurtain setFrame: box display: NO];
	box = [window frame];
	box.origin.x += box.size.width;
	box.size.width *= 2;
	rightCurtain = [[NSWindow alloc] initWithContentRect: box styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO];
	[rightCurtain setFrame: box display: NO];
	box = [[window contentView] frame];
	color = [NSColor colorWithCalibratedRed: ( 0x50 / 255.0 ) green: ( 0x50 / 255.0 ) blue: ( 0x75 / 255.0 ) alpha: 1.0];
	background = [[LoginCurtainView alloc] initWithFrame: box];
	[background setColor: color];
	[leftCurtain setContentView: background];
	background = [[LoginCurtainView alloc] initWithFrame: box];
	[background setColor: color];
	[rightCurtain setContentView: background];
	[leftCurtain orderFront: self];
	[rightCurtain orderFront: self];
	steps = 60;
	box = [window frame];
	step = ( box.size.width / steps ) / 2 + 1;

	for ( i = 0; i < steps - 2; i++) {
		box = [leftCurtain frame];
		box.origin.x += step;
		[leftCurtain setFrame: box display: YES];
		box = [rightCurtain frame];
		box.origin.x -= step;
		[rightCurtain setFrame: box display: YES];
	}

	[window close];
	[leftCurtain close];
	[rightCurtain close];
};

@end

@implementation LoginDelegate
/*
 * NIB actions.
 */
- (void) authenticate: (NSTextField *) sender
{
	register struct passwd	* pw = NULL;
	register void		* target = NULL;
	register int		status = -1;
	register BOOL		criteria = NO;
	struct utmp		ut;

	//NSLog ( @"Now performing authentication..." );
	username = [[usernameTextField stringValue] copy];
	//NSLog ( @"Got user name: %@...", username );
	password = [[passwordTextField stringValue] copy];
	//NSLog ( @"...and password: %@.", password );
/*
 * 1.	If the username's empty, there's no point in continuing.
 */
	criteria = ( [username length] != 0 );
	target = Choose ( criteria, && l1, && fail );
	goto * target;
/*
 * 2.	Get the passwd database entry for the user specified in 'username'.
 */
l1:	//NSLog ( @"Looking up user in the system's user database..." );
	pw = getpwnam ( [username cString] );
	criteria = ( pw != NULL );
	target = Choose ( criteria, && l2, && fail );
	goto * target;
/*
 * 3.	If the password's NULL, set it (to point) to an empty string. If it's equal to 'x', meaning login's disabled for that user,
 *	abort the procedure now.
 */
l2:	//NSLog ( @"User has an account on this system!" );
	criteria = ( strcmp ( pw->pw_passwd, "x" ) != 0 );
	target = Choose ( criteria, && l3, && fail );
	goto * target;
/*
 * 4.	Encrypt the given password and compare it to the pw_passwd field. If it's empty, this'll fail, so we check if it's empty as
 *	well and, if so, also check the length of the supplied password against 0. This'll tell us that we passed an empty string
 *	which would mean they match in that case.
 */
l3:	//NSLog ( @"Checking the given password against the stored one (%016X: %s)...", pw->pw_passwd, pw->pw_passwd );
	criteria = ( strcmp ( pw->pw_passwd, crypt ( [password cString], pw->pw_passwd )) == 0 );
	criteria = ( criteria || ( pw->pw_passwd [ 0 ] == '\0' && [password length] == 0 ));
	target = Choose ( criteria, && l4, && fail );
	goto * target;
/*
 * 5.	Set up the environment (i.e. change uid and gid to that of the user and change directory) before proceding to launch the
 *	user's GUI shell program.
 */
l4:	//NSLog ( @"Passwords match! Loging the in now..." );
	status = setuid ( pw->pw_uid );
	criteria = ( status == 0 );
	target = Choose ( criteria, && l5, && fail );
	goto * target;
l5:	setgid ( pw->pw_gid );
	status = chdir ( pw->pw_dir );
	criteria = ( status == 0 );
	target = Choose ( criteria, && final, && fail );
	goto * target;
/*
 * The login routine doesn't return anything, so no further checks are needed.
 */
final:	ut.ut_type = LOGIN_PROCESS;
	ut.ut_pid = getpid ();
	strncpy ( ut.ut_user, pw->pw_name, UT_NAMESIZE );
	strncpy ( ut.ut_host, [[hostnameTextField stringValue] cString], UT_HOSTSIZE );
	login ( & ut );
/*
 * This just execs the gui "shell" so there's no point in skiping over the next (the failure) case.
 */
	[self _launchLoginCommand];
fail:	[self _reset];
};

- (void) powerButtonPressed: (NSButton *) sender
{
	register NSString			* message = nil;
	register ShutdownPanelController	* controller = nil;
	register char				* command = NULL;
	register void				* target = NULL;
	register NSInteger			result = -1;
	register BOOL				criteria = NO;

	NSLog ( @"Power button pressed, shutting system down..." );
	criteria = (( [[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask ) == 0 );
	message = Choose ( criteria, @"Are you sure you want to power off the computer?", @"Are you sure you want to FULLY shut down the computer?" );
	command = Choose ( criteria, (char *) "/etc/halt", (char *) "/etc/Halt" );
	result = [AlertPanelController alertPanelWithTitle: nil message: message defaultButtonLabel: @"Yes" alternateButtonLabel: @"No" otherButtonLabel: nil];
	criteria = ( result == NSAlertFirstButtonReturn );
	target = Choose ( criteria, && in, && out );
	goto * target;
in:	[self _closeWindow];
	[sender setState: NSOffState];
	controller = [[ShutdownPanelController alloc] initWithMessage: @"Shutting down the computer..."];
	[controller retain];
	[controller showWindow];
	[NSCursor hide];
	system ( command );
/*
 * If this point is reached, we've re-entered from a suspend-to-disk operation. In that case we reset the whole environment.
 */
	[controller hideWindow];
	[controller release];
	[window makeKeyAndOrderFront: self];

out:	return;	
};

- (void) restartButtonPressed: (NSButton *) sender
{
	register NSString			* message = nil;
	register ShutdownPanelController	* controller = nil;
	register char				* command = NULL;
	register void				* target = NULL;
	register NSInteger			result = -1;
	register BOOL				criteria = NO;

	NSLog ( @"Restart button pressed, rebooting the computer..." );
	criteria = (( [[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask ) == 0 );
	message = Choose ( criteria, @"Are you sure you want to restart the computer?", @"Are you sure you want to FULLY restart the computer?" );
	command = Choose ( criteria, (char *) "/etc/reboot", (char *) "/etc/Reboot" );
	result = [AlertPanelController alertPanelWithTitle: nil message: message defaultButtonLabel: @"Yes" alternateButtonLabel: @"No" otherButtonLabel: nil];
	criteria = ( result == NSAlertFirstButtonReturn );
	target = Choose ( criteria, && in, && out );
	goto * target;
in:	[self _closeWindow];
	[sender setState: NSOffState];
	controller = [[ShutdownPanelController alloc] initWithMessage: @"Restarting the computer..."];
	[controller retain];
	[controller showWindow];
	[NSCursor hide];
	system ( command );
/*
 * If this point is reached, we've re-entered from a suspend-to-disk operation. In that case we reset the whole environment.
 */
	[controller hideWindow];
	[controller release];
	[window makeKeyAndOrderFront: self];

out:	return;	
};
/*
 * NSObject overrides.
 */
- (void) awakeFromNib
{
	register NSSecureTextFieldCell	* cell = nil;
	register NSString		* hostname = nil;
	
	cell = [passwordTextField cell];
	[cell setEchosBullets: NO];
	hostname = [[NSHost currentHost] name];
	[hostnameTextField setStringValue: hostname];
};
/*
 * NSControlTextEditingDelegate methods
 */
- (BOOL) control: (NSControl *) control textView: (NSTextView *) textView doCommandBySelector: (SEL) selector
{
	register void	* target = NULL;
	register BOOL	result = NO;

	result = sel_isEqual ( selector, @selector ( insertNewline: ));
	target = Choose ( result, && in, && out );
	goto * target;
in:	[usernameTextField resignFirstResponder];
	[passwordTextField becomeFirstResponder];

out:	return result;
};
/*
 * NSApplicationDelegate methods.
 */
- (void) applicationDidFinishLaunching: (NSNotification *) notification
{
	NSLog ( @"Application launched, setting up windows..." );
	[window makeKeyAndOrderFront: self];
	NSLog ( @"All done!" );
};

@end
