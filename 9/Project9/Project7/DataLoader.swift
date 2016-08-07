//
//  DataLoader.swift
//  Project7
//
//  Created by Mike Stubna on 12/2/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import Foundation

class DataLoader {

    // for loading remote data
    let baseString = "https://api.whitehouse.gov/v1/petitions.json"
    var urlStrings: [String] {
        return [
            baseString + "?limit=100&createdAfter=1467394257",
            baseString + "?signatureCountFloor=15000&limit=100&createdAfter=1451669457"
        ]
    }

    // saved data for testing
    let fileNames = [
        "data0",
        "data1"
    ]

    func run(loadLiveData liveData: Bool, option: Int) -> [JSON]? {
        guard let json = liveData ? loadLiveData(option) : loadSavedData(option) else { return nil }
        return sortData(json, option: option)
    }

    private func loadSavedData(option: Int) -> JSON? {
        let fileName = fileNames[option]
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
            else { return nil }
        guard let data = NSData(contentsOfFile: path) else { return nil }
        return JSON(data: data)
    }

    private func loadLiveData(option: Int) -> JSON? {
        let urlString = urlStrings[option]
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                guard json["metadata"]["responseInfo"]["status"].intValue == 200 else { return nil }
                return json
            }
        }
        return nil
    }

    private func sortData(json: JSON, option: Int) -> [JSON] {
        if option == 0 {
            return json["results"].arrayValue.sort { $0["created"] > $1["created"] }
        }
        return json["results"].arrayValue.sort { $0["signatureCount"] > $1["signatureCount"] }
    }
}
