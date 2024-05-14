class SidekiqWorker
  include Sidekiq::Worker
  def perform(who, message)
    logger.info "Message: #{message} from #{who}"
  end
end
