//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 7/20/25.
//

import UIKit

class ProfileHeaderView: UIView {

    // MARK: - Properties

    private var statusText: String? = nil

    private lazy var myImageView: UIImageView = {
        let myImageView = UIImageView()
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.image = UIImage(named: "ProfilePhoto")
        myImageView.contentMode = .scaleAspectFill
        myImageView.clipsToBounds = true

        myImageView.layer.cornerRadius = 64
        myImageView.layer.borderColor = UIColor.white.cgColor
        myImageView.layer.borderWidth = 3

        myImageView.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(profileImageTapped)
        )
        myImageView.addGestureRecognizer(tapGestureRecognizer)

        return myImageView
    }()

    private lazy var myProfileNameLabel: UILabel = {
        let myProfileNameLabel = UILabel()

        myProfileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        myProfileNameLabel.text = "Dmitrii Varlakhanov"
        myProfileNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        myProfileNameLabel.textColor = .black

        return myProfileNameLabel
    }()

    private lazy var myStatusLabel: UILabel = {
        let myStatusLabel = UILabel()

        myStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        myStatusLabel.text = "Waiting for something..."
        myStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        myStatusLabel.textColor = .gray

        return myStatusLabel
    }()

    private lazy var myShowStatusButton: UIButton = {
        let myShowStatusButton = UIButton()

        myShowStatusButton.translatesAutoresizingMaskIntoConstraints = false
        myShowStatusButton.setTitle("Show status", for: .normal)
        myShowStatusButton.setTitleColor(.white, for: .normal)
        myShowStatusButton.backgroundColor = .blue

        myShowStatusButton.layer.cornerRadius = 14
        myShowStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        myShowStatusButton.layer.shadowRadius = 4
        myShowStatusButton.layer.shadowColor = UIColor.black.cgColor
        myShowStatusButton.layer.shadowOpacity = 0.7

        myShowStatusButton.clipsToBounds = false

        myShowStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        return myShowStatusButton
    }()

    private lazy var myCustomTextField: MyCustomTestField = {
        let myCustomTextField: MyCustomTestField = MyCustomTestField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        myCustomTextField.translatesAutoresizingMaskIntoConstraints = false
        myCustomTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)

        return myCustomTextField
    }()

    private lazy var semitransperentView: UIView = {
        let semitransperentView = UIView(frame: ProfileViewController().view.frame)

        semitransperentView.backgroundColor = .white
        semitransperentView.alpha = 0

        return semitransperentView
    }()

    private lazy var buttonX: UIButton = {
        let buttonX = UIButton(frame: CGRect(
            x: Int(ProfileViewController().view.frame.width) - 50,
            y: Int(ProfileViewController().view.frame.minY),
            width: 50,
            height: 50
        ))

        buttonX.setImage(UIImage(systemName: "xmark"), for: .normal)
        buttonX.tintColor = .black
        buttonX.alpha = 0
        buttonX.addTarget(self, action: #selector(quitProfileImageTapped), for: .touchUpInside)

        return buttonX
    }()

    private lazy var globalCenterMyImageView: CGPoint? = nil

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(myProfileNameLabel)
        self.addSubview(myStatusLabel)
        self.addSubview(myShowStatusButton)
        self.addSubview(myCustomTextField)
        self.addSubview(semitransperentView)
        self.addSubview(buttonX)
        self.addSubview(myImageView)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func buttonPressed() {
        print(myStatusLabel.text!)
        myStatusLabel.text = statusText ?? ""
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }

    @objc func profileImageTapped() {
        let centerMyImageView = myImageView.center
        globalCenterMyImageView = centerMyImageView

        UIView.animateKeyframes(
            withDuration: 0.8,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.625,
                    animations: {
                        self.bringSubviewToFront(self.myImageView)
                        self.myImageView.center = CGPoint(
                            x: ProfileViewController().view.bounds.midX,
                            y: ProfileViewController().view.bounds.midY - 100
                        )
                        self.myImageView.transform = CGAffineTransform(
                            scaleX: UIScreen.main.bounds.width / self.myImageView.bounds.width,
                            y: UIScreen.main.bounds.width / self.myImageView.bounds.width
                        )
                        self.myImageView.layer.cornerRadius = 0

                        self.semitransperentView.alpha = 0.5
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.625,
                    relativeDuration: 0.375,
                    animations: {
                        self.buttonX.alpha = 1
                    }
                )
            }
        )
    }

    @objc func quitProfileImageTapped() {
        UIView.animateKeyframes(
            withDuration: 0.8,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.375,
                    animations: {
                        self.buttonX.alpha = 0
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.375,
                    relativeDuration: 0.625,
                    animations: {
                        self.myImageView.center = self.globalCenterMyImageView!
                        self.myImageView.transform = .identity
                        self.myImageView.layer.cornerRadius = 64

                        self.semitransperentView.alpha = 0
                    }
                )
            }
        )
    }

    // MARK: - Private

    private func setupView() {
        self.backgroundColor = .systemGray6
    }

    private func setupConstraints() {
        let safeAreaGuide = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            myImageView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor, constant: 16),
            myImageView.widthAnchor.constraint(equalToConstant: 128),
            myImageView.heightAnchor.constraint(equalToConstant: 128),

            myProfileNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27),
            myProfileNameLabel.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 27),

            myShowStatusButton.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor, constant: 16),
            myShowStatusButton.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor, constant: -16),
            myShowStatusButton.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 36),
            myShowStatusButton.heightAnchor.constraint(equalToConstant: 50),
            myShowStatusButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            myStatusLabel.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 27),
            myStatusLabel.bottomAnchor.constraint(equalTo: myShowStatusButton.topAnchor, constant: -74),

            myCustomTextField.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 27),
            myCustomTextField.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor, constant: -16),
            myCustomTextField.topAnchor.constraint(equalTo: myStatusLabel.bottomAnchor, constant: 10),
            myCustomTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
