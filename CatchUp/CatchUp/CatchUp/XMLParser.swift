//
//  XMLParser.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/28/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit



@objc protocol XMLParserDelegate {
    
    func parsingWasFinished()
}

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var delegate: XMLParserDelegate?
    
    var arrParsedData = [Dictionary<String, String>]()
    
    var currentDataDictionary = Dictionary<String, String>()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var url = ""
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingWasFinished()
    }
    
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        let parser = NSXMLParser(contentsOfURL: rssURL)
        parser!.delegate = self
        parser!.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        
        if (currentElement == "media:content") {
            url = String(UTF8String: attributeDict["url"]!)!
        } else if (currentElement == "media:thumbnail") {
            url = String(UTF8String: attributeDict["url"]!)!
        }
    }

    
    func parser(parser: NSXMLParser, foundCharacters string: String!) {
        if (currentElement == "media:content") {
            foundCharacters += url
        } else if (currentElement == "media:thumbnail") {
            foundCharacters += url
        }
        else if (currentElement == "title" || currentElement == "link" || currentElement == "pubDate" || currentElement == "description") {
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if !foundCharacters.isEmpty {
            
            if elementName == "link" {
                foundCharacters = (foundCharacters as NSString).substringFromIndex(3) //manipulate link string
            }
            
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentElement == "description" {
                arrParsedData.append(currentDataDictionary)
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.description)
    }
    
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print(validationError.description)
    }

}
