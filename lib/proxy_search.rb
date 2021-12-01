class ProxySearch < Rack::Proxy
  def initialize(app)
    @app = app
  end
  
  def call(env)
    original_host = env["HTTP_HOST"]
    rewrite_env(env)
    
    if env["HTTP_HOST"] != original_host
      perform_request(env)
    else
      @app.call(env)
    end
  end

  def rewrite_env(env)
    request = Rack::Request.new(env)

    if request.path =~ %r{/searches/new|/searches/results|/static|/icons}
      env["HTTP_HOST"] = (ENV["NEW_SEARCH_HOST"] || "localhost") + ":" + (ENV["NEW_SEARCH_PORT"] || "3000")
      env["HTTP_X_FORWARDED_PROTO"] = "http"
      env["rack.url_scheme"] = "http"
    elsif request.path =~ %r{/api/search}
      env["HTTP_HOST"] = (ENV["NEW_SEARCH_BACKEND_HOST"] || "localhost") + ":" + (ENV["NEW_SEARCH_BACKEND_PORT"] || "7107")
      env["HTTP_X_FORWARDED_PROTO"] = "http"
      env["rack.url_scheme"] = "http"
    end
  end
end