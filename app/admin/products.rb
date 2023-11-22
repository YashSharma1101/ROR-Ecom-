ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :name, :description, :price, :category_id, :image
   menu priority: 3
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
      f.input :image, as: :file 
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :image do |product|
        if product.image.attached?
          image_tag product.image.variant(resize: "100x100")
        else
          "No image attached"
        end
      end
    end
  end
  index do
    selectable_column
    id_column
    column :name
    column :image do |product|
      if product.image.attached? 
        image_tag product.image.variant(resize: "50x50") rescue nil
      else
        "No image attached"
      end
    end
    column :description
    column :price
    column :category
    
    actions
  end
end
