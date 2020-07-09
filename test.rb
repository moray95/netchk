# frozen_string_literal: true

def test(a: 1, b: 2, **others)
  puts a
  puts b
  puts others
end

test(a: 1, b: 2, 'c' => 3, 'd' => 4)
