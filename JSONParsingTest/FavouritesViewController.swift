//
//  FavouritesViewController.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 01/11/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var favourites: [String: Favourites]?
    var results: [Favourites]? = []
    var recommendations: [Recommended]? = []
    var artists: [String]? = []
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var recommendationsCollView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesTableView.reloadData()
        recommendationsCollView.reloadData()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let sortDescriptor = NSSortDescriptor(key: "orderNumber", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            var result = try managedContext?.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                print(data)
                let fav = Favourites.init(track: data.value(forKey: "track") as! String, duration: data.value(forKey: "duration") as! String, artist: data.value(forKey: "artist") as! String, orderNumber: data.value(forKey: "orderNumber") as! Int, trackId: data.value(forKey: "trackId") as! String)
                if((results?.contains(where: { $0.trackId == fav.trackId}))!){
                    results?.removeAll(where: { $0.trackId == fav.trackId})
                    results?.append(fav)
                } else {
                    results?.append(fav)
                }
                if (artists!.contains(where: { $0 == fav.artist })) {
                    artists?.removeAll(where: { $0 == fav.artist })
                    artists?.append(fav.artist)
                } else {
                    artists?.append(fav.artist)
                }
                print("brother \(fav)")
                print("okeeeei?\(artists)")
                print("ayo was crackin dude \(results)")
                let currentTrack = data.value(forKey: "track") as! String
                
            }
            print(result)
            print("ayo was crackin dude \(results)")
        } catch let e {
            print("error:\(e)")
        }
        do {
            let result = try managedContext?.fetch(fetchRequest)
                for res in results! {
                        for data in result as! [NSManagedObject] {
                            let resultAsObjects = result as! [NSManagedObject]
                            if(resultAsObjects.contains(where: { $0.value(forKey: "trackId") as! String == res.trackId })) {
                                let index = results?.firstIndex(where: { $0.trackId == res.trackId })
                                if(index != nil) {
                                    results?.remove(at: index!)
                                    results?.append(res)
                                    print(results)
                                }
                            } else {
                                let index = results?.firstIndex(where: { $0.track == res.track })
                                let fav = Favourites.init(track: data.value(forKey: "track") as! String, duration: data.value(forKey: "duration") as! String, artist: data.value(forKey: "artist") as! String, orderNumber: data.value(forKey: "orderNumber") as! Int, trackId: data.value(forKey: "trackId") as! String)
                                if(index != nil) {
                                    results?.remove(at: index!)
                                }
                                print(results)
                            }
                        }
                    }
            if (result?.count == 0) {
                results?.removeAll()
                recommendations?.removeAll()
            }
        } catch {
            print(error)
        }
        
        if (artists?.count != 0) {
            getRecommendations(completion: { success in
                self.recommendations = success
                
                print("er du serr nå \(self.recommendations)")
                self.recommendationsCollView.reloadData()
            })
        }
        if results?.count == 0 {
            artists?.removeAll()
            recommendations?.removeAll()
        }

        favouritesTableView.reloadData()
        recommendationsCollView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.register(UINib(nibName: "FavouritesCell", bundle: nil), forCellReuseIdentifier: "favouriteCell")
        
        recommendationsCollView.dataSource = self
        recommendationsCollView.delegate = self
        recommendationsCollView.register(UINib(nibName: "RecommendedCell", bundle: nil), forCellWithReuseIdentifier: "recommendedCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return favourites?.count ?? 0
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "favouriteCell") as? FavouriteCellController
        cell?.duration.text = results?[indexPath.row].duration
        cell?.artistName.text = results?[indexPath.row].artist
        cell?.numberLabel.text = "\(indexPath.row + 1)."
        let cellTrackName = cell?.trackName.text
        if (cellTrackName != results?[indexPath.row].track) {
            cell?.trackName.text = results?[indexPath.row].track
        }
        cell?.trackName.font = cell?.trackName.font.withSize(15)
        cell?.artistName.font = cell?.trackName.font.withSize(12)
        cell?.duration.font = cell?.trackName.font.withSize(15)
        for view in (cell?.subviews)!{
            if let button = view as? UIButton {
                button.removeFromSuperview()
            }
        }
        return cell!
    }
    
    @IBAction func startEditing (_ sender: Any?) {
        if (favouritesTableView.isEditing == false) {
            
            favouritesTableView.isEditing = true
        } else {
            favouritesTableView.isEditing = false
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
            fetchRequest.returnsObjectsAsFaults = false
            let cells = favouritesTableView.visibleCells

            do {
                let result = try managedContext?.fetch(fetchRequest)
                    
                for cell in cells {
                    let indexPath = favouritesTableView.indexPath(for: cell)
                    for data in result as! [NSManagedObject] {
                        let track = results?[indexPath!.row]
                            if(track?.trackId == data.value(forKey: "trackId") as! String)  {
                                data.setValue(indexPath!.row + 1, forKey: "orderNumber")
                            }
                    }
                }
                
                do {
                    try managedContext?.save()
                } catch {
                    print(error)
                }
                
            } catch {
                print(error)
            }
            print(results)
            /*for track in results! {
                if(!(artists!.contains(where: { $0 == track.artist }))) {
                    artists?.remove(at: $0)
                }
            }*/
            
            for artist in artists! {
                if(results!.contains(where: { $0.artist != artist})) {
                    let index = artists?.firstIndex(of: artist)
                    artists?.remove(at: index!)
                }
            }
            
            //print(recommendations)
            print(artists)
            
            if (cells.count != 0) {
                getRecommendations(completion: { success in
                    self.recommendations = success
                    self.recommendationsCollView.reloadData()
                })
            } else {
                artists?.removeAll()
                recommendations?.removeAll()
            }
            recommendationsCollView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
            fetchRequest.returnsObjectsAsFaults = false
            //favouritesTableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                let result = try managedContext?.fetch(fetchRequest)
                let trackToDelete = result?[indexPath.row] as! NSManagedObject
                let indexofDeleted = results?.firstIndex(where: {$0.trackId == results?[indexPath.row].trackId})
                results?.remove(at: indexofDeleted!)
                managedContext?.delete(trackToDelete)
            } catch {
                print(error)
            }
        }
        print(results)
        favouritesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTrack = self.results?[sourceIndexPath.row]
        results?.remove(at: sourceIndexPath.row)
        results?.insert(movedTrack!, at: destinationIndexPath.row)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false
        favouritesTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendationsCollView.dequeueReusableCell(withReuseIdentifier: "recommendedCell", for: indexPath) as! RecommendedCell
        cell.artistName.text = recommendations?[indexPath.row].Name
        cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        if(favouritesTableView.isEditing == false) {
        return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
        
    }
    
    func getRecommendations(completion: @escaping ([Recommended]?) -> Void) {
        
        var artistsString: String = ""
        
        for artist in artists! {
            if(artist != artists?.last) {
                artistsString.append("\(artist)%2C+")
            } else {
                artistsString.append(artist)
            }
        }
        print(artistsString)
        let urlString = artistsString.replacingOccurrences(of: " ", with: "+")
        print(urlString)
        
        let encodedString = artistsString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(artistsString)
        
        Alamofire.request("https://tastedive.com/api/similar?q=\(urlString)&k=350801-iOSExam-QSDW9FMH").responseJSON { response in
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode([String: [String: [Recommended]]].self, from:
                    response.data!)
                completion(model["Similar"]?["Results"])
            }catch {
                print("error: \(error), response: \(response.data)")
                completion(nil)
            }
            
        }
    }
}
