class InvoiceMailer < ApplicationMailer
  def send_invoice(order, user_email, pdf_invoice)
    @order = order
	attachments['invoice.pdf'] = File.read(pdf_invoice)
    mail(to: user_email, subject: 'Invoice for your order')
  end
end
