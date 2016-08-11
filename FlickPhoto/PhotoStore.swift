//
//  PhotoStore.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/10/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorProtocol)
}

enum PhotoError: ErrorProtocol {
    case ImageCreationError
}

class PhotoStore {
    let session: URLSession = {
       let config = URLSessionConfiguration.default()
        return URLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completion: (PhotosResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
           let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data: Data?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        
        if let image = photo.image {
            completion(.Success(image))
            return 
        }
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
            if case let .Success(image) = result {
                photo.image = image
            }
            completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: NSError?) -> ImageResult {
        guard let imageData = data, image = UIImage(data: imageData) else {
            if data == nil {
                return .Failure(error!)
            } else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        return .Success(image)
    }
    
    
}
