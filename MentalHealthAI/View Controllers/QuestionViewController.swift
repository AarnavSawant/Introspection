//
//  ViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/2/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Speech
import CoreML
import Firebase
import FirebaseFirestore
class QuestionViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var howWasYourDayLabel: UILabel!
    @IBOutlet weak var TranscribedText: UILabel!
    @IBOutlet weak var transcribedTextView: UIView!
    
    @IBOutlet weak var SpeakButton: UIButton!

    @IBOutlet weak var mainImageView: UIImageView!
    
    var timer: Timer?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    @IBOutlet weak var tapToRecordButton: UILabel!
    public var email: String?
    var isStillRunning:Bool?
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var UserSentenceLabel: UILabel!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
  
    @IBOutlet weak var stopButton: UIButton!
    private var recognitionTask: SFSpeechRecognitionTask?
    public var completionHandler: ((String) -> Void)?
    
    var number: Int?
    override func viewDidLoad() {
        print(UserDefaults.standard.object(forKey: "emailAddress"))
        let timestamp = NSDate().timeIntervalSince1970
        print(timestamp)
        print(timestamp)
        
        //UI Stuff
//        SpeakButton.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        SpeakButton.backgroundColor = .white
        SpeakButton.translatesAutoresizingMaskIntoConstraints = false
        SpeakButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        let parent = self.view!
        SpeakButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        stopButton.backgroundColor = .systemRed
//        SpeakButton.translatesAutoresizingMaskIntoConstraints = false
//        stopButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        let parent = self.view!
//        stopButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        SpeakButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 164).isActive = true
//        SpeakButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 589).isActive = true
        tapToRecordButton.frame = CGRect(x: 0, y: 0, width: 116, height: 64)
        tapToRecordButton.backgroundColor = .white

        tapToRecordButton.alpha = 0.6
        tapToRecordButton.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        tapToRecordButton.font = UIFont(name: "SFProText-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.96
        
        let navView = UIView()

        // Create the label
        let label = UILabel()
        label.text = "introspection"
        label.sizeToFit()
        label.center = navView.frame.origin
//        label.textAlignment = NSTextAlignment.center

        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "Infinity")
        label.frame.size.width = 150
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        // To maintain the image's aspect ratio:
        label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)
        // Setting the image frame so that it's immediately before the text:
