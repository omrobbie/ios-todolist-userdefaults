//
//  ViewController.swift
//  ios-todolist-userdefaults
//
//  Created by omrobbie on 29/06/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var items = [String]()
    private let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
        loadData()
    }

    private func setupList() {
        title = "Todo List"
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func saveData() {
        userDefaults.set(self.items, forKey: "items")
    }

    private func loadData() {
        if let array = userDefaults.array(forKey: "items") {
            items = array as! [String]
        }
    }

    @IBAction func btnAddTapped(_ sender: Any) {
        var textField = UITextField()

        let alertVC = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            self.items.append(textField.text!)
            self.tableView.reloadData()
            self.saveData()
        }

        alertVC.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item..."
            textField = alertTextField
        }

        alertVC.addAction(actionCancel)
        alertVC.addAction(actionAdd)

        present(alertVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
}
