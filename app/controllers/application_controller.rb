class ApplicationController < ActionController::Base
  require 'ipaddr'
  require 'redcarpet'

  before_filter :protect
  protect_from_forgery
  helper_method :current_group

  rescue_from CanCan::AccessDenied, Exceptions::AccessDenied, :with => :show_error_message
  
  def in_cloudflare_range?(request_ip_string)
    cloudflare_ips = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
    request_ip = IPAddr.new(request_ip_string)
    cloudflare_ips.each { |ip| 
      range = IPAddr.new(ip);
      next if !range.include?(request_ip)
      return true
    }
    return false
  end
    

  def protect
    if in_cloudflare_range?(request.headers["HTTP_REMOTE_ADDR"])
     Rails.logger.info "\n\n\n\nValid request\n\n\n\n\n"
    else
      Rails.logger.info "\n\n\n\nInvalid request - UNAUTHORIZED\n\n\n\n"
      render json: {}, status: 401
    end
  end

  def current_group
    # Group.first # changed to default to first group
  end

  def collection_authorize!(action, collection, *args)
    collection.each do |item|
      is_authorized? action, item, *args
    end
  end

  def is_authorized?(action, resource, expertizeNeeded=false)
    # Use Cancan
    authorize! action, resource
    # Use Rolify if requested


    if expertizeNeeded
      unless current_user && (current_user.admin? || current_user.group_admin_of?(current_group) || current_user.is_expert_of?(resource))
        raise Exceptions::AccessDenied
      end
    end
  end

  def show_error_message(exception)
    redirect_to root_url, :alert => exception.message
  end
  
end
