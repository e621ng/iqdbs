web: bundle exec ruby web/iqdbs.rb
sidekiq: bundle exec sidekiq -c 2 -r ./services/sidekiq_processor.rb -q iqdb
iqdb: iqdb listen2 127.0.0.1:62126 /home/vagrant/iqdbs/e621.db