//        image.contentMode = .center
        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
        view.backgroundColor = .white
        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)

        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView

        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()

        // Line height: 63 pt
        // (identical to box height)

        tapToRecordButton.textAlignment = .center
        tapToRecordButton.attributedText = NSMutableAttributedString(string: "Tap to answer", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        mainImageView.frame = CGRect(x: 0, y: 0, width: 271.86, height: 182.67)
        mainImageView.backgroundColor = .white

        mainImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        transcribedTextView.backgroundColor = .white

        transcribedTextView.alpha = 0.05
        transcribedTextView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        transcribedTextView.layer.cornerRadius = 11
        
        TranscribedText.frame = CGRect(x: 0, y: 0, width: 287, height: 64)
        TranscribedText.backgroundColor = .none
        TranscribedText.alpha = 0.6
        TranscribedText.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        TranscribedText.font = UIFont(name: "SFProText-Regular", size: 18)
        TranscribedText.numberOfLines = 2
        TranscribedText.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.19

        // Line height: 25 pt

        TranscribedText.textAlignment = .center
//        TranscribedText.attributedText = NSMutableAttributedString(string: "Answering this question will let us assess your stress level.", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])

//        howWasYourDayLabel.frame = CGRect(x: 0, y: 0, width: 267, height: 64)
        howWasYourDayLabel.backgroundColor = .white

        howWasYourDayLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
//        howWasYourDayLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 32)
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.66

        // Line height: 63 pt
        // (identical to box height)

//        howWasYourDayLabel.textAlignment = .center
//        howWasYourDayLabel.attributedText = NSMutableAttributedString(string: "How was your day?", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
//        howWasYourDayLabel.heightAnchor.constraint(equalToConstant: 64).isActive = true
//        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -379).isActive = true
        
        


        
        
        stopButton.isHidden = true
        stopButton.isEnabled = false
        SpeakButton.isHidden = false
        SpeakButton.isEnabled = true
        stopButton.layer.cornerRadius = 0.5 * stopButton.frame.width
        SpeakButton.layer.cornerRadius = 0.5 * SpeakButton.frame.width
        SpeakButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization {
            (auth_status) in
            var isButtonEnabled = false
            switch auth_status {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied permission to use microphone")
            
            case .notDetermined:
                isButtonEnabled = false
                print("Speech Recognition not yet authorized")
            case .restricted:
                isButtonEnabled = false
                print("Speech Recognition is restricted")
            @unknown default:
                print("Unknown Error")
            }
            OperationQueue.main.addOperation {
                self.SpeakButton.isEnabled = isButtonEnabled
            }
        }
//        TranscribedText.text = "My day was not great. I fell down in my soccer game"
//        SpeakButton.layer.cornerRadius = 0.5 * SpeakButton.bounds.size.width
        super.viewDidLoad()
//        Sp
//        let image = UIImage(named: "Infinity")
//        navigationItem.titleView = UIImageView(image: image)
//        print(dictionary)
//        print(sequenceArray)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        number = 0
        
    }
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setMode(.measurement)
            try audioSession.setCategory(.record)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error loading AVAudioSession Properties")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode: AVAudioInputNode = audioEngine.inputNode else {
            fatalError("audioEngine has no input")
        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("RecognitionRequest is nil")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if (result != nil) {
                print("Packers")
                guard let running = self.isStillRunning else {
                    return
                }
                if running {
                    self.TranscribedText.text = result?.bestTranscription.formattedString
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
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordFormat) { (buffer, where) in
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
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            SpeakButton.isEnabled = true
        } else {
            SpeakButton.isEnabled = false
        }
    }
    
    @objc func changeTimerNumber() {
        print("Boooooyah")
        number = number! + 1
        self.tapToRecordButton.text = "\(20 - number!)"
        if number == 20 {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.timer!.invalidate()
            self.number = 0
            self.tapToRecordButton.text = "Tap to Record"
            if self.audioEngine.isRunning {
                self.isStillRunning = false
                   }
                self.stopButton.isHidden = true
//                self.stopButton.isEnabled = false
                self.SpeakButton.isHidden = false
//                self.SpeakButton.isEnabled = true
            let words = self.TranscribedText.text!.components(separatedBy: " ").count
            print(self.TranscribedText.text!.count)
                if words > 8 {
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    self.SpeakButton.isEnabled = true
                    let vc = storyboard?.instantiateViewController(identifier: "confirm") as! ConfirmViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.text = TranscribedText.text
                    present(vc, animated: true)
                    self.SpeakButton.setTitle("Start", for: .normal)
                } else {
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    self.SpeakButton.isEnabled = true
                    print("Yay")
                    self.SpeakButton.setTitle("Start", for: .normal)
                    self.TranscribedText.text = "Tell me a bit more about your day!"
                }
        }
//        }
    }
    @IBAction func didTapRecordButton(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTimerNumber), userInfo: nil, repeats: true)
                print(timer)
                Analytics.logEvent("press_record_button", parameters: nil)
                //        print("Dictionary", UserDefaults.standard.object(forKey: "sentiment_dict")!)
                        print("hello")
                        isStillRunning = true
        //                SpeakButton.setTitle("Stop", for: .normal)
                        SpeakButton.layer.cornerRadius = 0.5 * SpeakButton.frame.width
                        startRecording()
                        stopButton.isHidden = false
                        stopButton.isEnabled = true
                        SpeakButton.isHidden = true
                        SpeakButton.isEnabled = false
    }
    
    
    public func switchToCalendar() {
        self.tabBarController?.selectedIndex = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! ConfirmViewController
               destinationVC.text = TranscribedText.text
        destinationVC.modalPresentationStyle = .fullScreen
        self.TranscribedText.text = "Thank you for Introspecting!"
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "confirm" {
            let words = TranscribedText.text!.components(separatedBy: " ").count
            print(TranscribedText.text!.count)
                       if words > 8 {
                           audioEngine.stop()
                           recognitionRequest?.endAudio()
                           SpeakButton.isEnabled = true
                           SpeakButton.setTitle("Start", for: .normal)
                            return true
                       } else {
                           audioEngine.stop()
                           recognitionRequest?.endAudio()
                           SpeakButton.isEnabled = true
                           print("Yay")
                           SpeakButton.setTitle("Start", for: .normal)
                           TranscribedText.text = "Tell me a bit more about your day!"
                       }
        }
            return false
    }
    @IBAction func didClickStopButton(_ sender: Any) {
        number = 0
        timer!.invalidate()
        tapToRecordButton.text = "Tap to Record"
        if audioEngine.isRunning {
            isStillRunning = false
        }
        stopButton.isHidden = true
        stopButton.isEnabled = false
        SpeakButton.isHidden = false
        SpeakButton.isEnabled = true
    }
    

}

