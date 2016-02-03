# Get Addic7ed

A simple ruby cli to download your subtitles from [addic7ed.com](www.addic7ed.com).
Inspired by [addic7ed-ruby](https://github.com/michaelbaudino/addic7ed-ruby) with a quiet different way to find subs.


## Installation

```bash
    $ gem install get-addic7ed
```

## Usage

Example : Download an italian subtitle for You're the worst s01e01

```bash
    $ get-addic7ed -l it /path/to/Youre.the.Worst.S01E01.HDTV.x264-ASAP.mp4
```

All options :

```bash
    $ get-addic7ed -h
    Usage :	get-addic7ed [options] <file1> [<file2>, <file3>, ...]
        -l, --language LANGUAGE          Language code for your subtitle (French by default)
        -c, --choose                     Choose your subitle manually
        -t, --tagged                     Include language tag in filename
        -v, --verbose                    Display more details
        -q, --quiet                      Run without output (cron-mode)
        -n, --do-not-download            Do not download the subtitle
        -h, --help                       Display this actual help page
        -L, --all-languages              List all available languages
        -V, --version                    Get get-addic7ed version
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicolasvergoz/get-addic7ed


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

