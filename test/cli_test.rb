require_relative 'test_helper'

class CliTest < MiniTest::Unit::TestCase
  def setup
  	@cli = SUS::CLI.new
  end

  def test_version
  	@cli.version
  	assert true
  rescue
  	assert false
  end

  def test_help
  	@cli.help
  	assert true
  rescue
  	assert false
  end  
end