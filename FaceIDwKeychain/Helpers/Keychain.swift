//
//  Keychain.swift
//  FaceIDwKeychain
//
//  Created by Harun Demirkaya on 16.06.2023.
//

import Foundation
import Security

class Keychain {

    class func save(key: String, data: String) {
        guard let dataFromString = data.data(using: String.Encoding.utf8) else { return }

        let keychainQuery: [NSString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as NSString,
            kSecValueData: dataFromString as AnyObject
        ]

        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    class func load(key: String) -> String? {
        let keychainQuery: [NSString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as NSString,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)

        guard status == errSecSuccess else { return nil }

        guard let data = result as? Data else { return nil }

        return String(data: data, encoding: String.Encoding.utf8)
    }
}
