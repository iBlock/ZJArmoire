//
//  ZJATemperatueCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/24.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJATemperatueCell: UITableViewCell {
    
    typealias TemperatueCallback = (Int, Int) -> Void
    var tempblock: TemperatueCallback?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    func prepareUI() {
        contentView.addSubview(titleView)
        contentView.addSubview(temperatueLabel)
        contentView.addSubview(coldIcon)
        contentView.addSubview(rangeSlider)
        contentView.addSubview(holdIcon)
        contentView.addSubview(bottomLine)
    }
    
    func setupViewConstraints() {
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
        }
        
        temperatueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleView.snp.right).offset(20)
            make.top.equalTo(10)
        }
        
        coldIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(titleView.snp.bottom).offset(15)
//            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        holdIcon.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(titleView.snp.bottom).offset(15)
//            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        rangeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(coldIcon.snp.right).offset(0)
            make.top.equalTo(titleView.snp.bottom).offset(0)
//            make.centerY.equalToSuperview()
            make.right.equalTo(holdIcon.snp.left).offset(0)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    public lazy var rangeSlider: TTRangeSlider = {
        let slider = TTRangeSlider()
        slider.delegate = self
        slider.minValue = -10
        slider.maxValue = 40
        slider.selectedMinimum = -10
        slider.selectedMaximum = 40
        slider.handleColor = UIColor.darkGray
        return slider
    }()
    
    private lazy var coldIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "cold"))
        return icon
    }()
    
    private lazy var holdIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "hold"))
        return icon
    }()
    
    private lazy var titleView:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.text = "温度"
        tagLabel.font = UIFont.systemFont(ofSize: 16)
        tagLabel.textColor = COLOR_TEXT_LABEL
        return tagLabel
    }()
    
    lazy var temperatueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = COLOR_TEXT_LABEL
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = COLOR_TABLE_LINE
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ZJATemperatueCell: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!,
                     didChangeSelectedMinimumValue selectedMinimum: Float,
                     andMaximumValue selectedMaximum: Float) {
        temperatueLabel.text = String(Int(selectedMinimum)) + "度 ~ " + String(Int(selectedMaximum)) + "度"
        tempblock?(Int(selectedMinimum),Int(selectedMaximum))
    }
}
