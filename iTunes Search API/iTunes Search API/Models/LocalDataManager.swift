//
//  LocalDataManager.swift
//  iTunes Search API
//
//  Created by Gerardo Hernández González on 20-02-20.
//  Copyright © 2020 Gerardo Hernández González. All rights reserved.
//

import Foundation

class LocalDataManager {
    
    enum Key: String, CaseIterable {
        case searchData
        func make(for searchTerm: String) -> String {
            return self.rawValue + "_" + searchTerm
        }
    }
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - API
    func storeSearchData(forSearchTerm searchTerm: String, data: [Song]) {
        saveValue(forKey: .searchData, value: data, searchTerm: searchTerm)
    }
    
    func getSearchData(forSearchTerm searchTerm: String) -> ([Song]?) {
        let searchResult: [Song]? = readValue(forKey: .searchData, searchTerm: searchTerm)
        return searchResult
    }
    
    func removeSearchData(forSearchTerm searchTerm: String) {
        Key
            .allCases
            .map { $0.make(for: searchTerm) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    
    private func saveValue(forKey key: Key, value: [Song], searchTerm: String) {
        let encoder = JSONEncoder()
        if let encodedValue = try? encoder.encode(value) {
            userDefaults.set(encodedValue, forKey: key.make(for: searchTerm))
        }
    }
    
    private func readValue<T>(forKey key: Key, searchTerm: String) -> T? {
        if let savedData = userDefaults.value(forKey: key.make(for: searchTerm)) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(Song.self, from: savedData) {
                print(loadedData.artistName)
                return loadedData as! T
            }
        }
        return nil
    }
}
