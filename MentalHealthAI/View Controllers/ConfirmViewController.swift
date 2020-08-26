//
//  ConfirmViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/12/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import CoreML
import CoreData
import NaturalLanguage
import Firebase
import Foundation
import FirebaseFirestore
class ConfirmViewController: UIViewController {
    var lastClass: String?
    @IBOutlet weak var keeplabel: UILabel!
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var transcribedTextView: UIView!
    var dictionary =  [String : [String : Any]]()
    var day_of_the_week_dict: [String : [String : Int]]?
    var predictedClass = String()
    var gifs = [Gif]()
    var returnString:String?
    var network = GifNetwork()
    let emailAddress = UserDefaults.standard.string(forKey: "emailAddress")
    public var text: String?
    @IBOutlet weak var emotionLabel: UILabel!
//    @IBOutlet weak var RedoButton: UIButton!
    @IBOutlet weak var GetResultsButton: UIButton!
    @IBOutlet weak var TranscribedText: UITextView!
    let questionViewController = QuestionViewController()
    func readJSONFromFile(filename: String) -> [String: Double]{
            let url = Bundle.main.url(forResource: filename, withExtension: "json")!
            do {
                let jsonData = try Data(contentsOf: url)
                    let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
                return json as! [String: Double]
            } catch{
    //            print(error)
            }
            return ["Error": 505]
        }
        func pad_sequences(arr: [Double]) -> MLMultiArray {
            let mlArray = try? MLMultiArray(shape: [35, 1, 1], dataType: MLMultiArrayDataType.double)
            var new_arr = arr
            let num_zeros = 35 - new_arr.count
            if num_zeros < 0 {
                new_arr = Array(new_arr[0...(new_arr.count + num_zeros - 1)])
            } else {
                for i in 0...num_zeros - 1 {
                    new_arr.insert(0, at: 0)
                }
            }
            for i in 0...new_arr.count - 1 {
                mlArray?[i] = NSNumber(value: new_arr[i])
            }
            return mlArray!
            }
        func textsToSequences(text: String, dict: [String: Any]) -> MLMultiArray {
            let contraction_mapping = ["ain\'t": "is not", "aren\'t": "are not","can\'t": "cant",
            "can\'t've": "cannot have", "'cause": "because", "could\'ve": "could have",
            "couldn\'t": "could not", "couldn\'t've": "could not have","didn\'t": "did not",
            "doesn't": "does not", "don't": "do not", "hadn't": "had not",
            "hadn\'t've": "had not have", "hasn\'t": "has not", "haven\'t": "have not",
            "he\'d": "he would", "he\'d've": "he would have", "he\'ll": "he will",
            "he\'ll've": "he will have", "he\'s": "he is", "how\'d": "how did",
            "how\'d'y": "how do you", "how\'ll": "how will", "how\'s": "how is",
            "I\'d": "I would", "I\'d've": "I would have", "I\'ll": "I will",
            "I\'ll've": "I will have","I\'m": "I am", "I\'ve": "I have",
            "i\'d": "i would", "i\'d've": "i would have", "i\'ll": "i will",
            "i\'ll've": "i will have","i'm": "i am", "i've": "i have",
            "isn't": "is not", "it'd": "it would", "it'd've": "it would have",
            "it'll": "it will", "it'll've": "it will have","it's": "it is",
            "let's": "let us", "ma'am": "madam", "mayn't": "may not",
            "might've": "might have","mightn't": "might not","mightn't've": "might not have",
            "must've": "must have", "mustn't": "must not", "mustn't've": "must not have",
            "needn't": "need not", "needn't've": "need not have","o'clock": "of the clock",
            "oughtn't": "ought not", "oughtn't've": "ought not have", "shan't": "shall not",
            "sha'n't": "shall not", "shan't've": "shall not have", "she'd": "she would",
            "she'd've": "she would have", "she'll": "she will", "she'll've": "she will have",
            "she's": "she is", "should've": "should have", "shouldn't": "should not",
            "shouldn't've": "should not have", "so've": "so have","so's": "so as",
            "this's": "this is",
            "that'd": "that would", "that'd've": "that would have","that's": "that is",
            "there'd": "there would", "there'd've": "there would have","there's": "there is",
                "here's": "here is",
            "they'd": "they would", "they'd've": "they would have", "they'll": "they will",
            "they'll've": "they will have", "they're": "they are", "they've": "they have",
            "to've": "to have", "wasn't": "was not", "we'd": "we would",
            "we'd've": "we would have", "we'll": "we will", "we'll've": "we will have",
            "we're": "we are", "we've": "we have", "weren't": "were not",
            "what'll": "what will", "what'll've": "what will have", "what're": "what are",
            "what's": "what is", "what've": "what have", "when's": "when is",
            "when've": "when have", "where'd": "where did", "where's": "where is",
            "where've": "where have", "who'll": "who will", "who'll've": "who will have",
            "who's": "who is", "who've": "who have", "why's": "why is",
            "why've": "why have", "will've": "will have", "won't": "will not",
            "won't've": "will not have", "would've": "would have", "wouldn't": "would not",
            "wouldn't've": "would not have", "y'all": "you all", "y'all'd": "you all would",
            "y'all'd've": "you all would have","y'all're": "you all are","y'all've": "you all have",
            "you'd": "you would", "you'd've": "you would have", "you'll": "you will",
            "you'll've": "you will have", "you're": "you are", "you've": "you have" ]
            var textArray =  [String]()
            textArray = text.lowercased().components(separatedBy: " ")
            for i in 0...textArray.count-1{
                print(textArray[i])
                if contraction_mapping.keys.contains(textArray[i]) {
                    textArray[i] = contraction_mapping[textArray[i]]!
                }
            }
            var cleanedTextArray = [String]()
            let fullText = textArray.joined(separator: " ")
            cleanedTextArray = fullText.lowercased().components(separatedBy: CharacterSet.punctuationCharacters).joined().components(separatedBy: " ")
            print(cleanedTextArray)
            var sequenceArray = [Double]()
            for i in 0...cleanedTextArray.count - 1 {
                if (dict[cleanedTextArray[i]] != nil && !["really", "feel", "feeling", "super", "very"].contains(cleanedTextArray[i])) {
                    
                    sequenceArray.append(dict[cleanedTextArray[i]] as! Double)
                }
            }
            print(sequenceArray)
            return pad_sequences(arr: sequenceArray)
    }
    override func viewDidLoad() {
        keeplabel.alpha = 0.6
        keeplabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        discardLabel.alpha = 0.6
        discardLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let navView = UIView()
////            mainImageView.backgroundColor = .white
////
////           mainImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
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
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        self.view.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
//
//              navView.sizeToFit()
//        var view = UILabel()
//        view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        GetResultsButton.backgroundColor = .white
//        var view = UILabel()
//        view.frame = CGRect(x: 0, y: 0, width: 63, height: 63)

        
        transcribedTextView.alpha = 0.05
//        TranscribedText.layer.backgroundColor?.copy(alpha: 0.05)
        TranscribedText.backgroundColor = .none
        transcribedTextView.layer.backgroundColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1).cgColor
        transcribedTextView.layer.cornerRadius = 10
        TranscribedText.layer.cornerRadius = 10
        TranscribedText.alpha = 0.6
        TranscribedText.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        let discardImage = UIImage(named: "Discard")
//        discardButton.setImage(discardImage, for: .normal)

