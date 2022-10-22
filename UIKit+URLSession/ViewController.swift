//
//  ViewController.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/18.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    private var isHello = true
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        label.text = "안녕하세요"
        Task {
            try await getNotionAPI()
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] str in
                    self?.label.text = str
                })
                .disposed(by: disposeBag)
        }
    }

    enum FetchError: Error {
        case badStatusCode
        case badMimeType
        case badDecode
    }

    func getNotionAPI() async throws -> Observable<String?> {
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

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FetchError.badStatusCode
        }
        guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
            throw FetchError.badMimeType
        }
        guard let sample = try? JSONDecoder().decode(NotionSample.self, from: data) else {
            throw FetchError.badDecode
        }
        return Observable.just(sample.results.description)
    }
}
