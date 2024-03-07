locals {
  frauddetector_entities = {
    customer = {
      name        = "customer"
      description = "Customer"
    }
  }
  frauddetector_labels = {
    legit = {
      name        = "legit"
      description = "Legit"
    }
    fraud = {
      name        = "fraud"
      description = "Fraud"
    }
  }
  frauddetector_outcomes = {
    approve = {
      name        = "approve"
      description = "Approve"
    }
    quarantine = {
      name        = "quarantine"
      description = "Quarantine"
    }
    decline = {
      name        = "decline"
      description = "Decline"
    }
  }
  frauddetector_variables = {
    billing-city = {
      name               = "billing_city",
      variable_type      = "BILLING_CITY",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing City"
    }
    billing-country = {
      name               = "billing_country",
      variable_type      = "CATEGORICAL",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing Country"
    }
    billing-latitude = {
      name               = "billing_latitude",
      variable_type      = "NUMERIC",
      data_type          = "FLOAT",
      data_source        = "EVENT",
      data_value_default = "0.0"
      description        = "Billing Latitude"
    }
    billing-longitude = {
      name               = "billing_longitude",
      variable_type      = "NUMERIC",
      data_type          = "FLOAT",
      data_source        = "EVENT",
      data_value_default = "0.0"
      description        = "Billing Longitude"
    }
    billing-phone = {
      name               = "billing_phone",
      variable_type      = "PHONE_NUMBER",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing Phone"
    }
    billing-state = {
      name               = "billing_state",
      variable_type      = "BILLING_STATE",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing State"
    }
    billing-street = {
      name               = "billing_street",
      variable_type      = "BILLING_ADDRESS_L1",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing State"
    }
    billing-zip = {
      name               = "billing_zip",
      variable_type      = "BILLING_ZIP",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Billing ZIP"
    }
    card-bin = {
      name               = "card_bin",
      variable_type      = "CARD_BIN",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Card ID"
    }
    customer-email = {
      name               = "customer_email",
      variable_type      = "EMAIL_ADDRESS",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Customer Email"
    }
    customer-job = {
      name               = "customer_job",
      variable_type      = "CATEGORICAL",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Customer Job"
    }
    customer-name = {
      name               = "customer_name",
      variable_type      = "CATEGORICAL",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Customer Name"
    }
    ip-address = {
      name               = "ip_address",
      variable_type      = "IP_ADDRESS",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "IP Address"
    }
    merchant = {
      name               = "merchant",
      variable_type      = "CATEGORICAL",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Merchant Nane"
    }
    order-price = {
      name               = "order_price",
      variable_type      = "PRICE",
      data_type          = "FLOAT",
      data_source        = "EVENT",
      data_value_default = "0.0"
      description        = "Order Price"
    }
    payment-currency = {
      name               = "payment_currency",
      variable_type      = "CURRENCY_CODE",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Payment Currency"
    }
    product-category = {
      name               = "product_category",
      variable_type      = "PRODUCT_CATEGORY",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Product Category"
    }
    user-agent = {
      name               = "user_agent",
      variable_type      = "USERAGENT",
      data_type          = "STRING",
      data_source        = "EVENT",
      data_value_default = "<null>"
      description        = "Browser Version"
    }
  }
  frauddetector_events = {
    customer-transaction = {
      name     = "customer_transaction"
      labels   = ["fraud", "legit"]
      entities = ["customer"]
      variables = [
        "billing-city",
        "billing-country",
        "billing-latitude",
        "billing-longitude",
        "billing-phone",
        "billing-state",
        "billing-street",
        "billing-zip",
        "card-bin",
        "customer-email",
        "customer-job",
        "customer-name",
        "ip-address",
        "merchant",
        "order-price",
        "payment-currency",
        "product-category",
        "user-agent",
      ]
      description = "Customer Transaction"
    }
  }
  frauddetector_detectors = {
    customer-transactions = {
      name   = "customer_transactions"
      event  = "customer-transaction"
      models = ["arn:aws:frauddetector:ap-southeast-1:316388132307:model-version/ONLINE_FRAUD_INSIGHTS/customer_transactions/2.0"]
      status = "DRAFT"
      rules = [
        {
          language   = "DETECTORPL"
          outcomes   = ["decline"]
          expression = "$customer_transactions_insightscore > 900"
          id         = "rule_customer_transactions_decline"
        },
        {
          language   = "DETECTORPL"
          outcomes   = ["quarantine"]
          expression = "$customer_transactions_insightscore > 750"
          id         = "rule_customer_transactions_quarantine"
        },
        {
          language   = "DETECTORPL"
          outcomes   = ["approve"]
          expression = "$customer_transactions_insightscore <= 750"
          id         = "rule_customer_transactions_approve"
        }
      ]
    }
  }
}

resource "awscc_frauddetector_entity_type" "main" {
  for_each    = local.frauddetector_entities
  name        = each.value.name
  description = lookup(each.value, "description", null)
  tags        = [for k, v in local.common_tags : { key = k, value = v }]
}

resource "awscc_frauddetector_label" "main" {
  for_each    = local.frauddetector_labels
  name        = each.value.name
  description = lookup(each.value, "description", null)
  tags        = [for k, v in local.common_tags : { key = k, value = v }]
}

resource "awscc_frauddetector_outcome" "main" {
  for_each    = local.frauddetector_outcomes
  name        = each.value.name
  description = lookup(each.value, "description", null)
  tags        = [for k, v in local.common_tags : { key = k, value = v }]
}

resource "awscc_frauddetector_variable" "main" {
  for_each      = local.frauddetector_variables
  name          = each.value.name
  description   = lookup(each.value, "description", null)
  variable_type = each.value.variable_type
  data_type     = each.value.data_type
  data_source   = each.value.data_source
  default_value = each.value.data_value_default
  tags          = [for k, v in local.common_tags : { key = k, value = v }]
}

resource "awscc_frauddetector_event_type" "main" {
  for_each    = local.frauddetector_events
  name        = each.value.name
  description = lookup(each.value, "description", null)

  labels = [for k in each.value.labels : {
    arn = awscc_frauddetector_label.main[k].arn
  }]

  entity_types = [for k in each.value.entities : {
    arn = awscc_frauddetector_entity_type.main[k].arn
  }]

  event_variables = [for k in each.value.variables : {
    arn = awscc_frauddetector_variable.main[k].arn
  }]

  tags = [for k, v in local.common_tags : { key = k, value = v }]
}

resource "awscc_frauddetector_detector" "main" {
  for_each                = local.frauddetector_detectors
  detector_id             = each.value.name
  detector_version_status = each.value.status

  event_type = {
    name = awscc_frauddetector_event_type.main[each.value.event].name
  }

  rule_execution_mode = "ALL_MATCHED"

  rules = [for v in each.value.rules : {
    rule_id     = v.id
    detector_id = each.value.name
    language    = v.language
    expression  = v.expression
    outcomes    = [for k in v.outcomes : { arn = awscc_frauddetector_outcome.main[k].arn }]
    tags        = [for k, v in local.common_tags : { key = k, value = v }]
  }]

  tags = [for k, v in local.common_tags : { key = k, value = v }]
}
