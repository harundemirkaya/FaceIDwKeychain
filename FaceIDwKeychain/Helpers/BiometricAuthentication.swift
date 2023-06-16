//
//  BiometricAuthentication.swift
//  FaceIDwKeychain
//
//  Created by Harun Demirkaya on 16.06.2023.
//

import Foundation
import LocalAuthentication

enum BiometricResult{
    case success
    case failed
    case notSupported
}

class BiometricAuthentication {

    // MARK: - Public methods
    
    static func isBiometricAuthenticationAvailable() -> BiometricResult {
        let context = LAContext()
        var error: NSError?
        let isBiometricAuthenticationPossible = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return isBiometricAuthenticationPossible ? .success : .notSupported
    }
    
    static func authenticateWithBiometricAuthentication(completion: @escaping (BiometricResult) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with biometric authentication"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        completion(.success)
                    } else {
                        completion(.failed)
                    }
                }
            }
        } else {
            completion(.notSupported)
        }
    }
}
