class OrderMailer < ApplicationMailer
  def out_for_delivery_email(user, order)
    @user = user
    @order = order
    html_content = render_to_string(template: 'invoices/invoice')
    pdf = WickedPdf.new.pdf_from_string(html_content)
    attachments['invoice.pdf'] = { mime_type: 'application/pdf', content: pdf}
    mail(to: @user.email, subject: 'Your Order is Out for Delivery, Verify Your Order')
  end
end
