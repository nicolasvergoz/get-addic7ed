module GetAddic7ed
  class VideoFile
    attr_reader :filename, :filepath

    def initialize(file)
      @filepath = File.expand_path(file)
      @filename = File.basename(@filepath)
    end

    def inspect
      puts "Filename".ljust(10) + ": #{@filename}"
      puts "Filepath".ljust(10) + ": #{@filepath}"
    end

  end
end