require_relative 'test_helper'

class ConstructorIORailsTest < MiniTest::Test
  def test_add_record_makes_request
    person = Person.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.stubs(:constructorio_send_request)

    person.expects(:constructorio_make_request_body)
    assert person.save
  end

  def test_add_simple_record_makes_request
    person = PersonSimple.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.stubs(:constructorio_send_request)

    person.expects(:constructorio_make_request_body)
    assert person.save
  end

  def test_add_record_accepts_procs
    person = Person.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.expects(:constructorio_send_request).with(
      'post',
      instance_of(Faraday::Connection),
      {'item_name' => 'Steven', 'test_metadata' => 'test_values', 'test_proc' => 'NEW YORK'},
      'person_autocomplete_key'
    )
    assert person.save
  end

  def test_add_simple_record_accepts_procs
    person = PersonSimple.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.expects(:constructorio_send_request).with(
      'post',
      instance_of(Faraday::Connection),
      {'item_name' => 'Steven'},
      'example_autocomplete_key'
    )
    assert person.save
  end

  def test_add_record_sends_request
    person = Person.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.expects(:constructorio_send_request)
    assert person.save
  end

  def test_delete_record_makes_request
    Person.any_instance.stubs(:constructorio_call_api)
    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    person.expects(:constructorio_call_api).with("delete", "Ronald", has_entry('test_proc', instance_of(Proc)),"person_autocomplete_key")
    person.destroy
  end

  def test_add_record_without_key_uses_default_key
    person = PersonNoKey.new(
      first_name: "Steven",
      last_name: "Lai",
      address: "New York"
    )

    person.expects(:constructorio_call_api).with("post", "Lai", anything, ConstructorIORails.configuration.autocomplete_key)
    assert person.save
  end

  def test_fields_are_tracked
    Person.any_instance.expects(:constructorio_call_api).with("post", "Ronald", anything, "person_autocomplete_key")
    person = Person.create(
      first_name: "Ronald",
      last_name: "McDonald",
      address: "Disneyland"
    )

    assert_equal ConstructorIORails::Fields.instance.list('Person'), ["first_name"]
  end
end
