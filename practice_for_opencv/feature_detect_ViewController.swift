//
//  feature_detect_viewcontroller.swift
//  practice_for_opencv
//
//  Created by 黃麒安 on 2019/7/1.
//  Copyright © 2019 黃麒安. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class feature_detect_ViewController: UIViewController {
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    
    @IBAction func btn_no_algorithm(_ sender: Any) {
        self.algorithmtype = 0
        setPreviewImage()
    }
    @IBAction func btn_algorithm1(_ sender: Any) {
        self.algorithmtype = 1
        setPreviewImage()
    }
    @IBAction func btn_algorithm2(_ sender: Any) {
        self.algorithmtype = 2
        setPreviewImage()
        
    }
    
    @IBOutlet weak var imageview: UIImageView!{
        didSet{
            self.imageview.layer.borderWidth = 1.0
//            self.imageview.alpha = 0.5
        }
    }
    
    @IBOutlet weak var imageview_background: UIImageView!
    
    @IBOutlet weak var btn_upload: UIButton!
    var previewImage = UIImage()
    
    
    var videoURL: NSURL?
    var selectedImageFromPicker: UIImage?
    var thresholdtype: Int = 0
    var algorithmtype: Int = 0
    var colormaptype: Int = 0
    
    private var optionsTableView: UITableView? = nil
    private var colormapTableView: UITableView? = nil
    var options: [Option] = [.THRESH_BINARY,.THRESH_BINARY_INV,.THRESH_TRUNC,.THRESH_TOZERO,.THRESH_TOZERO_INV,.THRESH_MASK]
    var colormaptypes: [ColormapTypes] = [.COLORMAP_AUTUMN , .COLORMAP_BONE, .COLORMAP_JET, .COLORMAP_WINTER, .COLORMAP_RAINBOW, .COLORMAP_OCEAN, .COLORMAP_SUMMER, .COLORMAP_SPRING, .COLORMAP_COOL, .COLORMAP_HSV, .COLORMAP_PINK, .COLORMAP_HOT, .COLORMAP_PARULA, .COLORMAP_MAGMA, .COLORMAP_INFERNO, .COLORMAP_PLASMA, .COLORMAP_VIRIDIS, .COLORMAP_CIVIDIS, .COLORMAP_TWILIGHT, .COLORMAP_TWILIGHT_SHIFTED]

    
    enum Option {
        case THRESH_BINARY
        case THRESH_BINARY_INV
        case THRESH_TRUNC
        case THRESH_TOZERO
        case THRESH_TOZERO_INV
        case THRESH_MASK
        
        var label: String {
            switch self {
            case .THRESH_BINARY: return "THRESH_BINARY"
            case .THRESH_BINARY_INV: return "THRESH_BINARY_INV"
            case .THRESH_TRUNC: return "THRESH_TRUNC"
            case .THRESH_TOZERO: return "THRESH_TOZERO"
            case .THRESH_TOZERO_INV: return "THRESH_TOZERO_INV"
            case .THRESH_MASK: return "THRESH_MASK"
            }
        }
    }
    
    enum ColormapTypes {
        case COLORMAP_AUTUMN
        case COLORMAP_BONE
        case COLORMAP_JET
        case COLORMAP_WINTER
        case COLORMAP_RAINBOW
        case COLORMAP_OCEAN
        case COLORMAP_SUMMER
        case COLORMAP_SPRING
        case COLORMAP_COOL
        case COLORMAP_HSV
        case COLORMAP_PINK
        case COLORMAP_HOT
        case COLORMAP_PARULA
        case COLORMAP_MAGMA
        case COLORMAP_INFERNO
        case COLORMAP_PLASMA
        case COLORMAP_VIRIDIS
        case COLORMAP_CIVIDIS
        case COLORMAP_TWILIGHT
        case COLORMAP_TWILIGHT_SHIFTED
        
        var label: String {
            switch self {
            case .COLORMAP_AUTUMN: return "COLORMAP_AUTUMN"
            case .COLORMAP_BONE: return "COLORMAP_BONE"
            case .COLORMAP_JET: return "COLORMAP_JET"
            case .COLORMAP_WINTER: return "COLORMAP_WINTER"
            case .COLORMAP_RAINBOW: return "COLORMAP_RAINBOW"
            case .COLORMAP_OCEAN: return "COLORMAP_OCEAN"
            case .COLORMAP_SUMMER: return "COLORMAP_SUMMER"
            case .COLORMAP_SPRING: return "COLORMAP_SPRING"
            case .COLORMAP_COOL: return "COLORMAP_COOL"
            case .COLORMAP_HSV: return "COLORMAP_HSV"
            case .COLORMAP_PINK: return "COLORMAP_PINK"
            case .COLORMAP_HOT: return "COLORMAP_HOT"
            case .COLORMAP_PARULA: return "COLORMAP_PARULA"
            case .COLORMAP_MAGMA: return "COLORMAP_MAGMA"
            case .COLORMAP_INFERNO: return "COLORMAP_INFERNO"
            case .COLORMAP_PLASMA: return "COLORMAP_PLASMA"
            case .COLORMAP_VIRIDIS: return "COLORMAP_VIRIDIS"
            case .COLORMAP_CIVIDIS: return "COLORMAP_CIVIDIS"
            case .COLORMAP_TWILIGHT: return "COLORMAP_TWILIGHT"
            case .COLORMAP_TWILIGHT_SHIFTED: return "COLORMAP_TWILIGHT_SHIFTED"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        /*
        if let optionsTableView = self.optionsTableView {
            optionsTableView.removeFromSuperview()
            self.optionsTableView = nil
            return
        }
        
        let optionsTableView = UITableView()
        optionsTableView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.optionsTableView = optionsTableView
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 40))
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: sender as! UIView,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: sender,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 5))
        
        self.view.addSubview(optionsTableView)
        constraints.forEach { $0.isActive = true }
        
        let constraint = NSLayoutConstraint(item: optionsTableView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .height,
                                            multiplier: 1,
                                            constant: 220)
        constraint.isActive = true
        */
    }
    
    @IBAction func colormapsButtonTapped(_ sender: Any) {
        /*
        if let colormapTableView = self.colormapTableView {
            colormapTableView.removeFromSuperview()
            self.colormapTableView = nil
            return
        }
        
        let colormapTableView = UITableView()
        colormapTableView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        colormapTableView.delegate = self
        colormapTableView.dataSource = self
        
        colormapTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.colormapTableView = colormapTableView
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: colormapTableView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 15))
        
        constraints.append(NSLayoutConstraint(item: colormapTableView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 15))
        
        constraints.append(NSLayoutConstraint(item: colormapTableView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: sender,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 5))
        
        self.view.addSubview(colormapTableView)
        constraints.forEach { $0.isActive = true }
        
        let constraint = NSLayoutConstraint(item: colormapTableView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .height,
                                            multiplier: 1,
                                            constant: 220)
        constraint.isActive = true
        */
    }
    
    
    
    @IBAction func value_change_by_slider1(_ sender: Any) {
        setPreviewImage()
    }
    
    @IBAction func value_change_by_slider2(_ sender: Any) {
        setPreviewImage()
    }

    @IBAction func Upload_Image(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        print(imagePickerController.mediaTypes)
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
extension feature_detect_ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //UIImagePickerController.InfoKey
        
        if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            let player = AVPlayer(url: videoURL as URL)

            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }

        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            imageview.image = pickedImage
            previewImage = pickedImage
            setPreviewImage()

        }
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @objc func setPreviewImage(){
        
        let image = ImageConverter.getdetectedImage(previewImage, threshold1: self.slider1.value, threshold2: self.slider2.value)
        
        imageview.image = image
    }
    
    
    
    
    
    
    
}

