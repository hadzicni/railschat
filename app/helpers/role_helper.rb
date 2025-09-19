module RoleHelper
  def role_badge(user)
    primary_role = user.primary_role
    return "" unless primary_role

    content_tag :span,
                primary_role.name.humanize,
                class: "badge role-badge ms-1",
                style: "background-color: #{primary_role.color}; color: white;"
  end

  def user_can?(permission)
    current_user&.can?(permission)
  end

  def role_color_class(role_name)
    role = Role.find_by(name: role_name)
    return "text-secondary" unless role

    case role.color
    when "#dc3545" then "text-danger"
    when "#fd7e14" then "text-warning"
    when "#6f42c1" then "text-purple"
    when "#28a745" then "text-success"
    else "text-secondary"
    end
  end

  def permission_description(permission)
    t("admin.permissions.#{permission}")
  end
end
