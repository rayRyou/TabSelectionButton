//
//  ViewController.swift
//  TabSelectionButton
//
//  Created by Ryou on 2022/06/17.
//

import UIKit

class ViewController: UIViewController, TabSelectionActionDelegate {

    var selectionButtons:TabSelectionButtons!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let selectionBar = TabSelectionButtons(frame: CGRect(x: 0.0, y: 30.0, width: self.view.frame.width, height: 60.0), items: ["test1"])
        self.view.addSubview(selectionBar)
        selectionBar.delegate = self
        self.selectionButtons = selectionBar
        self.selectionButtons.buttonBackgourndColor = UIColor.white
//        self.selectionButtons.selectedColor = UIColor.red
//        self.selectionButtons.selectedTitleColor = .white
        self.selectionButtons.titleColor = .darkText
        self.selectionButtons.setScrollBar(isShow: false)
        
        let addButton = UIButton()
        addButton.frame = .init(x: 10.0, y: 130.0, width: 100.0, height: 40.0)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.darkText, for: .normal)
        addButton.addTarget(self, action: #selector(didTouchAdd), for: .touchUpInside)
        addButton.backgroundColor = UIColor.red
        self.view.addSubview(addButton)
        
        let removeButton = UIButton()
        removeButton.frame = .init(x: 110.0, y: 130.0, width: 100.0, height: 40.0)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(.darkText, for: .normal)
        removeButton.addTarget(self, action: #selector(didTouchRemove), for: .touchUpInside)
        self.view.addSubview(removeButton)
    }

    @objc func didTouchAdd() {
        self.selectionButtons.addItem(title: String(format: "add %d", self.selectionButtons.itemCount))
    }
    @objc func didTouchRemove() {
        let index = self.selectionButtons.selectedIndex
        _ = self.selectionButtons.removeItem(at: index)
    }
}

