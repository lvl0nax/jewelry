ActiveAdmin.register Product do
  collection_action :process_pictures, method: :post do
    ::PictureWorker.perform_async
    render nothing: true
  end
  collection_action :process_products, method: :post do
    ::ProductWorker.perform_async
    render nothing: true
  end
end
