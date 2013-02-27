require 'RMagick'

def convert_image
  test = File.new("test.txt", "w")
  mask = File.join(Rails.root, 'app', 'assets', 'images', 'bujua', "*.jpg" )
  ims = Dir.glob(mask)
  mask = File.join(Rails.root, 'app', 'assets', 'images', 'bujua', "*.JPG" )

  ims |= Dir.glob(mask)

  puts("Search ended\n")
  # test.syswrite("Search ended\n")
  ims.map!{|im| File.basename(im)}
  i = 0
  # test.syswrite("start creating pictures\n")
  puts("start creating pictures\n")
  ims.each{|p|
    i = i + 1
    puts "#{i} iteration"
    #test.syswrite("#{ims.join(',')}") # - all name of images
    fname = p.split(".").first
    clown = Magick::Image.read("#{Rails.root}/app/assets/images/bujua/#{p}").first
    clown.write("#{Rails.root}/public/original/#{fname}.jpg")
    # test.syswrite("#{Time.now} - read image \n") # - time action
    puts("#{Time.now} - read image \n") # - time action
    tmp = clown.resize_to_fit(130, 130)
    # test.syswrite("resize image \n")
    puts("resize image \n")
    tmp.write("#{Rails.root}/public/thumb/#{fname}.jpg")
    # test.syswrite("sace to thumb \n")
    puts("sace to thumb \n")
    tmp = clown.resize_to_fit(600, 800)
    puts("resize to medium \n")
    # test.syswrite("resize to medium \n")
    tmp.write("#{Rails.root}/public/medium/#{fname}.jpg")
    # test.syswrite("save to medium \n")
    puts("save to medium \n")
    File.delete("#{Rails.root}/app/assets/images/bujua/#{p}")
  }
end

namespace :images do
  desc "processing images"
  task :processing => :environment do
    convert_image
  end
end
