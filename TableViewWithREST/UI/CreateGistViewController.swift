//
//  CreateGistViewController.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-09-21.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import XLForm

class CreateGistViewController: XLFormViewController {
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.initForm()
    }

    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initForm()
    }

    func initForm() {
        let form = XLFormDescriptor(title: "Gist")
        let section1 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
        form.addFormSection(section1)

        let descriptionRow = XLFormRowDescriptor(tag: "description", rowType:
            XLFormRowDescriptorTypeText, title: "Description")
        descriptionRow.isRequired = true
        section1.addFormRow(descriptionRow)

        let isPublicRow = XLFormRowDescriptor(tag: "isPublic", rowType:
            XLFormRowDescriptorTypeBooleanSwitch, title: "Public?")
        isPublicRow.isRequired = false
        section1.addFormRow(isPublicRow)

        let section2 = XLFormSectionDescriptor.formSection(withTitle: "File 1") as
        XLFormSectionDescriptor
        form.addFormSection(section2)

        let filenameRow = XLFormRowDescriptor(tag: "filename", rowType:
            XLFormRowDescriptorTypeText, title: "Filename")
        filenameRow.isRequired = true
        section2.addFormRow(filenameRow)
        let fileContent = XLFormRowDescriptor(tag: "fileContent", rowType:
            XLFormRowDescriptorTypeTextView, title: "File Content")
        fileContent.isRequired = true
        section2.addFormRow(fileContent)
        self.form = form
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed(_:)))
    }

    @objc
    func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    fileprivate func isPublic() -> Bool {
        if let isPublicValue = self.form.formRow(withTag: "isPublic")?.value as? Bool {
            return isPublicValue
        }
        return false
    }

    @objc
    func savePressed(_ sender: UIBarButtonItem) {
        let validationErrors = self.formValidationErrors() as? [Error]
        guard validationErrors?.count == 0 else {
            self.showFormValidationError(validationErrors!.first)
            return
        }
        tableView.endEditing(true)

        guard let gistDescription = self.form.formRow(withTag: "description")?.value as? String,
            let filename = self.form.formRow(withTag: "filename")?.value as? String,
            let fileContent = self.form.formRow(withTag: "fileContent")?.value as? String else {
                return
        }

        var files = [String:File]()
        let file = File(filename: filename, url: nil, content: fileContent)
        files[filename] = file

        let gist = Gist(gistDescription: gistDescription, files: files, isPublic: isPublic())

        GitHubAPIManager.shared.creaateGist(gist: gist) { (response) in
            switch response {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure:
                let alertController = UIAlertController(title: "Couldn't create Gist", message: "helpful error message", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            }
        }
    }
}
