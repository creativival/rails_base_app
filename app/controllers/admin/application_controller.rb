# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      # TODO Add authentication logic here.
      if !user_signed_in?
        flash[:alert] = I18n.t('errors.messages.require_login')
        redirect_to new_user_session_path
      elsif !current_user.admin?
        flash[:alert] = I18n.t('errors.messages.not_admin')
        redirect_to '/'
        # debugger
      end
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
