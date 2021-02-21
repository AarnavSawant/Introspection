//
//  RecordingViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/12/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Speech
import FirebaseAnalytics
//import StarWarsTextView
class RecordingViewController: UIViewController {
    var microPhoneEnabled: Bool?
    @IBOutlet weak var voiceImage: UIImageView!
    @IBOutlet weak var goAheadLabel: UILabel!
    var timer: Timer?
    var shouldContinue: Bool?
    var number: Int?
    var isStillRunning:Bool?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) //Does the Actual Speech Recognition in English
    @IBOutlet weak var TranscribedText:UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopRecordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? //Controls the buffer between when User speaks and speechRecognizer does recognition
        private let audioEngine = AVAudioEngine() //Processes the Audio Stream
      
    //    @IBOutlet weak var stopButton: UIButton!
        private var recognitionTask: SFSpeechRecognitionTask? //Used to cancel, stop, or start current recognition task
    override func viewDidLoad() {
        TranscribedText.isEditable = false
        TranscribedText.isSelectable = false
        Analytics.logEvent("entered_Recording_Screen", parameters: nil)
        timerLabel.alpha = 0.6
        voiceImage.backgroundColor = .none
        timerLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        TranscribedText.isHidden = true
        self.TranscribedText.backgroundColor = .white
//        timerLabel.isHidden = true
        let navView = UIView()

        let label = UILabel()
        label.text = "introspection"
        label.sizeToFit()
        label.center = navView.frame.origin

        let image = UIImageView()
        image.image = UIImage(named: "Infinity")
        label.frame.size.width = 150
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)

        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
        view.backgroundColor = .white
        image.contentMode = UIView.ContentMode.scaleAspectFit

        navView.addSubview(label)
        navView.addSubview(image)

        self.navigationItem.titleView = navView

        navView.sizeToFit()
        super.viewDidLoad()
//        TranscribedText.startCrawlingAnimation()
        number = 0
        //        scrollTextView.crawlingSpeed = 7.5
        //                scrollTextView.inclinationRatio = 1.0
        //                print("INCLINE", scrollTextView.inclinationRatio)
        //                scrollTextView.isHidden = false
        //                scrollTextView.startCrawlingAnimation()
        //                mainImageView.isHidden = true
                //        TranscribedText.isHidden = true
        //                howWasYourDayLabel.isHidden = true
                        SFSpeechRecognizer.requestAuthorization {
                            (auth_status) in
                            switch auth_status {
                            case .authorized:
                                print("Hello")
                                self.shouldContinue = true
                                print(self.shouldContinue)
                            case .denied:
                                self.shouldContinue = false
                                print("User denied permission to use microphone")
                            case .notDetermined:
                                self.shouldContinue = false
                                print("Speech Recognition not yet authorized")
                            case .restricted:
                                self.shouldContinue = false
                                print("Speech Recognition is restricted")
                            @unknown default:
                                self.shouldContinue = false
                                print("Unknown Error")
                            }
                        }
