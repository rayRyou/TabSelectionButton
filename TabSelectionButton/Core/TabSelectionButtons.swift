//
//  TabSelecitonButtons.swift
//  TabSelectionButton
//
//  Created by Ryou on 2022/06/17.
//

import UIKit
@objc protocol TabSelectionActionDelegate {
    @objc optional func selectedButtonIndex(index:Int, tag:Int)
}
enum SelectorPosition {
    case top
    case bottom
    case left
    case right
    case none
}
class TabSelectionButtons: UIView {
    
    var titleColor:UIColor = UIColor.darkText
    var buttonBackgourndColor:UIColor?
    
    var selectedColor:UIColor?
    var selectedTitleColor:UIColor?
    
    
    var selectorColor:UIColor = UIColor.cyan
    var borderWidth:CGFloat = 10.0
    var selectorPosition:SelectorPosition = .bottom
    var selectorWidth:CGFloat = 80.0
    
    var delegate:TabSelectionActionDelegate?
    var minButtonWidth:CGFloat = 80.0
    var itemCount:Int = 0
    
    
    private var itemArray:[UIButton] = Array()
    private let scrollView:UIScrollView = UIScrollView()
    private var buttonWidth:CGFloat = 80.0
    private let selector:UIView = UIView()
    private var prevSelected:UIButton?
    private(set) var selectedIndex:Int = 0

    init(frame:CGRect, items:[String]) {
        super.init(frame: frame)
        self.scrollView.frame = frame
        self.addSubview(self.scrollView)
        self.addItems(items: items)
        self.scrollView.addSubview(self.selector)
        self.resizeSelector(selectorView: self.selector, position: self.selectorPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func getButtonWidth(width:CGFloat, itemCount:Int,minWidth:CGFloat) -> CGFloat {
        var btnWidth:CGFloat = width
        
        btnWidth = self.frame.width / CGFloat(itemCount)

        
        if minWidth > btnWidth {
            return minWidth
        }
        return btnWidth
    }
    func getLeastButtonPositionX(itemCount:Int, width:CGFloat) -> CGFloat {
        return width * CGFloat(itemCount - 1)
    }
    
    func createButton(title:String) -> UIButton {
        let button = UIButton(frame: .init(x: 0.0, y: 0.0, width: self.buttonWidth, height: self.frame.height))
        button.setTitle(title, for: .normal)
        button.setTitleColor(self.titleColor, for: .normal)
        button.addTarget(self, action: #selector(didTouchButton(_:)), for: .touchUpInside)

        return button
    }
    
    
    func addItem(title:String) {
        self.itemCount = self.itemArray.count + 1
        let button = createButton(title: title)
        self.scrollView.addSubview(button)
        self.itemArray.append(button)
        button.backgroundColor = self.buttonBackgourndColor
        self.scrollView.bringSubviewToFront(self.selector)
        resizeButtons()
        resizeSelector(selectorView: self.selector, position: self.selectorPosition, selectedIndex: self.selectedIndex)
    }
    func addItems(items:[String]) {
        for item in items {
            self.addItem(title: item)
        }
    }
    func removeItem(at index:Int) -> Bool {
        if self.itemCount <= index {
            return false
        }
        let btn = self.itemArray[index]
        btn.removeFromSuperview()
        self.itemArray.remove(at: index)
        self.itemCount = self.itemArray.count
        
        if self.selectedIndex == index{
            if index == 0 {
                self.selectedIndex = 0
            }else{
                self.selectedIndex = index - 1
            }
            if self.itemArray.count > 0 {
                let btn = self.itemArray[self.selectedIndex]
                didChangeSelectedButton(btn: btn, prevBtn: self.prevSelected)
            }
        }

        resizeButtons()
        if self.itemArray.count > 0 {
            resizeSelector(selectorView: self.selector, position: self.selectorPosition, selectedIndex: self.selectedIndex)
        }
        return true
    }
    func removeAll(){
        for button in self.itemArray {
            button.removeFromSuperview()
        }
        self.itemArray.removeAll()
        self.selectedIndex = 0
        self.itemCount = 0
        self.prevSelected = nil
        self.scrollView.contentSize = .zero
    }
    func insertItem(at index:Int, title:String) {
        self.buttonWidth = self.getButtonWidth(width: self.buttonWidth, itemCount: self.itemCount, minWidth: self.minButtonWidth)
        let button = createButton(title: title)
        self.scrollView.addSubview(button)
        self.itemArray.insert(button, at: index)
    }
    func resizeButtons() {
        // buttons re positioning
        var index = 0
        self.buttonWidth = self.getButtonWidth(width: self.buttonWidth, itemCount: self.itemCount, minWidth: self.minButtonWidth)
        for btn in self.itemArray {
            var rect = btn.frame
            rect.origin.x = CGFloat(index) * self.buttonWidth
            rect.size.width = self.buttonWidth
            btn.frame = rect
            btn.tag = index
            index += 1
        }
        
        self.scrollView.contentSize = CGSize(width: self.buttonWidth * CGFloat(self.itemCount), height: self.frame.height)
    }

    
    func resizeSelector(selectorView:UIView, position:SelectorPosition, selectedIndex:Int = 0) {
        let posX:CGFloat = self.buttonWidth * CGFloat(selectedIndex)
        switch position {
        case .top:
            selectorView.frame = .init(x: posX, y: 0.0, width: self.buttonWidth, height: self.borderWidth)
            break
        case .bottom:
            selectorView.frame = .init(x: posX, y: self.frame.height - self.borderWidth, width: self.buttonWidth, height: self.borderWidth)
            break
        case .left:
            selectorView.frame = .init(x: posX, y: 0.0, width: self.borderWidth, height: self.frame.height)
            break
        case .right:

            selectorView.frame = .init(x: posX, y: 0.0, width: self.borderWidth, height: self.frame.height)
            break
        case .none:
            self.selector.frame = .zero
        }
        self.selector.backgroundColor = self.selectorColor
        self.selector.isUserInteractionEnabled = false
    }

    func setScrollBar(isShow:Bool) {
        self.scrollView.showsVerticalScrollIndicator = isShow
        self.scrollView.showsHorizontalScrollIndicator = isShow
    }
    func setPaging(isPaging:Bool) {
        self.scrollView.isPagingEnabled = isPaging
    }
    func setSelected(index:Int) -> Bool{
        if index < self.itemCount {
            self.selectedIndex = index
            self.selectorMoveTo(index: index)
            return true
        }
        return false
    }
    func didChangeSelectedButton(btn: UIButton, prevBtn:UIButton?){
        if btn != prevBtn {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                btn.backgroundColor = self.selectedColor
                btn.setTitleColor(self.selectedTitleColor ?? .darkText, for: .normal)
                
                prevBtn?.backgroundColor = self.buttonBackgourndColor
                prevBtn?.setTitleColor(self.titleColor, for: .normal)
            }, completion: nil)
        }
        self.prevSelected = btn
    }
    func selectorMoveTo(index:Int) {
        var rect = self.selector.frame
        rect.origin.x = self.buttonWidth * CGFloat(index)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.selector.frame = rect
        }, completion: nil)
    }
    func showsSelector(isShow:Bool){
        self.selector.isHidden = isShow
    }
    
    @objc func didTouchButton(_ btn:UIButton) {
        let selected = self.itemArray.firstIndex(of: btn) ?? 0
        _ = self.setSelected(index: selected)
        self.didChangeSelectedButton(btn: btn, prevBtn: self.prevSelected)
        self.delegate?.selectedButtonIndex?(index: selected, tag: btn.tag)
    }
}

