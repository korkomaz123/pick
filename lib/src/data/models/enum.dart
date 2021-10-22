enum BottomEnum { home, category, store, wishlist, account }
enum GenderEnum { women, men, kids }
enum ShippingEnum { free, rate }
enum PaymentEnum { cash, visa, knet }
enum OrderStatusEnum {
  canceled,
  closed,
  complete,
  fraud,
  holded,
  order_approval_pending,
  order_approved,
  order_disapproved,
  payment_review,
  paypal_canceled_reversal,
  paypal_reversed,
  pending,
  pending_paypal,
  processing,
  new_pending,
  pending_payment,
  canceled_payment,
  failed_payment
}
enum ProductViewModeEnum { category, brand, filter, sort, celebrity }
enum ProcessStatus { none, process, done, failed }
enum TransactionType { order, transfer, debit, admin_credit, admin_debit }
