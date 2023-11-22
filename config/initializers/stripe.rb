Rails.configuration.stripe = {
  :publishable_key => 'pk_test_51OERGBSDBGNNOPnKA24JYeFxkvCflnLs1NvE6p8FKYHXq3xp6jBaobG8gXcyPKrO0fTrilYQ9TuOyTKNrYZ0EdNa00ABisvmlU',
  :secret_key      => 'sk_test_51OERGBSDBGNNOPnKQ3KU83IjyZtfGdbb3d6bPqoXxCXF1BWj09OP91ayoQ39i5crlCt571t6xLY5quUMIoc1UGNw00TwNIrHVp'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
