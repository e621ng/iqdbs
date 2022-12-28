class IqdbUpdateJob
  include Sidekiq::Worker

  sidekiq_options queue: 'iqdb'

  def perform(post_id, thumbnail_url)
    server = Iqdb::Server.new(ENV["IQDB_HOSTNAME"], ENV["IQDB_PORT"])
    command = Iqdb::Command.new(ENV["IQDB_DATABASE_FILE"])

    if thumbnail_url[0..3] == "md5:"
      md5 = thumbnail_url[4..-1]
      path = "#{ENV["IMAGES_FOLDER"]}/preview/#{md5[0..1]}/#{md5[2..3]}/#{md5}"
      server.add(post_id, path)
      command.add(post_id, path)
      return
    end

    url = URI.parse(thumbnail_url)

    Tempfile.open("iqdbs") do |f|
      Net::HTTP.start(url.host, url.port, :use_ssl => url.is_a?(URI::HTTPS)) do |http|
        http.request_get(url.to_s) do |res|
          if res.is_a?(Net::HTTPSuccess)
            res.read_body(f)
            size = f.size
            f.close
          else
            raise Exception(res.to_s)
          end
        end
      end
      server.add(post_id, f.path)
      command.add(post_id, f.path)
    end
  end
end
