require 'test_helper'

class WorkExample < ActiveRecord::Base
end

class WorkOption < ActiveRecord::Base
end

class AadgSchemaTest < ActiveSupport::TestCase
  load_schema

  def test_schema_loads
    assert_equal [], WorkExample.all
    assert_equal [], WorkOption.all
  end
end
