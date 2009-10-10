module Sparkline
  def self.included(model)
    model.extend(ClassMethods)
  end

  module ClassMethods
    def counts_grouped_by_created_at_from_past(days)
      all :select => 'COUNT(id) AS count, created_at',
          :group  => 'DATE(created_at)',
          :order  => 'created_at DESC',
          :limit  => days / 1.day
    end

    def sparkline_data_from_past(days)
      records = counts_grouped_by_created_at_from_past(days)
      days    = days / 1.day

      (0..(days - 1)).inject([]) do |result, day|
        date   = day.days.ago.to_date
        record = records.find { |record|
          record.created_at && record.created_at.to_date == date
        }

        result << record.try(:count).to_i
      end.reverse
    end
  end
end
