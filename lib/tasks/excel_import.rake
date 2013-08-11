# coding: utf-8
def import_from_excel
  toCat = []
  objs = []
  articles = []

  catAr = Category.all
  catAr.each {|c| toCat.push("('#{c.title}')")}
  sql = ActiveRecord::Base.connection()
  sql.execute('TRUNCATE products ')
  #file_path = File.join(Rails.root, 'public', 'products.xls')
  tbl = Excel.new('products.xls') #should be original name in root directory for the site
  tbl.default_sheet = tbl.sheets.first

  #TODO: customize to our product

  j = 0
  1.upto(tbl.last_row) do |line|
    j=j+1

    article = tbl.cell(line, 'A')
    next if article.blank? || (articles.include? article)
    type = tbl.cell(line, 'B')
    next if type.blank?
    type = 'серьги' if type.include? 'ерьги'
    price = tbl.cell(line, 'D')
    count = tbl.cell(line, 'E')
    #descr = tbl.cell(line, 'C')
    #     check that category is exists in DB
    i = toCat.index("('#{type}')")
    if i.nil?
      cat_id = toCat.length
      toCat.push("('#{type}')")
    else
      cat_id = i + 1
    end
    objs.push("('#{article}', '#{price.to_i.abs}', '#{cat_id}', '#{count}')")
  end

  #fill DB
  sql.execute('TRUNCATE categories ')
  sql.execute('INSERT INTO categories (title) VALUES ' + toCat.join(',') )
  sql.execute('INSERT INTO products (article, price, category_id, number) VALUES ' + objs.join(','))
end

namespace :excel do
  desc 'excel import'
  task import: :environment do
    import_from_excel
  end
end
