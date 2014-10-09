require 'minitest/autorun'
require_relative 'camera_script'

class CameraTest < MiniTest::Unit::TestCase

  def setup
    Dir.chdir(File.dirname(__FILE__))
    @merged =
              {
                  'Canon 5D mark II'=>'Canon 5D Mark II',
                  'Canon 5d MKII'=>'Canon 5D Mark II',
                  'Canon 5dMKII'=>'Canon 5D Mark II'
              }
  end

  def test_condense
    # Dir.chdir('tests')
    assert_equal ["Nkon 700D", "Phantom Flex", "Sony NEX7"], CameraReader.new('condense_test_file.txt').condense
  end

  def test_merge
    # Dir.chdir('tests')
    assert_equal @merged, CameraReader.new('merge_test_file.txt').merge
  end

end
