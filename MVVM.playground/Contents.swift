import UIKit

// Model

struct Visitor {
  let name: String
  let age: Int
  let photo: UIImage?
}

// ViewModel Protocol

protocol VisitorsDisplayViewModelProtocol: AnyObject {
  var name: String? { get }
  var age: Int? { get }
  var photo: UIImage? { get }
  
  var displayNewCustomersInformation: ((VisitorsDisplayViewModelProtocol) -> ())? { get set }
  
  init(visitor: Visitor)
  func newCustomerArrived(visitor: Visitor)
}

// ViewModel Implementation

class VisitorsDisplayViewModelImplementation: VisitorsDisplayViewModelProtocol {
  
  var currentVisitor: Visitor {
    didSet {
      self.name = self.currentVisitor.name
      self.age = self.currentVisitor.age
      self.photo = self.currentVisitor.photo
      self.displayNewCustomersInformation?(self)
    }
  }
  
  var name: String?
  var age: Int?
  var photo: UIImage?
  
  var displayNewCustomersInformation: ((VisitorsDisplayViewModelProtocol) -> ())?
  
  required init(visitor: Visitor) {
    self.currentVisitor = visitor
  }
  
  func newCustomerArrived(visitor: Visitor) {
    self.currentVisitor = visitor
  }
  
}

// View

class VisitorsDisplayViewController: UIViewController {
  
  var viewModel: VisitorsDisplayViewModelProtocol! {
    didSet {
      self.viewModel.displayNewCustomersInformation = { [weak self] viewModel in
        self?.nameLabel.text = viewModel.name
        let ageString = String(viewModel.age ?? 0)
        self?.ageLabel.text = ageString
        self?.photoImageView.image = viewModel.photo
        print("\(self?.nameLabel.text ?? ""), \(self?.ageLabel.text ?? "")")
      }
    }
  }
  
  let nameLabel = UILabel()
  let ageLabel = UILabel()
  let photoImageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Configure view layout
  }
  
}

// Assemble MVVM

let model = Visitor(name: "Igor", age: 29, photo: nil)
let viewModel = VisitorsDisplayViewModelImplementation(visitor: model)
let view = VisitorsDisplayViewController()
view.viewModel = viewModel

viewModel.newCustomerArrived(visitor: model)
