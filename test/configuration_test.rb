require_relative 'test_helper'

class ConfigurationTest < MiniTest::Test
  def test_configure_api_token
    assert_equal ConstructorIO.configuration.api_token, "example_api_token"
  end

  def test_configure_autocomplete_key
    assert_equal ConstructorIO.configuration.autocomplete_key, "example_autocomplete_key"
  end

  def test_configure_api_url
    assert_equal ConstructorIO.configuration.api_url, "http://example.constructor.io"
  end
end
