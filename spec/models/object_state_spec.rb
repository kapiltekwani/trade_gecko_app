require 'spec_helper'

describe ObjectState do
  context "Validations" do
    it { should validate_presence_of(:object_id) }
    it { should validate_presence_of(:object_type) }
    it { should validate_presence_of(:timestamp) }
    it { should validate_presence_of(:object_changes) }
  end
end

