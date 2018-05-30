//
//  LSJsonParser.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/22.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

class LSJsonParser {

    var songList = [Song]()

    var pageToken = LSConstants.emptyString

    func getPaging(pageToken: String) -> String {
        return pageToken
    }

    func parseToSongs(data: Data) {

        songList.removeAll()

        guard let json = try? parse(data: data) else {
            return
        }

        guard let items = json["items"] as? [AnyObject] else {

            return }

        guard let pageToken = json["nextPageToken"] as? String else { return }

        self.pageToken = pageToken

        for result in items {

            guard let snippetDict = result["snippet"] as? [String:Any], let id = result["id"] as? [String: AnyObject] else {
                return
            }

            guard let thumbnails = snippetDict["thumbnails"] as? [String: AnyObject], let vedioID = id["videoId"] as? String, let title = snippetDict["title"] as? String, let defaultImage = thumbnails["default"] as? [String: AnyObject], let imageUrl = defaultImage["url"] as? String else {
                return
            }

            let song = Song(id: vedioID, name: title, singer: nil, image: imageUrl, rank: nil, type: nil)

            self.songList.append(song)
        }
    }

    private func parse(data: Data) throws -> [String : AnyObject] {

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            throw LSError.jsonParsedError
        }

        guard let jsonGuard = json else {
            throw LSError.jsonParsedError
        }

        return jsonGuard
    }
}
