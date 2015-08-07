class ProductWorker
  include Sidekiq::Worker

  def perform
    ProductsService.new.import_from_excel
  end
end
