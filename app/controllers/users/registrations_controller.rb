# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :get_profile_max_length, only: [:edit]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    super
    if account_update_params[:avatar].present?
      resource.avatar.attach(account_update_params[:avatar])
      return false
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

    # サインアップ時にnameのストロングパラメータを追加
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    end

    # アカウント編集の時にnameとprofileのストロングパラメータを追加
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :avatar, :role])
    end

  def get_profile_max_length
    @profile_max_length = Settings.user.profile_max_length
  end

    # #必須  更新（編集の反映）時にパスワード入力を省く（current_password を入力して更新するとエラーになる）
    # def update_resource(resource, params)
    #   resource.update_without_password(params)
    # end

    def after_sign_up_path_for(resource)
      flash[:notice] = t('devise.registrations.signed_up_and_edit')
      edit_user_registration_path(resource)
    end

    def after_inactive_sign_up_path_for(resource)
      root_path
    end

    def after_update_path_for(resource)
      user_path(resource)
    end
end
