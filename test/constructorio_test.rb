require_relative 'test_helper'

class ConstructorIOTest < MiniTest::Test
  def test_add_record_api
    person = Person.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )
    Person.expects(:call_api).with(
      "post",
      { item_name: "Steven" },
      "person_autocomplete_key"
    )

    assert person.save
  end

  def test_add_record_with_dynamic_value
    person = PersonDynamicValue.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )
    PersonDynamicValue.expects(:call_api).with(
      "post",
      {
        item_name: "Steven",
        url: "/people/Steven"
      },
      "person_autocomplete_key"
    )

    assert person.save
  end

  def test_delete_record
    Person.expects(:call_api).with(
      "post",
      { item_name: "Ronald" },
      "person_autocomplete_key"
    )

    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    Person.expects(:call_api).with("delete", "Ronald", "person_autocomplete_key")
    person.destroy
  end

  def test_add_record_without_key
    person = PersonNoKey.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    PersonNoKey.expects(:call_api).with(
      "post",
      { item_name: "Lai" },
      ConstructorIO.configuration.autocomplete_key
    )
    assert person.save
  end

  def test_fields
    Person.expects(:call_api).with(
      "post",
      { item_name: "Ronald" },
      "person_autocomplete_key"
    )

    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    assert_equal ConstructorIO::Fields.instance.list("Person"), ["first_name"]
  end
end
