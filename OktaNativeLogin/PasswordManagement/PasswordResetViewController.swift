/*
 * Copyright 2019 Okta, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import OktaAuthSdk
import SVProgressHUD

class PasswordResetViewController: AuthBaseViewController {
    lazy var resetStatus: OktaAuthStatusPasswordReset = {
        
        return status as! OktaAuthStatusPasswordReset
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isHidden = !resetStatus.canReset()
        cancelButton.isHidden = !resetStatus.canCancel()
    }
    
    // MARK: - IB
    
    @IBAction private func resetButtonTapped() {
        guard let password = passwordTextField.text else { return }
        SVProgressHUD.show()
        resetStatus.resetPassword(newPassword: password,
                                  onStatusChange:
            { [weak self] status in
                SVProgressHUD.dismiss()
                self?.flowCoordinatorDelegate?.onStatusChanged(status: status)
        })  { [weak self] error in
            SVProgressHUD.dismiss()
            self?.showError(message: error.description)
        }
    }
    
    @IBAction private func cancelButtonTapped() {
        processCancel()
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
}
