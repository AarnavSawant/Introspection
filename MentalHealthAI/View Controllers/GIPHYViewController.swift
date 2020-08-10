//
//  GIPHYViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/1/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftGifOrigin
class GIPHYViewController: UIViewController {
    @IBOutlet weak var cheerLabel: UILabel!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    var gifs  = [Gif]()
    var network = GifNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadInputViews()
//        let shouldSearch = UserDefaults.standard.bool(forKey: "shouldSearch")
//        let lastEmotion = UserDefaults.standard.object(forKey: "lastEmotion") as? String
//        print(lastEmotion)
//        let lastDate = UserDefaults.standard.object(forKey: "lastDate") as? Date
        let uid = UserDefaults.standard.string(forKey: "uid")
        let db = Firestore.firestore()
        var maxTimestamp = 0.0
        var maxURL: String?
        var maxTerm: String?
        var maxEmotion: String?
        db.collection("users").document(uid!).collection("user_sentiment").getDocuments { (querySelector, err) in
            if err != nil {
                print("There was an error retrieving data")
            } else if (querySelector != nil && !querySelector!.isEmpty) {
                print("REAL MADRID")
                let documents = querySelector!.documents
                for document in documents {
                    let data = document.data()
                    print("Lakers", data["gif_term"])
                    let timestamp = data["timestamp"] as! Double
                    print("Timestamp", timestamp)
                    if timestamp > maxTimestamp {
                        maxTimestamp = timestamp
                        print("Max Timestamp", maxTimestamp)
                        maxEmotion = data["emotion"] as! String
                        maxTerm = data["gif_term"] as! String
                        maxURL = data["gif_url"] as! String
                    }
                }
                print("Max Term Inside Completion", maxTerm)
                //                cell.gifURL = url as! String
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        print("Max Term", maxTerm)
        if maxTimestamp != 0.0 {
            let lastDate = Date.init(timeIntervalSince1970: maxTimestamp)
            let lastEmotion = maxEmotion!
            let term = maxTerm!
            let gifURL = maxURL!
            let calendar = Calendar.current
            if lastDate != nil {
                let day = calendar.component(.day, from: lastDate)
                let month = calendar.monthSymbols[calendar.component(.month, from: lastDate) - 1]
                let year = calendar.component(.year, from: lastDate)
                self.dayLabel.text = "\(day)"
                self.MonthLabel.text = "\(month)"
                self.yearLabel.text = "\(year)"
            }
            self.gifView.image = UIImage.gif(url: gifURL)
//        if shouldSearch {
//            if lastEmotion == "joy" {
//                let joyGifs = ["Rabbit", "MickeyMouse", "Hamsters", "Pandas"]
//                term = joyGifs[Int.random(in: 0...joyGifs.count-1)]
//                searchGifs(for: term!)
//                UserDefaults.standard.set(term!, forKey: "Last Term")
//            } else if lastEmotion == "sadness" {
//                let sadGifs = ["Minions", "Hamsters", "Dogs", "Snoopy"]
//                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
//                searchGifs(for: term!)
//                UserDefaults.standard.set(term!, forKey: "Last Term")
//            } else if lastEmotion == "anger" {
//                let sadGifs = ["Northern Lights", "Glaciers", "Forrests", "GrandCanyon"]
//                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
//                searchGifs(for: term!)
//                UserDefaults.standard.set(term!, forKey: "Last Term")
//            } else if lastEmotion == "fear" {
//                let sadGifs = ["Sunsets", "Clouds", "BugsBunny", "ToyStory"]
//                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
//                searchGifs(for: term!)
//                UserDefaults.standard.set(term!, forKey: "Last Term")
//            } else {
//                let sadGifs = ["Geysers", "roadrunner", "waterfall", "madagascar"]
//                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
//                searchGifs(for: term!)
//                UserDefaults.standard.set(term!, forKey: "Last Term")
//            }
//        } else {
//            let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
//            if UserDefaults.standard.url(forKey: "lastGIF") != nil {
//                self.gifView.image = UIImage.gif(url: gifURL!)
//            }
//        }
            print(lastEmotion)
            if lastEmotion != nil {
    //            let term = UserDefaults.standard.string(forKey: "Last Term")
                    if lastEmotion == "joy" {
            //            searchGifs(for: "pandas")
                        self.emotionLabel.text = "You seem to be feeling happy today!"
                        self.cheerLabel.text = "So let's keep that going with a \(term) GIF!"
                        print("Wizards", self.cheerLabel.text!)
                    } else if lastEmotion == "sadness" {
//                        searchGifs(for: "dogs")
                        self.emotionLabel.text = "You seem to be feeling sad today."
                        self.cheerLabel.text = "So let's cheer you up with a \(term) GIF!"
                    } else if lastEmotion == "anger" {
            //            searchGifs(for: "nature")
                        self.emotionLabel.text = "You seem to be feeling angry today."
                        self.cheerLabel.text = "So let's calm you down with a beautiful \(term) GIF!"
                    } else if lastEmotion == "fear" {
            //            searchGifs(for: "ocean")
                        self.emotionLabel.text = "You seem to be feeling afraid today!"
                        self.cheerLabel.text = "So let's calm your apprehensions with a blissful \(term) GIF!"
                    } else {
            //            searchGifs(for: "Packers")
                        
                        self.emotionLabel.text = "You seem to be feeling okay today!"
                        self.cheerLabel.text = "So let's see if you can crack a smile with this  \(term) GIF!"
                    }
            }
            }
        }
        print("Celtics", self.cheerLabel.text!)
    }
    
    func searchGifs(for searchText: String) {
        network.fetchGIFs(searchTerm: searchText) { gifArray in
            if gifArray != nil {
                print(gifArray!.gifs.count)
                self.gifs = gifArray!.gifs
                let randomNumber = Int.random(in: 0..<gifArray!.gifs.count)
                let gifURL = self.gifs[randomNumber].getGIFURL()
                UserDefaults.standard.set(gifURL, forKey: "lastGIF")
                UserDefaults.standard.set(false, forKey: "shouldSearch")
//                let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
//                if UserDefaults.standard.url(forKey: "lastGIF") != nil {
                    self.gifView.image = UIImage.gif(url: gifURL)
//                }
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
