# usage: <%= autocomplete :dom_id => "search" %>

module ConstructorIO
  module Helper
    def autocomplete(options = {})
      result = %Q|<script type="text/javascript" src="//cnstrc.com/js/ac.js"></script>\n|
      result += %Q|<script>$(document).ready(function(){ $('##{options[:dom_id]}').constructorAutocomplete({ key: '#{ConstructorIO.configuration.autocomplete_key}' }); })</script>|
      return result.html_safe
    end
  end
end
