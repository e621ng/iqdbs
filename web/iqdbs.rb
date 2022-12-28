$:.unshift(File.expand_path("../../lib", __FILE__))

require "dotenv"
Dotenv.load

require "sinatra"
require "json"
require "iqdb/responses/collection"
require "iqdb/responses/error"
require "iqdb/responses/responses"
require "iqdb/server"
require "iqdb/command"

set :port, ENV["SINATRA_PORT"]

def find_referer(url)
  if url =~  /\Ahttps?:\/\/(?:\w+\.)?pixiv\.net/ || url =~ /\Ahttps?:\/\/i\.pximg\.net/
    return "https://www.pixiv.net"
  end

  if url =~ %r{https?://lohas\.nicoseiga\.jp} || url =~ %r{https?://seiga\.nicovideo\.jp}
    return "https://seiga.nicovideo.jp"
  end

  return nil
end

search = lambda do
  server = Iqdb::Server.default

  begin
    if params["file"]
      file = params["file"]
      results = server.query(3, file["tempfile"].path)
    elsif params["url"]
      url = params["url"]
      ref = params["ref"] || find_referer(url)
      results = server.download_and_query(url, ref, 3)
    end

    content_type :json
    results.to_json
  rescue Iqdb::Responses::Error => e
    content_type :json
    JSON.generate({"error" => e.to_s})
  end
end

get "/favicon.ico" do
  204
end

post "/similar", &search

get "/similar", &search

get "/" do
	redirect "/index.html"
end
