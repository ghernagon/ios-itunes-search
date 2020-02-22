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
    
    var userDefaults: UserDefaults = UserDefaults.standard
    
//    init(userDefaults: UserDefaults = .standard) {
//        self.userDefaults = userDefaults
//        print(userDefaults)
//    }
    
    // MARK: - API
    
    // Store search term
    func storeTerm(_ searchTerm: String) {
        let time = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
        userDefaults.set(["date": time, "term": searchTerm], forKey: "term_\(searchTerm)")
    }
    
    // Store search results by term
    func storeSearchData(forSearchTerm searchTerm: String, data: [Song]) {
        saveValue(forKey: .searchData, value: data, searchTerm: searchTerm)
    }
    
    // Get an array of previous searches (just terms)
    func getSearchTerms() -> [String]? {
        var dafaultsSearch: [[String : Any]] = []
        var sortedHistorySearch: [String] = []
        
        for key in userDefaults.dictionaryRepresentation().keys {
            if key.hasPrefix("term_"){
                dafaultsSearch.append(userDefaults.dictionary(forKey: key)!)
            }
        }
        let sortedArray = dafaultsSearch.sorted { $0["date"] as? Int64 ?? .zero > $1["date"] as? Int64 ?? .zero }
        
        for dict in sortedArray {
            sortedHistorySearch.append(dict["term"] as! String)
        }
        
        return sortedHistorySearch
    }
    
    // Get local stored data by search term
    func getSearchData(forSearchTerm searchTerm: String) -> [Song]? {
        let searchResult: [Song]? = readValue(forKey: .searchData, searchTerm: searchTerm)
        return searchResult
    }
    
    // Remove local stored data by search term
    func removeSearchData(forSearchTerm searchTerm: String) {
        Key
            .allCases
            .map { $0.make(for: searchTerm) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    
    // It write data to NSUserDefaults
    private func saveValue(forKey key: Key, value: [Song], searchTerm: String) {
        let encoder = JSONEncoder()
        if let encodedValue = try? encoder.encode(value) {
            userDefaults.set(encodedValue, forKey: key.make(for: searchTerm))
        }
    }
    
    // It reads the stored local data by search term
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
