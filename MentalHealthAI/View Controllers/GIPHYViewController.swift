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
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var dictionary: [String : [String : Any]]?
    var gifShareURL: String?
    @IBOutlet weak var cheerLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    var gifs  = [Gif]()
    var network = GifNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        let uid = UserDefaults.standard.string(forKey: "uid")
        let cal = Calendar.current
        let current_year = cal.component(.year, from: Date())
        let should_query = UserDefaults.standard.bool(forKey: "should_query")
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
    override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
        activityView.isHidden = false
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        shareButton.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        shareButton.layer.cornerRadius = 11
        shareButton.setTitleColor(.white, for: .normal)
        calendarButton.setTitleColor(UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1), for: .normal)
        calendarButton.layer.cornerRadius = 11
        calendarButton.backgroundColor = .white
        let navView = UIView()
        //            mainImageView.backgroundColor = .white
        //
        //           mainImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
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
//        reloadInputViews()
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
//               let db = Firestore.firestore()
        let calendar = Calendar.current
        let testdate = dateFormatter.date(from: "2020 08 15")!
        let current_year = calendar.component(.year, from: testdate)
        let current_month = calendar.component(.month, from: testdate)
        let current_day = calendar.component(.day, from: testdate)
        let currentMonthString = calendar.monthSymbols[current_month - 1]
        print("DAY", current_day)
        print("MONTH", current_month)
        print("YEAR", current_year)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                db.collection("users").document(uid!).getDocument { (querySelector, err) in
                if err != nil {
                    print("There was an error retrieving data")
                } else if (querySelector != nil) {
                    print("REAL MADRID")
                    let data = querySelector?.data()
                    if data!["last_gif_url"] != nil {
                        maxURL = data!["last_gif_url"] as! String
                    }
                    if data!["last_gif_term"] != nil {
                        maxTerm = data!["last_gif_term"] as! String
                    }
                    if data!["last class"] != nil {
                        maxEmotion = data!["last class"] as! String
                    }
                    if data!["timestamp"] != nil {
                        maxTimestamp = data!["timestamp"] as! Double
                    }
                    }
                    //                cell.gifURL = url as! String
                }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("Max Term", maxTerm)
//        if maxTimestamp != 0.0 {
            let lastDate = Date.init(timeIntervalSince1970: maxTimestamp)
                if maxEmotion != nil && maxTerm != nil && maxURL != nil {
                    let lastEmotion = maxEmotion!
                    let term = maxTerm!
                    let gifURL = maxURL!
                    self.gifShareURL = gifURL
                    let calendar = Calendar.current
                    if lastDate != nil {
                        let day = calendar.component(.day, from: lastDate)
                        let month = calendar.monthSymbols[calendar.component(.month, from: lastDate) - 1]
                        let year = calendar.component(.year, from: lastDate)
                        self.dayLabel.text = "\(currentMonthString) \(day), \(year)"
//                        self.MonthLabel.text = "\(month)"
//                        self.yearLabel.text = "\(year)"
                    }
                    self.activityView.stopAnimating()
                    self.activityView.isHidden = true
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
    //            }
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
    @IBAction func didClickShareButton(_ sender: Any) {
//        var URLString: String = gifView!.contentUR
        print(self.gifShareURL!)
        var shareURL:NSURL = NSURL(string: self.gifShareURL!)!
        var shareData:NSData = NSData(contentsOf: shareURL as URL)!
        
        let vc = UIActivityViewController(activityItems: [shareData as Any], applicationActivities: nil)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func didClickCalendarButton(_ sender: Any) {
        let vc = self.tabBarController as! MainTabBarController
        vc.selectedIndex = 0
    }
//    Thread 1: EXC_BREAKPOINT (code=1, subcode=0x1048cd8e4)
    
}
