//
//  GameScene.m
//  PeerReview15
//
//  Created by Ananta Shahane on 15/02/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

static const uint32_t categoryFence = 0x1 << 0;
static const uint32_t categoryBall = 0x1 << 0;



- (void)didMoveToView:(SKView *)view {
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.name = @"Fence";
    self.physicsBody.categoryBitMask = categoryFence;
    self.physicsBody.collisionBitMask = categoryBall;
    self.physicsBody.contactTestBitMask = categoryBall;
    self.physicsWorld.contactDelegate = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self childNodeWithName:@"Ball"] != nil)
    {
        [[self childNodeWithName:@"Ball"] removeFromParent];
    }
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
    ball.name = @"Ball";
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.affectedByGravity = YES;
    ball.zPosition = 1;
    ball.physicsBody.friction = 0.2;
    ball.physicsBody.restitution = 0.9;
    ball.physicsBody.linearDamping = 0.01;
    ball.physicsBody.angularDamping = 0.02;
    ball.physicsBody.mass = 4;
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    ball.physicsBody.categoryBitMask = categoryBall;
    ball.physicsBody.contactTestBitMask = categoryFence;
    ball.physicsBody.collisionBitMask = categoryFence;
    self.ball = ball;
    [self addChild:ball];
    NSArray *touchup = [touches allObjects];
    self.initialTouch = [[touchup objectAtIndex:0] locationInNode:self];
    
    for (UITouch *t in touches) {
        self.ball.position = [t locationInNode:self];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {
        self.ball.position = [t locationInNode:self];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *touchup = [touches allObjects];
    self.finalTouch = [[touchup lastObject] locationInNode:self];
    self.ball.physicsBody.velocity = CGVectorMake((self.finalTouch.x - self.initialTouch.x), (self.finalTouch.y - self.initialTouch.y));
    for (UITouch *t in touches) {
        self.ball.position = [t locationInNode:self];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self childNodeWithName:@"Ball"] removeFromParent];
}

-(void) didBeginContact:(SKPhysicsContact *)contact{
    CGVector velocity = self.ball.physicsBody.velocity;
    CGFloat speed = sqrt((velocity.dx * velocity.dx) + (velocity.dy * velocity.dy));
    if(speed > 1024)
    {
        SKAction *tallSound = [SKAction playSoundFileNamed:@"LongDrop.wav" waitForCompletion:NO];
        NSString *File = [[NSBundle mainBundle] pathForResource:@"TallDrop" ofType:@"sks"];
        SKEmitterNode *Sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:File];
        Sparks.position = contact.contactPoint;
        SKAction *Sparking = [SKAction runBlock:^{
            [self addChild:Sparks];
        }];
        [self runAction:tallSound];
        [self runAction:Sparking];
    }
    else if(speed < 1024 && speed > 512)
    {
        SKAction *tallSound = [SKAction playSoundFileNamed:@"MidDrop.wav" waitForCompletion:NO];
        NSString *File = [[NSBundle mainBundle] pathForResource:@"MidDrop" ofType:@"sks"];
        SKEmitterNode *Sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:File];
        Sparks.position = contact.contactPoint;
        SKAction *Sparking = [SKAction runBlock:^{
            [self addChild:Sparks];
        }];
        [self runAction:tallSound];
        [self runAction:Sparking];
    }
    else
    {
        SKAction *tallSound = [SKAction playSoundFileNamed:@"ShortDrop.wav" waitForCompletion:NO];
        NSString *File = [[NSBundle mainBundle] pathForResource:@"ShortDrop" ofType:@"sks"];
        SKEmitterNode *Sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:File];
        Sparks.position = contact.contactPoint;
        SKAction *Sparking = [SKAction runBlock:^{
            [self addChild:Sparks];
        }];
        [self runAction:tallSound];
        [self runAction:Sparking];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
