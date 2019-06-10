//
//  MySingleton.m
//  AudioPlayer
//
//  Created by jack on 10-1-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MySingleton.h"
@implementation MySingleton
@synthesize openId,token;
@synthesize cartItem;

static MySingleton* _sharedMySingleton = nil;

+(MySingleton*)sharedMySingleton
{
	@synchronized([MySingleton class])
	{
		if (!_sharedMySingleton)
			[[self alloc] init];
		
		return _sharedMySingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([MySingleton class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
	
	return self;
}

-(void)sayHello {
	//NSLog(@"**%a",self.flag);
}
@end
