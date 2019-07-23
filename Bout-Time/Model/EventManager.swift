//
//  EventManager.swift
//  Bout-Time
//
//  Created by Cristian Sedano Arenas on 22/07/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import GameKit

enum EventSelection: String {
    case Event1
    case Event2
    case Event3
    case Event4
    case Event5
    case Event6
    case Event7
    case Event8
    case Event9
    case Event10
    case Event11
    case Event12
    case Event13
    case Event14
    case Event15
    case Event16
    case Event17
    case Event18
    case Event19
    case Event20
    case Event21
    case Event22
    case Event23
    case Event24
    case Event25
}

// MARK: - Event item protocol

protocol EventItem {
    var eventName: String { get }
    var yearOfEvent: Int { get }
    var url: String { get }
    var description: String { get }
    var id: Int { get }
}

// MARK: - Event protocol

protocol Events {
    var events: [EventSelection : EventItem] { get set }
    
    func item(forSelection selection: EventSelection) -> EventItem?
}

// MARK: - Implement EventItem Protocol

struct Item: EventItem {
    var eventName: String
    var yearOfEvent: Int
    var url: String
    var description: String
    var id: Int
}


enum EventError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
}

// MARK: - Plist converter

class PlistConverter {
    static func dictionary(fromFile name: String, offType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw EventError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else {
            throw EventError.conversionFailure
        }
        
        return dictionary
    }
}

// MARK: - Event Dictionary Creation

class EventUnarchiver {
    static func eventItem(fromDictionary dictionary: [String : AnyObject]) throws -> [EventSelection : EventItem] {
        var events: [EventSelection : EventItem] = [:]
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String : Any],
               let eventName = itemDictionary["eventName"] as? String,
               let yearOfEvent = itemDictionary["yearOfEvent"] as? Int,
               let url = itemDictionary["url"] as? String,
               let description = itemDictionary["description"] as? String,
               let id = itemDictionary["id"] as? Int {
                
                let item = Item(eventName: eventName, yearOfEvent: yearOfEvent, url: url, description: description, id: id)
                guard let selection = EventSelection(rawValue: key) else {
                    throw EventError.invalidSelection
                }
                
                events.updateValue(item, forKey: selection)
                
            }
        }
        
        return events
    }
}

// MARK: - EventManager implement Events Protocols

class EventManager : Events {
    var eventsAsked = 0
    var eventsPerRound = 6
    var correctRounds = 0
    var numberOfRounds = 0
    var randomNumberGenerated = [Int]()
    
    var events: [EventSelection : EventItem]
    
    init(events: [EventSelection: EventItem]) {
        self.events = events
    }
    
    func item(forSelection selection: EventSelection) -> EventItem? {
        return events[selection]
    }
    
    func generateUniqueNumber() -> Int {
        if randomNumberGenerated.count >= self.events.count {
            randomNumberGenerated.removeAll()
        }
        
        var randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
        while randomNumberGenerated.contains(randomNumber) {
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: self.events.count)
        }
        
        randomNumberGenerated.append(randomNumber)
        
        return randomNumber
    }
    
    // MARK: - Random Event Selection
    
    func randomEvent() throws -> EventItem {
        guard let selection = EventSelection(rawValue: "Event\(generateUniqueNumber()+1)") else {
            throw EventError.invalidSelection
        }
        
        guard let event = events[selection] else {
            throw EventError.invalidResource
        }
        
        return event
    }
    
    func randomEvents() -> [EventItem] {
        var randomEvents: [EventItem] = []
        
        for _ in 1...eventsPerRound {
            do {
                try randomEvents.append(randomEvent())
            } catch {
                print("Event error \(error)")
            }
        }
        return randomEvents
    }
}
