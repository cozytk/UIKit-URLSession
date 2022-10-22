//
//  ViewController.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/18.
//

import UIKit

import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    private var isHello = true
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        label.text = "안녕하세요"
        getNotionAPI()
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }

    private func getNotionAPI() -> Observable<String?> {
        return Observable.create { emitter in
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

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    emitter.onError(error)
                    print(error.localizedDescription)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    var response = response as? HTTPURLResponse
                    print("Response Problem")
                    return
                }
                guard let mimeType = httpResponse.mimeType, mimeType == "application/json", let data else {
                    print("mimeType Problem")
                    return
                }
                guard let sample = try? JSONDecoder().decode(NotionSample.self, from: data) else {
                    print("sample Problem")
                    return
                }
                emitter.onNext(sample.results.description)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create()
//                task.cancel()
//            }
        }
    }
}
