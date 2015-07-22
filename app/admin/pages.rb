ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :mtitle
      f.input :mdesc
      f.input :mkeywords
    end

    f.buttons
  end
  
end
