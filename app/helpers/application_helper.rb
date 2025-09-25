module ApplicationHelper
  # Format datetime for German locale with Berlin timezone
  def format_datetime(datetime, format = :default)
    return unless datetime

    localized_time = datetime.in_time_zone("Berlin")

    case format
    when :short_time
      localized_time.strftime("%H:%M")
    when :date_time
      localized_time.strftime("%d.%m.%Y um %H:%M")
    when :date_only
      localized_time.strftime("%d.%m.%Y")
    when :month_year
      # German month names
      month_names = {
        1 => "Januar", 2 => "Februar", 3 => "März", 4 => "April",
        5 => "Mai", 6 => "Juni", 7 => "Juli", 8 => "August",
        9 => "September", 10 => "Oktober", 11 => "November", 12 => "Dezember"
      }
      "#{month_names[localized_time.month]} #{localized_time.year}"
    else
      localized_time.strftime("%d.%m.%Y um %H:%M")
    end
  end

  # Time ago in words with proper German locale
  def time_ago_german(datetime)
    return unless datetime

    localized_time = datetime.in_time_zone("Berlin")
    time_ago_in_words(localized_time)
  end
end
