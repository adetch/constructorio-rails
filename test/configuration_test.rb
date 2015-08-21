require_relative 'test_helper'

class ConfigurationTest < MiniTest::Test
  def test_configure_api_token
    assert_equal ConstructorIORails.configuration.api_token, "example_api_token"
  end

  def test_configure_autocomplete_key
    assert_equal ConstructorIORails.configuration.autocomplete_key, "example_autocomplete_key"
  end

  def test_configure_api_url
    assert_equal ConstructorIORails.configuration.api_url, "http://example.constructor.io"
  end
end
