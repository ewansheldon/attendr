import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth


class ChatViewController: JSQMessagesViewController {
    
    var myID:String!
    var theirID:String!
    var theirName:String!
    var messages = [JSQMessage]()
    var messageRef = FIRDatabase.database().reference().child("messages")



    override func viewDidLoad() {
        super.viewDidLoad()
        self.topContentAdditionalInset = 60
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:60)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.white
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = theirName
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Back", style:   .plain, target: self, action: #selector(self.btn_clicked(_:)))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        self.senderId = myID
        self.senderDisplayName = ""
        observeMessages()
    }
    
    func btn_clicked(_ sender: UIBarButtonItem) {
        // Instantiate SecondViewController
        let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        
        // Take user to SecondViewController

        TabBarController.selectedIndex = 1
        self.present(TabBarController, animated: true)
    }
    
    func observeMessages() {
        messageRef.child(myID).child(theirID).observe(FIRDataEventType.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                let text = dict["text"] as! String
                self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                self.collectionView.reloadData()
            }
            
            
        })
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let newMessage = messageRef.child("\(myID!)").child("\(theirID!)").childByAutoId()
        let theirMessage = messageRef.child("\(theirID ?? "")").child("\(myID!)").childByAutoId()
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName] as NSDictionary
        
        newMessage.setValue(messageData)
        theirMessage.setValue(messageData)
        self.finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource{
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if message.senderId == self.senderId {
            return bubbleFactory!.outgoingMessagesBubbleImage(with: UIColor(red:0.79, green:0.60, blue:0.60, alpha:1.0))
        } else {
            return bubbleFactory!.incomingMessagesBubbleImage(with: UIColor(red:0.56, green:0.65, blue:0.80, alpha:1.0))
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items:\(messages.count)")
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView,  cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
}

