//
//  PhotoPicker.swift
//  Swell
//
//  Created by Tanner Maasen on 4/3/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                // compress image
                guard let data = image.jpegData(compressionQuality: 0.3), let compressedImage = UIImage(data: data) else {
                    // return error
                    return
                }
                // set it locally
                UserViewModel.avatarImage = compressedImage
                // save to firebase storage
                UserViewModel.setAvatarImage(pImage: compressedImage)
            } else {
                //return an error message
            }
            picker.dismiss(animated: true)
        }
    }
}
