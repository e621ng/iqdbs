class IQDBRemoveJob
  include Sidekiq::Worker

  sidekiq_options queue: 'iqdb'

  def perform(post_id)
    server = Iqdb::Server.new(ENV["IQDB_HOSTNAME"], ENV["IQDB_PORT"])
    command = Iqdb::Command.new(ENV["IQDB_DATABASE_FILE"])

    server.remove(post_id)
    command.remove(post_id)
  end
end
