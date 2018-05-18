//
//  SongProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

private enum searchSongAPI: LSHTTPRequest {

    case getSongBySearch(String)

    func urlString() -> String {
        return LSConstants.youtubeUrl
    }

    func urlParameter() -> String {

        switch self {

        case .getSongBySearch(let song):

            return "/search"

        }
    }

    func requestParameters() -> [String : String] {

        switch self {
        case .getSongBySearch(let song):

            return ["part" : "snippet", "q" : song, "maxResult": "1", "key" : LSConstants.youtubeKey]
        }
    }


    func httpMethod() -> LSHTTPMethod {

        switch self {

        case .getSongBySearch:

            return .get
        }
    }
}

struct SongProvider {

    private weak var httpClient = LSHTTPClient.shared

    func getSearchSongs(songName: String, success: @escaping ([Song]) -> Void, failure: @escaping(LSError) -> Void) {

        httpClient?.request(searchSongAPI.getSongBySearch(songName), success: { (data) in

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return
            }

            guard let jj = json else {
                return
            }

            guard let items = jj["items"] as? [AnyObject] else { return }

            var songList = [Song]()

            for result in items {

                guard let snippetDict = result["snippet"] as? [String:Any], let id = result["id"] as? [String: AnyObject] else {
                    return
                }

                guard let thumbnails = snippetDict["thumbnails"] as? [String: AnyObject], let vedioID = id["videoId"] as? String, let title = snippetDict["title"] as? String, let defaultImage = thumbnails["default"] as? [String: AnyObject], let imageUrl = defaultImage["url"] as? String else {
                    return
                }

                let song = Song(id: vedioID, name: title, singer: nil, image: imageUrl, hasCaption: false, rank: nil, type: nil)

                songList.append(song)
            }

            success(songList)

        }, failure: { (error) in
            print(error)
        })

    }
}
