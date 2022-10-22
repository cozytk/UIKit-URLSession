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

    private func getNotionAPI() -> Observable<String> {
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

        return session.rx.data(request: request)
            .map { try JSONDecoder().decode(NotionSample.self, from: $0)}
            .map { $0.results.description }
    }
}
