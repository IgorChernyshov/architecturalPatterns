import UIKit

// Entity. Simple data structure that does nothing.

struct Visitor {
  let name: String
  let age: Int
}

// Transport data structure (not Entity).

struct GreetingData {
  let greeting: String
  let subject: String
}

// Protocols.

protocol GreetingProvider {
  func provideGreetingData()
}

protocol GreetingOutput: AnyObject {
  func receiveGreetingData(greetingData: GreetingData)
}

protocol GreetingViewEventHandler {
  func didTapShowGreetingButton()
}

protocol GreetingView: AnyObject {
  func setGreeting(greeting: String)
}

// Interactor.

class GreetingInteractor: GreetingProvider {
  
  weak var output: GreetingOutput!
  
  func provideGreetingData() {
    let visitor = Visitor(name: "Igor", age: 29)
    let subject = visitor.name
    let greetingData = GreetingData(greeting: "Hello", subject: subject)
    self.output.receiveGreetingData(greetingData: greetingData)
  }
  
}

// Presenter

class GreetingPresenter: GreetingOutput, GreetingViewEventHandler {
  
  weak var view: GreetingView!
  var greetingProvider: GreetingProvider!
  
  func receiveGreetingData(greetingData: GreetingData) {
    let greeting = "\(greetingData.greeting) \(greetingData.subject)"
    self.view.setGreeting(greeting: greeting)
  }
  
  func didTapShowGreetingButton() {
    self.greetingProvider.provideGreetingData()
  }
  
}

// View

class GreetingViewController: UIViewController, GreetingView {
  
  var eventHandler: GreetingViewEventHandler!
  let showGreetingButton = UIButton()
  let greetingLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showGreetingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc func didTapButton() {
    self.eventHandler.didTapShowGreetingButton()
  }
  
  func setGreeting(greeting: String) {
    self.greetingLabel.text = greeting
    print(greeting)
  }
  
  // Layout code goes below
  
}

// Assemble VIPER module without Router

let view = GreetingViewController()
let presenter = GreetingPresenter()
let interactor = GreetingInteractor()

view.eventHandler = presenter
presenter.view = view
presenter.greetingProvider = interactor
interactor.output = presenter

// Test Greeting

view.didTapButton()
