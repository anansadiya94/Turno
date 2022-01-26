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
    case    generic_error_message_key
    case    connection_failed_error_title_key
    case    connection_failed_error_message_key
    case    services_key
    case    information_key
    case    check_availability_key
    case    call_now_key
    case    open_in_key
    case    book_now_key
    case    confirm_key
    case    confirm_message_key
    case    no_favorites_error_title_key
    case    no_favorites_error_message_key
    case    no_turns_error_title_key
    case    no_turns_error_message_key
    case    no_available_dates_title_key
    case    no_available_dates_message_key
    case    no_blocked_users_title_key
    case    no_blocked_users_message_key
    case    user_to_block_title_key
    case    unblock_user_title_key
    case    unblock_user_message_key
    case    no_key
    case    cancel_turn_title_key
    case    cancel_turn_message_key
    case    no_turns_business_message_key
    case    unblock_key
    case    block_user_key
    case    account_key
    case    app_key
    case    business_key
    case    blocked_users_key
    case    notifications_key
    case    about_key
    case    contact_us_key
    case    share_key
    case    terms_of_use_key
    case    change_to_business_key
    case    change_to_user_key
    case    day_key
    case    start_time_key
    case    end_time_key
    case    minute_key
    case    hour_key
    case    client_information_key
    case    add_appointment_key
    case    block_key
    case    close_key
    case    home_error_message_key
    case    cancel_turn_key
    case    force_update_title_key
    case    force_update_message_key
    case    force_update_action_key
    case    sign_out_key
    
    case    total_services_time_key
    case    block_user_by_name_key
    case    user_by_phone_number_key
}

extension LocalizedConstants {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var enLocalized: String {
        guard let bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else { return "" }
        return NSLocalizedString(self.rawValue, bundle: bundle, value: " ", comment: "")
    }
}
