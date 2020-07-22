//
//  LocalizableConstants.swift
//  Turno
//
//  Created by Anan Sadiya on 01/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

enum LocalizedConstants: String {

    case    first_onboarding_title_key
    case    first_onboarding_subtitle_key
    case    second_onboarding_title_key
    case    second_onboarding_subtitle_key
    case    third_onboarding_title_key
    case    third_onboarding_subtitle_key
    case    next_key
    case    done_key
    case    welcome_to_turno_key
    case    benefits_text_key
    case    agree_to_terms_key
    case    continue_key
    case    privacy_policy_key
    case    installation_key
    case    name_key
    case    phone_number_key
    case    phone_number_question_key
    case    edit_key
    case    yes_key
    case    activate_your_account_key
    case    sms_sent_key
    case    wrong_number_key
    case    six_digit_code_key
    case    resend_sms_key
    case    activate_by_call_key
    case    finish_key
    case    cancel_key
    case    empty_field_key
    case    invalid_name_key
    case    invalid_phoneNumber_key
    case    home_key
    case    my_turns_key
    case    favorites_key
    case    settings_key
    case    ok_key
    case    generic_error_title_key
    case    connection_failed_error_title_key
    case    connection_failed_error_message_key
    case    services_key
    case    information_key
    case    check_availability_key
    case    call_now_key
    case    open_in_key
}

extension LocalizedConstants {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
