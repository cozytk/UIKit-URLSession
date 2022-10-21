//
//  ViewController.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    private var isHello = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        label.text = "안녕하세요"
        getNotionAPI()
    }

    func getNotionAPI() {
        let headers = [
            "accept": "application/json",
            "Notion-Version": "2022-06-28",
            "content-type": "application/json",
            "authorization": "Bearer secret_lJJ6o18yolookxqAqlgKwUC3VFQMYlEige3enTaPIK7"
        ]

        let parameters = ["page_size": 100] as [String : Any]
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: "https://api.notion.com/v1/databases/a255741aa68f43c89982561c09a1e3fe/query")!, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let data {
                if let sample = try? JSONDecoder().decode(NotionSample.self, from: data) {
                    DispatchQueue.main.async {
                        self.label.text = sample.results.description
                    }
                }
            }
        }

        dataTask.resume()
    }
}
