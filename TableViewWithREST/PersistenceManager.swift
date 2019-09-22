//
//  PersistenceManager.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-22.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

class PersistenceManager {

    enum Path: String {
        case Public
        case Starred
        case MyGists
    }

    class private func cachesDirectory() -> URL?  {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    class func save<T: Encodable>(_ itemToSave: T, path: Path) -> Bool {
        guard let directory = cachesDirectory() else {
            print("Couldn't find caches directory")
            return false
        }
        let file = directory.appendingPathComponent(path.rawValue)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let itemAsData = try encoder.encode(itemToSave)

            // check for existing file
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }

            // add file
            FileManager.default.createFile(atPath: file.path, contents: itemAsData, attributes: nil)
        } catch {
            print(error)
            return false
        }
        return true
    }

    class func load<T: Decodable>(path: Path) -> T? {
        guard let directory = cachesDirectory() else {
            print("Couldn't find caches directory")
            return nil
        }

        let file = directory.appendingPathComponent(path.rawValue)
        if !FileManager.default.fileExists(atPath: file.path) {
            print("could not load - no file found")
            return nil
        }

        guard let itemAsData = FileManager.default.contents(atPath: file.path) else {
            print("could not load - no file contents")
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let item = try decoder.decode(T.self, from: itemAsData)
            return item
        } catch {
            print(error)
            return nil
        }
    }
}
