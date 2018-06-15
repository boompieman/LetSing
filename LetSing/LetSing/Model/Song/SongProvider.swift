//
//  SongProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

private enum SearchSongAPI: LSHTTPRequest {

    case getSongBySearch(String, String)

    case getSongByDiscover(String)

    func urlString() -> String {
        return LSConstants.youtubeUrl
    }

    func urlParameter() -> String {

        switch self {

        case .getSongBySearch:

            return "/search"

        case .getSongByDiscover:

            return "/search"

        }
    }

    func requestParameters() -> [String: String] {

        switch self {
        case .getSongBySearch(let searchText, let pageToken):

            // partial request
            return [
                "type": "video",
                "part": "snippet",
                "fields": "nextPageToken,items(id,snippet(title,thumbnails(default)))",
                "q": searchText,
                "maxResults": "5",
                "key": LSConstants.youtubeKey,
                "pageToken": pageToken
            ]

        case .getSongByDiscover(let songName):

            return [
                "type": "video",
                "part": "snippet",
                "fields": "nextPageToken,items(id,snippet(title,thumbnails(default)))",
                "q": songName,
                "maxResults": "1", "key": LSConstants.youtubeKey
            ]
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

    private let parser = LSJsonParser()

    func getSearchSongs(searchText: String, pageToken: String, success: @escaping ([Song], String) -> Void, failure: @escaping(LSError) -> Void) {

        httpClient?.request(
            SearchSongAPI.getSongBySearch(searchText, pageToken),
            success: { (data) in

                self.parser.parseToSongs(data: data, completion: {(songList, pageToken) in
                    success(songList, pageToken)
                })
        },
            failure: { (error) in
            print(error)
        })
    }

    func getDiscoverSong(songName: String, success: @escaping (Song) -> Void, failure: @escaping(LSError) -> Void) {

        httpClient?.request(
            SearchSongAPI.getSongByDiscover(songName),
            success: { (data) in

                self.parser.parseToSongs(data: data, completion: {(songList, _) in
                    success(songList[0])
                })
        },
            failure: { (error) in
            print(error)
        })
    }
}
