class PictureWorker
  include Sidekiq::Worker

  def perform
    FileService.new.convert_images
  end
end
