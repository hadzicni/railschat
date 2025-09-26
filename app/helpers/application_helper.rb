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
      # Localized month names
      month_keys = [
        nil, :january, :february, :march, :april, :may, :june,
        :july, :august, :september, :october, :november, :december
      ]
      month_name = I18n.t("months.#{month_keys[localized_time.month]}")
      "#{month_name} #{localized_time.year}"
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
