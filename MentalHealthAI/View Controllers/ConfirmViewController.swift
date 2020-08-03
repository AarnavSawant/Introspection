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
    var predictedClass = String()
    var gifs = [Gif]()
    var network = GifNetwork()
    let emailAddress = UserDefaults.standard.string(forKey: "emailAddress")
    public var text: String?
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var RedoButton: UIButton!
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
            let contraction_mapping = ["ain't": "is not", "aren't": "are not","can't": "cannot",
            "can't've": "cannot have", "'cause": "because", "could've": "could have",
            "couldn't": "could not", "couldn't've": "could not have","didn't": "did not",
            "doesn't": "does not", "don't": "do not", "hadn't": "had not",
            "hadn't've": "had not have", "hasn't": "has not", "haven't": "have not",
            "he'd": "he would", "he'd've": "he would have", "he'll": "he will",
            "he'll've": "he will have", "he's": "he is", "how'd": "how did",
            "how'd'y": "how do you", "how'll": "how will", "how's": "how is",
            "I'd": "I would", "I'd've": "I would have", "I'll": "I will",
            "I'll've": "I will have","I'm": "I am", "I've": "I have",
            "i'd": "i would", "i'd've": "i would have", "i'll": "i will",
            "i'll've": "i will have","i'm": "i am", "i've": "i have",
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
            textArray = text.lowercased().components(separatedBy: CharacterSet.punctuationCharacters).joined().components(separatedBy: " ")
            for i in 0...textArray.count-1{
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
                if (dict[textArray[i]] != nil) {
                    sequenceArray.append(dict[cleanedTextArray[i]] as! Double)
                }
            }
            print(sequenceArray)
            return pad_sequences(arr: sequenceArray)
    }
    override func viewDidLoad() {
        print("Warriors", emailAddress)
        super.viewDidLoad()
        TranscribedText.text = text!
        RedoButton.layer.cornerRadius = 0.5 * RedoButton.bounds.size.width
        GetResultsButton.layer.cornerRadius = 0.5 * GetResultsButton.bounds.size.width
        super.viewDidLoad()
        let dictionary = readJSONFromFile(filename: "july_31_v2")
        let sequenceArray = textsToSequences(text: TranscribedText.text, dict: dictionary)
        var max_pred = Double()
        let new_model = GRUModel()
        if let predictions = try? new_model.predictions(inputs: [GRUModelInput(tokenizedString: sequenceArray)]) {
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
            if max_pred < 0.6 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "anger" {
            if max_pred < 0.6 {
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
            emotionLabel.text = "You seem to be very happy!"
        } else if (predictedClass == "sadness") {
            emotionLabel.text = "You seem to be sad today."
        } else  if (predictedClass == "fear") {
             emotionLabel.text = "You seem to be feeling scared."
        } else if (predictedClass == "anger"){
            emotionLabel.text = "You seem to be angry."
        } else {
            emotionLabel.text = "I am failing to detect any emotion. You seem to have had a okay day."
        }
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PopUpViewController {
            let vc = segue.destination as? PopUpViewController
            vc?.inputText = TranscribedText.text
        }
    }
    @IBAction func didPressResults(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
        let email = UserDefaults.standard.string(forKey: "emailAddress")
//        print(tabBarController.selectedIndex)
        let tabBarController = self.presentingViewController as? MainTabBarController
        tabBarController!.selectedIndex = 4
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let testdate = dateFormatter.date(from: "2020 08 04")!
        let current_year = calendar.component(.year, from: Date())
        let current_month = calendar.component(.month, from: Date())
        let current_day = calendar.component(.day, from: Date())
        let day_of_week_formatter = DateFormatter()
        let timestamp = Date().timeIntervalSince1970 as! Double
        day_of_week_formatter.dateFormat = "EEEE"
        print(email)
        let dayOfTheWeekString = day_of_week_formatter.string(from: testdate)
        let lastEmotion = predictedClass
        if lastEmotion == "joy" {
                    db.collection("users").document(email!).collection("user_sentiment").document(dateFormatter.string(from: Date())).setData(["year" : current_year, "day" : current_day, "month" : current_month, "day_of_the_week" : dayOfTheWeekString, "text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp])
                } else if lastEmotion == "sadness" {
                            db.collection("users").document(email!).collection("user_sentiment").document(dateFormatter.string(from: Date())).setData(["year" : current_year, "day" : current_day, "month" : current_month, "day_of_the_week" : dayOfTheWeekString, "text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp])
                } else if lastEmotion == "anger" {
                            db.collection("users").document(email!).collection("user_sentiment").document(dateFormatter.string(from: Date())).setData(["year" : current_year, "day" : current_day, "month" : current_month, "day_of_the_week" : dayOfTheWeekString, "text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp])
                } else if lastEmotion == "fear" {
                    db.collection("users").document(email!).collection("user_sentiment").document(dateFormatter.string(from: Date())).setData(["year" : current_year, "day" : current_day, "month" : current_month, "day_of_the_week" : dayOfTheWeekString, "text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp])
                } else {

                            db.collection("users").document(email!).collection("user_sentiment").document(dateFormatter.string(from: Date())).setData(["year" : current_year, "day" : current_day, "month" : current_month, "day_of_the_week" : dayOfTheWeekString, "text" : self.TranscribedText.text, "emotion" : self.predictedClass, "timestamp" : timestamp])
                }
        UserDefaults.standard.set(predictedClass, forKey: "lastEmotion")
        UserDefaults.standard.set(Date(), forKey: "lastDate")
        UserDefaults.standard.set(true, forKey: "shouldSearch")
        Analytics.logEvent("press_save_button", parameters: ["emotion" : predictedClass])
            }
@IBAction func didPressRedo(_ sender: Any) {
//        self.dismiss(animated: true, completion: {
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
//        })
    }
    
    func searchGifs(for searchText: String, gifCompletionHandler : @escaping (String?, Error?) -> Void) {
            var gifURL = String()
            network.fetchGIFs(searchTerm: searchText) { gifArray in
                if gifArray != nil {
                    print(gifArray!.gifs.count)
                    self.gifs = gifArray!.gifs
                    print(gifArray!.gifs)
                    gifURL = self.gifs[0].getGIFURL()
                    gifCompletionHandler(gifURL, nil)
    //                UserDefaults.standard.set(gifURL, forKey: "lastGIF")
    //                UserDefaults.standard.set(false, forKey: "shouldSearch")
    //                let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
    //                if UserDefaults.standard.url(forKey: "lastGIF") != nil {
    //                    self.gifView.image = UIImage.gif(url: gifURL)
    //                }
                }
            }
//        print("GIFURLAFTER:", Date().timeIntervalSince1970)
//            return gifURL
        }

   

}
