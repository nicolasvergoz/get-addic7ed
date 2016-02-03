module GetAddic7ed
  class VideoFile
    attr_reader :filename, :filepath

    def initialize(file)
      @filepath = File.expand_path(file)

      if self.class.file? (@filepath)
        @filename = File.basename(@filepath)
      else
        raise InvalidVideoFile
      end
    end

    def inspect
      puts "Filename".ljust(10) + ": #{@filename}"
      puts "Filepath".ljust(10) + ": #{@filepath}"
    end

    def self.file? filepath
      if File.file? (filepath)
        return true
      else
        raise InvalidFile
      end
    end

    def self.video? filepath
      if File.file? (filepath)
=begin
     TODO : Find a way to make it work on windows, mac os x and linux
=end
        return mimetype(filepath).start_with?("video") || File.extname(filepath) == ".mkv"
      else
        raise WrongArgument
      end
    end

  end
end