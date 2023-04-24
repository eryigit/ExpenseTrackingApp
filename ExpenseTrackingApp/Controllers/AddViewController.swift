
import UIKit

protocol RefreshData {
    func refreshTableView()
}

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var dataReceivedClosure: ((ExpenseDetails) -> Void)?
    var delegate: RefreshData?
    
    var indexPath: IndexPath?
    
    let scrollView = UIScrollView()
    
    lazy var expenseName = AddViewTextFields(placeholder: "Write your expense")
    lazy var expensePrice = AddViewTextFields(placeholder: "How much did you spend ?")
    lazy var expenseDatePicker = ExpenseDatePicker()
    private let doneButton = Buttons(title: "Done")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        navigationController?.navigationBar.tintColor = .black
        self.title = "Add Expense"
        
        scrollView.frame = view.bounds
        // scrollView.contentSize = view.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        expenseDatePicker.locale = Locale(identifier: "en_US")
        
        expensePrice.delegate = self
        expenseName.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        setupUI()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func doneAction() {
        
        if expensePrice.text!.isEmpty || expenseName.text!.isEmpty {
            alertController()
        }else {
            let previousVC = navigationController?.viewControllers[0] as? HomeViewController
            previousVC?.handler()
            let newExpense = ExpenseDetails(expenseName: expenseName.text!, expensePrice: expensePrice.text!, expenseDate: expenseDatePicker.date)
            if let indexPath = indexPath {
                previousVC?.expensesList[indexPath.row] = newExpense
                previousVC?.sumExpense[indexPath.row] = Int(expensePrice.text!)!
                previousVC?.refreshTableView()
                navigationController?.popViewController(animated: true)
            }else {
                dataReceivedClosure?(newExpense)
                delegate?.refreshTableView()
                previousVC?.sumExpense.append(Int(expensePrice.text!)!)
                previousVC?.refreshTableView()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func alertController() {
            let alertController = UIAlertController(title: "Warning", message: "Please fill in the empty fields", preferredStyle: .actionSheet)
            let okayButton = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okayButton)
            present(alertController, animated: true)
        }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expensePrice {
            let allowedCharacterSet = CharacterSet.decimalDigits
            let enteredCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: enteredCharacterSet)
        }else if textField == expenseName {
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }else {
            return true
        }
    }
    
    private func configExpenseName() {
        view.addSubview(expenseName)
        NSLayoutConstraint.activate([
            expenseName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            expenseName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            expenseName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
        ])
    }
    
    private func configExpensePrice() {
        view.addSubview(expensePrice)
        expensePrice.keyboardType = .numberPad
        NSLayoutConstraint.activate([
            expensePrice.topAnchor.constraint(equalTo: expenseName.bottomAnchor, constant: 30),
            expensePrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            expensePrice.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    private func configDatePicker() {
        view.addSubview(expenseDatePicker)
        expenseDatePicker.preferredDatePickerStyle = .wheels
        NSLayoutConstraint.activate([
            expenseDatePicker.topAnchor.constraint(equalTo: expensePrice.bottomAnchor, constant: 40),
            expenseDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configDoneButton() {
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: expenseDatePicker.bottomAnchor, constant: 30),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    private func setupUI() {
        configExpenseName()
        configExpensePrice()
        configDatePicker()
        configDoneButton()
    }
    
}
