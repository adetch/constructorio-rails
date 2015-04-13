require_relative 'test_helper'

class ViewHelperTest < MiniTest::Test
  def setup
    @fakeview = FakeView.new
  end

  def test_autocomplete_html
    assert_equal @fakeview.autocomplete(dom_id: 'a'), "<script type=\"text/javascript\" src=\"//cnstrc.com/js/ac.js\"></script>\n<script>$(document).ready(function(){ $('#a').constructorAutocomplete({ key: 'example_autocomplete_key' }); })</script>"
  end
end
