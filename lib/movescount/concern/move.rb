module Movescount
  module Concern
    module Move
      def self.included(base)
        base.extend ClassMethods
      end

      # Get the movescount move
      def movescount_move
        return unless self[movescount_options[:move_id_column]] && movescount_member
        @movescount_move ||= Movescount::Move.new(movescount_member, 'MoveID' => self[movescount_options[:move_id_column]])
      end

      # Save the points to the database
      def movescount_save
        self.class.transaction do
          # First delete all point
          public_send(movescount_options[:points_relation]).public_send(movescount_options[:points_clear_method])
          # Then for each point create a new point
          movescount_move.points.each do |point|
            attributes = {}
            movescount_options[:point_attributes].each do |attribute, target|
              attributes[target] = point.public_send(attribute) if target
            end
            unless attributes.empty?
              if persisted?
                public_send(movescount_options[:points_relation]).create attributes
              else
                public_send(movescount_options[:points_relation]).build attributes
              end
            end
          end
        end
      end

      private

      # Get the set options. Getting the defaults is ugly with send but its ok for now
      def movescount_options
        self.class.movescount_options || self.class.send(:movescount)
      end

      # Returns the movescount member object
      def movescount_member
        return unless public_send(movescount_options[:member_relation])
        public_send(movescount_options[:member_relation]).movescount_member
      end

      module ClassMethods
        attr_reader :movescount_options

        private

        # Allow to set the options from the class
        def movescount(options = {})
          default_options = {
            move_id_column: :movescount_move_id,
            member_relation: :user,
            points_relation: :points,
            points_clear_method: :delete_all,
            point_attributes: {
              Latitude: nil,
              Longitude: nil,
              Altitude: nil,
              Cadence: nil,
              Distance: nil,
              HeartRate: nil,
              Power: nil,
              Speed: nil,
              Temperature: nil,
              MeasuredAt: nil
            }
          }
          @movescount_options = default_options.merge options
        end
      end
    end
  end
end
