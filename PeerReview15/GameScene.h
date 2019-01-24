//
//  GameScene.h
//  PeerReview15
//
//  Created by Ananta Shahane on 15/02/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKNode *ball;
@property (assign, nonatomic) CGPoint initialTouch;
@property (assign, nonatomic) CGPoint finalTouch;
@end