        discardButton.alpha = 0.2
        discardButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        var parent = self.view!
//        parent.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 106).isActive = true
//        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 661).isActive = true
        print("Warriors", emailAddress)
        super.viewDidLoad()
        let navbar = self.navigationController as! ResultsNavController
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.TranscribedText.text = navbar.text!
//        })
        discardButton.layer.cornerRadius = 0.5 * discardButton.bounds.size.width
        GetResultsButton.layer.cornerRadius = 0.5 * GetResultsButton.bounds.size.width
        super.viewDidLoad()
        let dictionary = readJSONFromFile(filename: "august_24")
        let sequenceArray = textsToSequences(text: TranscribedText.text, dict: dictionary)
        var max_pred = Double()
        let new_model = IntrospectionSentimentModel()
        if let predictions = try? new_model.predictions(inputs: [IntrospectionSentimentModelInput(tokenizedString: sequenceArray)]) {
            max_pred = predictions[0].emotion.values.max()!
            for key in predictions[0].emotion {
                if key.value == max_pred {
                    predictedClass = key.key
                }
            }
            print(max_pred)
        }
        print(predictedClass)
        if predictedClass == "joy" {
            if max_pred < 0.52 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "anger" {
            if max_pred < 0.7 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "sadness" {
            if max_pred < 0.6 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "fear" {
            if max_pred < 0.8 {
                predictedClass = "neutral"
            }
        }
        if (predictedClass == "joy") {
            mainImageView.image = UIImage(named: "JoyResults")
            emotionLabel.text = "You seem to be happy today!"
        } else if (predictedClass == "sadness") {
            mainImageView.image = UIImage(named: "SadnessResults")
            emotionLabel.text = "You seem to be sad today."
        } else  if (predictedClass == "fear") {
            mainImageView.image = UIImage(named: "FearResults")
             emotionLabel.text = "You seem to be scared today."
        } else if (predictedClass == "anger"){
            mainImageView.image = UIImage(named: "AngerResults")
            emotionLabel.text = "You seem to be angry today."
        } else {
            mainImageView.image = UIImage(named: "NeutralResults")
            emotionLabel.text = "You seem to be neutral today."
        }
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FeedbackNavController{
            let vc = segue.destination as? FeedbackNavController
            vc?.inputText = TranscribedText.text
            vc?.modalPresentationStyle = .fullScreen
        }
    }
    @IBAction func didPressResults(_ sender: Any)  {
        GetResultsButton.isEnabled = false
        let tab_vc = self.presentingViewController?.presentingViewController as! MainTabBarController
        let nav_vc = tab_vc.viewControllers![tab_vc.selectedIndex] as! ReflectViewController
        let vc = nav_vc.viewControllers[0] as! QuestionViewController
        vc.howWasYourDayLabel.text = "How was your day?"
        vc.TranscribedText.text = "Answering this question will let us assess your stress level"
        UserDefaults.standard.set(true, forKey: "should_query")
        print(UserDefaults.standard.set(true, forKey: "should_query"))
        let email = UserDefaults.standard.string(forKey: "emailAddress")
//        print(tabBarController.selectedIndex)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let testdate = Date()
//        let testdate = dateFormatter.date(from: "2020 07 04")!
        let current_year = calendar.component(.year, from: testdate)
        let current_month = calendar.component(.month, from: testdate)
        let current_day = calendar.component(.day, from: testdate)
        let formatter = DateFormatter()
        let timestamp = testdate.timeIntervalSince1970 as! Double
       formatter.dateFormat = "yyyy MM dd"
        let day_of_week_formatter = DateFormatter()
        day_of_week_formatter.dateFormat = "EEEE"
        print(email)
        let dayOfTheWeekString = day_of_week_formatter.string(from: testdate)
        let lastEmotion = predictedClass
        print("Last Emotion", lastEmotion)
        let uid = UserDefaults.standard.string(forKey: "uid")
        var term: String?
        if lastEmotion == "joy" {
            let joyGifs = ["Rabbit", "MickeyMouse", "Hamsters", "Pandas"]
            term = joyGifs[Int.random(in: 0...joyGifs.count-1)]
            searchGifs(for: term!)
            } else if lastEmotion == "sadness" {
                        let sadGifs = ["Minions", "Hamsters", "Dogs", "Snoopy"]
                        term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                        searchGifs(for: term!)
                } else if lastEmotion == "anger" {
                        let sadGifs = ["Galaxy", "Glaciers", "Garfield", "Scenery"]
                        term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                        searchGifs(for: term!)
                } else if lastEmotion == "fear" {
                    let sadGifs = ["Sunsets", "Clouds", "BugsBunny", "ToyStory"]
                    term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                    searchGifs(for: term!)
                } else if lastEmotion == "neutral" {
                    let sadGifs = ["Koalas", "looneytunes", "waterfall", "madagascar"]
                    term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                    searchGifs(for:  term!)
                }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let gifURL = self.returnString!
                db.collection("users").document(uid!).getDocument { (querrySnapshot, err) in
                    if err != nil {
                        print("ERROR RECEIVING QUERY FOR DAY OF THE WEEKS")
                    } else {
                        let data = querrySnapshot?.data()
                        if data!["day_of_the_week_dict"] != nil {
                            self.day_of_the_week_dict = data!["day_of_the_week_dict"] as! [String : [String : Int]]
                        }
                        self.lastClass = data!["last class"] as? String
                        var dayOfTheWeekService = DayOfTheWeekWriter(oldDictionary: self.day_of_the_week_dict, dayOfTheWeekString: dayOfTheWeekString, timestamp: timestamp, date: testdate, previousClass: self.lastClass , predictionClass: self.predictedClass)
                        self.day_of_the_week_dict = dayOfTheWeekService.getNewDayOfTheWeekDictionary()
                        print("REAL MADRID", self.day_of_the_week_dict)
                        
                         db.collection("users").document(uid!).setData([ "last_gif_term" : term, "last_gif_url" : gifURL, "year" : "\(current_year)", "last class" : self.predictedClass, "timestamp" : timestamp, "day_of_the_week_dict" : self.day_of_the_week_dict])

                    }
                }
            db.collection("users").document(uid!).collection("\(current_year)").document("\(current_month)").getDocument { (querySnapshot, err) in
                    if err != nil {
                        print("ERROR ERROR ERROR")
                    } else {
                        let data = querySnapshot?.data()
                        if data != nil {
                            self.dictionary = (data!["user_sentiment"] as? [String : [String : Any]])!
//                            print("FUCKKKKKK", data!["user_sentiment"]!)
//                            print("dIcTiOnArY", self.dictionary)
                        }
                        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: testdate)
                        components.hour = 0
                        components.minute = 0
                        components.second = 0
                        let currentDate = Calendar.current.date(from: components)
                        print("Current Date", currentDate!)
                        self.dictionary["\(formatter.string(from: currentDate!))"] = ["text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp]
                        print("Dictionary2", self.dictionary)
                            db.collection("users").document(uid!).collection("\(current_year)").document("\(current_month)").setData([ "user_sentiment" : self.dictionary])
                        print("DAY OF THE WEEK", self.day_of_the_week_dict)

//                        db.collection("users").document(uid!).setData([ "last_gif_term" : term, "last_gif_url" : gifURL, "year" : "\(current_year)", "last class" : self.predictedClass, "timestamp" : timestamp, "day_of_the_week_dict" : ["Monday" : ["joy" : 1]]])
                    }
                }
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
                let tabBarController = self.presentingViewController?.presentingViewController as? MainTabBarController
                tabBarController!.selectedIndex = 4
            }

            Analytics.logEvent("press_save_button", parameters: ["emotion" : predictedClass])
        }

    @IBAction func didClickDiscardButton(_ sender: Any) {
        discardButton.isEnabled = false
        let tab_vc = self.presentingViewController?.presentingViewController as! MainTabBarController
        let nav_vc = tab_vc.viewControllers![tab_vc.selectedIndex] as! ReflectViewController
        let vc = nav_vc.viewControllers[0] as! QuestionViewController
        vc.howWasYourDayLabel.text = "How was your day?"
        vc.TranscribedText.text = "Answering this question will let us assess your stress level"
    }
    
    func searchGifs(for searchText: String){
            network.fetchGIFs(searchTerm: searchText) { gifArray in
                if gifArray != nil {
                    print(gifArray!.gifs.count)
                    self.gifs = gifArray!.gifs
                    let randomNumber = Int.random(in: 0..<gifArray!.gifs.count)
                    let gifURL = self.gifs[randomNumber].getGIFURL()
                    UserDefaults.standard.set(gifURL, forKey: "lastGIF")
//                    UserDefaults.standard.set(false, forKey: "shouldSearch")
    //                let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
    //                if UserDefaults.standard.url(forKey: "lastGIF") != nil {
//                        self.gifView.image = UIImage.gif(url: gifURL)
    //                }
                    self.returnString = gifURL
                }
            }
        }
    
}


