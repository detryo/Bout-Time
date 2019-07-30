//
//  ViewController.swift
//  Bout-Time
//
//  Created by Cristian Sedano Arenas on 22/07/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var downEvent1Button: UIButton!
    @IBOutlet weak var upEvent2Button: UIButton!
    @IBOutlet weak var downEvent2Button: UIButton!
    @IBOutlet weak var upEvent3Button: UIButton!
    @IBOutlet weak var downEvent3Button: UIButton!
    @IBOutlet weak var upEvent4Button: UIButton!
    @IBOutlet weak var eventText1: UITextView!
    @IBOutlet weak var eventText2: UITextView!
    @IBOutlet weak var eventText3: UITextView!
    @IBOutlet weak var eventText4: UITextView!
    @IBOutlet weak var greenNextButton: UIButton!
    @IBOutlet weak var redNextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var scoreRoundLabel: UILabel!

    var timer = Timer()
    var isTimerRunning = false
    var randomEvents: [EventItem] = []
    var wikipediaLink = ""
    let roundTime = 60
    var seconds = 60
    var currentRound = 0
    var eventManager: EventManager
    
    // MARK: - Load the plist file
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "EventsSource", offType: "plist")
            let events = try EventUnarchiver.eventItem(fromDictionary: dictionary)
            self.eventManager = EventManager(events: events)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startRound()
    }

    //MARK: - IBAction
    
    @IBAction func downEvent1Button(_ sender: UIButton) {
        randomEvents.swapAt(0, 1)
        
        displayEvents()
    }
    
    @IBAction func upEvent2Button(_ sender: UIButton) {
        randomEvents.swapAt(1, 0)
        
        displayEvents()
    }
    
    @IBAction func downEvent2Button(_ sender: UIButton) {
        randomEvents.swapAt(1, 2)
        
        displayEvents()
    }
    
    @IBAction func upEvent3Button(_ sender: UIButton) {
        randomEvents.swapAt(2, 1)
        
        displayEvents()
    }
    
    @IBAction func downEvent3Button(_ sender: UIButton) {
        randomEvents.swapAt(2, 3)
        
        displayEvents()
    }
    
    @IBAction func upEvent4Button(_ sender: UIButton) {
        randomEvents.swapAt(3, 2)
        
        displayEvents()
    }
    
    @IBAction func nextRoundGreenButton(_ sender: UIButton) {
        nextRound()
    }
    
    @IBAction func nextRoundRedButton(_ sender: UIButton) {
        nextRound()
    }
    
    @IBAction func eventView1Gesture(_ sender: UITapGestureRecognizer) {
        wikipediaLink = randomEvents[0].url
        callWebView()
    }
    
    @IBAction func eventView2Gesture(_ sender: UITapGestureRecognizer) {
        wikipediaLink = randomEvents[1].url
        callWebView()
    }
    
    @IBAction func eventView3Gesture(_ sender: UITapGestureRecognizer) {
        wikipediaLink = randomEvents[2].url
        callWebView()
    }
    
    @IBAction func eventView4Gesture(_ sender: UITapGestureRecognizer) {
        wikipediaLink = randomEvents[3].url
        callWebView()
    }
    
    @IBAction func gameOverButton(_ sender: UIButton) {
        gameOverButton.isHidden = true
        gameOverButton.isEnabled = false
        eventManager.numberOfRounds = 0
        eventManager.correctRounds = 0;
        nextRound()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAgainSegue" {
            let playAgainViewController = segue.destination as! PlayAgainViewController
            playAgainViewController.score = "\(eventManager.correctRounds) / \(eventManager.eventsPerRound)"
        } else if segue.identifier == "wikiSegueID" {
            let wikiViewController = segue.destination as! WikiViewController
            wikiViewController.wikipediaLink = wikipediaLink
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            timer.invalidate()
            checkAnswer()
        }
    }
    
    // MARK: - Game logic
    
    func displayEvents() {
        eventText1.text = randomEvents[0].description
        eventText2.text = randomEvents[1].description
        eventText3.text = randomEvents[2].description
        eventText4.text = randomEvents[3].description
    }
    
    func startRound() {
        eventManager.numberOfRounds += 1
        currentRound += 1
        
        scoreRoundLabel.text = "Round: \(currentRound)"
        
        timerLabel.isEnabled = true
        timerLabel.isHidden = false
        
        redNextButton.isEnabled = false
        redNextButton.isHidden = true
        
        greenNextButton.isEnabled = false
        greenNextButton.isHidden = true
        
        gameOverButton.isEnabled = false
        gameOverButton.isHidden = true
        
        randomEvents = eventManager.randdomEvents()
        
        displayEvents()
        runTimer()
    }
    
    func nextRound() {
        if eventManager.numberOfRounds < eventManager.eventsPerRound {
            resetTimer()
            startRound()
        } else {
            // Show play again view with score
            greenNextButton.isHidden = true
            greenNextButton.isEnabled = false
            redNextButton.isHidden = true
            redNextButton.isEnabled = false
            timerLabel.isHidden = true
            timerLabel.isEnabled = false
            gameOverButton.isHidden = false
            gameOverButton.isEnabled = true
            performSegue(withIdentifier: "playAgainSegue", sender: nil)
        }
    }
    
    func checkAnswer() {
        if (randomEvents[0].yearOfEvent <= randomEvents[1].yearOfEvent &&
            randomEvents[1].yearOfEvent <= randomEvents[2].yearOfEvent &&
            randomEvents[2].yearOfEvent <= randomEvents[3].yearOfEvent) {
            eventManager.correctRounds += 1
            greenNextButton.isEnabled = true
            greenNextButton.isHidden = false
        } else {
            redNextButton.isEnabled = true
            redNextButton.isHidden = false
        }
        timerLabel.isEnabled = true
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            checkAnswer()
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds)"
        }
    }
    
    func resetTimer() {
        seconds = roundTime
        timerLabel.text = "\(seconds)"
    }
    
    func callWebView() {
        performSegue(withIdentifier: "wikiSegueID", sender: nil)
    }
}

