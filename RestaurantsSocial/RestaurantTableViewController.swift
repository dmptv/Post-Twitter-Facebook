//
//  RestaurantTableViewController.swift
//  RestaurantSocial
//
//  Created by Игорь on 26.12.15.
//  Copyright © 2015 Ihor Malovanyi. All rights reserved.
//

import UIKit
import Social

class RestaurantTableViewController: UITableViewController {
    
    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "Thai Cafe"]
    
    var restaurantImages = ["cafedeadend.jpg", "homei.jpg", "teakha.jpg", "cafeloisl.jpg", "petiteoyster.jpg", "forkeerestaurant.jpg", "posatelier.jpg", "bourkestreetbakery.jpg", "haighschocolate.jpg", "palominoespresso.jpg", "upstate.jpg", "traif.jpg", "grahamavenuemeats.jpg", "wafflewolf.jpg", "fiveleaves.jpg", "cafelore.jpg", "confessional.jpg", "barrafina.jpg", "donostia.jpg", "royaloak.jpg", "thaicafe.jpg"]

    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    var ss = [Bool](repeatElement(false, count: 21))

    var restaurantIsVisited = [Bool](repeating: false, count: 21)

    override func viewDidLoad() {
        super.viewDidLoad()
   
        
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
        cell.locationLabel.text = restaurantLocations[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]
        cell.favorIconImageView.isHidden = !restaurantIsVisited[indexPath.row]

        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Alert View
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        
        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: UIAlertActionStyle.default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        
        let isVisitedTitle = restaurantIsVisited[indexPath.row] ? "I haven't been to here before" : "I've been here"
        let isVisitedAction = UIAlertAction(title: isVisitedTitle, style: .default, handler: {
            (action:UIAlertAction) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            
            self.restaurantIsVisited[indexPath.row] = self.restaurantIsVisited[indexPath.row] ? false : true
            cell.favorIconImageView.isHidden = !self.restaurantIsVisited[indexPath.row]
        })
        optionMenu.addAction(isVisitedAction)

        // Presnt Alert View
        self.present(optionMenu, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete rows
        if editingStyle == .delete {
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantLocations.remove(at: indexPath.row)
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)
            self.restaurantImages.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
        
        // Share
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in

            // Alert Controller
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .actionSheet)
            
            // Пост в твиттер
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler: {(action) in
                
                // Провверка на ошибку
                guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
                    let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "Login Error", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                    return
                }
                
                let twitComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitComposer?.setInitialText(self.restaurantNames[indexPath.row])
                twitComposer?.add(UIImage(named: self.restaurantImages[indexPath.row]))
                
                self.present(twitComposer!, animated: true, completion: nil)
            })
            
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action) in
                guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) else {
                    let alertMessage = UIAlertController(title: "FaceBook Unavailable", message: "Login Error", preferredStyle: .alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertMessage, animated: true, completion: nil)
                    return
                }
                
                let facebookCompose = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookCompose?.setInitialText(self.restaurantNames[indexPath.row])
                facebookCompose?.add(UIImage(named: self.restaurantImages[indexPath.row]))
                facebookCompose?.add(URL.init(string: "http://www.youtube.com"))
                
                self.present(facebookCompose!, animated: true, completion: nil)
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(cancelAction)
            
            self.present(shareMenu, animated: true, completion: nil)
            }
        )
        
        // Delete
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in

            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantLocations.remove(at: indexPath.row)
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)
            self.restaurantImages.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)

            }
        )
        
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)

        return [deleteAction, shareAction]
    }

    

}














