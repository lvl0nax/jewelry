def import_from_excel
  toCat = []
  objs = []

  catAr = Category.all
  catAr.each {|c| toCat.push("('#{c.title}')")}
  sql = ActiveRecord::Base.connection()
  sql.execute("TRUNCATE products ")
  file_path = File.join(Rails.root, 'public', 'qwerty.xls')
  tbl = Excel.new("qwerty.xls") #should be original name in root directory for the site
  tbl.default_sheet = tbl.sheets.first

  #TODO: customize to our product

  j = 0
  2.upto(tbl.last_row) do |line|
    j=j+1

    article = tbl.cell(line, 'A')
    next if article.blank?
    price = tbl.cell(line, 'F')
    type = tbl.cell(line, 'B')
    brand = tbl.cell(line, 'D')
    descr = tbl.cell(line, 'C')
    #     check that category is exists in DB
    i = toCat.index("('#{type}')")
    if i.nil?
      cat_id = toCat.length
      toCat.push("('#{type}')")
    else
      cat_id = i + 1
    end
    objs.push("('#{article}', '#{price.to_i.abs}', '#{brand}','#{cat_id}')")
  end

  #fill DB
  sql.execute("TRUNCATE categories ")
  sql.execute("INSERT INTO `categories` (`title`) VALUES " + toCat.join(','))
  sql.execute("INSERT INTO `products` (`article`, `price`, `brand`, `category_id`) VALUES " + objs.join(','))
end

namespace :excel do
  desc "excel import"
  task import: :environment do
    import_from_excel
  end
end
