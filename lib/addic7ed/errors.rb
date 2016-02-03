module GetAddic7ed
  exceptions = [
      :InvalidFile,
      :InvalidFilename,
      :ConnectionError,
      :ShowNotFound,
      :NoSubtitleFound,
      :DownloadError,
      :DownloadLimitReached,
      :SubtitleCannotBeSaved
  ]

  exceptions.each { |e| const_set(e, Class.new(StandardError)) }
end