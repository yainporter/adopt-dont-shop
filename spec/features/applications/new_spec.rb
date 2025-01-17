require "rails_helper"

RSpec.describe "new application page" do

  before(:each) do
    @application_1 = Application.create!(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love animals")

    visit "/applications/new"
  end

  describe "User Story 2 - Starting an Application" do
    it "has a form to create an application" do
      expect(page).to have_field("Name")
      expect(page).to have_field("Street Address")
      expect(page).to have_field("City")
      expect(page).to have_field("State")
      expect(page).to have_field("Zipcode")
      expect(page).to have_field("Why I would make a good home")
      expect(page).to have_button("Submit")

      fill_in("name", with: "John")
      fill_in("street_address", with: "1234 ABC Lane")
      fill_in("city", with: "Turing")
      fill_in("state", with: "Backend")
      fill_in("zipcode", with: "54321")
      fill_in("description", with: "I love animals")
      click_button("Submit")

      expect(page).to have_content("John's Application")
      expect(page).to have_content("1234 ABC Lane")
      expect(page).to have_content("Turing")
      expect(page).to have_content("Backend")
      expect(page).to have_content("54321")
      expect(page).to have_content("I love animals")
      expect(page).to have_content("In Progress")
    end
  end

  describe "User Story 3 - Form Note Completed" do
    it "shows an error if all fields are not completed" do
      fill_in("street_address", with: "1234 ABC Lane")
      fill_in("city", with: "Turing")
      fill_in("state", with: "Backend")
      fill_in("zipcode", with: "54321")
      fill_in("description", with: "I love animals")
      click_button("Submit")

      expect(page).to have_content("Error: Application not created: Required information missing.")
    end
  end
end
