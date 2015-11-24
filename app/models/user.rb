# Rename uid attribute to uuid or user_id_with_provider
# Remove has_secure_token and token attribute incl table and gem
# Clean up routes
# Remove omniauth gems
# Remove omniauth config

class User < ActiveRecord::Base
  scope :data_for_listing, -> { select(:id, :email, :administrator, :coach, :name, :gender, :birth_date) }

  has_secure_token
  has_attached_file :avatar, :styles => { :small => "100x100>" }

  has_one  :location, dependent: :destroy
  has_many :availabilities, class_name: :Availability, foreign_key: :coach_id, dependent: :destroy
  has_many :bookings, class_name: :Booking, foreign_key: :coach_id
  has_many :exercise_descriptions, dependent: :destroy
  has_many :exercise_plans, dependent: :destroy
  has_many :habit_descriptions, dependent: :destroy
  has_many :habit_descriptions, through: :habit_logs
  has_many :habit_logs, dependent: :destroy
  has_many :payments
  has_many :payment_plans
  has_many :products, dependent: :destroy
  has_many :tags

  # Validate attributes
  validates :uid,
            :provider,
            presence: true

  validates_attachment :avatar, # presence: true,
    :content_type => { :content_type => [/image\/jpeg/, /image\/png/] },
    :file_name => { :matches => [/jpeg/, /jpg/, /png/] }

  def as_json(options={})
    UserSerializer.new(self).as_json(options)
  end

  def administrator?
    self.administrator
  end

  def coach?
    self.coach
  end

  def self.create_with_auth_token(provider, uid, email)
    create! do |user|
      user.provider = provider
      user.uid = uid
      user.email = email
    end
  end
end
