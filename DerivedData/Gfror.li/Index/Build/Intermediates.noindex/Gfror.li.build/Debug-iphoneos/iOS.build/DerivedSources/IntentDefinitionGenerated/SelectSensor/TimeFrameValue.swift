//
// TimeFrameValue.swift
//
// This file was automatically generated and should not be edited.
//

#if canImport(Intents)

import Intents

@available(iOS 12.0, macOS 10.16, watchOS 5.0, *) @available(tvOS, unavailable)
@objc public enum TimeFrameValue: Int {
    case `unknown` = 0
    case `day` = 1
    case `week` = 2
    case `month` = 3
}

@available(iOS 13.0, macOS 10.16, watchOS 6.0, *) @available(tvOS, unavailable)
@objc(TimeFrameValueResolutionResult)
public class TimeFrameValueResolutionResult: INEnumResolutionResult {

    // This resolution result is for when the app extension wants to tell Siri to proceed, with a given TimeFrameValue. The resolvedValue can be different than the original TimeFrameValue. This allows app extensions to apply business logic constraints.
    // Use notRequired() to continue with a 'nil' value.
    @objc(successWithResolvedTimeFrameValue:)
    public class func success(with resolvedValue: TimeFrameValue) -> Self {
        return __success(withResolvedValue: resolvedValue.rawValue)
    }

    // This resolution result is to ask Siri to confirm if this is the value with which the user wants to continue.
    @objc(confirmationRequiredWithTimeFrameValueToConfirm:)
    public class func confirmationRequired(with valueToConfirm: TimeFrameValue) -> Self {
        return __confirmationRequiredWithValue(toConfirm: valueToConfirm.rawValue)
    }
}

#endif
