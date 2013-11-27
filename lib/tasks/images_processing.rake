# coding: utf-8
require 'RMagick'

def convert_image
  #Product.update_all for_main_page: false
  failed = []
  flag = false
  counts_not_founded = 0

  #test = File.new('test.txt', 'w')
  mask = File.join(Rails.root, 'app', 'assets', 'images', 'bujua', '*.jpg')
  ims = Dir.glob(mask)
  mask = File.join(Rails.root, 'app', 'assets', 'images', 'bujua', '*.JPG')

  ims |= Dir.glob(mask)

  puts("Search ended\n")
  # test.syswrite("Search ended\n")
  ims.map!{|im| File.basename(im)}
  i = 0
  # test.syswrite("start creating pictures\n")
  puts("start creating pictures\n")
  ims.each{|p|

    i = i + 1
    puts ">>>>>>>>>>>>>>>#{i} iteration<<<<<<<<<<<<<<"
    #test.syswrite("#{ims.join(',')}") # - all name of images
    fname = p.split('.').first
    begin
      flag = true
      product = Product.find_by_article(fname)#.update_attributes(img: true)
      puts '--------- product was found ----------' if product
      puts 'Product updated'
    rescue
      counts_not_founded +=1
      puts '==================================> Product did not found'
      flag = false
    end

    if !flag #File.exists?("#{Rails.root}/public/original/#{fname}.jpg") || !flag
      # TODO: delete all photos if file exists and product did not found
    else
      begin
        puts "===================#{fname}======================"
        error_flag = true
        clown = File.open("#{Rails.root}/public/original/#{fname}.jpg")
        product.photo = clown
        product.save!
        puts '+++++++++++++++ image uploaded ++++++++++++++++++'
        #clown = Magick::Image.read("#{Rails.root}/app/assets/images/bujua/#{p}").first
        #clown.write("#{Rails.root}/public/original/#{fname}.jpg")
        ## test.syswrite("#{Time.now} - read image \n") # - time action
        #puts("#{Time.now} - read image \n") # - time action
        #tmp = clown.resize_to_fit(317, 284)
        ## test.syswrite("resize image \n")
        #puts("resize image \n")
        #tmp.write("#{Rails.root}/public/medium/#{fname}.jpg")
        ## test.syswrite("sace to medium \n")
        #puts("save to medium \n")
        #
        #tmp = clown.resize_to_fit(146, 131)
        ## test.syswrite("resize image \n")
        #puts("resize image \n")
        #tmp.write("#{Rails.root}/public/small/#{fname}.jpg")
        ## test.syswrite("sace to small \n")
        #puts("save to small \n")
        #
        #tmp = clown.resize_to_fit(75, 68)
        ## test.syswrite("resize image \n")
        #puts("resize image \n")
        #tmp.write("#{Rails.root}/public/thumb/#{fname}.jpg")
        ## test.syswrite("sace to thumb \n")
        #puts("save to thumb \n")
        #
        #tmp = clown.resize_to_fit(576, 369)
        #puts("resize to big \n")
        ## test.syswrite("resize to big \n")
        #tmp.write("#{Rails.root}/public/big/#{fname}.jpg")
        ## test.syswrite("save to big \n")
        #puts("save to big \n")
        error_flag = false
      rescue
        puts '========image uploading was failed========='
        #Product.find_by_article(fname).update_attributes(for_main_page: false) if error_flag
      end
    end
    File.delete("#{Rails.root}/app/assets/images/bujua/#{p}")
  }

  puts "unfounded products by images names = #{counts_not_founded}"
end

namespace :images do
  desc 'processing images'
  task processing: :environment do
    convert_image
  end
end
