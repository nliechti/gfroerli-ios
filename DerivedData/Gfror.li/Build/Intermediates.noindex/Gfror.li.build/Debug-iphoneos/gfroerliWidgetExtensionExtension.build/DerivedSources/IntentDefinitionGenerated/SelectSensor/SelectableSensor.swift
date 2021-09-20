//
// SelectableSensor.swift
//
// This file was automatically generated and should not be edited.
//

#if canImport(Intents)

import Intents

@available(iOS 12.0, macOS 10.16, watchOS 5.0, *) @available(tvOS, unavailable)
@objc(SelectableSensor)
public class SelectableSensor: INObject {

}

@available(iOS 13.0, macOS 10.16, watchOS 6.0, *) @available(tvOS, unavailable)
@objc(SelectableSensorResolutionResult)
public class SelectableSensorResolutionResult: INObjectResolutionResult {

    // This resolution result is for when the app extension wants to tell Siri to proceed, with a given SelectableSensor. The resolvedValue can be different than the original SelectableSensor. This allows app extensions to apply business logic constraints.
    // Use notRequired() to continue with a 'nil' value.
    @objc(successWithResolvedSelectableSensor:)
    public class func success(with resolvedObject: SelectableSensor) -> Self {
        return super.success(with: resolvedObject)
    }

    // This resolution result is to ask Siri to disambiguate between the provided SelectableSensor.
    @objc(disambiguationWithSelectableSensorsToDisambiguate:)
    public class func disambiguation(with objectsToDisambiguate: [SelectableSensor]) -> Self {
        return super.disambiguation(with: objectsToDisambiguate)
    }

    // This resolution result is to ask Siri to confirm if this is the value with which the user wants to continue.
    @objc(confirmationRequiredWithSelectableSensorToConfirm:)
    public class func confirmationRequired(with objectToConfirm: SelectableSensor?) -> Self {
        return super.confirmationRequired(with: objectToConfirm)
    }

    @available(*, unavailable)
    override public class func success(with resolvedObject: INObject) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    override public class func disambiguation(with objectsToDisambiguate: [INObject]) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    override public class func confirmationRequired(with objectToConfirm: INObject?) -> Self {
        fatalError()
    }

}

#endif
