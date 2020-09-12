//
//  ViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/2/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Speech
import CoreLocation
import CoreML
import Firebase
import FirebaseAuth
import FirebaseFirestore
class QuestionViewController: UIViewController, SFSpeechRecognizerDelegate {
//    @IBOutlet weak var scrollTextView: StarWarsTextView!
    var dictionary: [String : [String : Any]]?
    var shouldContinue: Bool?
     var isStillRunning:Bool?
    @IBOutlet weak var howWasYourDayLabel: UILabel!
    @IBOutlet weak var TranscribedText: UILabel!
    @IBOutlet weak var transcribedTextView: UIView!
    
    @IBOutlet weak var SpeakButton: UIButton!

    @IBOutlet weak var mainImageView: UIImageView!
    
    var timer: Timer?
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    @IBOutlet weak var tapToRecordButton: UILabel!
    public var email: String?
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var UserSentenceLabel: UILabel!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
  
//    @IBOutlet weak var stopButton: UIButton!
    private var recognitionTask: SFSpeechRecognitionTask?
    public var completionHandler: ((String) -> Void)?
    
    var number: Int?
    override func viewDidLoad() {
//        UserDefaults.standard.set(nil, forKey: "NotificationTime")
//        UserDefaults.standard.set(nil, forKey: "NotificationsEnabledInApp")
        print("Notifications Enabled", UIApplication.shared.isRegisteredForRemoteNotifications)
//        var practiceDict = [String : [String : Any]]()
//        for i in 0...1200 {
//            practiceDict["\(i)"] = ["timestamp" : 12345678, "emotion" : "joy", "text" : "The Bears still suck"]
//        }
//        UserDefaults.standard.set(practiceDict, forKey: "test_dict")
//        print("COUNT", UserDefaults.standard.dictionary(forKey: "test_dict"))
        

//        scrollTextView.crawlingSpeed = 20.0
//        scrollTextView.text = ""
//        scrollTextView.xAngle = 1
//        scrollTextView.inclinationRatio = 3.0
//        scrollTextView.font = UIFont(name: "Helvetica", size: 24)
        print("SIGNED IN QUESTION", UserDefaults.standard.bool(forKey: "signed_in"))
        print("UID", UserDefaults.standard.string(forKey: "uid"))
//        print(UserDefaults.standard.object(forKey: "emailAddress"))
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
        tapToRecordButton.frame = CGRect(x: 0, y: 0, width: 116, height: 64)
        tapToRecordButton.backgroundColor = .white

        tapToRecordButton.alpha = 0.6
        tapToRecordButton.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        tapToRecordButton.font = UIFont(name: "SFProText-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.96
        
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
        
//        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        self.navigationItem.titleView = navView
        self.navigationItem.titleView!.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)

        navView.sizeToFit()

//        scrollTextView.isHidden = true
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



        TranscribedText.textAlignment = .center
        howWasYourDayLabel.backgroundColor = .white

        howWasYourDayLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)

        
        


        
        
//        stopButton.isHidden = true
//        stopButton.isEnabled = false
        SpeakButton.isHidden = false
        SpeakButton.isEnabled = true
//        stopButton.layer.cornerRadius = 0.5 * stopButton.frame.width
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
                self.SpeakButton.isEnabled = true
            }
        }

        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        number = 0
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let cal = Calendar.current
        let current_year = cal.component(.year, from: Date())
        var should_query = UserDefaults.standard.bool(forKey: "should_query")
//        should_query = true
        print("SHOULD QUERY", should_query)
        if should_query != nil {
            if should_query {
                for year in current_year-1...current_year {
                    db.collection("users").document(uid!).collection("\(year)").getDocuments { (querySelector, error) in
                                    if error != nil {
                                        print("There was an error retrieving data")
                                    } else if (querySelector != nil) {
                                        
                                        let documents = querySelector!.documents
                                        for document in documents {
                                            print(document)
                                            let data = document.data()
                                            if data != nil {
                                                if self.dictionary == nil {
                                                    self.dictionary = data["user_sentiment"] as! [String : [String : Any]]
                                                } else {
                                                    self.dictionary = self.dictionary!.merging(data["user_sentiment"] as! [String : [String : Any]], uniquingKeysWith: { $1 })
                                                    
                                                }
                                            }
                                    }
                            }
                        UserDefaults.standard.set(self.dictionary, forKey: "calendar_dictionary")
                        UserDefaults.standard.set(false, forKey: "should_query")
                        print("SHAQ", UserDefaults.standard.object(forKey: "calendar_dictionary"))
                        }
                }
            }
        }
        
    }

    

    @IBAction func didTapRecordButton(_ sender: Any) {

    }
    
    
    public func switchToCalendar() {
        self.tabBarController?.selectedIndex = 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! UINavigationController
//               destinationVC.text = scrollTextView.text
        destinationVC.modalPresentationStyle = .fullScreen
//        self.TranscribedText.text = "Thank you for Introspecting!"
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "recording" {
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                print(self.shouldContinue)
                                if self.shouldContinue! {
//                                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeTimerNumber), userInfo: nil, repeats: true)
//                                print(self.timer)
//                                    Analytics.logEvent("press_record_button", parameters: nil)
//                                            print("hello")
                                    self.performSegue(withIdentifier: "recording", sender: self)
//                                self.isStillRunning = true
            //                        self.SpeakButton.layer.cornerRadius = 0.5 * self.SpeakButton.frame.width
//                                self.startRecording()
            //                    self.stopButton.isHidden = false
            //                    self.stopButton.isEnabled = true
            //                    self.SpeakButton.isHidden = true
            //                        self.SpeakButton.isEnabled = false
                                } else {
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
        }
            return false
    }
    @IBAction func didClickStopButton(_ sender: Any) {
//        scrollTextView.stopCrawlingAnimation()
        number = 0
        timer!.invalidate()
        tapToRecordButton.text = "Tap to Record"
        if audioEngine.isRunning {
            isStillRunning = false
        }
//        stopButton.isHidden = true
//        stopButton.isEnabled = false
        SpeakButton.isHidden = false
        SpeakButton.isEnabled = true
    }
    

}

