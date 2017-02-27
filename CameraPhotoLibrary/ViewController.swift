//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by Lucia on 2017. 2. 27..
//  Copyright © 2017년 Lucia. All rights reserved.
//

import UIKit
import MobileCoreServices // 다양한 타입들을 정의해 놓은 헤더파일.

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // delegate protocol 추가.

    @IBOutlet weak var imgView: UIImageView!
    
    // UIImagePickerController 인스턴스 변수 생성.
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var videoURL: URL!
    var flagImageSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 사진 촬영.
    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) { // 카메라의 사용 가능 여부 확인.
            flagImageSave = true // 이미지 저장 허용.
            
            imagePicker.delegate = self // 이미지 picker의 delegate를 self로 설정.
            imagePicker.sourceType = .camera // 이미지 picker의 소스 type은 camera.
            imagePicker.mediaTypes = [kUTTypeImage as String] // 미디어 타입.
            imagePicker.allowsEditing = false // 편집 허용 안함.
            
            present(imagePicker, animated: true, completion: nil) // 현재 뷰 컨트롤러를 imagePicker로 대체.
        } else { // 카메라 사용이 불가할 때의 경고창.
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    
    // 사진 불러오기.
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary //이미지 피커의 소스타입을 PhotoLibrary로 설정.
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true // 편집 허용.
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }

    }
 

    // 비디오 촬영하기.
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String] // 미디어 타입을 kUTTypeMovie로 설정.
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // 비디오 불러오기.
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
        
    }
    
    // 사진, 비디오 촬영이나 선택이 끝났을 때 호출되는 delegate 메서드. 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString // 미디어 종류 확인.
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) { // 미디어 종류가 Image일 경우.
            captureImage = info[UIImagePickerControllerOriginalImage] as! UIImage // 사진을 가져와 captureImage에 저장.
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                // flagImageSave가 true면 가져온 사진을 포토라이브러리에 저장.
            }
            
            imgView.image = captureImage
        } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) { // 미디어 종류가 Movie일 경우.
            if flagImageSave {
                // flagImageSave가 true면 촬영한 비디오를 가져와 포토라이브러리에 저장.
                videoURL = (info[UIImagePickerControllerMediaURL] as! URL)
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
            
        }
        
        // 현재의 뷰 컨트롤러 제거. 즉, 뷰에서 이미지 피커화면을 제거하여 초기 뷰를 보여줌.
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // 사용자가 찍지 않고 취소하거나 선택하지 않고 취소하는 경우 호출되는 imagePickerControllerDidCancel 메서드. 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 문제가 생겼을 때 화면에 표시해 줄 경고 표시용 메서드.
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

