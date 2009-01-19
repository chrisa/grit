require File.dirname(__FILE__) + '/helper'

class TestDiff < Test::Unit::TestCase
  def setup
    @r = Repo.new(GRIT_REPO)
  end
  
  # list_from_string
  
  def test_list_from_string_new_mode
    output = fixture('diff_new_mode')
    
    diffs = Grit::Diff.list_from_string(@r, output)
    assert_equal 2, diffs.size
    assert_equal 10, diffs.first.diff.split("\n").size
    assert_equal nil, diffs.last.diff
  end

  def test_file_removed
    diffs = Grit::Commit.diff(@r, 
                              '734713bc047d87bf7eac9674765ae793478c50d3', 
                              'd921970aadf03b3cf0e71becdaab3147ba71cdef')
    
    assert_equal 'lib/grit/head.rb', diffs[0].b_path
    assert_equal false, diffs[0].new_file
    assert_equal true,  diffs[0].deleted_file
  end

  def test_file_added
    diffs = Grit::Commit.diff(@r, 
                              '1c002dd4b536e7479fe34593e72e6c6c1819e53b', 
                              '1c3618887afb5fbcbea25b7c013f4e2114448b8d')
    
    assert_equal 'lib/grit/blame.rb', diffs[3].b_path
    assert_equal true,  diffs[3].new_file
    assert_equal false, diffs[3].deleted_file
  end

  def test_diff_files_added_and_removed
    diffs = Grit::Commit.diff(@r, 
                              'dfeffcef039cb1b1682baadba39d82b4c6f8470d',
                              'c615d80aa8e72f2450ccfa399e6957021ae38024')
    
    assert_equal 16, diffs.length

    diffs.each do |d|
      if d.new_file
        assert_match /^\+/, d.diff.split("\n")[3]
      end
      if d.deleted_file
        assert_match /^-/, d.diff.split("\n")[3]
      end
    end
  end
end
