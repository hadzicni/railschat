class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :email, presence: true, uniqueness: true
  validates :locale, inclusion: { in: %w[de en], message: "must be a valid locale" }

  # Set default locale if not provided
  before_validation :set_default_locale, on: :create

  # Assign default user role after creation
  after_create :assign_default_role

  # Override Devise method to check if user is banned
  def active_for_authentication?
    super && !banned?
  end

  # Custom message for banned users
  def inactive_message
    banned? ? :banned : super
  end

  # Admin scopes - now based on roles
  scope :admins, -> { joins(:roles).where(roles: { name: "admin" }) }
  scope :regular_users, -> { where.not(id: joins(:roles).where(roles: { name: "admin" })) }
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

  # Admin methods - now based on roles
  def admin?
    has_role?("admin")
  end

  def make_admin!
    add_role("admin")
  end

  def remove_admin!
    remove_role("admin")
  end

  def can_be_deleted_by?(current_user)
    current_user.admin? && current_user != self
  end

  def can_have_roles_modified_by?(current_user)
    current_user.admin?
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
      I18n.t('status.banned')
    elsif has_role?("admin")
      I18n.t('status.admin')
    else
      I18n.t('status.user')
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

  # Role system methods
  def has_role?(role_name)
    roles.exists?(name: role_name.to_s)
  end

  def add_role(role_name)
    role = Role.find_by(name: role_name.to_s)
    return false unless role

    user_roles.find_or_create_by(role: role)
    true
  end

  def remove_role(role_name)
    role = Role.find_by(name: role_name.to_s)
    return false unless role

    user_roles.where(role: role).destroy_all
    true
  end

  def can?(permission)
    # Check if user has any role with this permission
    roles.any? { |role| role.has_permission?(permission) }
  end

  def primary_role
    # Return the highest priority role (admin > moderator > vip > user)
    return roles.find_by(name: "admin") if has_role?("admin")
    return roles.find_by(name: "moderator") if has_role?("moderator")
    return roles.find_by(name: "vip") if has_role?("vip")

    roles.find_by(name: "user") || roles.first
  end

  def role_names
    roles.pluck(:name)
  end

  def role_colors
    roles.pluck(:color)
  end

  def primary_role_color
    primary_role&.color || "#6c757d"
  end

  # Enhanced admin methods - simplified
  def admin?
    has_role?("admin")
  end

  def make_admin!
    add_role("admin")
  end

  def remove_admin!
    remove_role("admin")
  end

  private

  def set_default_locale
    self.locale ||= "de"
  end

  def assign_default_role
    add_role("user") unless roles.any?
  end
end
