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
    private let viewModel = ViewModel()

    @IBOutlet weak var label: UILabel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        label.text = "안녕하세요"
        viewModel.getNotionAPI()
            .observe(on: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }
}
