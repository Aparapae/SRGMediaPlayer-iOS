//
//  PseudoILDataProvider.h
//  RTSMediaPlayer Demo
//
//  Created by Cédric Foellmi on 01/06/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RTSMediaPlayer/RTSMediaPlayerControllerDataSource.h>
#import <RTSMediaPlayer/RTSMediaPlayerSegmentDataSource.h>

@interface PseudoILDataProvider : NSObject <RTSMediaPlayerControllerDataSource, RTSMediaSegmentsDataSource>

@end
