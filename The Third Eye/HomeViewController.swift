import UIKit
import Vision
import VisionKit
import AVKit
import Speech

class HomeViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    private var scanText = ScanText(frame: .zero)
    private var saveText = SaveImagesButton(frame: .zero)
    private var searchMenus = SearchMenusByVoice(frame: .zero)
    private var scanImageView = ScanImageView(frame: .zero)
    private var ocrTextView = OcrTextView(frame: .zero, textContainer: nil)
    private var invisibleTextView = UITextView(frame: .zero, textContainer: nil)
    private var clearButton = ClearButton(frame: .zero)
    private var updateButton = UpdateButton(frame: .zero)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    private var ocrText = ""
    fileprivate var tf: UITextField?
    fileprivate var updatetf: UITextField?
    private var alertController : UIAlertController?
    private var updateAlertController : UIAlertController?
    private var searchViewController:SearchViewController?
    private var defaults = UserDefaults.standard
    private var screenWidth = UIScreen.main.bounds.size.width
    private var screenHeight = UIScreen.main.bounds.size.height

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 170, y: 95)
            label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        
        
            label.text = "THE THIRD EYE"
        

            self.view.addSubview(label)
        
        
        
        //UITextView scanTextView = 
        //view.insertSubview(scanText, belowSubview: label);
        //view.insertSubview(searchMenus  , belowSubview: scanText);
        
        configure()
        configureOCR()
        configureOnlyOcr()
       // configureOnlyInvisibleTextView()
       
        
    }
   

    
    private func configure() {
       
        
       
        view.addSubview(searchMenus)
        view.addSubview(scanText)
        view.addSubview(saveText)
        view.addSubview(clearButton)
        view.addSubview(updateButton)
        
        
        
        let padding: CGFloat = 0.05 * screenWidth
        let spacing : CGFloat = 0.51 * screenWidth
        let bottomspacingforb2 : CGFloat = 0.065 * screenHeight
        let bottomspacingfort2 : CGFloat = 0.01 * screenHeight
        let spacingForUpdate : CGFloat = 0.05 * screenWidth
        
        NSLayoutConstraint.activate([
            
            updateButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacingForUpdate),
            updateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacingForUpdate),
            updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            updateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.85 * screenHeight)),
           
            
            scanText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            scanText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomspacingforb2),
            scanText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.785 * screenHeight)),
            
            saveText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            saveText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            saveText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomspacingforb2),
            saveText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.785 * screenHeight)),
            
            searchMenus.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            searchMenus.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            searchMenus.bottomAnchor.constraint(equalTo: saveText.topAnchor, constant: -bottomspacingfort2),
            searchMenus.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.725 * screenHeight)),
            
            clearButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            clearButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            clearButton.bottomAnchor.constraint(equalTo: scanText.topAnchor, constant: -bottomspacingfort2),
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.725 * screenHeight)),

           
          
            
            
            
        ])
        
        scanText.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
       searchMenus.addTarget(self, action: #selector(onSelectSearchMenus), for: .touchUpInside)
      clearButton.addTarget(self, action: #selector(clearMenuText), for: .touchUpInside)
       
        
       
        
        alertController = UIAlertController(title: "Save Menu", message: "Restaurant name to save menu ", preferredStyle: .alert)
        
        alertController?.addAction(UIAlertAction(title: "Save", style: .default, handler: saveMenu))
        alertController?.addTextField(configurationHandler: { (textField) in
            self.tf = textField
            
            
            
            
        
            
        
        })
        updateAlertController = UIAlertController(title: "Update Message", message: "Restaurant name to update menu", preferredStyle: .alert)
        
        updateAlertController?.addAction(UIAlertAction(title: "Update", style: .default, handler: updateMenu))
        updateAlertController?.addTextField(configurationHandler:{(textfield) in self.updatetf = textfield
            
            
        })
        
        
    }
    
    private func configureOnlyOcr() {
        view.addSubview(ocrTextView)
        NSLayoutConstraint.activate([
            ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.1 * screenWidth),
            ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(0.1 * screenWidth)),
            ocrTextView.bottomAnchor.constraint(equalTo: searchMenus.topAnchor, constant: -(screenHeight * 0.05)),
        ocrTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:(0.10 * screenHeight)),
        ])
    }
   
    
    
    private func configureOnlySaveButton() {
        view.addSubview(saveText)
        NSLayoutConstraint.activate([
        saveText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        saveText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        saveText.bottomAnchor.constraint(equalTo: scanText.topAnchor, constant: -20),
        saveText.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
    }


    @objc private func scanDocument() {
        configure()
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
        scanText.setTitle("Add To Menu", for: .normal)
        saveText.addTarget(self, action: #selector(showSaveUI), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(showUpdateUI), for: .touchUpInside)
        
        
        
        
        
        
    }
    @objc private func saveHistoryTextView()
    {
        if ocrTextView.text?.count != nil
        {
            let defaults = UserDefaults.standard
            defaults.set(ocrTextView.text!, forKey: "combos")
        }
    }
    @objc private func displaySavedHistory()
    {
        let defaults = UserDefaults.standard
        if let savedCombos = defaults.string(forKey: "combos")
        {
            ocrTextView.text = savedCombos
        }
    }
    
    @objc private func showSaveUI(){
        present(alertController!, animated: true)
    }
    
    @objc private func showUpdateUI(){
        present(searchViewController!, animated: true)
    }
    
    @objc private func clearMenuText(){
        ocrTextView.text = ""
    }
    
    @objc private func onSelectSearchMenus(){
        let searchVC = SearchViewController()
        searchVC.setParentVC(vc: self)
        let navVC = UINavigationController(rootViewController: searchVC)
        present(navVC, animated: true)
        navVC.modalPresentationStyle = .fullScreen

    }
    
    private var strDelimiter:String = String("!@!@")
    
    private func saveMenu(action : UIAlertAction){
        var restName:String = (self.tf?.text)!
        var restMenu:String = ocrTextView.text
       
        let dict = UserDefaults.standard.dictionaryRepresentation()
        var arrayOfMenus : Array<String> = Array() as Array<String>
        
        if(dict["Menus"] != nil)
        {
            arrayOfMenus = dict["Menus"] as! Array<String>
        }
        
        arrayOfMenus.append(restName + strDelimiter + restMenu)

        UserDefaults.standard.set(arrayOfMenus, forKey: "Menus")
        
    }
    
    private func updateMenu(action : UIAlertAction){
        print("Button Pressed")
        
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        ocrTextView.text = ""
        scanText.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }

    
    
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                self.ocrText += topCandidate.string + "\n"
                
            }
            
            
            DispatchQueue.main.async {
                self.ocrTextView.text = self.ocrText
                self.scanText.isEnabled = true
                
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
        ocrTextView.isEditable = false
        
        
    }
    
    public func setMenuText(restMenu: String)
    {
        ocrTextView.text = restMenu
    }

}

class ResultsVC: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .none
    }
}


