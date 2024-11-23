//
//  BiometricAuthManager.swift
//  RecipeApp
//
//  Created by Jonas S on 22/11/2024.
//

import LocalAuthentication
import UIKit

class BiometricAuthManager {

    static let shared = BiometricAuthManager()

    private init() {}

    /// Checks if biometric authentication can be used on the device.
    /// - Returns: A `Bool` indicating whether the device supports biometric authentication and if it is available.
    func canUseBiometricAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?
        /// Evaluates if the device can use biometric authentication.
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Retrieves the type of biometric authentication available on the device.
    /// - Returns: An `LABiometryType` value indicating the type of biometric authentication (e.g., `.none`, `.touchID`, `.faceID`).
    func getBiometricType() -> LABiometryType {
        let context = LAContext()
        /// Returns the type of biometric capability supported by the device.
        return context.biometryType
    }

    /// Performs biometric authentication using Face ID or Touch ID.
    /// - Parameters:
    ///   - completion: A closure that gets called after authentication is attempted.
    ///     - `Bool`: Indicates whether the authentication was successful.
    ///     - `LAContext`: The context used during the authentication process.
    ///     - `Error?`: An optional error if the authentication failed.
    func authenticateWithBiometrics(completion: @escaping (Bool, LAContext, Error?) -> Void) {
        let context = LAContext()
        /// Attempts biometric authentication with a localized reason for the prompt.
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate using Face ID or Touch ID"
        ) { success, error in
            /// Ensures the completion handler is called on the main thread.
            DispatchQueue.main.async {
                completion(success, context, error)
            }
        }
    }
}

