require_relative 'test_helper'
require_relative '../find_in_file.rb'


class DplaFindInFileTest < Minitest::Test
  def test_it_finds
    finder = Haystack::FindInFile.new(origin_path: "./fixtures/dpla_test.json")
    expected = '{"sourceResource":{"title":"Civil Rights"},"matches_ssi":"<strong>civil rights</strong>"}'
    finder.each_found  {|record| assert_equal(expected, record) }
  end
end