require "nokogiri"
require "fuzzystringmatch"
require "open-uri"

module GetAddic7ed
  class Episode

    REGEX_SEASON_EPISODE = /\WS?(?<season>\d{1,2})[XE](?<episode>\d{2})\W|\W(?<seasonepisode>[0-9]{3})\W/i
    attr_reader :id, :title, :season, :episode, :filename, :filepath

    def initialize filepath
      @filename = File.basename filepath
      @filepath = filepath

      if results = REGEX_SEASON_EPISODE.match(filename)
        pos = filename.rindex(REGEX_SEASON_EPISODE)
        @title    = filename[0, pos].gsub(/[.]|\s/i, ' ')

        unless results[:seasonepisode]
          @season   = results[:season].to_i
          @episode  = results[:episode].to_i
        else
          @season   = results[:seasonepisode][0].to_i
          @episode  = results[:seasonepisode][1,2].to_i
        end
      else
        raise InvalidFilename
      end

      @id = self.class.get_show_id @title
      raise ShowNotFound if @id == nil
    end

    #Get all show from addic7ed.com
    def self.get_all_shows
      uri = URI('http://www.addic7ed.com/')
      all_shows = {}


      puts "Try to reach Addic7ed.com, please wait..." unless GetAddic7ed::OPT_QUIET

      begin
        body = open(uri)
      rescue
        raise ConnectionError
      end

      html = Nokogiri::HTML(body)

      html.css("#qsShow option").each do |d|
        all_shows[d.text.downcase] = d.attr("value").to_i
      end

      return all_shows
    end

    # Get the show id from the list of all shows
    def self.get_show_id show_title
      all_shows = self.get_all_shows
      # Looking in the show list correponding show_title
      id = all_shows[show_title.to_s.downcase]
      # In case we don't have the exact show name (ex: You're The Worst <> You.are.The.Worst)
      if id == nil
        best_result     = 0
        best_show_id    = 0
        best_show_title = nil

        jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
        all_shows.each do |show, key|
          matching = jarow.getDistance( show.downcase , show_title.to_s.downcase )
          if matching > best_result
            best_result     = matching
            best_show_id    = key
            best_show_title = show
          end
        end

        id = best_show_id
      end

      return id
    end

    def inspect
      puts "Filename".ljust(10) + ": #{@filename}"
      puts "Filepath".ljust(10) + ": #{@filepath}"
      puts "Id".ljust(10) + ": #{@id}"
      puts "Title".ljust(10) + ": #{@title}"
      puts "Season".ljust(10) + ": #{@season}"
      puts "Episode".ljust(10) + ": #{@episode}"
    end

  end
end
