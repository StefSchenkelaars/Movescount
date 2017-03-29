module Movescount
  class Member
    # Make sure it responds to serialization when loaded in a rails app
    include ActiveModel::Serialization if defined? ActiveModel

    include HTTParty
    raise_on [401, 403, 404, 500]
    # debug_output $stderr
    attr_reader :options

    def initialize(options={})
      raise ArgumentError, 'An email is required as an option' unless options[:email]
      raise ArgumentError, 'A userkey is required as an option' unless options[:userkey]
      self.class.base_uri Movescount.configuration.api_uri
      @options = {
        query: {
          appKey: Movescount.configuration.app_key,
          userKey: options.delete(:userkey),
          email: options.delete(:email)
        }
      }.merge options
    end

    # Returns the entire user profile
    # Force argument forces reload of data from api
    def profile(force = false)
      force ? @profile = get_profile : @profile ||= get_profile
    end

    # Returns the user's movescount username
    def username
      profile['Username']
    end

    # Returns the user's moves
    # Options include: startDate, endDate and maxcount
    # Force argument forces reload of data from api
    def moves(options = {}, force = false)
      # Return moves if present and not forcing reload
      return @moves if @moves && !force
      # Get moves from the api and create move objects
      @moves = get_moves(options).map do |move|
        Move.new self, move
      end
    end

    # Get a move by move_id
    def move_by_id(id)
      Move.new self, self.class.get("/moves/#{id}", @options)
    end

    private

    # Get the moves from the api
    def get_moves(options)
      self.class.get "/members/#{username}/moves", combined_options(options)
    end

    # Get the profile page from the api
    def get_profile
      self.class.get '/members/private', @options
    end

    # Combine the instance variable options hash with arguments options
    def combined_options(options)
      resp = @options
      resp[:query].merge! options
      resp
    end
  end
end
