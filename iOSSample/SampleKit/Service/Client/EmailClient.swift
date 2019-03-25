import MessageUI
import UIKit

public class EmailClient: UIViewController {
  
  private var completion: ((Bool) -> Void)?
  
  public func send(content: (subject: String, body: String?), data: (dt: Data, type: String, name: String)? = nil, recipient: [String], from vc: UIViewController, completion: @escaping (Bool) -> Void) {
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients(recipient)
      mail.setSubject(content.subject)
      if let body = content.body {
        mail.setMessageBody(body, isHTML: false)
      }
      if let data = data {
        mail.addAttachmentData(data.dt, mimeType: data.type, fileName: data.name)
      }
      
      self.completion = completion
      vc.present(mail, animated: true)
    } else {
      completion(false)
    }
  }
}

extension EmailClient: MFMailComposeViewControllerDelegate {
  
  public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true) { [weak self] in
      self?.completion?(true)
    }
  }
}
