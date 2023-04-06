web: bundle exec unicorn -c /home/iqdbs/iqdbs/config/unicorn/production.rb
sidekiq: bundle exec sidekiq -c 1 -r ./services/sidekiq_processor.rb -q iqdb
iqdb: iqdb listen2 127.0.0.1:62126 /home/iqdbs/iqdbs/e621.db
