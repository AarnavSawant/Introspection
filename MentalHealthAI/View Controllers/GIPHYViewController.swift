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
    @IBOutlet weak var gifView: UIImageView!
    var gifs  = [Gif]()
    var network = GifNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadInputViews()
        let shouldSearch = UserDefaults.standard.bool(forKey: "shouldSearch")
        let lastEmotion = UserDefaults.standard.object(forKey: "lastEmotion") as! String
        print(lastEmotion)
        let lastDate = UserDefaults.standard.object(forKey: "lastDate") as! Date
        if shouldSearch {
            if lastEmotion == "joy" {
                searchGifs(for: "pandas")
            } else if lastEmotion == "sadness" {
                searchGifs(for: "dogs")
            } else if lastEmotion == "anger" {
                searchGifs(for: "nature")
            } else if lastEmotion == "fear" {
                searchGifs(for: "ocean")
            } else {
                searchGifs(for: "Packers")
            }
        } else {
            let gifURL = UserDefaults.standard.string(forKey: "lastGIF")
            if UserDefaults.standard.url(forKey: "lastGIF") != nil {
                self.gifView.image = UIImage.gif(url: gifURL!)
            }
        }
    }
    
    func searchGifs(for searchText: String) {
        network.fetchGIFs(searchTerm: searchText) { gifArray in
            if gifArray != nil {
                print(gifArray!.gifs.count)
                self.gifs = gifArray!.gifs
                let gifURL = self.gifs[0].getGIFURL()
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
