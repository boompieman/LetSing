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

    case getSongByDiscover(String)

    func urlString() -> String {
        return LSConstants.youtubeUrl
    }

    func urlParameter() -> String {

        switch self {

        case .getSongBySearch(let _):

            return "/search"

        case .getSongByDiscover(let _):

            return "/search"

        }
    }

    func requestParameters() -> [String : String] {

        switch self {
        case .getSongBySearch(let searchText):

            // partial request
            return ["type" : "video", "part" : "snippet", "fields": "items(id,snippet(title,thumbnails(default)))", "q" : searchText, "maxResults": "7", "key" : LSConstants.youtubeKey]

        case .getSongByDiscover(let songName):

            return ["type" : "video", "part" : "snippet", "fields": "items(id,snippet(title,thumbnails(default)))", "q" : songName, "maxResults": "1", "key" : LSConstants.youtubeKey]
        }
    }


    func httpMethod() -> LSHTTPMethod {

        switch self {

        case .getSongBySearch:

            return .get

        case .getSongByDiscover:

            return .get
        }
    }
}

struct SongProvider {

    private weak var httpClient = LSHTTPClient.shared

    let parser = LSJsonParser()

    func getSearchSongs(searchText: String, success: @escaping ([Song]) -> Void, failure: @escaping(LSError) -> Void) {

        httpClient?.request(
            searchSongAPI.getSongBySearch(searchText),
            success: { (data) in

                let songList = self.parser.parseToSongs(data: data)
                success(songList)
        },
            failure: { (error) in
            print(error)
        })
    }

    func getDiscoverSong(songName: String, success: @escaping (Song) -> Void, failure: @escaping(LSError) -> Void) {

        httpClient?.request(
            searchSongAPI.getSongByDiscover(songName),
            success: { (data) in

                let songList: [Song] = self.parser.parseToSongs(data: data)

                
                success(songList[0])

        },
            failure: { (error) in
            print(error)
        })
    }
}
