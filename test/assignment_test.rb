require 'test_helper'
require 'json'

class AssignmentTest < MiniTest::Unit::TestCase

  def setup
    @experiment = Experiments::Experiment.new('assignment test')
    @group = Experiments::Group.new(@experiment, :control)
  end

  def test_basic_properties
    assignment = Experiments::Assignment.new(@experiment, @group)
    assert_equal @experiment, assignment.experiment 
    assert_equal @group, assignment.group 
    assert assignment.returning?
    assert assignment.qualified?
    assert_equal :control, assignment.to_sym
    assert_equal 'control', assignment.handle

    non_assignment = Experiments::Assignment.new(@experiment, nil, false)
    assert_equal nil, non_assignment.group 
    assert !non_assignment.returning?
    assert !non_assignment.qualified?
    assert_equal nil, non_assignment.to_sym
    assert_equal nil, non_assignment.handle
  end

  def test_triple_equals
    assignment = Experiments::Assignment.new(@experiment, @group)
    assert !(assignment === nil)
    assert assignment === @group
    assert assignment === 'control'
    assert assignment === :control

    non_assignment = Experiments::Assignment.new(@experiment, nil, false)
    assert non_assignment === nil
    assert !(non_assignment === @group)
    assert !(non_assignment === 'control')
    assert !(non_assignment === :control)
  end

  def test_json_representation
    assignment = Experiments::Assignment.new(@experiment, @group)
    json = JSON.parse(assignment.to_json)

    assert_equal 'assignment test', json['experiment']
    assert_equal true, json['qualified']
    assert_equal true, json['returning']
    assert_equal 'control', json['group']

    non_assignment = Experiments::Assignment.new(@experiment, nil, false)
    json = JSON.parse(non_assignment.to_json)
    assert_equal 'assignment test', json['experiment']
    assert_equal false, json['qualified']
    assert_equal false, json['returning']
    assert_equal nil, json['group']    
  end
end
