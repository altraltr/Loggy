//
//  LoggyViewController.swift
//  Loggy
//
//  Created by V on 27.11.2023.
//

import UIKit

public class LoggyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let logTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Copy whole log", for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    private let logEntries: [Logx]

    public init(_ log: String) {
        if let logData = log.data(using: .utf8),
           let logArray = try? JSONDecoder().decode([Logx].self, from: logData) {
            self.logEntries = logArray
        } else {
            self.logEntries = []
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

        logTableView.dataSource = self
        logTableView.delegate = self
        logTableView.register(LogTableViewCell.self, forCellReuseIdentifier: "LogCell")
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(logTableView)
        view.addSubview(copyButton)
        view.addSubview(dismissButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            logTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            copyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            copyButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),

            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
        ])
    }

    @objc private func copyButtonTapped() {
        // You may want to copy the selected log entry instead of the entire log
        UIPasteboard.general.string = "\(logEntries)"
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logEntries.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogTableViewCell
        let logEntry = logEntries[indexPath.row]
        cell.configure(with: logEntry)
        return cell
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection if needed
        tableView.deselectRow(at: indexPath, animated: true)
        UIPasteboard.general.string = "\(logEntries[indexPath.row])"
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the height based on the content of the cell
        let logEntry = logEntries[indexPath.row]
        let titleHeight = heightForLabel(text: logEntry.text, font: UIFont.boldSystemFont(ofSize: 16), width: tableView.bounds.width - 20)
        let detailHeight = heightForLabel(text: "Types: \(logEntry.types.map { $0.rawValue }.joined(separator: ", "))", font: UIFont.systemFont(ofSize: 14), width: tableView.bounds.width - 20)

        return titleHeight + detailHeight + 30 // Add some padding between title and detail labels
    }

    private func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
