//
//  PhotoPicker.swift
//  Swell
//
//  Created by Tanner Maasen on 4/3/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    @EnvironmentObject var user: AuthenticationViewModel
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var photoPicker: PhotoPicker
        
        init(_ photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                // compress image
                guard let data = image.jpegData(compressionQuality: 0.3),
                      let compressedImage = UIImage(data: data) else {
                    // return error
                    return
                }
                // resize image
                let imageData = resizeImage(image: compressedImage, targetSize: CGSize(width: 200, height: 200))
                // set it locally
                photoPicker.user.avatarImage = imageData!
                // save to firebase storage
                photoPicker.user.setAvatarImage(pImage: imageData!)
            } else {
                //return an error message
            }
            picker.dismiss(animated: true)
        }
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
            let size = image.size
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }
            
            let rect = CGRect(origin: .zero, size: newSize)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
    }
}
