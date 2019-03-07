//
//  TimeViewController.swift
//  Addition Game
//
//  Created by Yaroslav Sarnitskiy on 08.12.16.
//  Copyright © 2016 GS Develop Inc. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class TimeViewController: UIViewController {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblTotalCorrect: UILabel!
    @IBOutlet weak var lblCorrectIncorrect: UILabel!
    
    @IBOutlet weak var lblTimeLeft: UILabel!
    
    @IBOutlet weak var btnAnswer0: UIButton!
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    
    var firstNumber = 0
    var secondNumber = 0
    var answer = 0
    
    var correctIncorrect = ""
    
    var buttonRandom = 0
    var score = 0
    var bestCorrect = 0
    
    var incorrectAnswer1 = 0
    var incorrectAnswer2 = 0
    var incorrectAnswer3 = 0
    
    var timeLeft = 60
    var timer = Timer()
    
    var gameOver = false // if time run out
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerSecond = AVAudioPlayer()
    var audioPlayerThird = AVAudioPlayer()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        bestCorrect = UserDefaults.standard.integer(forKey: "bestCorrect")
        
        startCounting()
        
        randomizeTheNumbers()
        printButtonText()
        printStats()
        
        lblCorrectIncorrect.text = "\(NSLocalizedString("CORRECT_INCORRECT", comment: "Correct / Incorrect"))"
    }
    
    func buttonPresedSoundPlay() {
        let click = NSURL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "mp3")!)
        do {
            audioPlayerSecond = try AVAudioPlayer(contentsOf: click as URL)
            audioPlayerSecond.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayerSecond.play()
    }
    
    func startCounting(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimeViewController.countDown), userInfo: nil, repeats: true)
    }
    
    func countDown(){
        let tick = NSURL(fileURLWithPath: Bundle.main.path(forResource: "tick", ofType: "mp3")!)
        do {
            audioPlayerSecond = try AVAudioPlayer(contentsOf: tick as URL)
            audioPlayerSecond.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayerSecond.play()
        
        
        
        timeLeft -= 1
        lblTimeLeft.text = NSLocalizedString("TIME", comment: "Time Left") + ": \(timeLeft)"
        
        if timeLeft == 0 {
            timer.invalidate()
            gameOverLogic()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAnswer0ACTION(_ sender: UIButton) {
        if buttonRandom == 0 {
            button0Correct()
        }else if buttonRandom != 0 {
            incorrectAnswer()
        }
        
        randomizeTheNumbers()
        printButtonText()
    }
    
    @IBAction func btnAnswer1ACTION(_ sender: UIButton) {
        if buttonRandom == 1 {
            button1Correct()
        }else if buttonRandom != 1 {
            incorrectAnswer()
        }
        
        randomizeTheNumbers()
        printButtonText()
    }
    
    @IBAction func btnAnswer2ACTION(_ sender: UIButton) {
        if buttonRandom == 2 {
            button2Correct()
        }else if buttonRandom != 2 {
            incorrectAnswer()
        }
        
        randomizeTheNumbers()
        printButtonText()
    }
    
    @IBAction func btnAnswer3ACTION(_ sender: UIButton) {
        if buttonRandom == 3 {
            button3Correct()
        }else if buttonRandom != 3 {
            incorrectAnswer()
        }
        
        randomizeTheNumbers()
        printButtonText()
    }
    
    @IBAction func btnRestartACTION(_ sender: UIButton) {
        resetButton()
        buttonPresedSoundPlay()
    }
    
    func randomizeTheNumbers(){
        
        firstNumber = Int(arc4random_uniform(9))
        secondNumber = Int(arc4random_uniform(9))
        answer = firstNumber + secondNumber
        
        buttonRandom = Int(arc4random_uniform(4))
        
        incorrectAnswer1 = Int(arc4random_uniform(15))
        incorrectAnswer2 = Int(arc4random_uniform(9))
        incorrectAnswer3 = Int(arc4random_uniform(7))
        
        checkTheRandom()
        
        printTheQuestion()
    }
    
    func checkTheRandom(){
        if answer == incorrectAnswer1 || answer == incorrectAnswer2 || incorrectAnswer1 == incorrectAnswer2  || answer == incorrectAnswer3 {
            incorrectAnswer1 = Int(arc4random_uniform(15))
            incorrectAnswer2 = Int(arc4random_uniform(9))
            incorrectAnswer3 = Int(arc4random_uniform(7))
            
            if answer == incorrectAnswer1 || answer == incorrectAnswer2 || answer == incorrectAnswer3 {
                incorrectAnswer1 = 20
                incorrectAnswer2 = 25
                incorrectAnswer3 = 19
            }
            
            
        }
        
        
    }
    
    func printTheQuestion(){
        lblQuestion.text = "\(firstNumber) + \(secondNumber) = ?"
    }
    
    func printButtonText(){
        if buttonRandom == 0 {
            btnAnswer0.setTitle("\(answer)", for: .normal)
            btnAnswer1.setTitle("\(incorrectAnswer1)", for: .normal)
            btnAnswer2.setTitle("\(incorrectAnswer2)", for: .normal)
            btnAnswer3.setTitle("\(incorrectAnswer3)", for: .normal)
        }
        
        if buttonRandom == 1 {
            btnAnswer1.setTitle("\(answer)", for: .normal)
            btnAnswer0.setTitle("\(incorrectAnswer1)", for: .normal)
            btnAnswer2.setTitle("\(incorrectAnswer3)", for: .normal)
            btnAnswer3.setTitle("\(incorrectAnswer2)", for: .normal)
        }
        
        if buttonRandom == 2 {
            btnAnswer2.setTitle("\(answer)", for: .normal)
            btnAnswer1.setTitle("\(incorrectAnswer3)", for: .normal)
            btnAnswer0.setTitle("\(incorrectAnswer1)", for: .normal)
            btnAnswer3.setTitle("\(incorrectAnswer2)", for: .normal)
        }
        
        if buttonRandom == 3 {
            btnAnswer3.setTitle("\(answer)", for: .normal)
            btnAnswer1.setTitle("\(incorrectAnswer2)", for: .normal)
            btnAnswer2.setTitle("\(incorrectAnswer1)", for: .normal)
            btnAnswer0.setTitle("\(incorrectAnswer3)", for: .normal)
        }
    }
    
    func incorrectAnswer(){
        // play lose sound
        let loseSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "lose", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: loseSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayer.play()
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        UIView.animate(withDuration: 0.8, animations: {
            self.view.backgroundColor = UIColor.red
            
            UIView.animate(withDuration: 0.8, animations: {
                self.view.backgroundColor = UIColor.white
            }, completion: nil)
            
        }, completion: nil)
        
        
        correctIncorrect = "\(NSLocalizedString("INCORRECT", comment: "Incorrect"))"
        score = score - 1
        printStats()
    }
    
    func button0Correct(){
        correctLogic()
    }
    
    func button1Correct(){
        correctLogic()
    }
    
    func button2Correct(){
        correctLogic()
    }
    
    func button3Correct(){
        correctLogic()
    }
    
    func correctLogic(){
        // win sound
        let winSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "win", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: winSound as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting File")
        }
        audioPlayer.play()
        
        UIView.animate(withDuration: 0.8, animations: {
            self.view.backgroundColor = UIColor.green
            
            UIView.animate(withDuration: 0.8, animations: {
                self.view.backgroundColor = UIColor.white
            }, completion: nil)
            
        }, completion: nil)
        
        
        score = score + 1
        correctIncorrect = "\(NSLocalizedString("CORRECT", comment: "Correct"))"
        printStats()
    }
    
    func saveBestScore(){
        if bestCorrect < score {
            bestCorrect = score
            UserDefaults.standard.setValue(bestCorrect, forKey: "bestCorrect")
            UserDefaults.standard.synchronize()
        }
        
        
        print("best \(bestCorrect)")
    }
    
    func printStats(){
        
        
        lblTotalCorrect.text = NSLocalizedString("SCORE", comment: "Score") + ": \(score)"
        lblCorrectIncorrect.text = "\(correctIncorrect)"
    }
    
    func resetButton(){
        timer.invalidate()
        
        timeLeft = 60
        
        lblTimeLeft.text = NSLocalizedString("TIME", comment: "Time Left") + ": \(timeLeft)"
        lblTotalCorrect.text = NSLocalizedString("SCORE", comment: "Score") + ": \(score)"
        lblCorrectIncorrect.text = "\(NSLocalizedString("CORRECT_INCORRECT", comment: "Correct / Incorrect"))"
        randomizeTheNumbers()
        
        gameOver = false
    }
    
    func gameOverLogic(){
        gameOver = true
        saveBestScore()
        
        let viewControllers: [UIViewController] = navigationController!.viewControllers as [UIViewController]
        navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
