//
//  LyricProvider.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

private enum LyricsAPI: LSHTTPRequest {

    case getLyrics(String)

//    case getLyricsLines(String)

    func urlString() -> String {

        return LSConstants.captionsUrl

    }

    func urlParameter() -> String {

        switch self {

        case .getLyrics(let songId):

            return LSConstants.emptyString

//        case .getLyricsLines(let lyricsId):
//
//            return "/captions/id"
        }
    }

    func requestParameters() -> [String: String] {

        switch self {
        case .getLyrics(let songId):

            return ["lang": "zh-TW", "v": songId]

//        case .getLyricsLines(let lyricsId):
//
//            return ["id": lyricsId]
        }
    }

    func httpMethod() -> LSHTTPMethod {

        switch self {

        case .getLyrics:

            return .get

//        case .getLyricsLines:
//
//            return .get
        }
    }
}

struct LyricsProvider {

    private weak var httpClient = LSHTTPClient.shared

    let parser = LSXMLParser()

    func getLyrics(
        songId: String,
        success: @escaping (Lyrics) -> Void,
        failure: @escaping(LSError) -> Void) {

        httpClient?.request(LyricsAPI.getLyrics(songId), success: { (data) in

            let lines:[Line] = self.parser.parseForLines(data: data)

            success(Lyrics(songId: songId, lines: lines))

        }, failure: { (error) in
            print(error)
        })

    }
}
