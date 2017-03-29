module Movescount
  module Concern
    module Member
      def self.included(base)
        base.extend ClassMethods
      end

      # Returns the Movescount Member object
      def movescount_member
        return unless self[movescount_options[:email_column]]
        @movescount_member ||= Movescount::Member.new(email: self[movescount_options[:email_column]], userkey: movescount_userkey)
      end

      private

      # Get the set options. Getting the defaults is ugly with send but its ok for now
      def movescount_options
        self.class.movescount_options || self.class.send(:movescount)
      end

      # Returns the user's movescount user key
      def movescount_userkey
        unless self[movescount_options[:userkey_column]]
          self[movescount_options[:userkey_column]] = SecureRandom.base58(15)
          save! if persisted?
        end
        self[movescount_options[:userkey_column]]
      end

      module ClassMethods
        attr_reader :movescount_options

        private

        # Allow to set the options from the class
        def movescount(options = {})
          default_options = {
            email_column: :movescount_email,
            userkey_column: :movescount_userkey
          }
          @movescount_options = default_options.merge options
        end
      end
    end
  end
end
