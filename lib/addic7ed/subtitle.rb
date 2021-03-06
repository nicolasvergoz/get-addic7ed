require "nokogiri"
require "fuzzystringmatch"
require "open-uri"
require 'net/http'

module GetAddic7ed
  class Subtitle
    attr_reader :episode, :lang, :page, :all, :link, :group

    def initialize episode, lang = 'fr'
      @episode  = episode # Episode instance
      @lang     = lang
      @page     = get_page_link

      @all = get_subtitles
      if @all.length == 1
        @link   = @all.first[:link]
        @group  = @all.first[:group]
      end

    end

    def inspect
      puts "Sub Lang".ljust(25) + ": #{GetAddic7ed::LANGUAGES[@lang][:name]}"
      #TODO puts "Hearing Impaired".ljust(25) + ": #{@hi}"
      puts "Page Link".ljust(25) + ": #{@page}"
      unless @link == nil
        puts "Group".ljust(25) + ": #{@group}"
        puts "Download Link".ljust(25) + ": #{@link}"
      else
        puts "#{@all.length} subtitles available"
=begin
        @all.each do |item|
          print "\n-".ljust(3)
          print "#{item[:group]}".ljust(25)
          print "#{item[:lang]}".ljust(25)
          print "#{item[:completed]}".ljust(20)
        end
        print "\n"
=end
      end

    end

    def get_page_link
      return "http://www.addic7ed.com/ajax_loadShow.php?show=#{@episode.id}&season=#{@episode.season}&langs=&hd=undeENDed&hi=#{@hi}"
    end

    def get_subtitles
      puts "Searching for <#{GetAddic7ed::LANGUAGES[@lang][:name]}> subtitles..." unless GetAddic7ed::OPT_QUIET

      # sub list
      sub_list = get_sub_list

      if sub_list.length == 0
        raise NoSubtitleFound
      else
        return sub_list
      end
    end

    def get_sub_list
      sub_list      = []
      all_sub_list  = []

      link = get_page_link
      uri = URI(link)

      begin
        body = open(uri)
      rescue
        raise ConnectionError
      end

      html = Nokogiri::HTML(body)

      html.css("#season table tbody tr.epeven").each do |sub|

        current_sub = {
            season: sub.children[0].text,
            episode: sub.children[1].text,
            lang: sub.children[3].text,
            group: sub.children[4].text,
            completed: sub.children[6].text,
            link: "http://www.addic7ed.com#{sub.children[10].children.first['href']}"
        }

        sub_list.push (current_sub) if (
            sub.children[0].text.to_i     == @episode.season &&
            sub.children[1].text.to_i     == @episode.episode &&
            sub.children[3].text.downcase == LANGUAGES[@lang][:name].downcase &&
            sub.children[6].text          == 'Completed'
        )

        all_sub_list.push ( current_sub ) if (
            sub.children[0].text.to_i == @episode.season &&
            sub.children[1].text.to_i == @episode.episode
        )

        next
      end

      if GetAddic7ed::OPT_CHOOSE
        return all_sub_list
      end

      if sub_list.length > 0
        # Looking for the corresponding subtitle sub group in filename
        sub_list.each_index do |i|
          if (@episode.filename.downcase =~ /#{Regexp.escape( sub_list[i][:group].downcase )}/ ) != nil
            puts "> #{@episode.title} : S#{sub_list[i][:season].rjust(2, '0')}E#{sub_list[i][:episode].rjust(2, '0')}, #{sub_list[i][:lang]}, #{sub_list[i][:group]}"  unless GetAddic7ed::OPT_QUIET

            return Array.new.push( sub_list[i] )
          end
        end
      end

      return sub_list.length > 0 ? sub_list : all_sub_list
    end

    def choose_sub sub_list
      if GetAddic7ed::OPT_CHOOSE
        puts "Choose a subtitle :"
      else
        puts "No perfect match found.\nBut you can choose one of those instead :"
      end

      sub_list.each_index do |i|
        print "\n#{i+1} -".ljust(6)
        print "#{sub_list[i][:group]}".ljust(25)
        print "#{sub_list[i][:lang]}".ljust(25)
        print "#{sub_list[i][:completed]}".ljust(20)
      end

      puts "\n\nType 'exit' or '0' or 'q' to cancel.\n\n"

      choice = -1

      until (choice.to_i >= 1 && choice.to_i <= sub_list.length)
        puts "* Which subtitle do you want ?"
        print "> "
        choice = STDIN.gets.chomp

        if choice === "exit" || choice === "0" || choice === "q"
          puts "Done."
          exit
        else
          choice = choice.to_i
        end
      end

      return choice-1
    end

    def download_sub

      if @link == nil
        the_one = @all[choose_sub(@all)]
        @link   = the_one[:link]
      end

      dir_path = File.dirname(@episode.filepath)
      sub_name = File.basename(@episode.filepath, '.*')

      begin
        srt_filename = "#{dir_path}/#{sub_name}#{('.' + @lang) if GetAddic7ed::OPT_TAGGED}.srt"

        #TODO check download limit /^\/downloadexceeded.php/.match

        File.open(srt_filename, "wb") do |saved_file|
          open("#{@link}", "rb", "Referer" => @page) do |read_file|
            saved_file.write(read_file.read)
          end
        end
        puts "Subtitle downloaded !"  unless GetAddic7ed::OPT_QUIET
        puts srt_filename  unless GetAddic7ed::OPT_QUIET
      rescue
        raise DownloadError
      end
    end

    def to_h
      return {episode: @episode.to_h, lang: @lang, page: @page, all: @all, link: @link, group: @group}
    end

  end
end
