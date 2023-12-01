ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.order("created_at desc").limit(3), class: "dashboard-table" do
            column("Order ID") { |order| link_to(order.id, admin_order_path(order)) }
            column("User") { |order| link_to(order.user.email, admin_user_path(order.user)) }
            column("Total Price") { |order| ("₹" + order.total_price.to_s) }
            column("Status") { |order| status_tag(order.status.capitalize, class: order.status == 'delivered' ? 'ok' : 'warning') }
          end
        end

        panel "Recent Users" do
          table_for User.last(3), class: "dashboard-table" do
            column("Name") { |user| link_to(user.name, admin_user_path(user)) }
            column("Email") { |user| user.email }
            column("Email Verified") { |user| status_tag(user.email_verified? ? 'Yes' : 'No') }
          end
        end
      end

      column do
        panel "Revenue Chart" do
          line_chart Order.group_by_day(:created_at).sum(:total_price), download: true, prefix: "₹", class: "dashboard-chart"
        end
      end
    end

    columns do
      column do
        panel "Top Products by Sales" do
          data = OrderItem.joins(:order)
                          .group(:product_id)
                          .order('sum_quantity DESC')
                          .limit(3)
                          .sum(:quantity)

          products_data = data.map do |product_id, quantity_sold|
            product = Product.find(product_id)
            { name: product.name, quantity_sold: quantity_sold, id: product.id }
          end
          table_for products_data, class: "dashboard-table" do
            column("Product") { |product| link_to(product[:name], admin_product_path(product[:id])) }
            column("Total Quantity Sold") { |product| product[:quantity_sold] }
          end
        end
      end

      column do
        panel "Overall Statistics" do
          para "Total Users: #{User.count}"
          para "Total Orders: #{OrderHistory.count+Order.count}"
          para "Total Revenue: ₹#{OrderHistory.sum(:total_price).to_i+Order.sum(:total_price).to_i}"
        end
      end
    end

    columns do
      column do
        panel "Monthly Statistics" do
          h5 'User Registration Over Time', class: "dashboard-heading"
          div do
            area_chart User.group_by_month(:created_at).count, height: '150px', library: { title: 'User Registration Over Time' }, class: "dashboard-chart"
          end
          h5 'Monthly Order Count', class: "dashboard-heading"
          div do
            line_chart Order.group_by_month(:created_at).count, height: '150px', library: { title: 'Monthly Order Count' }, class: "dashboard-chart"
          end
        end
      end

      column do
        panel "Order Status Distribution" do
          data = Order.group(:status).count
          div do
            pie_chart data, height: '300px', library: { title: 'Order Status Distribution' }, class: "dashboard-chart"
          end
        end
      end
    end
  end
end
