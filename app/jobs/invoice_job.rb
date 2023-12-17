class InvoiceJob < ApplicationJob
  queue_as :default

  def perform(order_id, user_email)
    order = Order.find(order_id)
    InvoiceMailer.send_invoice(order, user_email).deliver_now
  end
end

#********************if using prawn gem to generate the invoice pdf**************************************#
# require 'prawn'
# require 'open-uri'
# require 'tempfile'

# class InvoiceJob < ApplicationJob
#   queue_as :default
#   def perform(order_id, user_email)
#     order = Order.find(order_id)
#     pdf_invoice = generate_invoice_pdf(order)
#     InvoiceMailer.send_invoice(order, user_email, pdf_invoice).deliver_now
#   end
#   private

# 	def generate_invoice_pdf(order)
# 	  temp_file = Tempfile.new(['invoice', '.pdf'], encoding: 'ascii-8bit')

# 	  logo_url = 'https://i.postimg.cc/gcKQJqW0/Sz-1-11.png'
# 	  logo_tempfile = Tempfile.new(['logo', '.png'])
# 	  logo_tempfile.binmode
# 	  logo_tempfile.write(open(logo_url).read)
# 	  logo_tempfile.rewind

# 	  Prawn::Document.generate(temp_file.path, margin: [20, 50, 20, 50]) do |pdf|
# 	    pdf.font 'Helvetica'
# 	    pdf.font_size 10
# 	    lineheight_y = 12

# 	    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
# 	      pdf.image logo_tempfile.path, width: 75
# 	      pdf.move_down 10

# 	      pdf.text "ShopZone", size: 16, style: :bold
# 	      pdf.text "22 A-10 Road, Ujjain (456001)", leading: 2
# 	      pdf.text "MP, India", leading: 2
# 	      pdf.move_down 15

# 	      pdf.text "Customer Details", size: 12, style: :bold
# 	      client_info = User.find(order.user_id)
# 	      pdf.text "Customer Name: #{client_info.name}", leading: 2
# 	      pdf.text "Customer Email:#{client_info.email}", leading: 2
# 	      pdf.text "Customer Address: Indore, MP India (452001)", leading: 2
# 	    end

# 			pdf.move_down 20
# 			pdf.text "Invoice Details", size: 12, style: :bold
# 			pdf.move_down 2
# 			pdf.text "Invoice: ##{rand(10000..99999)}", leading: 2
# 	    pdf.text "Invoice Date: #{order.created_at.strftime('%B %e, %Y')}", leading: 2
	    

# 			pdf.move_down 20
# 	    pdf.text "Product Details", size: 12, style: :bold
# 	    pdf.move_down 2
# 	    order.order_items.each do |item|
# 	    	pdf.move_down 1
# 	      product = item.product
# 	      pdf.text "#{product.name}", leading: 2
# 	      pdf.text "Description: #{product.description}", leading: 2
# 	      pdf.text "Quantity: #{item.quantity}", leading: 2
# 	      pdf.text "Unit Price: #{product.price} INR", leading: 2
# 	      pdf.text "Total Price: #{order.total_price} INR", leading: 2
# 	      pdf.move_down 10
# 	    end

# 			pdf.move_down 20
# 			pdf.text "Invoice Totals", size: 12, style: :bold
# 			pdf.move_down 5

# 			pdf.text "Total: #{order.total_price} INR", leading: 2
# 	    pdf.text "Amount Paid: #{order.total_price} INR", leading: 2
# 	    pdf.text "Amount Due:  0.00 INR", leading: 2

# 	    pdf.move_down 20
# 	    pdf.text "Notes", size: 12, style: :bold
# 	    pdf.text "Thank you for doing business with ShopZone"
# 	  end

# 	  logo_tempfile.close
# 	  logo_tempfile.unlink
# 	  temp_file.rewind
# 	  temp_file.close
# 	  temp_file.path
# 	end
# end

