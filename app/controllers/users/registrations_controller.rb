class Users::RegistrationsController < Devise::RegistrationsController
  def create
    email = params[:user].delete(:email)
    website = params[:user].delete(:website)
    build_resource sign_up_params
    resource.email = email
    resource.website = website
    resource.access_level = User::NEW_USER

    if verify_recaptcha(model: resource) && resource.save
      RegistrationsMailer.notify(User.where(email: ENV["NEW_USER_NOTIFY"]).first, resource).deliver
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      clean_up_passwords(resource)
      render :new
    end
  end
end
