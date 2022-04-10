require 'cgi'

module Trashinfo
  def self.new (path)
    trashinfo_string = <<~DESKTOP
      [Trash Info]
      Path=#{CGI.escape(File.expand_path path)}
      DeletionDate=#{Time.now.strftime('%Y-%m-%dT%H:%M:%S')}
    DESKTOP
  end

  def self.parse (trashinfo)
    regex = /\A\[Trash Info\]\nPath=(?<path>\S+)\nDeletionDate=(?<deletion_date>\S+)/m

    matches = regex.match trashinfo

    parts = {
      :path => CGI.unescape(matches[:path]),
      :deletion_date => matches[:deletion_date]
    }
  end
end
