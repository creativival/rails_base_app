module HeaderHelper
  def header_link_active?(link)
    controller = params[:controller]
    action = params[:action]

    case link
    when 'top'
      if (controller == 'static_pages' && action == 'top')
        return ' active'
      end
    when 'sign_in'
      if (controller == 'devise/sessions' && action == 'new')
        return ' active'
      end
    when 'sign_up'
      if (controller == 'devise/registrations' && action == 'new')
        return ' active'
      end
    else
    end
  end
end