class SearchViewController : UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        
        
        print(text)
    }
    
    let defaults = UserDefaults.standard.dictionaryRepresentation()
    let searchController = UISearchController(searchResultsController: ResultsVC())
    private var testlabel : UILabel?
    private var restaurantMenuButtons = RestaurantMenuButtons(frame: .zero)
    private var strDelimiter:String = String("!@!@")
    weak var parentVC: HomeViewController?
    
    public func setParentVC(vc: HomeViewController)
    {
        parentVC = vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Search Existing Menus"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
       navigationItem.searchController = searchController
        
    
        if(defaults["Menus"] != nil){
        
        let menuList:Array <String> = defaults["Menus"] as! Array<String>
            var changingHeight = 100
        if(menuList != nil){
            for menu in menuList{
                let components = menu.components(separatedBy:strDelimiter)
                print(components[0])
                //buttob.center = CGPoint(x: 170, y: 95)
                let button = UIButton(frame: CGRect(x: 100, y: changingHeight, width: 200, height: 60))
                changingHeight += 80
                button.setTitle(components[0], for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor.systemIndigo
                self.view.addSubview(button)
                button.addTarget(self, action: #selector(onMenuSelected), for: .touchUpInside)

                    
                    }
            }
        }
        
    }
    
    @objc private func onMenuSelected(btn: UIButton){
        print(btn.titleLabel?.text)
        let defaults = UserDefaults.standard.dictionaryRepresentation()
        let menuList:Array <String> = defaults["Menus"] as! Array<String>
        
        if(menuList != nil){
            for menu in menuList{
                let components = menu.components(separatedBy:strDelimiter)
                if(components[0] == btn.titleLabel?.text)
                {
                    parentVC?.setMenuText(restMenu: components[1])
                    break
                }
            }
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    

    
}
 


        
        
        
extension HomeViewController {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        scanImageView.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)
        
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}




