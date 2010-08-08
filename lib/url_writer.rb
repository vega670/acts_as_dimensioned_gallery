# Currently not used
module ActionController
  module UrlWriter

    def url_for(options)
      options = self.class.default_url_options.merge(options)

      url = ''

      unless options.delete(:only_path)
        url << (options.delete(:protocol) || 'http')
        url << '://' unless url.match("://")

        raise "Missing host to link to! Please provide :host parameter or set default_url_options[:host]" unless options[:host]

        url << options.delete(:host)
        url << ":#{options.delete(:port)}" if options.key?(:port)
      else
        # Delete the unused options to prevent their appearance in the query string.
        [:protocol, :host, :port, :skip_relative_url_root].each { |k| options.delete(k) }
      end
      trailing_slash = options.delete(:trailing_slash) if options.key?(:trailing_slash)
      url << ActionController::Base.relative_url_root.to_s unless options[:skip_relative_url_root]
      anchor = "##{CGI.escape options.delete(:anchor).to_param.to_s}" if options[:anchor]
      generated = Routing::Routes.generate(options, {})
      url << (trailing_slash ? generated.sub(/\?|\z/) { "/" + $& } : generated)
      url << anchor if anchor

      return url
    end
  end
end