module ActionView
  module Helpers
    module UrlHelper

      def url_for(options = {})
        options ||= {}
        url = case options
        when String
          escape = true
          strs = options.split('/')
          if (strs.include? 'galleries') || (strs.include? 'dimensions') || (strs.include? 'images')
            prefix_holder(options)
          else
            options
          end
        when Hash
          options = { :only_path => options[:host].nil? }.update(options.symbolize_keys)
          escape  = options.key?(:escape) ? options.delete(:escape) : true
          polymorphic = options.key?(:polymorphic) ? options.delete(:polymorphic) : true
          if polymorphic && (%w[galleries dimensions images].include? options[:controller].to_s)
            prefix_holder(@controller.send(:url_for, options))
          else
            @controller.send(:url_for, options)
          end
        when :back
          escape = false
          @controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
          escape = false
          polymorphic_path(options)
        end
        
        escape ? escape_once(url) : url
      end

      def prefix_holder(url)
        strs = url.split('/')
        if @holder && (@holder.automatic_polymorphic_paths == :true) && !(strs.include? @holder.class.to_s.pluralize.downcase)
          return "/#{@holder.class.to_s.pluralize.downcase}/#{@holder.id}#{url}"
        else
          return url
        end
      end
      
    end
  end
end