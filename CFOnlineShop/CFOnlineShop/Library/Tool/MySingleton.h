//
//  MySingleton.h
//  AudioPlayer
//
//  Created by jack on 10-1-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSShopCartList.h"
@interface MySingleton : NSObject {
	NSString *updateUrl;
}
@property (nonatomic, retain) NSString *openId,*token;
@property (nonatomic, retain) FSShopCartList* cartItem;
+(MySingleton*)sharedMySingleton;
-(void)sayHello;
@end
