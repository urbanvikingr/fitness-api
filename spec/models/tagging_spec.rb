require 'spec_helper'

describe Tagging, type: :model do
  it "has a valid factory" do
    tagging = build(:tagging)
    expect(tagging).to be_valid
  end
end
