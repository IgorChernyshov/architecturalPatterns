import UIKit

// Model

struct Visitor {
  let name: String
  let age: Int
}

// Protocols

protocol GreetingViewProtocol: AnyObject {
  func setGreeting(greeting: String)
}

protocol GreetingPresenterProtocol: AnyObject {
  init(view: GreetingViewProtocol, visitor: Visitor)
  func viewDidTapGreetButton()
}

// Presenter

class GreetingPresenter: GreetingPresenterProtocol {
  
  weak var view: GreetingViewProtocol?
  private let visitor: Visitor
  
  required init(view: GreetingViewProtocol, visitor: Visitor) {
    self.view = view
    self.visitor = visitor
  }
  
  func viewDidTapGreetButton() {
    print("\(visitor.name), age \(visitor.age) is at the door")
    let greeting = "Hello \(visitor.name)"
    self.view?.setGreeting(greeting: greeting)
  }
  
}

// View

class GreetingViewController: UIViewController, GreetingViewProtocol {
  
  var presenter: GreetingPresenterProtocol?
  let showGreetingButton = UIButton()
  let greetingLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showGreetingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc func didTapButton() {
    self.presenter?.viewDidTapGreetButton()
  }
  
  func setGreeting(greeting: String) {
    self.greetingLabel.text = greeting
  }
  
  // Configure layout
  
}

// Assemble MVP architecture

let model = Visitor(name: "Igor", age: 29)
let view = GreetingViewController()
let presenter = GreetingPresenter(view: view, visitor: model)
view.presenter = presenter

// Test interaction

view.didTapButton()
