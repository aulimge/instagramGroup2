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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

