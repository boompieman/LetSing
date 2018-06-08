//
//  XMLParser.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/18.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

class LSXMLParser: NSObject {

    private var lines = [Line]()

    private var start: Float?

    private var duration: Float?

    private var words: String?

    func parseForLines(data: Data) -> [Line] {

        let parser = XMLParser(data: data)

        parser.delegate = self
        parser.parse()

        return self.lines
    }
}

extension LSXMLParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        if elementName == "text" {
            let words = String()

            guard let start = attributeDict["start"] as? String, let duration = attributeDict["dur"] as? String else { return }

            guard let floatStart = Float(start), let floatDuration = Float(duration) else { return }

            self.start = floatStart
            self.duration = floatDuration
        }

    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "text" {
            print("parser did end")

            guard let words = words, let start = start, let duration = duration else {
                return
            }

            let line = Line(words: words, start: start, duration: duration)

            print(line)

            lines.append(line)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            self.words = data
        }
    }
}
