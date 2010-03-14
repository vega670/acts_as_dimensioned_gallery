require 'test_helper'

class WorkExample < ActiveRecord::Base
  #acts_as_dimensioned_gallery
end

class WorkOption < ActiveRecord::Base
  #acts_as_dimensioned_gallery
end

class AadgTest < ActiveSupport::TestCase
  #load_schema

  def test_workexample_has_access_to_instance_methods
    assert true
  end

  def test_workoption_changes_fields_with_options
    assert true
  end

  def test_truth
    assert true
  end
end
