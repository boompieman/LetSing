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

                let song = Song(name: title, singer: nil, image: imageUrl, youtube_url: vedioID, rank: nil, type: nil)

                songList.append(song)
            }

            success(songList)

        }, failure: { (error) in
            print(error)
        })

    }
}

//struct AuthorProvider {
//
//    private weak var httpClient = VoyageHTTPClient.shared
//
//    func getAuthor(
//        authorId: String = VYConstants.emptyString,
//        success: @escaping (Author) -> Void,
//        failure: @escaping (VoyageError) -> Void
//        ) {
//        httpClient?.request(AuthorAPI.getAuthor(authorId), success: { value in
//
//            do {
//                var author = [Author]
//
//                guard let value = value else {
//                    return
//                }
//
//                for val in value {
//
//                    let author = Author.fromFirebaseValue(value: val)
//
//                    if author != nil {
//                        print("no author")
//                    }
//                }
//
//                success(author)
//
//            }
//
//        }, failure: {
//
//            print("error: can't not retrieve data")
//
//        })
//    }
//
//    func getSpotArticles(
//        spotId: String,
//        success: @escaping ([Article]) -> Void,
//        failure: @escaping (VoyageError) -> Void) {
//
//        httpClient?.request(ArticleAPI.getSpotAritles(spotId), success: { (value) in
//
//            do {
//                var articles = [Article]()
//
//                guard let value = value else {
//                    return
//                }
//
//                for val in value {
//
//                    let request = Database.database().reference().child("articles").child(val.key)
//
//                    request.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                        guard let a = (key: snapshot.key, value: snapshot.value) as? (key: String, value: AnyObject) else { return }
//
//                        let article = Article.fromFirebaseValue(value: a)
//
//                        if article != nil {
//                            articles.append(article!)
//                        }
//
//                    }, withCancel: { (error) in
//                        print(error)
//                    })
//                }
//
//
//            }
//
//        }, failure: {
//            print("error: can't not retrieve data")
//        })
//    }
//}
//
