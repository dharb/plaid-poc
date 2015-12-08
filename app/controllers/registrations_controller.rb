class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    select_bank_user_path(resource)
  end
end
