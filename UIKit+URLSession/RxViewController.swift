import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
  var viewWillAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)  // $0.first는 animate를 의미한다. animate가 true 혹은 false
  }
}
