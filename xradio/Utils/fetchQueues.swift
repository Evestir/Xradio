//
//  fetchQueues.swift
//  xradio
//
//  Created by vesolis on 2023/10/05.
//

import Foundation

var currentMusic:Music = Music(name: "", author: "", coverImage: "")

func fetchData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        completion(data, response, error)
    }.resume()
}

func makeArrayFromJson(jsonString: String) -> Array<Music> {
    var isFirst:Bool = true
    var queueList: Array<Music> = []
    if let data = jsonString.data(using: .utf8) {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                // Now you have an array of dictionaries. You can work with this array.
                for item in jsonArray {
                    if let artistName = item["artist_name"] as? String, 
                        let songName = item["song_name"] as? String,
                        let imageLink = item["itunes_img"] as? String {
                        if (isFirst) { currentMusic = Music(name: songName, author: artistName, coverImage: imageLink) }
                        queueList.append(Music(name: songName, author: artistName, coverImage: imageLink))
                        
                        //print("Artist: \(artistName), Song: \(songName), CoverImage: \(imageLink)")
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    } else {
        print("Invalid JSON string.")
    }
    return queueList
}

func test() {
    let string:String = "[{\"sans\": \"4\", \"papyrus\": \"4\"}, {\"sans\": \"3\", \"papyrus\": \"3\"}]"
    
    if let data = string.data(using: .utf8) {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                // Now you have an array of dictionaries. You can work with this array.
                for item in jsonArray {
                    if let artistName = item["sans"] as? String,
                       let songName = item["papyrus"] as? String {
                        print("Artist: \(artistName), Song: \(songName)")
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    } else {
        print("Invalid JSON string.")
    }
}

func fetchFromTheBeach(completion: @escaping (Result<[Music], Error>) -> Void) {
    if let url = URL(string: "https://socast-public.s3.amazonaws.com/player/lp_756_905.js") {
        fetchData(from: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                // Process the data here
                print("Data received: \(data)")
                let sans = makeArrayFromJson(jsonString: String(decoding: data, as: UTF8.self))
                completion(.success(sans))
            }
        }
    }
}
