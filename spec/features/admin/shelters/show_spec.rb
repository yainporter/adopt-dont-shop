require "rails_helper"

RSpec.describe "Admins Shelter Show" do
  before(:each) do
    @shelter_1 = Shelter.create!(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    @turing = Shelter.create!(foster_program: true, name: "Turing", city: "Backend", rank: 3)
    @fsa = Shelter.create!(foster_program: true, name: "Fullstack Academy", city: "Backend", rank: 3)
    @codesmith = Shelter.create!(foster_program: true, name: "Codesmith", city: "Backend", rank: 3)
    @rithm = Shelter.create!(foster_program: true, name: "Rithm School", city: "Backend", rank: 3)
    @hackreactor = Shelter.create!(foster_program: true, name: "Hack Reactor", city: "Backend", rank: 3)

    @pet_1 = @shelter_1.pets.create!(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create!(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: "Ann", breed: "ragdoll", age: 5, adoptable: true)

    @application_1 = Application.create!(name: "John", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love cats")
    @application_2 = Application.create!(name: "Jake", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love dogs", status: 1)
    @application_3 = Application.create!(name: "Jerry", street_address: "1234 ABC Lane", city: "Turing", state: "Backend", zipcode: "54321", description: "I love hamsters", status: 1)

    @application_pet_1 = ApplicationPet.create!(application_id: @application_2.id, pet_id: @pet_4.id)
    @application_pet_2 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @pet_3.id)

    visit show_admin_shelters_path(@shelter_1)
  end
  describe "User Story 19 - Admin Shelters Show Page SQL only" do
    it "displays the Shelter's name and full address" do
      expect(page).to have_content("Aurora shelter")
      expect(page).to have_content("Location: Aurora, CO")
    end
  end

  describe "User Story 23 - Average Pet Age" do
    it "has a section for stats that include the average of adoptable pets" do

      expect(page).to have_content("Shelter Statistics")
      expect(page).to have_content("Average age of adoptable pets: 4")
    end
  end
  describe "User Story 23 -  Count of Adoptable Pets" do
    it "shows many pets are available" do
      expect(page).to have_content("Pets available for adoption: 2")
    end
  end

  describe "User Story 24 - Count of Pets that have been Adopted" do
    it "shows how many pets have been adopted" do
      application_pet_3 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @pet_2.id, application_approved: true)
      application_pet_4 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @pet_4.id, application_approved: true)
      application_pet_4 = ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_4.id, application_approved: true)

      visit show_admin_shelters_path(@shelter_1)

      expect(page).to have_content("Pets that have been adopted: 3")
    end
  end

  describe "User Story 25 -  Action Required" do
    it "displays a section for Pets that have pending applications" do
      expect(page).to have_content("Action Required")
      save_and_open_page
      within "#action-required" do
        expect(page).to have_content("Ann")
      end
    end
  end

  describe "User Story 26 - Action Required Links to Application Show Page" do
    it "has a link next to each pet's name" do
      @shelter_1.pending_pets.each do |pet|
        within "#action-required-#{pet.id}" do
          expect(page).to have_link("Take Action")
          click_link("Take Action")
        end
        expect(page.current_path).to eq(show_admin_applications_path(@shelter_1.application_id_for_pet(pet.id)))
        expect(page).to have_button("Approve Pet Application")
        expect(page).to have_button("Reject Pet Application")
      end
    end
  end
end
