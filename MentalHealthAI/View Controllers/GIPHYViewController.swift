//
//  GIPHYViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/1/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
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
        let shouldSearch = UserDefaults.standard.bool(forKey: "shouldSearch")
        let lastEmotion = UserDefaults.standard.object(forKey: "lastEmotion") as? String
        print(lastEmotion)
        let lastDate = UserDefaults.standard.object(forKey: "lastDate") as? Date
        let calendar = Calendar.current
        if lastDate != nil {
            let day = calendar.component(.day, from: lastDate!)
            let month = calendar.monthSymbols[calendar.component(.month, from: lastDate!) - 1]
            let year = calendar.component(.year, from: lastDate!)
            dayLabel.text = "\(day)"
            MonthLabel.text = "\(month)"
            yearLabel.text = "\(year)"
        }
        if lastEmotion != nil {
        if lastEmotion == "joy" {
//            searchGifs(for: "pandas")
            emotionLabel.text = "You seem to be feeling happy today!"
            cheerLabel.text = "So let's keep that going with a Panda GIF!"
        } else if lastEmotion == "sadness" {
            searchGifs(for: "dogs")
            emotionLabel.text = "You seem to be feeling sad today."
            cheerLabel.text = "So let's cheer you up with a Dog GIF!"
        } else if lastEmotion == "anger" {
//            searchGifs(for: "nature")
            emotionLabel.text = "You seem to be feeling angry today."
            cheerLabel.text = "So let's calm you down with a beautiful Nature GIF!"
        } else if lastEmotion == "fear" {
//            searchGifs(for: "ocean")
            emotionLabel.text = "You seem to be feeling afraid today!"
            cheerLabel.text = "So let's calm your apprehensions with a blissful Lakes GIF!"
        } else {
//            searchGifs(for: "Packers")
            emotionLabel.text = "You seem to be feeling okay today!"
            cheerLabel.text = "So let's see if you can crack a smile with this Packers GIF!"
        }
        var term: String?
        if shouldSearch {
            if lastEmotion == "joy" {
                let joyGifs = ["rabbits", "MickeyMouse", "Hamsters", "Pandas"]
                term = joyGifs[Int.random(in: 0...joyGifs.count-1)]
                searchGifs(for: term!)
            } else if lastEmotion == "sadness" {
                let sadGifs = ["Minions", "Hamsters", "Dogs", "Snoopy"]
                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                searchGifs(for: term!)
            } else if lastEmotion == "anger" {
                let sadGifs = ["Northern Lights", "Glaciers", "Forrests", "GrandCanyon"]
                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                searchGifs(for: term!)
            } else if lastEmotion == "fear" {
                let sadGifs = ["Sunsets", "Clouds", "BugsBunny", "ToyStory"]
                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                searchGifs(for: term!)
            } else {
                let sadGifs = ["Geysers", "roadrunner", "NiagaraFalls", "madagascar"]
                term = sadGifs[Int.random(in: 0...sadGifs.count-1)]
                searchGifs(for: term!)
            }
        } else {
            let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
            if UserDefaults.standard.url(forKey: "lastGIF") != nil {
                self.gifView.image = UIImage.gif(url: gifURL!)
            }
        }
        }
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
