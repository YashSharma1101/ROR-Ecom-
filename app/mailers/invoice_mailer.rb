class InvoiceMailer < ApplicationMailer
  def send_invoice(order, user_email)
    @order = Order.find(order)
    # @order = order
    @user = User.find(@order.user_id)
    html_content = render_to_string(template: 'invoices/invoice')
    pdf = WickedPdf.new.pdf_from_string(html_content)
    attachments['invoice.pdf'] = { mime_type: 'application/pdf', content: pdf}
    mail(to: user_email, subject: 'Invoice for your order')
  end
end

#*********if using prawn gem to generate invoice**********#

# class InvoiceMailer < ApplicationMailer
#   def send_invoice(order, user_email, pdf_invoice)
#     @order = order
#     @user = User.find(@order.user_id)
#     attachments['invoice.pdf'] = File.read(pdf_invoice)
#     mail(to: user_email, subject: 'Invoice for your order')
#   end
# end
