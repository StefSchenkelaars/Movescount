module Movescount
  class Move < OpenStruct
    # Make sure it responds to serialization when loaded in a rails app
    include ActiveModel::Serialization if defined? ActiveModel

    include HTTParty
    raise_on [401, 403, 404, 500]
    # debug_output $stderr

    attr_accessor :member

    def initialize(member, attributes={})
      # raise ArgumentError, 'First argument should be a member' unless member && member.class == Member
      raise ArgumentError, 'Attributes should include a MoveID' unless attributes['MoveID']
      self.class.base_uri Movescount.configuration.api_uri
      @member = member
      super attributes
    end

    # Return the datapoints (samples) of the move
    # Force argument forces reload of data from api
    def samples(force = false)
      # Return samples if present and not forcing reload
      return @samples if @samples && !force
      # Get samples from the api and create points objects
      @samples = get_samples.map do |sample|
        Sample.new self, sample
      end
    end

    # Return the gps points
    # Force argument forces reload of data from api
    def track_points(force = false)
      # Return points if present and not forcing reload
      return @track_points if @track_points && !force
      # Get points from the api and create points objects
      @track_points = get_track_points.map do |track_point|
        TrackPoint.new self, track_point
      end
    end

    # Returns the gps points or the sampmle points when gps not available
    def points
      return @points if @points
      if track_points.any?
        current_index = 0
        # If there are track points available, then create the points based on those
        @points = track_points.map do |track_point|
          # Find the correct index for the corresponding sample
          loop do
            current_index += 1
            # Skip this sample (so loop again) if it is far away from the current point
            break if samples[current_index].LocalTime >= track_point.MeasuredAt - 5e-5
          end
          Point.new self, track_point.to_h.merge(samples[current_index].to_h)
        end
      else
        @points = samples.map do |sample|
          Point.new self, sample.to_h
        end
      end
    end


    private

    # Get the datapoints (samples) of the move from the api
    def get_samples
      self.class.get("/moves/#{self.MoveID}/samples", member.options)['SampleSets']
    end

    # Get the track points from the api
    def get_track_points
      csv_array = self.class.get("/moves/#{self.MoveID}/track", member.options)['Points'] || ''
      # The track points are returned in a csv format where each point is split by a semicolumn
      csv_array.split(';').map do |track_point_csv|
        # Each attribute is then split by a comma
        attributes = {}
        splited = track_point_csv.split(',')
        if splited.length == 4
          attributes[:Latitude] = splited[0].to_f
          attributes[:Longitude] = splited[1].to_f
          attributes[:Altitude] = splited[2].to_f
          attributes[:MeasuredAt] = DateTime.parse(splited[3])
        end
        attributes
      end
    end
  end
end
