//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaPlayerController.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Button which is automatically shown when subtitles are available, disappears otherwise by default. If your controls are
 *  stacked using a `UIStackView`, the layout will automatically adjust when the button appears or disappears.
 *
 *  The button is automatically shown or hidden by having its `hidden` property automatically adjusted. Attempting
 *  to manually alter this property leads to undefined behavior. You can force the button to always be hidden by
 *  setting its `alwaysHidden` property to YES if needed.
 *
 *  A media player controller must be attached. If the current AVplayerItem has subtitles (AVMediaCharacteristicLegible)
 *  the button is displayed, and regarding a subtitle selected or not, the button is selected.
 *  Action on the button display the available subtitles list in an action sheet, with possibity to select one.
 */
IB_DESIGNABLE
@interface SRGTracksButton : UIView <UIPopoverPresentationControllerDelegate>

/**
 *  The media player which the button must be associated with
 */
@property (nonatomic, weak, nullable) IBOutlet SRGMediaPlayerController *mediaPlayerController;

/**
 *  Images customization (default 23x19 images are used if not set)
 */
@property (nonatomic, null_resettable) IBInspectable UIImage *image;
@property (nonatomic, null_resettable) IBInspectable UIImage *selectedImage;

/**
 *  When set to YES, force the button to be always hidden, even if subtitles are available.
 *
 *  Default value is NO
 */
@property (nonatomic, getter=isAlwaysHidden) IBInspectable BOOL alwaysHidden;

@end

NS_ASSUME_NONNULL_END
