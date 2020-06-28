require "test_helper"

class NetchkTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Netchk::VERSION
  end
end
