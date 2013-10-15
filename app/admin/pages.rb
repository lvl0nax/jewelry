ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :description, as: :html_editor
      f.input :mtitle
      f.input :mdesc
      f.input :mkeywords
    end

    f.buttons
  end
  
end
