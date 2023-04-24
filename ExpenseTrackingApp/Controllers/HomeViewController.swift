
import UIKit

class HomeViewController: UIViewController, RefreshData {
    
    var expensesList = [ExpenseDetails]()
    var sumExpense = [Int]()
    var resultExpense = Int()

    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let addButton = Buttons(title: "Add")
    var totalPrice = TitleLabel(title: "Total Expense: $ 0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Expense Tracking"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sumExpenses()
    }
    
    private func sumExpenses() {
        var total = 0
        for expense in sumExpense {
            total += expense
        }
        resultExpense = total
        totalPrice.text = "Total Expense: $ \(resultExpense)"
    }
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
    @objc func addExpense() {
        let addViewController = AddViewController()
        addViewController.title = "Add Page"
        navigationController?.pushViewController(addViewController, animated: true)
    }
    
    func handler(){
        let nextVC = navigationController?.viewControllers[1] as? AddViewController
        nextVC?.dataReceivedClosure = { [self] data in
            expensesList.append(ExpenseDetails(expenseName: data.expenseName, expensePrice: data.expensePrice, expenseDate: data.expenseDate))
        }
    }
    
   private func configAddButton() {
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addExpense), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemOrange
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -50)
        ])
    }
    
    private func configTotalPrice() {
        view.addSubview(totalPrice)
        NSLayoutConstraint.activate([
            totalPrice.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            totalPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupUI() {
        configAddButton()
        configTableView()
        configTotalPrice()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesList.count
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier)! as! ExpenseTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        
        cell.contentView.backgroundColor = .systemOrange
        cell.textLabel?.text = expensesList[indexPath.row].expenseName
        cell.detailTextLabel?.text = dateFormatter.string(from: expensesList[indexPath.row].expenseDate!)
        cell.priceLabel.text = "$ \(expensesList[indexPath.row].expensePrice)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, compHandler in
            compHandler(true)
            expensesList.remove(at: indexPath.row)
            sumExpense.remove(at: indexPath.row)
            sumExpenses()
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = AddViewController()
        nextVC.expensePrice.text = String(expensesList[indexPath.row].expensePrice)
        nextVC.expenseName.text = expensesList[indexPath.row].expenseName
        nextVC.indexPath = indexPath
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
