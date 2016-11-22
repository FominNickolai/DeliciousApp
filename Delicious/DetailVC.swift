//
//  DetailVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    let text = ["", "", "Lorem ipsum – псевдо-латинский текст, который используется для веб дизайна, типографии, оборудования, и распечатки вместо английского текста для того, чтобы сделать ударение не на содержание, а на элементы дизайна. Такой текст также называется как заполнитель. Это очень удобный инструмент для моделей (макетов). Он помогает выделить визуальные элементы в документе или презентации, например текст, шрифт или разметка. Lorem ipsum по большей части является элементом латинского текста классического автора и философа Цицерона.", "В профессиональной сфере часто случается так, что личные или корпоративные клиенты заказывают, чтобы публикация была сделана и представлена еще тогда, когда фактическое содержание все еще не готово. Вспомните новостные блоги, где информация публикуется каждый час в живом порядке. Тем не менее, читатели склонны к тому, чтобы быть отвлеченными доступным контентом, скажем, любым текстом, который был скопирован из газеты или интернета. Они предпочитают сконцентрироваться на тексте, пренебрегая разметкой и ее элементами. К тому же, случайный текст подвергается риску быть неумышленно смешным или оскорбительным, что является неприемлемым риском в корпоративной среде. Lorem ipsum, а также ее многие варианты были использованы в работе начиная с 1960-ых, и очень даже похоже, что еще с 16-го века."]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "food-3")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cellImageId = "cellId"
    let cellButtonsId = "cellButtonsId"
    let cellTextId = "cellTextId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(blurView)
        
        view.addSubview(collectionView)
        
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
 
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .clear
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: cellImageId)
        collectionView.register(DetailButtonsCell.self, forCellWithReuseIdentifier: cellButtonsId)
        collectionView.register(DetailTextCell.self, forCellWithReuseIdentifier: cellTextId)
    }
    
    fileprivate func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: UIScreen.main.bounds.width - 50, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    deinit {
        print("DetailVC Deinit")
    }
    
}

//UICollectionViewDataSource
extension DetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellImageId, for: indexPath) as! DetailImageCell
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellButtonsId, for: indexPath) as! DetailButtonsCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTextId, for: indexPath) as! DetailTextCell
            cell.textCell = text[indexPath.item]

            return cell
        }
    
    }
}

//UICollectionViewDelegate
extension DetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

//UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        var height: CGFloat = 0
        if indexPath.item == 0 {
            height = 244
        } else if indexPath.item == 1 {
            height =  103
        } else {
            let messageText = text[indexPath.item]
            height = estimateFrameForText(text: messageText).height + 100
        }
        print(height)
        return CGSize(width: view.frame.width - 20, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(75, 0, 0, 0)
        
    }
    
}
