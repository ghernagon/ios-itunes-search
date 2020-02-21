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
    func storeTerm(_ searchTerm: String) {
        let time = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
        userDefaults.set(["date": time, "term": searchTerm], forKey: "term_\(searchTerm)")
    }
    
    func storeSearchData(forSearchTerm searchTerm: String, data: [Song]) {
        saveValue(forKey: .searchData, value: data, searchTerm: searchTerm)
    }
    
    func getSearchTerms() -> [String]? {
        var dafaultsSearch: [[String : Any]] = []
        var sortedHistorySearch: [String] = []
        
        for key in userDefaults.dictionaryRepresentation().keys {
            if key.hasPrefix("term_"){
                dafaultsSearch.append(userDefaults.dictionary(forKey: key)!)
            }
        }
        let sortedArray = dafaultsSearch.sorted { $0["date"] as? Int64 ?? .zero < $1["date"] as? Int64 ?? .zero }
        
        for dict in sortedArray {
            sortedHistorySearch.append(dict["term"] as! String)
        }
        
        return sortedHistorySearch
    }
    
    func getSearchData(forSearchTerm searchTerm: String) -> [Song]? {
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
    
    private func readValue<T>(forKey key: Key, searchTerm: String) -> [T]? {
        if let savedData = userDefaults.value(forKey: key.make(for: searchTerm)) as? Data {
            let decoder = JSONDecoder()
            do {
                if let loadedData = try? decoder.decode([Song].self, from: savedData) {
                    return loadedData as? [T]
                }
            } catch  {
                print(error)
            }
        }
        return nil
    }
}
