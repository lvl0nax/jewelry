class ProductsService
  def initialize
    excel = File.join(Rails.root, 'public', 'tmp', 'products.xls')
    @table = ::Roo::Excel.new(excel)
  end

  ###TODO implement images deleting for deleted products
  def import_from_excel
    ::Product.truncate_table
    @table.default_sheet = @table.sheets.first
    products = []
    i=0
    1.upto(@table.last_row) do |line|
      i+=1
      article = @table.cell(line, 'A')
      type = @table.cell(line, 'B')
      next if article.blank? || type.blank?
      type = 'серьги' if type.include? 'ерьги'
      price = @table.cell(line, 'D')
      count = @table.cell(line, 'E')
      time =  Time.zone.now.to_s.sub(' UTC', '')
      cat_id =
        ::Category.find_or_create_by(title: type).try(:id)
      products.push("('#{article}', '#{price.to_f.abs}', '#{cat_id}', '#{count.to_i}', '#{time}', '#{time}')")
      if i == 1000
        ::Product.append_new(products)
        products = []
      end
    end
    ::Product.append_new(products)
  end
end
