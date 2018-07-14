//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "NSStringFromADYDeviceStatus.h"

NSString *NSStringFromADYDeviceStatus(ADYDeviceStatus deviceStatus) {
    switch (deviceStatus) {
        case ADYDeviceStatusInitializing:
            return @"Connecting";
        case ADYDeviceStatusInitialized:
            return @"Ready for use";
        case ADYDeviceStatusNotBoarded:
            return @"Not Boarded";
        case ADYDeviceStatusStopped:
            return @"Stopped";
        case ADYDeviceStatusGone:
            return @"Disconnected";
        case ADYDeviceStatusError:
            return @"Error";
    }
}
