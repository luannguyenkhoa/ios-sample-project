public struct ShareClient {
  
  public static func share(content: String, from vc: UIViewController) {
    let activity = UIActivityViewController(activityItems: [content], applicationActivities: nil)
    activity.excludedActivityTypes = [.assignToContact, .print, .copyToPasteboard, .addToReadingList]
    if let wPPC = activity.popoverPresentationController {
      wPPC.sourceView = vc.view
      wPPC.sourceRect = CGRect(x: vc.view.frame.width/2, y: vc.view.frame.height/2, width: 0, height: 0)
      wPPC.permittedArrowDirections = []
    }
    vc.present(activity, animated: true)
  }
}