//                        switch AVAudioSession.sharedInstance().recordPermission {
//                            case AVAudioSessionRecordPermission.granted:
//                                microPhoneEnabled = true
//                                print("Permission granted")
//                            case AVAudioSessionRecordPermission.denied:
//                                microPhoneEnabled = false
//                                print("Pemission denied")
//                            case AVAudioSessionRecordPermission.undetermined:
//                                microPhoneEnabled = false
//                                print("Request permission here")
//                            default:
//                                break
//                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            print(self.shouldContinue)
                            if self.shouldContinue! {
                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeTimerNumber), userInfo: nil, repeats: true)
                            print(self.timer)
                                Analytics.logEvent("press_record_button", parameters: nil)
                                        print("hello")
                            self.isStillRunning = true
        //                        self.SpeakButton.layer.cornerRadius = 0.5 * self.SpeakButton.frame.width
                            self.startRecording()
        //                    self.stopButton.isHidden = false
        //                    self.stopButton.isEnabled = true
        //                    self.SpeakButton.isHidden = true
        //                        self.SpeakButton.isEnabled = false
                            } else if !(self.shouldContinue!){
                                let alertController = UIAlertController(title: "Speech Recognition Required", message: "Please enable speech recognition in settings.", preferredStyle: UIAlertController.Style.alert)

                                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                                    //Redirect to Settings app
                                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                                })

                                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                                alertController.addAction(cancelAction)

                                alertController.addAction(okAction)

                                self.present(alertController, animated: true, completion: nil)
                            }
                        }

        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "confirm_segue" {
            let words = TranscribedText.text!.components(separatedBy: " ").count
            print(TranscribedText.text!.count)
                       if words > 8 {
                           audioEngine.stop()
                           recognitionRequest?.endAudio()
                            self.performSegue(withIdentifier: "confirm_segue", sender: self)
//                           SpeakButton.isEnabled = true
//                           SpeakButton.setTitle("Start", for: .normal)
//                            return true
                       } else {
                           audioEngine.stop()
                           recognitionRequest?.endAudio()
//                           SpeakButton.isEnabled = true
                           print("Yay")
                        let tab_vc = self.presentingViewController as! MainTabBarController
                        self.dismiss(animated: true, completion: nil)
                        let nav_vc = tab_vc.viewControllers![tab_vc.selectedIndex] as! ReflectViewController
                        let vc = nav_vc.viewControllers[0] as! QuestionViewController
                        vc.howWasYourDayLabel.text = "Tell me a bit more about your day"
                        vc.TranscribedText.text = "Oops! I need at least 8 words! The more, the better!"
//                           SpeakButton.setTitle("Start", for: .normal)
//                           TranscribedText.text = "Tell me a bit more about your day!"
                       }
        }
            return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
            
    }
    @IBAction func didClickStopButton(_ sender: Any) {
        number = 0
        timer!.invalidate()
//        tapToRecordButton.text = "Tap to Record"
        if audioEngine.isRunning {
            isStillRunning = false
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            SpeakButton.isEnabled = true
//        } else {
//            SpeakButton.isEnabled = false
//        }
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             let destinationVC = segue.destination as! ResultsNavController
            destinationVC.text = TranscribedText.text
            destinationVC.modalPresentationStyle = .fullScreen
//            self.dismiss(animated: true, completion: nil)
//            self.TranscribedText.text = "Thank you for Introspecting!"
        }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setMode(.measurement) //set
            try audioSession.setCategory(.record)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error loading AVAudioSession Properties")
        }
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSessionRecordPermission.granted:
                microPhoneEnabled = true
                print("Permission granted")
            case AVAudioSessionRecordPermission.denied:
                timer?.invalidate()
                self.dismiss(animated: true, completion: nil)
                let alertController = UIAlertController(title: "Microphone Required", message: "Please enable the microphone in settings.", preferredStyle: UIAlertController.Style.alert)

                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })

                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
                microPhoneEnabled = false
                print("Pemission denied")
            case AVAudioSessionRecordPermission.undetermined:
                timer?.invalidate()
                self.dismiss(animated: true, completion: nil)
                let alertController = UIAlertController(title: "Microphone Required", message: "Please enable the microphone in settings.", preferredStyle: UIAlertController.Style.alert)

                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })

                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
                microPhoneEnabled = false
                print("Request permission here")
            default:
                break
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode: AVAudioInputNode = audioEngine.inputNode
        if inputNode == nil { //Singleton for Audio = InputNode
            fatalError("audioEngine has no input")
        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("RecognitionRequest is nil")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if self.TranscribedText.text.count > 0 {
                self.goAheadLabel.isHidden = true
                self.voiceImage.isHidden = true
                self.TranscribedText.isHidden = false
        
            }
            if (result != nil) {
                print("Transcribed Text Running", self.TranscribedText.text)
                guard let running = self.isStillRunning else {
                    return
                }
                if running {
//                    self.TranscribedText.text = "blah blah blah blah blah blah blah blah"
                    self.TranscribedText.text = result?.bestTranscription.formattedString
                    let range = NSRange(location: self.TranscribedText.text.count - 1, length: 0)
                    self.TranscribedText.scrollRangeToVisible(range)
                }
                isFinal = (result?.isFinal)!
            }
            if (error != nil || isFinal) {
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
            }
        })
        let recordFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordFormat) { (buffer, where) in
            recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            fatalError("Audio Engine Not Starting")
        }
        self.TranscribedText.text = "Go Ahead, I'm Listening"
        
        
        
        
    }
    
    @objc func changeTimerNumber() {
            print("Timer Changed Booooyah")
            number = number! + 1
            self.timerLabel.text = "00:\(20 - number!)s"
            if number == 20 {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                self.timer!.invalidate()
                self.number = 0
//                self.tapToRecordButton.text = "Tap to Record"
                if self.audioEngine.isRunning {
                    self.isStillRunning = false
                       }
//                    self.stopButton.isHidden = true
    //                self.stopButton.isEnabled = false
//                    self.SpeakButton.isHidden = false
    //                self.SpeakButton.isEnabled = true
                let words = self.TranscribedText.text!.components(separatedBy: " ").count
                print(self.TranscribedText.text!.count)
                    if words > 8 {
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
//                        self.SpeakButton.isEnabled = true
                        self.performSegue(withIdentifier: "confirm_segue", sender: self)
//                        self.SpeakButton.setTitle("Start", for: .normal)
                    } else {
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        let tab_vc = self.presentingViewController as! MainTabBarController
                        self.dismiss(animated: true, completion: nil)
                        let nav_vc = tab_vc.viewControllers![tab_vc.selectedIndex] as! ReflectViewController
                        let vc = nav_vc.viewControllers[0] as! QuestionViewController
                        vc.howWasYourDayLabel.text = "Tell me a bit more about your day"
                        vc.TranscribedText.text = "Oops! I need at least 8 words! The more, the better!"
//                        self.SpeakButton.isEnabled = true
                        print("Yay")
//                        self.SpeakButton.setTitle("Start", for: .normal)
//                        self.TranscribedText.text = "Tell me a bit more about your day!"
                    }
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
