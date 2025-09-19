class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  validates :email, presence: true, uniqueness: true

  # Admin scopes
  scope :admins, -> { where(admin: true) }
  scope :regular_users, -> { where(admin: false) }

  # Display name method
  def display_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.present?
      first_name
    else
      email.split("@").first
    end
  end

  # Initials for avatar
  def initials
    if first_name.present?
      "#{first_name.first}#{last_name&.first}".upcase
    else
      email.first.upcase
    end
  end

  # Full name with fallback
  def full_name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end

  # Admin methods
  def admin?
    admin == true
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end

  def can_be_deleted_by?(current_user)
    current_user.admin? && current_user != self
  end

  def status
    admin? ? "Administrator" : "Benutzer"
  end
end
