//
//  ResultsViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/13/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import CoreML
import CoreData
class ResultsViewController: UIViewController {
    var predictedClass = ""
    public var inputText: String?
//    weak var calendarController: RecapViewController?
    @IBOutlet weak var ModelResultText: UILabel!
    @IBOutlet weak var doneButtonn: UIButton!
    @IBOutlet weak var TranscribedText: UITextView!
    @IBOutlet weak var Quote: UITextView!
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
    public func setText(text: String) {
        self.inputText = text
    }
    func pad_sequences(arr: [Double]) -> MLMultiArray {
        let mlArray = try? MLMultiArray(shape: [40, 1, 1], dataType: MLMultiArrayDataType.double)
        var new_arr = arr
        let num_zeros = 40 - new_arr.count
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
        var sequenceArray = [Double]()
        for i in 0...cleanedTextArray.count - 1 {
            if (dict[textArray[i]] != nil) {
                sequenceArray.append(dict[cleanedTextArray[i]] as! Double)
            }
        }
//        print(sequenceArray)
        return pad_sequences(arr: sequenceArray)
    }
    override func viewDidLoad() {
        ModelResultText.numberOfLines = 5
        TranscribedText.text = inputText
        super.viewDidLoad()
        let dictionary = readJSONFromFile(filename: "july_24_v4")
        let sequenceArray = textsToSequences(text: inputText!, dict: dictionary)
        var max_pred = Double()
        let new_model = stackedGRUModel()
        if let predictions = try? new_model.predictions(inputs: [stackedGRUModelInput(tokenizedString: sequenceArray)]) {
            max_pred = predictions[0].emotion.values.max()!
            for key in predictions[0].emotion {
                if key.value == max_pred {
                    predictedClass = key.key
                }
            }
            print(max_pred)
        }
        if predictedClass == "joy" {
            if max_pred < 0.68 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "anger" {
            if max_pred < 0.9 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "sadness" {
            if max_pred < 0.45 {
                predictedClass = "neutral"
            }
        } else if predictedClass == "fear" {
            if max_pred < 0.9 {
                predictedClass = "neutral"
            }
        }
        if (predictedClass == "joy") {
            ModelResultText.text = "You seem to be very happy!"
        } else if (predictedClass == "sadness") {
            ModelResultText.text = "You seem to be sad today."
        } else  if (predictedClass == "fear") {
             ModelResultText.text = "You seem to be feeling scared."
        } else if (predictedClass == "anger"){
            ModelResultText.text = "You seem to be angry."
        } else {
            ModelResultText.text = "I am failing to detect any emotion. You seem to have had a okay day."
        }
    }


    @IBAction func didClickDoneButton(_ sender: Any) {
//        print("dict", UserDefaults.standard.object(forKey: "sentiment_dict"))
        self.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
//        let calendarController = tabviewControllers.viewControllers[0] as! RecapViewController
//        calendarController.emotionForTheDay = predictedClass
//        calendarController.textForTheDay = TranscribedText.text
//        print(calendarController.emotionForTheDay)
        weak var pvc = self.presentingViewController
        pvc?.dismiss(animated: true, completion: nil)
        if let tabBarController = self.presentingViewController?.presentingViewController?.tabBarController {
            tabBarController.selectedIndex = 1
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        let dateString = dateFormatter.string(from: Date())
        let date = dateFormatter.date(from: "2020 07 27")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let readContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)
        let newEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        let entity2 = Entity()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.returnsObjectsAsFaults = false
        var sentiment_dict = [Date : Emotion]()
        var list = [[Date : Emotion]]()
        do {
            let result = try readContext.fetch(request) as![NSManagedObject]
//            print("Result", result)
            print(result.count)
            for data in result {
//                print("DATA", data.value(forKey: "sentiment"))
                if (data.value(forKey: "emotionDict") != nil) {
                    sentiment_dict = (data.value(forKey: "emotionDict") as? [Date : Emotion])!
                    list.append(sentiment_dict)
                }
                break
            }
        } catch {
            print("FAILED")
        }
        print("List Count", list.count)
        for x in list {
            print("Dictionary", x)
        }
//        if (sentiment_list != nil || sentiment_list.count == 0) {
//            print("Sentiment List Count:", sentiment_list.count)
//            var dateSet = Set<Date>()
//            var newList = [Emotion]()
//            let sentiment = Emotion(text: TranscribedText.text, emotion: predictedClass, date: date!)
//            for sentiment_entry in sentiment_list {
//                if !(dateSet.contains(sentiment_entry.date)) {
//                    newList.append(sentiment_entry)
//                    dateSet.insert(sentiment_entry.date)
//                }
//            }
//            newList.append(sentiment)
//            print(newList.count)
////            let emotionList = EmotionList(emotionList: newList)
//            newEntity.setValue(newList, forKey: "emotionList")
//        } else {
//            let sentiment = Emotion(text: TranscribedText.text, emotion: predictedClass, date: date!)
//            let emotionList = EmotionList(emotionList: [sentiment])
//            newEntity.setValue(emotionList, forKey: "emotionList")
//        }
        let sentiment = Emotion(text: TranscribedText.text, emotion: predictedClass)
//        print(sentiment_list!.emotions.count)
        sentiment_dict[date!] = sentiment
        print("Sentiment Dictionary: ", sentiment_dict)
//        print(sentiment_list!.emotions.count)
        newEntity.setValue(sentiment_dict, forKey: "emotionDict")
        do {
            try managedContext.save()
            print("SAVED!!!!!!!!!!!!!!!!!!")
        } catch {
            print("NO")
        }
    }
}

public class Emotion: NSObject, NSCoding {

    public var text: String = ""
    public var emotion: String = ""
    
    init(text: String, emotion: String) {
        self.text = text
        self.emotion = emotion
    }
    
    public override init() {
        super.init()
    }
    public func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "text")
        coder.encode(emotion, forKey: "emotion")
       }
       
       public required convenience init?(coder: NSCoder) {
         let mText = coder.decodeObject(forKey: "text") as! String
         let mEmotion = coder.decodeObject(forKey: "emotion") as! String
        
        self.init(text: String(mText), emotion: String(mEmotion))
       }
    
}

public class EmotionList: NSObject, NSCoding {
   public var emotions: [Emotion] = []
    
    init(emotionList: [Emotion]) {
        self.emotions = emotionList
        
    }
    public func append(emotion: Emotion) {
        emotions.append(emotion)
    }
    
    public override init() {
        super.init()
    }
    public func encode(with coder: NSCoder) {
        coder.encode(emotions, forKey: "emotions")
       }
       
       public required convenience init?(coder: NSCoder) {
        let mEmotions = coder.decodeObject(forKey: "emotions") as! [Emotion]
        
        self.init(emotionList: mEmotions)
       }
    
}

