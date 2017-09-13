//
//  helper.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 13/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from urlString : String) {
        //1. url
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            
        }
        task.resume()
    }
}

