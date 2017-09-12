//
//  ViewController.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 11/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        signOutUser()
        
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           }
    
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        
        //setup
        //cell.textLabel?.text = "\(indexPath.row )"
        //cell.detailTextLabel?.text = pokemons[indexPath.row].name
        
        return cell
        
    }
}
