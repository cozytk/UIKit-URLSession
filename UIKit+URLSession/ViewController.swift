//
//  ViewController.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/18.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController, ViewModelBindableType {

    var viewModel: ViewModel!

    private let label = {
        let text = UILabel()
        text.text = "안녕하세요"
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func bind() {
        let input = ViewModelType.Input(viewWillAppear: rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        output.fetchedString
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: viewModel.disposeBag)
    }
}
