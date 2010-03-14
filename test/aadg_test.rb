require 'test_helper'

class WorkExample < ActiveRecord::Base
  acts_as_dimensioned_gallery
end

class WorkOption < ActiveRecord::Base
  acts_as_dimensioned_gallery :path => 'imggal'
end

class AadgTest < ActiveSupport::TestCase
  load_schema

  def test_workexample_has_access_to_plugin_models
    wex = WorkExample.new
    wex.save
    wex.galleries.create({'name' => 'name', 'description' => 'description', 'gallery_image_id' => 1})
    gal = wex.galleries.first
    assert_equal wex.galleries.path, 'galleries'
    assert_equal gal.name, "name"
    assert_equal gal.description, "description"
    assert_equal gal.holder_id, wex.id
    assert_equal gal.holder_type, wex.class.name
    assert_equal gal.gallery_image_id, 1
  end

  def test_workoption_doesnt_break_with_options
    assert_kind_of WorkOption, WorkOption.new
  end
end
