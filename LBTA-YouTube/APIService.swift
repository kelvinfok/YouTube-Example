//
//  APIService.swift
//  LBTA-YouTube
//
//  Created by kelvinfok on 20/4/17.
//  Copyright © 2017 kelvinfok. All rights reserved.
//

import UIKit

struct APIService {
    
    static let sharedInstance = APIService()
    
    func fetchVideos(completion: @escaping ([Video])->()) {
        
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                for dictionary in json as! [[String : Any]] {
                    
                    var video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    var channel = Channel()
                    let channelDictionary = dictionary["channel"] as? [String : Any]
                    channel.name = channelDictionary?["name"] as? String
                    channel.profileImageName = channelDictionary?["profile_image_name"] as? String
                    
                    video.channel = channel
                    videos.append(video)
                    
                    OperationQueue.main.addOperation {
                        completion(videos)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
}
