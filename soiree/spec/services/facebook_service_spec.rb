require 'rails_helper'

describe 'FacebookService' do
  context "#sign in" do
    it "returns image and name" do
      VCR.use_cassette("returns user") do
        visit root_path
        click_on "Login Through FB"

        expect(current_path).to eq dashboard_path
        binding.pry
      end
    end
  end
end