extension feature_detect_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if optionsTableView != nil {
            return 1
        }
        if colormapTableView != nil {
            return 1
        }
        
        return 0
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionsTableView != nil {
            return options.count
        }else if colormapTableView != nil{
            return colormaptypes.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if optionsTableView != nil {
            return 40.0;
        }else if colormapTableView != nil{
            return 40.0;
        }
        
        return 44.0;
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.optionsTableView{
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell?.backgroundView = nil
                cell?.backgroundColor = .clear
                cell?.textLabel?.textColor = .white
            }
            cell?.textLabel?.text = self.options[indexPath.row].label
            
            return cell!
        }else if tableView == self.colormapTableView{
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell?.backgroundView = nil
                cell?.backgroundColor = .clear
                cell?.textLabel?.textColor = .white
            }
            cell?.textLabel?.text = self.colormaptypes[indexPath.row].label
            
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell?.backgroundView = nil
                cell?.backgroundColor = .clear
                cell?.textLabel?.textColor = .white
            }
            cell?.textLabel?.text = "unexpected result"
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.optionsTableView{
            if optionsTableView != nil {
                tableView.deselectRow(at: indexPath, animated: true)
                
                optionsTableView?.removeFromSuperview()
                self.optionsTableView = nil
                
                self.optionTapped(self.options[indexPath.row])
            }
        }else if tableView == self.colormapTableView{
            if colormapTableView != nil {
                tableView.deselectRow(at: indexPath, animated: true)
                
                colormapTableView?.removeFromSuperview()
                self.colormapTableView = nil
                
                self.colormapTapped(self.colormaptypes[indexPath.row])
            }
        }else{
            
        }
        
        
    }
    
    func optionTapped(_ option: Option) {
        switch option {
        case .THRESH_BINARY:
            self.thresholdtype = 0
            break
        case .THRESH_BINARY_INV:
            self.thresholdtype = 1
            break
        case .THRESH_TRUNC:
            self.thresholdtype = 2
            break
        case .THRESH_TOZERO:
            self.thresholdtype = 3
            break
        case .THRESH_TOZERO_INV:
            self.thresholdtype = 4
            break
        case .THRESH_MASK:
            self.thresholdtype = 7
            break
        default:
            self.thresholdtype = 0
            break
        }
        setPreviewImage()
    }
    
    func colormapTapped(_ colormaptype: ColormapTypes) {
        switch colormaptype {
        case .COLORMAP_AUTUMN:
            self.colormaptype = 0
            break
        case .COLORMAP_BONE:
            self.colormaptype = 1
            break
        case .COLORMAP_JET:
            self.colormaptype = 2
            break
        case .COLORMAP_WINTER:
            self.colormaptype = 3
            break
        case .COLORMAP_RAINBOW:
            self.colormaptype = 4
            break
        case .COLORMAP_OCEAN:
            self.colormaptype = 5
            break
        case .COLORMAP_SUMMER:
            self.colormaptype = 6
            break
        case .COLORMAP_SPRING:
            self.colormaptype = 7
            break
        case .COLORMAP_COOL:
            self.colormaptype = 8
            break
        case .COLORMAP_HSV:
            self.colormaptype = 9
            break
        case .COLORMAP_PINK:
            self.colormaptype = 10
            break
        case .COLORMAP_HOT:
            self.colormaptype = 11
            break
        case .COLORMAP_PARULA:
            self.colormaptype = 12
            break
        case .COLORMAP_MAGMA:
            self.colormaptype = 13
            break
        case .COLORMAP_INFERNO:
            self.colormaptype = 14
            break
        case .COLORMAP_PLASMA:
            self.colormaptype = 15
            break
        case .COLORMAP_VIRIDIS:
            self.colormaptype = 16
            break
        case .COLORMAP_CIVIDIS:
            self.colormaptype = 17
            break
        case .COLORMAP_TWILIGHT:
            self.colormaptype = 18
            break
        case .COLORMAP_TWILIGHT_SHIFTED:
            self.colormaptype = 19
            break
        }
        setPreviewImage()
    }
    
}

