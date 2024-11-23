//
//  KeychainManager.swift
//  RecipeApp
//
//  Created by Jonas S on 22/11/2024.
//

import LocalAuthentication
import CryptoKit

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    /// Stores recipe data securely in the Keychain with biometric protection.
    /// - Parameters:
    ///   - recipeData: The data to be stored, typically encoded from a `Recipe` object.
    ///   - completion: A closure returning `true` if the data was stored successfully, or `false` otherwise.
    func storeItemData(recipeData: Data?, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let account = "RecipeItem"
            
            if let recipeData {
                /// Keychain query to define attributes of the item to store.
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: account,
                    kSecValueData as String: recipeData,
                    kSecAttrAccessControl as String: SecAccessControlCreateWithFlags(
                        nil,
                        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                        .biometryCurrentSet, // Restricts access to the current biometric set
                        nil
                    )!
                ]
                /// Remove any existing Keychain item with the same account to avoid duplicates.
                SecItemDelete(query as CFDictionary)
                
                /// Add the new item to the Keychain.
                let status = SecItemAdd(query as CFDictionary, nil)
                if status == errSecSuccess {
                    completion(true)
                } else {
                    print("Failed to store login information securely.")
                    completion(false)
                }
            }
        }
    }
    
    /// Retrieves recipe data securely from the Keychain using biometric authentication.
    /// - Parameters:
    ///   - context: An `LAContext` object that manages authentication and user interaction.
    ///   - completion: A closure returning:
    ///     - `Data?`: The retrieved data if successful, or `nil` if retrieval failed.
    ///     - `String?`: Additional information or error description, currently unused.
    ///     - `Error?`: An error object if the retrieval failed.
    func retrieveItemData(context: LAContext, completion: @escaping (Data?, String?, Error?) -> Void) {
        let account = "RecipeItem"
        
        /// Keychain query to find the desired item.
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true, // Request the data to be returned
            kSecMatchLimit as String: kSecMatchLimitOne, // Only retrieve one match
            kSecUseAuthenticationContext as String: context // Use biometric context for access
        ]
        
        query[kSecReturnAttributes as String] = true // Request attributes for the item
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let retrievedData = dataTypeRef as? [String: Any],
           let recipeData = (retrievedData[kSecValueData as String] as? Data) {
            /// Successfully retrieved the data.
            completion(recipeData, nil, nil)
        } else if let error = SecCopyErrorMessageString(status, nil) as String? {
            /// Return an error if retrieval failed with a descriptive message.
            completion(nil, nil, NSError(domain: "KeychainErrorDomain", code: Int(status), userInfo: [NSLocalizedDescriptionKey: error]))
        } else {
            /// Handle unexpected errors without a descriptive message.
            completion(nil, nil, NSError(domain: "KeychainErrorDomain", code: Int(status), userInfo: nil))
        }
    }
}

