//
//  KeychainManager.swift
//  Keychain
//
//  Created by Aleksey Libin on 29.01.2023.
//

import Foundation

class KeychainManager {

    enum KeychainError: Error {
        case duplicateEntry
        case unknownError(OSStatus)
    }

    static func save(account: String, password: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            print("success")
        case errSecDuplicateItem:
            throw KeychainError.duplicateEntry
        default:
            throw KeychainError.unknownError(status)
        }
        print("saved")
    }

    static func checkPass(_ passwordToCheck: String, by account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        guard
            SecItemCopyMatching(query as CFDictionary, &item) == noErr,
            let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let correctPassword = String(data: passwordData, encoding: .utf8)
        else { return false }

        if passwordToCheck == correctPassword {
            return true
        } else {
            print("false pass")
            return false
        }
    }
}
