//
//  PhotoPicker.swift
//  Swell
//
//  Created by Tanner Maasen on 4/3/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var avatarImage: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                // compress image
                guard let data = image.jpegData(compressionQuality: 0.3), let compressedImage = UIImage(data: data) else {
                    // return error
                    return
                }
                photoPicker.avatarImage = compressedImage
                // save to firestore
            } else {
                //return an error message
            }
            picker.dismiss(animated: true)
        }
    }
}
