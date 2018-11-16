//
//  ViewController.swift
//  HashTagAutoCompleteTextView
//
//  Created by 田中 厳貴 on 2018/11/16.
//  Copyright © 2018年 田中 厳貴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "HashTagCell", bundle: nil), forCellReuseIdentifier: "cell")
            tableView.isHidden = true
        }
    }
    
    private var viewModel: HashTagAutoCompleteViewModel?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var coverView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeEditor))
            coverView.addGestureRecognizer(tapGesture)
            coverView.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let isFocus = Observable.merge(
            textView.rx.didBeginEditing.map{true},
            textView.rx.didEndEditing.map{false}
        ).asDriver(onErrorJustReturn: false)
        
        let input = HashTagAutoCompleteViewModel.Input(
            inputHashTag: textView.rx.hashtag,
            isFocus: isFocus
        )
        
        viewModel = HashTagAutoCompleteViewModel(input: input)
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel?.hashtags.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: HashTagCell.self)) { _, element, cell in
            cell.hashtagLabel.text = element.0
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected((String?, String.Index?, String.Index?).self)
            .subscribe(onNext: { [weak self] model in
                var hashtagText = model.0
                hashtagText?.removeFirst()
                self?.textView.setHashTag(hashtagText, start: model.1, end: model.2)
            }).disposed(by: disposeBag)
        
        viewModel?.isCoverViewHidden
        .drive(onNext: { [weak self] isHidden in
            self?.coverView.isHidden = isHidden
        }).disposed(by: disposeBag)
        
        viewModel?.isTableViewHidden
        .drive(onNext: { [weak self] isHidden in
            self?.tableView.isHidden = isHidden
        }).disposed(by: disposeBag)
    }

    @objc func closeEditor() {
        view.endEditing(true)
    }

}

