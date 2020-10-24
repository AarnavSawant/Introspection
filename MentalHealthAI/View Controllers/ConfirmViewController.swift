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
import FirebaseAuth
class ConfirmViewController: UIViewController {
    var lastClass: String?
    @IBOutlet weak var keeplabel: UILabel!
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var transcribedTextView: UIView!
    var dictionary =  [String : [String : Any]]()
    var day_of_the_week_dict: [String : [String : Int]]?
    var lastTimestamp = Double()
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
        func textsToSequences(text2: String, dict: [String: Double]) -> MLMultiArray {
            var text = text2.lowercased().components(separatedBy: CharacterSet.punctuationCharacters).joined()
            
            let contraction_mapping = ["tired" :"tiring", "hard" : "difficult","aint": "is not", "arent": "are not","cant": "cant",
            "cantve": "cannot have", "cause": "because", "couldve": "could have",
            "couldnt": "could not", "couldntve": "could not have","didnt": "did not",
            "doesnt": "does not", "dont": "do not", "hadnt": "had not",
            "hadntve": "had not have", "hasnt": "has not", "havent": "have not",
            "hed": "he would", "hed've": "he would have",
            "hellve": "he will have", "hes": "he is", "howd": "how did",
            "howdy": "how do you", "howll": "how will", "hows": "how is",
            "Id": "I would", "Idve": "I would have", "Ill": "I will",
            "Illve": "I will have","Im": "I am", "Ive": "I have",
            "id": "i would", "idve": "i would have", "ill": "i will",
            "illve": "i will have","im": "i am", "ive": "i have",
            "isnt": "is not", "itd": "it would", "itdve": "it would have",
            "itll": "it will", "itllve": "it will have","its": "it is",
            "lets": "let us", "maam": "madam", "maynt": "may not",
            "mightve": "might have","mightnt": "might not","mightntve": "might not have",
            "mustve": "must have", "mustnt": "must not", "mustntve": "must not have",
            "neednt": "need not", "needntve": "need not have","oclock": "of the clock",
            "oughtnt": "ought not", "oughtnt've": "ought not have", "shant": "shall not",
            "shantve": "shall not have", "shed": "she would",
            "shedve": "she would have", "shell": "she will", "shellve": "she will have",
            "shes": "she is", "shouldve": "should have", "shouldnt": "should not",
            "shouldntve": "should not have", "sove": "so have","sos": "so as",
            "thiss": "this is",
            "thatd": "that would", "thatdve": "that would have","thats": "that is",
            "thered": "there would", "theredve": "there would have","theres": "there is",
                "heres": "here is",
            "theyd": "they would", "theydve": "they would have", "theyll": "they will",
            "theyllve": "they will have", "theyre": "they are", "theyve": "they have",
            "tove": "to have", "wasnt": "was not", "wed": "we would",
            "wedve": "we would have", "well": "we will", "wellve": "we will have",
            "were": "we are", "weve": "we have", "werent": "were not",
            "whatll": "what will", "whatllve": "what will have", "what're": "what are",
            "whats": "what is", "what've": "what have", "whens": "when is",
            "whenve": "when have", "whered": "where did", "wheres": "where is",
            "whereve": "where have", "wholl": "who will", "whollve": "who will have",
            "whos": "who is", "who've": "who have", "whys": "why is",
            "whyve": "why have", "will've": "will have", "wont": "will not",
            "wontve": "will not have", "would've": "would have", "wouldn't": "would not",
            "wouldntve": "would not have", "yall": "you all", "yalld": "you all would",
            "yalldve": "you all would have","yallre": "you all are","yallve": "you all have",
            "youd": "you would", "youdve": "you would have", "you'll": "you will",
            "youllve": "you will have", "youre": "you are", "youve": "you have" ]
//            print(text_contraction_mapping.keys)
            var textArray =  [String]()
            var textToPOSArray =  [Int : String]()
            textArray = text.lowercased().components(separatedBy: " ")
            for i in 0...textArray.count-1{
                print("Word \(i + 1) from the given text", textArray[i])
                if contraction_mapping.keys.contains(textArray[i]) {
                    textArray[i] = contraction_mapping[textArray[i]]!
                }
            }
            var fullText = textArray.joined(separator: " ")
            let negatedText = textArray.joined(separator: " ")
            print("TextToPOSArray", textToPOSArray)
//            print("FUCKKER", text_contraction_mapping["didn't"])
            var cleanedTextArray = [String]()
            cleanedTextArray = fullText.lowercased().components(separatedBy: CharacterSet.punctuationCharacters).joined().components(separatedBy: " ")
            print(cleanedTextArray)
            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            tagger.string = fullText
            let range = NSRange(location: 0, length: fullText.utf16.count)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            var wordNum = 0
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
                if let tag = tag {
                    let word = (fullText as NSString).substring(with: tokenRange)
                    print("\(word): \(tag)")
                    textToPOSArray[wordNum] = tag.rawValue
                    wordNum += 1
                }
            }
            var shouldNegate = false
            for i in 0..<textArray.count {
                print("Should Negate \(textArray[i])", shouldNegate)
                if shouldNegate {
                    if ["Noun", "Pronoun"].contains(textToPOSArray[i]) {
                        shouldNegate = false
                    }
                    cleanedTextArray[i] = "neg" + cleanedTextArray[i]
                }
                if ["not", "never", "nowhere", "nobody", "no", "none", "no one", "nothing", "neither", "nowhere", "hardly", "rarely", "scarcely", "barely", "seldom", "noone"].contains(cleanedTextArray[i]) {
                    cleanedTextArray[i] = ""
                    shouldNegate = true
                }
                
            }
            print("CLEANED TEXT for Sequence", cleanedTextArray)
            let stopwordsList = [" ", "ok", "english", "outside", "morning", "history", "dog", "math", "today", "hey","really", "feel", "dads", "feeling", "super", "very", "pretty", "sure", "raise", "drank", "ceiling", "hot", "math", "today", "hot", "ran", "teacher","pretty","very", "really","super","feeling", "feel", "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "you're", "you've", "you'll", "you'd", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "she's", "her", "hers", "herself", "it", "it's", "its", "itself", "they", "them", "their", "theirs", "themselves", "which", "who", "whom", "this", "that", "that'll", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from","in", "out", "on", "off", "over", "under", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "", " ", "inside", "study", "meetings" ,"sleep", "outside", "morning", "history", "dog", "math", "today", "hey","really", "feel", "feeling", "super", "very", "pretty", "sure", "raise", "drank", "ceiling", "hot"]
            var sequenceArray = [Double]()
            for i in 0...cleanedTextArray.count - 1 {
                if (dict[cleanedTextArray[i]] != nil && !stopwordsList.contains(cleanedTextArray[i])) {
                    let num = dict[cleanedTextArray[i]] as! Double
                    if (num <= 7500.0) {
                        sequenceArray.append(dict[cleanedTextArray[i]] as! Double)
                        
                    }
                    
                }
            }
            print("Sequence Array for Model", sequenceArray)
            return pad_sequences(arr: sequenceArray)
    }
    override func viewDidLoad() {
        Analytics.logEvent("entered_Results_Screen", parameters: nil)
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
        super.viewDidLoad()
        let navbar = self.navigationController as! ResultsNavController
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.TranscribedText.text = navbar.text!
//        })
        discardButton.layer.cornerRadius = 0.5 * discardButton.bounds.size.width
        GetResultsButton.layer.cornerRadius = 0.5 * GetResultsButton.bounds.size.width
        super.viewDidLoad()
        let dictionary = readJSONFromFile(filename: "october_2_official") as! [String : Double]
        let sequenceArray = textsToSequences(text2: TranscribedText.text, dict: dictionary)
        var max_pred = Double()
        let new_model = EmotionPredictionModel()
        if let predictions = try? new_model.predictions(inputs: [EmotionPredictionModelInput(tokenizedString: sequenceArray)]) {
            max_pred = predictions[0].emotion.values.max()!
            for key in predictions[0].emotion {
                if key.value == max_pred {
                    predictedClass = key.key
                }
            }
            print("Max Probability for Model", max_pred)
        }
        print("Predicted Class", predictedClass)
        if predictedClass == "joy" {
            if max_pred < 0.43 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "anger" {
            if max_pred < 0.75{
                predictedClass = "neutral"
            }
        } else if predictedClass == "sadness" {
            if max_pred < 0.45{
                predictedClass = "neutral"
            }
        } else if predictedClass == "fear" {
            if max_pred < 0.74{
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
            vc?.predictedClass = predictedClass
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
        print("Should Query", UserDefaults.standard.set(true, forKey: "should_query"))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let testdate = Date()
//        let testdate = dateFormatter.date(from: "2021 09 10")!
        let current_year = calendar.component(.year, from: testdate)
        let current_month = calendar.component(.month, from: testdate)
        let current_day = calendar.component(.day, from: testdate)
        let formatter = DateFormatter()
        let timestamp = testdate.timeIntervalSince1970 as! Double
       formatter.dateFormat = "yyyy MM dd"
        let day_of_week_formatter = DateFormatter()
        day_of_week_formatter.dateFormat = "EEEE"
        let dayOfTheWeekString = day_of_week_formatter.string(from: testdate)
        let lastEmotion = predictedClass
        print("Last Emotion", lastEmotion)
        let uid = Auth.auth().currentUser?.uid
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
            db.collection("users").document(uid!).collection("day_of_the_week").document("day_of_the_week").getDocument { (querrySnapshot, err) in
                    if err != nil {
                        print("ERROR RECEIVING QUERY FOR DAY OF THE WEEKS")
                    } else {
                        let data = querrySnapshot?.data()
//                        if data!["day_of_the_week_dict"] != nil {
                        self.day_of_the_week_dict = (data?["day_of_the_week_dict"] as? [String : [String : Int]]) ?? nil
//                        }
                        self.lastClass = data?["last class"] as? String
                        self.lastTimestamp = data?["timestamp"] as? Double ?? 0
                        var dayOfTheWeekService = DayOfTheWeekWriter(oldDictionary: self.day_of_the_week_dict, dayOfTheWeekString: dayOfTheWeekString, timestamp: self.lastTimestamp, date: testdate, previousClass: self.lastClass , predictionClass: self.predictedClass)
                        self.day_of_the_week_dict = dayOfTheWeekService.getNewDayOfTheWeekDictionary()
                         db.collection("users").document(uid!).collection("day_of_the_week").document("day_of_the_week").setData([ "last_gif_term" : term, "last_gif_url" : gifURL, "year" : "\(current_year)", "last class" : self.predictedClass, "timestamp" : timestamp, "day_of_the_week_dict" : self.day_of_the_week_dict])

                    }
                }
            db.collection("users").document(uid!).collection("\(current_year)").document("\(current_month)").getDocument { (querySnapshot, err) in
                    if err != nil {
                        print("ERROR ERROR ERROR READING FROM FIREBASE IN CONFIRM VC")
                    } else {
                        let data = querySnapshot?.data()
                        if data != nil {
                            self.dictionary = (data!["user_sentiment"] as? [String : [String : Any]])!
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
                    let randomNumber = Int.random(in: 0..<25)
                    print("RANDOM NUMBER", randomNumber)
                    let gifURL = self.gifs[randomNumber].getGIFURL()
                    self.returnString = gifURL
                }
            }
        }
    
}


