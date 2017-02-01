//
//  PickerView.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

protocol PickerViewDelegate {
    
    /// Use this delegate method to get the value chosen on picker
    ///
    /// - Parameter value: The value chosen
    func pickerView(value: String)
    
    /// Use this delegate method to dismiss the picker
    func prickerViewDismiss()
}

fileprivate struct Texts {
    static let done = "Ok"
    static let cancel = "Cancelar"
}

fileprivate struct ToolBar {
    
    static let height: CGFloat = 44
    
    struct Button {
        static let doneTitle = Texts.done
        static let cancelTitle = Texts.cancel
    }
}

fileprivate struct Colors {
    static let red = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    static let dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

class PickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Properties
    fileprivate var options = [String]()
    fileprivate var doneButton = UIBarButtonItem()
    fileprivate var cancelButton = UIBarButtonItem()
    fileprivate let numberOfComponents: Int = 1
    fileprivate let rowHeightForComponent: CGFloat = 35
    fileprivate let widthForComponent: CGFloat = 200
    fileprivate let pickerHeight: CGFloat = 162
    
    var delegate: PickerViewDelegate?
    var picker = UIPickerView()
    
    // MARK: - Actions
    init(options: [String], delegate: AnyObject, image: UIImage? = nil) {
        
        let width: CGFloat = delegate.view??.frame.size.width ?? delegate.contentView?.frame.size.width ?? 0
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: pickerHeight+ToolBar.height))
        
        self.options = options
        self.delegate = delegate as? PickerViewDelegate
        
        picker.frame = CGRect(x: 0, y: ToolBar.height, width: self.frame.size.width, height: pickerHeight)
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: ToolBar.height))
        toolbar.isTranslucent = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        cancelButton = UIBarButtonItem(title: ToolBar.Button.cancelTitle, style: .plain, target: self, action: #selector(cancel))
        cancelButton.tintColor = Colors.red
        cancelButton.setTitleTextAttributes([NSFontAttributeName: Font.defaultBold(size: Font.Size.regular)!], for: .normal)
        
        doneButton = UIBarButtonItem(title: ToolBar.Button.doneTitle, style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = Colors.dark
        doneButton.setTitleTextAttributes([NSFontAttributeName: Font.defaultBold(size: Font.Size.regular)!], for: .normal)
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addBlurEffect()
        
        DispatchQueue.main.async {
            self.addSubview(imageView)
            self.addSubview(toolbar)
            self.addSubview(self.picker)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @objc fileprivate func done() {
        delegate?.pickerView(value: options[picker.selectedRow(inComponent: 0)])
    }
    
    @objc fileprivate func cancel() {
        delegate?.prickerViewDismiss()
    }
    
    // MARK: - PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if view == nil {  // if no label there yet
            pickerLabel = UILabel()
            // color the label's background
            pickerLabel?.backgroundColor = Colors.dark
        }
        
        let titleData = options[row]
        let title = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: Font.defaultMedium(size: Font.Size.small)!, NSForegroundColorAttributeName: UIColor.white])
        
        pickerLabel?.attributedText = title
        pickerLabel?.textAlignment = .center
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeightForComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return widthForComponent
    }
}
