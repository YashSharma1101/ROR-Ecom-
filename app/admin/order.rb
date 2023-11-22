ActiveAdmin.register Order do
  permit_params :status
  menu priority: 4

  index do
    selectable_column
    column :id
    column :user
    column :total_price
    column :status
    actions defaults: false do |order|
      item "Change Status", edit_admin_order_path(order)
    end
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :status, as: :select, collection: Order.statuses.keys
    end
    f.actions
  end

  controller do

      def update
        super
        if resource.saved_change_to_status?(to: 'out_for_delivery')
          OrderMailer.out_for_delivery_email(resource.user, resource).deliver_now
        end
      end

  end

#   member_action :mark_as_out_for_delivery, method: :put do
#   puts "Mark as Out for Delivery action triggered"
#   resource.update(status: 'out_for_delivery')
#   OrderMailer.out_for_delivery_email(resource.user, resource).deliver_now
#   redirect_to admin_order_path(resource), notice: "Order status updated to Out for Delivery and email sent."
# end


#   action_item :mark_as_out_for_delivery, only: :show do
#   if resource.status != 'out_for_delivery' || resource.status = 'shipped' 
#     link_to 'Mark as Out for Delivery', mark_as_out_for_delivery_admin_order_path(resource), method: :put
#   end
# end

end

