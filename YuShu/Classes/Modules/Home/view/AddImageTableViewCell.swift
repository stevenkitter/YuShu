//
//  AddImageTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
class AddImageTableViewCell: UITableViewCell {
    var images: [UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(str: "YSAddImageCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

extension AddImageTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSAddImageCollectionViewCell", for: indexPath) as! YSAddImageCollectionViewCell
        cell.imageView.image = indexPath.item == 0 ? UIImage(named: "zz_publish_add_images")! : images[indexPath.item - 1]
        cell.deleteBtn.isHidden = indexPath.item == 0
        cell.closure = { [unowned self] () in
            self.images.remove(at: indexPath.item - 1)
            self.collectionView.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            selectIcon()
        }else{
            showImages(index: indexPath.item - 1)
        }
    }
    
}
extension AddImageTableViewCell{
    func selectIcon() {
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 8
        imagePicker.delegate = self
        guard let superVc = self.superVc() else {
            return
        }
        superVc.present(imagePicker, animated: true, completion: nil)
        
    }
    func showImages(index: Int) {
        guard images.count > 0 else {return}
        let lightImages = images.map{return LightboxImage(image: $0)}
        let box = LightboxController(images: lightImages, startIndex: index)
        guard let superVc = self.superVc() else {
            return
        }
        superVc.present(box, animated: true, completion: nil)
    }
}
extension AddImageTableViewCell: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else {return}
        let lightImages = images.map{return LightboxImage(image: $0)}
        let box = LightboxController(images: lightImages, startIndex: 0)
        imagePicker.present(box, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        self.images.append(contentsOf: images)
        collectionView.reloadData()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
