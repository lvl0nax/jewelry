class FileService
  def initialize
    @files = Dir.glob(File.join(Rails.root, 'public', 'tmp', '*.{jpg,JPG,png,PNG}'))
  end

  def convert_images
    @files.each do |img|
      begin
        file_name = File.basename(img)
        file = File.join(Rails.root, 'public', 'tmp', file_name)
        article = file_name.split('.').first
        product = Product.find_by(article: article)
        if product
          product.photo = File.open(file)
          product.save!
        end
      ensure
        File.delete(file)
      end
    end
  end
end
