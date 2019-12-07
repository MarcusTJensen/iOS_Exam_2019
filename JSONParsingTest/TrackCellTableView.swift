//
//  TrackCellTableView.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 01/11/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateTableViewFromCell: class {
    func tableViewUpdate()
}

class TrackCellTableView: UITableViewCell {

    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    weak var delegate: UpdateTableViewFromCell?
    
    let unColoredStar = #imageLiteral(resourceName: "icons8-star-51")
    let coloredStar = #imageLiteral(resourceName: "icons8-star-50-2")
    
    var artistName: String = ""
    var trackId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favouriteBtn.setImage(unColoredStar, for: .normal)
        
        favouriteBtn.addTarget(self, action: #selector(TrackCellTableView.addToFavourites(_:)), for: .touchUpInside)
        
        print("hahahahahlol\(artistName)")
        
        favouriteBtn.setTitle(nil, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.favouriteBtn.setImage(unColoredStar, for: .normal)
    }
    
    @objc
    func addToFavourites(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let favouriteTrack = NSEntityDescription.entity(forEntityName: "Favourite", in: managedContext)!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false
        
        if (favouriteBtn.currentImage == unColoredStar) {
            
            let favourite = NSManagedObject(entity: favouriteTrack, insertInto: managedContext)
            favourite.setValue(trackName.text, forKey: "track")
            favourite.setValue(duration.text, forKey: "duration")
            favourite.setValue(artistName, forKey: "artist")
            favourite.setValue(trackId, forKey: "trackId")
            
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if(result.count != 0) {
                    let positionNumber = result.count
                    favourite.setValue(positionNumber, forKey: "orderNumber")
                } else {
                    favourite.setValue(1, forKey: "orderNumber")
                }
            } catch {
                print(error)
            }
            
            do {
                try managedContext.save()
            } catch(let error) {
                print("error: \(error)")
            }
            print("favouriteyeaYEA\(favourite)")
        } else if (favouriteBtn.currentImage == coloredStar) {
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    if (data.value(forKey: "track") as! String == trackName.text) {
                        managedContext.delete(data)
                    }
                }
            } catch {
                print(error)
            }
            do {
                try managedContext.save()
            } catch(let error) {
                print("error: \(error)")
            }
            favouriteBtn.setImage(unColoredStar, for: .normal)
        }
        //let tableView = sender.superview?.superview?.superview?.superview as! UITableView
        //tableView.reloadData()
        delegate?.tableViewUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
