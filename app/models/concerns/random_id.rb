module Concerns
  module RandomId
    extend ActiveSupport::Concern

    included do
      before_create :generate_random_id

      def generate_random_id
        self.id = SecureRandom.random_number(2**24)
        self.id = SecureRandom.random_number(2**24) while self.class.where(id: id).exists?
      end

      #
      # Javascript doesn't support integers larger than 48-bits, so convert
      # to string if we encounter larger integers during serialization.
      #
      def read_attribute_for_serialization(key)
        v = send(key)
        v = v.to_s if v.is_a?(Integer) && v >= (2**48)
        v
      end
    end
  end
end

#
# Encode integers as strings when Javascript would truncate them.
#
class Numeric
  def as_json(_options = nil)
    if self >= 2**48
      to_s
    else
      self
    end
  end
end
