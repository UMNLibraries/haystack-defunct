require_relative 'test_helper'
require_relative '../matcher.rb'


class MatcherTest < Minitest::Test
  def test_it_matches
    record = {
      'sourceResource' =>
        {
          'title' => 'The blah of blergh.',
          'collection' => {'title' => 'Stuff I like', 'description' => 'All the stuffs I like'},
          'subject' => [{'name' => 'Civil Rights'},{'name' => 'Civil War'}],
          'creator' => 'Malcolm X',
          'contributor' => 'Jack Smith.',
          'Description' => 'A blah blah thing blah blah.',
        }
    }
    expected = record.merge("matches_ssi" => "the blah of blergh. stuff i like all the stuffs i like <strong>civil rights</strong> civil war <strong>malcolm x</strong> jack smith.")
    matcher = Haystack::Matcher.new(record: record, terms: 'Malcolm X|Civil Rights|African American')
    assert_equal(expected, matcher.record_with_match)
    assert(matcher.matched?)
  end
end