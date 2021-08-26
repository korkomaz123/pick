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
  pending_payment,
  pending_paypal,
  processing
}
enum ProductViewModeEnum { category, brand, filter, sort }
enum ProcessStatus { none, process, done, failed }
enum TransactionType { order, transfer, debit, admin_credit, admin_debit }
