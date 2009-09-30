ActiveRecord::Base.class_eval do
  named_scope :limited, lambda { |limit| { :limit => limit } }
end

