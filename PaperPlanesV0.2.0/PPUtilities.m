//
//  PPUtilities.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/22/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPUtilities.h"

@implementation PPUtilities

+ (NSString*) trim: (NSString*) text {
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*) getEmailUsername: (NSString*) text {
    NSArray *temp = [text componentsSeparatedByString: @"@"];
    return [temp objectAtIndex:0];
}

+ (NSError*) newError: (NSString*) message {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:@"error"];
    NSError *error = [NSError errorWithDomain:@"PP" code:418 userInfo:details];
    return error;
}

+ (void) showError:(NSError *) error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:[error.userInfo objectForKey:@"error"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (UIBAlertView*) getAlertUnsavedCommentAbandon:(NSString*) nameOfAbandonedObject {
    NSString *errorMessage = [NSString stringWithFormat:@"If you abandon this %@, your comment will be discarded.", nameOfAbandonedObject];
    NSString *errorTitle = @"Discard Comment?";
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:errorTitle message:errorMessage cancelButtonTitle:@"Hold on" otherButtonTitles:@"Discard", nil];
    return alert;
}

+ (UIImage*) getImageFromObject:(PFObject*) imageObject {
    PFFile* imageFile = imageObject[@"image"];
    UIImage* image = [UIImage imageWithData:[imageFile getData]];
    return image;
}

+ (PFPush*) pushWithFeedbackItem:(PPFeedbackItem*) feedbackItem {
    PFPush* push = [[PFPush alloc] init];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:feedbackItem.objectId, @"objectId", nil];
    [push setChannel:@"FeedbackItem"];
    [push setData:data];
    return push;
}

+ (UIBAlertView*) getAlertUnsavedEdits {
    NSString *errorMessage = @"If you abandon this box, your edits will be discarded.";
    NSString *errorTitle = @"Discard Edits?";
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:errorTitle message:errorMessage cancelButtonTitle:@"Hold on" otherButtonTitles:@"Discard", nil];
    return alert;
}
    

@end
