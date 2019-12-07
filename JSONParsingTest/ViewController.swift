//
//  ViewController.swift
//  JSONParsingTest
//
//  Created by Marcus Jensen on 14/10/2019.
//  Copyright © 2019 Marcus Jensen. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        //Alamofire.request((URL).self as! (URLRequestConvertible)).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var posts = [String:[Post]]()
    var idAlbum: String!
    var albumName: String?
    var artistName: String?
    var downloadUrl: String?
    var releaseYear: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collVIew: UICollectionView!
    @IBOutlet weak var layoutSwitch: UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        
        /*getPosts(){ response in
            self.posts = response!
            print(response)*/
        /*DispatchQueue.main.async {
            self.tableView.reloadData()
        }*/
        getPosts() { response in
            self.posts = response!
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collVIew.reloadData()
            }
        }
        print("yoooooo\(posts)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "albumCellTableView")
        tableView.register(UINib(nibName: "TopFiftyTableCell", bundle: nil), forCellReuseIdentifier: "AlbumTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        //collVIew.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collCell")
        collVIew.register(UINib(nibName: "AlbumCollCell", bundle: nil), forCellWithReuseIdentifier: "albumCollCell")
        collVIew.delegate = self
        collVIew.dataSource = self
        collVIew.isHidden = true
        
        tableView.layer.cornerRadius = 10.0
        collVIew.contentInset.left = 8
        collVIew.contentInset.right = 8
        
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch layoutSwitch.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            collVIew.isHidden = true
        case 1:
            tableView.isHidden = true
            collVIew.isHidden = false
             self.collVIew.reloadData()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts["loved"]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHalved = UIScreen.accessibilityFrame().width/2
        return CGSize(width: 170, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVIew.dequeueReusableCell(withReuseIdentifier: "albumCollCell", for: indexPath) as! AlbumCollectionViewCell
        
        cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        cell.albumName.text = posts["loved"]?[indexPath.row].strAlbum
        cell.artistName.text = posts["loved"]?[indexPath.row].strArtist

        cell.albumThumb.downloadImage(from: URL(string:(posts["loved"]?[indexPath.row].strAlbumThumb)!)!)

        return cell

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCellTableView", for: indexPath)
        let enCelle = tableView.dequeueReusableCell(withIdentifier: "AlbumTableCell") as! TopAlbumsTableViewCellClass
        cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        enCelle.albumName.text = posts["loved"]![indexPath.row].strAlbum
        enCelle.artistName.text = posts["loved"]![indexPath.row].strArtist
        /*if let albumName = cell.viewWithTag(100) as? UILabel {
            albumName.text = posts["loved"]![indexPath.row].strAlbum
        } else {
            let albumName = UILabel(frame: CGRect(x: 200, y: 0, width: 150, height: 60))
            albumName.tag = 100
            albumName.text = posts["loved"]![indexPath.row].strAlbum
            albumName.textAlignment = .right
            albumName.font = albumName.font.withSize(15)
            albumName.adjustsFontSizeToFitWidth = true

            albumName.minimumScaleFactor = 0.5
            cell.addSubview(albumName)
        }*/
        cell.textLabel?.text = posts["loved"]?[indexPath.row].strArtist
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        //cell.layer.cornerRadius = 5.0
        return enCelle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts["loved"]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        idAlbum = posts["loved"]![indexPath.row].idAlbum
        albumName = posts["loved"]![indexPath.row].strAlbum
        artistName = posts["loved"]![indexPath.row].strArtist
        downloadUrl = posts["loved"]![indexPath.row].strAlbumThumb
        releaseYear = posts["loved"]![indexPath.row].intYearReleased
        
        print(posts["loved"]![indexPath.row].strArtist)
        
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! AlbumDetailViewController
        detailView.albumId = idAlbum
        detailView.strAlbum = albumName
        detailView.strArtist = artistName
        detailView.downloadUrl = downloadUrl
        detailView.yearRelease = releaseYear
        detailView.getAlbumDetails(id: idAlbum) { success in
            detailView.albumDetails = success!
        }
        print(idAlbum, albumName, artistName)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idAlbum = posts["loved"]![indexPath.row].idAlbum
        albumName = posts["loved"]![indexPath.row].strAlbum
        artistName = posts["loved"]![indexPath.row].strArtist
        downloadUrl = posts["loved"]![indexPath.row].strAlbumThumb
        releaseYear = posts["loved"]![indexPath.row].intYearReleased
        
        performSegue(withIdentifier: "showDetailView", sender: self)
        
    }
    
    func getPosts(completion: @escaping ([String:[Post]]?) -> Void){
        
       Alamofire.request("https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album&format=album").responseJSON{ response in
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode([String:[Post]].self, from:
                    response.data!) //Decode JSON Response Data
                //self.posts = model
                completion(model)
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil)
            }
        }
    }
}
