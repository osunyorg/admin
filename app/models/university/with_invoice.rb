module University::WithInvoice
  extend ActiveSupport::Concern

  included do

    before_save :denormalize_invoice_date

    scope :contributing, -> { where.not(contribution_amount: [nil, 0]) }

    def invoice_proximity
      if next_invoice_in_days < 30
        'danger'
      elsif next_invoice_in_days < 60
        'warning'
      end
    end

    private

    def denormalize_invoice_date
      self.invoice_date_yday = self.invoice_date.nil? ? nil : self.invoice_date.yday
    end

    def next_invoice_in_days
      return 999999 if invoice_date_yday.nil?
      # ignores bisextil year but... who cares?
      today = Time.now.yday
      today < invoice_date_yday ? invoice_date_yday - today : invoice_date_yday + 365 - today
    end

  end
end
