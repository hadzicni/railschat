class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :locale, inclusion: { in: %w[de en], message: "must be a valid locale" }

  # Set default locale if not provided
  before_validation :set_default_locale, on: :create

  # Override Devise method to check if user is banned
  def active_for_authentication?
    super && !banned?
  end

  # Custom message for banned users
  def inactive_message
    banned? ? :banned : super
  end

  # Admin scopes
  scope :admins, -> { where(admin: true) }
  scope :regular_users, -> { where(admin: false) }
  scope :banned_users, -> { where(banned: true) }
  scope :active_users, -> { where(banned: false) }

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

  # Ban methods
  def banned?
    banned == true
  end

  def ban!(reason = nil)
    update!(
      banned: true,
      banned_at: Time.current,
      banned_reason: reason
    )
  end

  def unban!
    update!(
      banned: false,
      banned_at: nil,
      banned_reason: nil
    )
  end

  def can_be_banned_by?(current_user)
    current_user.admin? && current_user != self && !banned?
  end

  def can_be_unbanned_by?(current_user)
    current_user.admin? && banned?
  end

  def status
    if banned?
      "Gesperrt"
    elsif admin?
      "Administrator"
    else
      "Benutzer"
    end
  end

  # Locale methods
  def preferred_locale
    locale.presence || "de"
  end

  def update_locale!(new_locale)
    if %w[de en].include?(new_locale.to_s)
      update!(locale: new_locale)
    end
  end

  private

  def set_default_locale
    self.locale ||= "de"
  end
end
