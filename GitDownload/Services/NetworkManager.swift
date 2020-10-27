//
//  NetworkManager.swift
//  GitDownload
//
//  Created by Anna Sverdlova on 27.10.2020.
//

import Foundation

class NetworkManager {

    private let URLString = "https://api.github.com/search/repositories?q=language:swift"
    private let firstRequestString = "&page=1&per_page=15"
    private let secondRequestString = "&page=2&per_page=15"

    private static var sharedNetworkManager = NetworkManager()
    init(){}
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }

    private func download(url: String, completion: @escaping ([Result]?) -> Void) {
        guard let url = URL(string: url) else {
            debugPrint("Failed to create url")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            var result: [Result]? = nil

            if error != nil {
                debugPrint("Failed to load: \(error!.localizedDescription)")
            }

            if response != nil {
                let httpResponse = response as! HTTPURLResponse

                if httpResponse.statusCode == 200 {
                    if data != nil {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                            if let data = json["items"] as? Array<[String: Any]> {
                                print(data)
                                result = []
                                data.forEach({ item in
                                    result?.append(Result(item))
                                })
                            } else {
                                debugPrint("Failed to parse data")
                            }

                        } catch let error as NSError {
                            debugPrint("Failed to load: \(error.localizedDescription)")
                        }
                    } else {
                        debugPrint("There is no data")
                    }
                } else {
                    debugPrint("Failed to load: request returns with status code \(httpResponse.statusCode)")
                }
            }



            completion(result)
        })

        task.resume()
    }

    func fire(competion: @escaping ([Result]?) -> Void) {
        let group = DispatchGroup()
        var firstArray: [Result]?
        var secondArray: [Result]?

        group.enter()
        download(url: URLString + firstRequestString, completion: { result in
            firstArray = result
            group.leave()
        })

        group.enter()
        download(url: URLString + secondRequestString, completion: { result in
            secondArray = result
            group.leave()
        })

        group.notify(queue: DispatchQueue.main, execute: {
            if firstArray != nil && secondArray != nil {
                firstArray!.append(contentsOf: secondArray!)
            } else {
                debugPrint("Failed to download all data")
            }
            competion(firstArray)
        })

    }
}
