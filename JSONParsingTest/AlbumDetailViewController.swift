//
//  AlbumDetailViewController.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 26/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AlbumDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateTableViewFromCell{
    

    var albumDetails = [AlbumDetailView]()
    
    @IBOutlet weak var albumArt: UIImageView!
    
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var tracks: UITableView!
    var downloadUrl: String?
    var albumId : String?
    var strAlbum: String?
    var strArtist: String?
    var yearRelease: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracks.reloadData()
    }
    
    override func loadView() {
        
        super.loadView()
        print("hehe\(albumId)")
        print(strArtist)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                print("zuuup\(data)")
                print("heyaman \(data.value(forKey: "track"))")
            }
        } catch {
            print("fail hahaha noob ass!!")
        }
        //self.artistName?.text = strArtist
        //self.albumName?.text = strAlbum
        if(downloadUrl != nil && !(downloadUrl ?? "").isEmpty) {
            albumArt.downloadImage(from: URL(string:(downloadUrl)!)!)
        } else {
            albumArt.downloadImage(from: URL(string:("https://stationsite.co.uk/app/artist_catalog/default.jpg"))!)
        }
        /*albumArt.layer.cornerRadius = 10.0
        albumArt.layer.shadowRadius = 2.0
        albumArt.layer.shadowOpacity = 0.7
        albumArt.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        albumArt.layer.shadowPath = UIBezierPath(roundedRect: albumArt.bounds, cornerRadius: albumArt.layer.cornerRadius).cgPath*/
        artistName?.text = strArtist
        albumName?.text = strAlbum
        releaseYear?.text = yearRelease
        tracks.dataSource = self
        tracks.delegate = self
        tracks.register(UINib(nibName: "trackCell", bundle: nil), forCellReuseIdentifier: "trackCell")
        tracks.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetails.count
    }
    
    func tableViewUpdate() {
        tracks.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracks.dequeueReusableCell(withIdentifier: "trackCell") as! TrackCellTableView
        
        let duration = Int(albumDetails[indexPath.row].intDuration)
        
        let minDouble = Double((duration! / 1000) / 60)
        var min = (duration! / 1000) / 60
        let sec = (duration! / 1000) % 60
        print(minDouble)
        if(min < 10 && sec < 10) {
            cell.duration.text = "0\(min):0\(sec)"
        } else if(sec < 10) {
            cell.duration.text = "\(min):0\(sec)"
        } else if(min < 10) {
            cell.duration.text = "0\(min):\(sec)"
        } else {
            cell.duration.text = "\(min):\(sec)"
        }
        print(min)
        
            cell.duration.font = cell.duration.font.withSize(15)
            cell.delegate = self
            cell.trackName.text = albumDetails[indexPath.row].strTrack
            cell.trackId = albumDetails[indexPath.row].idTrack
            cell.trackName.font = cell.trackName.font.withSize(15)
            cell.artistName = strArtist!
        let currentTrack = albumDetails[indexPath.row]
        let indexOfTrack = albumDetails.firstIndex(where: {$0.strTrack == currentTrack.strTrack})
        cell.numberLabel.text = "\(indexOfTrack! + 1)."
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let coloredStar = #imageLiteral(resourceName: "icons8-star-50-2")
        let unColoredStar = #imageLiteral(resourceName: "icons8-star-50")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            var result = try managedContext?.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let fav = Favourites.init(track: data.value(forKey: "track") as! String, duration: data.value(forKey: "duration") as! String, artist: data.value(forKey: "artist") as! String, orderNumber: data.value(forKey: "orderNumber") as! Int, trackId: data.value(forKey: "trackId") as! String)
                if(albumDetails[indexPath.row].idTrack == fav.trackId) {
                    print("okeidude \(albumDetails[indexPath.row].strTrack), \(fav.track)")
                    cell.favouriteBtn.setImage(coloredStar, for: .normal)
                }
            }
        } catch let error {
            print("error: \(error)")
        }
        return cell
    }
    
    func getAlbumDetails(id: String, completion: @escaping ([AlbumDetailView]?) -> Void) {
        
        Alamofire.request("https://theaudiodb.com/api/v1/json/195228/track.php?m=\(id)").responseJSON{ response in
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode([String:[AlbumDetailView]].self, from: response.data!)
                let infoArray = model["track"]
                completion(infoArray)
                print(response.data)
                self.viewDidLoad()
                
            } catch let e {
                print("Error", e)
                completion(nil)
            }
        }
        
    }

}
