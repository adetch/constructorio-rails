require_relative 'test_helper'

class ConstructorIOTest < MiniTest::Test
  def test_add_record
    person = Person.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )
    person.expects(:call_api).with("post", "Steven", "person_autocomplete_key")

    assert person.save
  end

  def test_delete_record
    Person.any_instance.expects(:call_api).with("post", "Ronald", "person_autocomplete_key")
    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    person.expects(:call_api).with("delete", "Ronald", "person_autocomplete_key")
    person.destroy
  end

  def test_add_record_without_key
    person = PersonNoKey.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.expects(:call_api).with("post", "Lai", ConstructorIO.configuration.autocomplete_key)
    assert person.save
  end

  def test_fields
    Person.any_instance.expects(:call_api).with("post", "Ronald", "person_autocomplete_key")
    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    assert_equal ConstructorIO::Fields.instance.list('Person'), ["first_name"]
  end
end
