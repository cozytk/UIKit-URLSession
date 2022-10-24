//
//  ViewModel.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/22.
//

import Foundation

import RxCocoa
import RxSwift

final class ViewModel: ViewModelType {

    struct Input {
        let viewWillAppear: ControlEvent<Bool>
    }

    struct Output {
        let fetchedString: Observable<String>
    }

    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let fetchedString = input.viewWillAppear
            .flatMap { _ in
                self.getNotionAPI()
            }

        return Output(fetchedString: fetchedString)
    }

    func getNotionAPI() -> Observable<String> {
        return URLSession.shared.rx.data(request: self.request)
            .map { try JSONDecoder().decode(NotionSample.self, from: $0)}
            .map { $0.results.description }
    }
}

extension ViewModel {
    private var request: URLRequest {
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
        return request
    }

}
