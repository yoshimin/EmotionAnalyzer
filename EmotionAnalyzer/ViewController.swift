//
//  ViewController.swift
//  EmotionAnalyzer
//
//  Created by 新谷　よしみ on 2017/02/10.
//  Copyright © 2017年 新谷　よしみ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import APIKit

class ViewController: UIViewController {
    enum Emotion {
        case normal
        case laugh
        case angry
        case cry
    }
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    let isTextEmpty = PublishSubject<Bool>()
    let result = PublishSubject<AnalyzeResults?>()
    let emotion = PublishSubject<Emotion>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        tapGesture.rx.event
            .subscribe(onNext: { _ in
                self.textView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        textView.rx.text
            .map({
                ($0?.isEmpty)!
            })
            .bindTo(isTextEmpty)
            .addDisposableTo(disposeBag)
        
        isTextEmpty
            .map({ !$0 })
            .startWith(false)
            .bindTo(analyzeButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        isTextEmpty
            .subscribe(onNext: {
                if ($0 == true) {
                    self.result.onNext(nil)
                }
            })
            .addDisposableTo(disposeBag)
        
        analyzeButton.rx.tap
            .subscribe(onNext: { _ in
                self.textView.resignFirstResponder()
                self.analyzeEmotion()
            })
            .addDisposableTo(disposeBag)
        
        result
            .map({
                guard let res = $0 else {
                    return ""
                }
                return "likedislike: \(res.likedislike)\njoysad: \(res.joysad)\nangerfear: \(res.angerfear)"
            })
            .bindTo(resultView.rx.text)
            .addDisposableTo(disposeBag)
        
        result
            .map({
                guard let res = $0 else {
                    return .normal
                }
                return self.emotion(from: res)
            })
            .bindTo(emotion)
            .addDisposableTo(disposeBag)
        
        result
            .subscribe(onError: { error in
                let alert = UIAlertController(title: "ERROR", message: "\(error)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        emotion
            .map({
                switch $0 {
                case .normal:
                    return UIImage(named: "Normal")!
                case .laugh:
                    return UIImage(named: "Laugh")!
                case .angry:
                    return UIImage(named: "Angry")!
                case .cry:
                    return UIImage(named: "Cry")!
                }
            })
            .bindTo(resultImageView.rx.image)
            .addDisposableTo(disposeBag)
    }
    
    private func emotion(from result: AnalyzeResults) -> Emotion {
        var emotion: Emotion = .normal
        let values = [result.likedislike, result.joysad, result.angerfear]
        var value: Float = 0
        for (i, e) in values.enumerated() {
            if (fabs(e) > fabs(value)) {
                value = e
                switch i {
                case 0:
                    if (value > 0) {
                        emotion = .laugh
                    } else if (value < 0) {
                        emotion = .cry
                    }
                    break
                case 1:
                    if (value > 0) {
                        emotion = .laugh
                    } else if (value < 0) {
                        emotion = .cry
                    }
                    break
                case 2:
                    if (value > 0) {
                        emotion = .angry
                    } else if (value < 0) {
                        emotion = .cry
                    }
                    break
                default:
                    break
                }
            }
        }
        return emotion
    }

    private func analyzeEmotion() {
        let request = AnalyzeEmotion(textView.text)
        
        Session.send(request) { result in
            switch result {
            case .success(let emotion):
                self.result.onNext(emotion)
                break
            case .failure(let error):
                self.result.onError(error)
                break
            }
        }
    }
}

