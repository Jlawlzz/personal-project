require 'rails_helper'

describe'FacebookService' do
  include Capybara::DSL
  context "#sign in" do
    it "returns image and name" do
      VCR.use_cassette("returns user") do
        visit '/'
        click_on "login with facebook"

        expect(current_path).to eq '/dashboard'
        expect(page).to have_content "Taylor Moore"
      end
    end
  end
end
