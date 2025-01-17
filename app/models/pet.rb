class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets, dependent: :destroy
  has_many :applications, through: :application_pets, dependent: :destroy, source: :application

  scope :adoptable, -> { where(adoptable: true) }

  def shelter_name
    shelter.name
  end

  def self.check_pet_applications
    Pet.joins(:application_pets).pluck(:application_approved)
  end
end
