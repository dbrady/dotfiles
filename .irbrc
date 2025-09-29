#!/usr/bin/env ruby

# begin
#   # looksee is awesome. Adds gorgeous Object#ls method
#   # https://github.com/oggy/looksee
#   require 'looksee'
# rescue LoadError => e
#   $stderr.puts "~/.irbrc:#{__LINE__}: Could not load looksee/shortcuts: looksee gem not present in this gemset"
# end

require File.expand_path("~/dotfiles/json_load_file")
require File.expand_path("~/dotfiles/xml_load_file")
require File.expand_path("~/dotfiles/just_your_methods")

begin
  require "text-table"
rescue LoadError
  puts "Could not load gem text-table. explain_conditions() will not work."
end

def code(path, create: false)
  path = File.expand_path(path)
  if !(File.exist?(path) || create)
    puts "Cannot open #{path}. Does it exist? If you want to rerun with create: true"
    return nil
  end
  system "code", path
end
puts "Kernel#code(path) created. code <file> to open in VSCode."

# Hello Acima MP Rails
if defined? Rails

  # model.schema /
  class ApplicationRecord
    class <<self
      def schema(format: nil)
        raise ArgumentError, "format must be :sql or :ruby" if format && ![:sql, :ruby].include?(format)
        # run schema-peek on my table
        command = "#{File.expand_path('~/bin/schema-peek')} #{table_name}"
        puts `#{command}`
      end
    end

    def schema(format: nil)
      self.class.schema
    end
  end

  # TEMP FOR CREDIT-492, PARTS PROBABLY WORTH GENERALIZING
  def prepare_contract_for_credit_492(contract=nil)
    contract ||= Lease.last
    puts "Preparing contract #{contract.lease_number}".yellow

    amount_approved ||= contract.amount_approved
    available_amount ||= contract.amount_approved

    puts "Creating CreditContract".yellow
    credit_contract = CreditContract.create!(amount_approved:, available_amount:, transaction_id: "2222", customer_account_id: 4111_1111_1111_1111.to_s)
    contract.update!(amount_approved:, credit_contract_id: credit_contract.id)

    puts "Setting up conditions".yellow
    conditions = [LeaseConditionType::ID_VERIFICATION, LeaseConditionType::CONFIRM_PURCHASE]
    types = LeaseConditionType.where(code: conditions)
    types.each {|type| LeaseCondition.create!(lease_condition_type: type, lease: contract, how_many_required: 1, required_by_workflow_state: ::Lease::WAITING_FOR_SUPPORTING_DOCUMENTS, is_optional: false )}

    puts "Creating invoice".yellow
    puts ">>>> THIS TAKES A MINUTE, PLEASE BE PATIENT <<<<".bold.white
    ::Scripts::Api::EndPoints::Invoices::V2::CreateOrUpdate.run

    puts "Creating credit invoice".yellow
    contract.invoice.credit_invoice = CreditInvoice.create!(total_amount: contract.amount_approved)
    contract.invoice.save!

    puts "Creating lease contract".yellow
    lease_contract = LeaseContract.create!(
      lease: contract,
      max_approval_amount: amount_approved,
      amount_approved: amount_approved,
      available_amount:amount_approved
    )

    contract.lease_contract = lease_contract
    contract.save!
    puts "Converted lease #{contract.lease_number}: #{contract.applicant.full_name} approved for $#{contract.amount_approved}".yellow

    puts "Click here to open the purchase confirmation customer flow:".yellow
    ::Process::TextMessages::Credit::PurchaseConfirmation::Create.run(lease: contract).url
 end

  class Lease < ApplicationRecord
    def cpt; consumer_product_type; end
    def cpts; consumer_product_types; end

    def workflow_state_history
      last_workflow_state = nil

      versions.map.with_index do |version, index|
        next unless version.object

        object = JSON.parse(version.object)
        workflow_state = object["workflow_state"]
        if last_workflow_state != workflow_state
          last_workflow_state = workflow_state
          timestamp = version.created_at.strftime("%F %T")
          "#{timestamp}: #{workflow_state}"
        end
      end.compact
    end

    # env is one of :localhost, :preflight, :production
    def whatup(env: :localhost)
      lease = self
      template = <<TEMPLATE
Lease ID and Number: <%= lease.id %> (<%= lease.lease_number %>)
Customer: <%= lease.applicant.full_name %>
Location (Merchant): <%= lease.location.dba %> (<%= lease.merchant.dba %>)
User Link: <userspace_url>
Merchant Link: <merchant_url>
TEMPLATE
      puts ERB.new(template).result(binding)
    end
  end

  DAVE_USER_ID=4607
  DAVE_MERCHANT_ID=1
  DAVE_MERCHANT_GUID="merc-c64969e8-50c4-499a-8a5e-379d639cbeeb"
  DAVE_LOCATION_ID=1
  DAVE_LOCATION_GUID="loca-f14ea4eb-9779-4ad1-8578-8bda1287a27a"

  puts 'def load_merchant; Merchant.find(DAVE_MERCHANT_ID); end # Find Zboncak-Adams easily'
  puts 'def load_user; User.find(DAVE_USER_ID); end # Find my user easily'
  puts 'def load_api_user; ApiUser.find(377); end'
  puts "def load_hacks -> load all files in app/local_hacks"

  def load_hacks
    # load all files in app/local_hacks
    Dir.glob(Rails.root + "app/local_hacks/*").each do |file|
      puts "Loading #{file}..."
      load file
    end
    puts "Loaded! Call ApiScript.ls to list important/useful methods"
  end

  # Call this and it will display the next line of source code
  def log_next_line!
    file, line, _ = caller.first.split(/:/)
    line = line.to_i
    source = File.readlines(file)[line]
    source.chomp
    puts source.cyan
  end

  def load_merchant
    log_next_line!
    Merchant.find DAVE_MERCHANT_ID
  end

  def load_location
    log_next_line!
    Location.find DAVE_LOCATION_ID
  end

  def load_user
    log_next_line!
    User.find DAVE_USER_ID
  end

  def load_api_user
    raise "DAVE_API_USER_ID needs to be updated"
    ApiUser.find DAVE_API_USER_ID
  end

  class User < ApplicationRecord
    def add_all_roles!
      puts "Giving all roles to #{full_name}..."
      self.role_names = "|#{Role.all.pluck(:short_name) * '|'}|"
      save
    end

    def make_coworker!(location: nil)
      remove_all_roles!
      roles = %w[location_staff payment_proc invoice_handler apply_handler delivery_handler]
      roles.each {|role| self.add_role!(role) }
      locations_as_assigned_user << location if location
      save
    end

    def make_not_coworker!
      remove_all_roles!
      roles = %w[location_staff payment_proc invoice_handler apply_handler delivery_handler]
      roles.each {|role| self.remove_role!(role) }
    end

    def make_developer!
      remove_all_roles!
      roles = %w(accounting admin auditor lead_proc legal master_admin user_admin developer)
      roles.each {|role| self.add_role!(role) }
    end

    def remove_all_roles!
      puts "Removing all roles from #{full_name}..."
      self.role_names = ''
      save
    end
  end

  # Convenience Preload user / merchant / location
  begin
    user = load_user
    merchant = load_merchant
    location = load_location
  rescue StandardError => e
    puts "Could not load user, merchant, or location: #{e}"
  end

  def load_last_contract
    Lease.order(:created_at).last.tap do |contract|
      puts "Loaded contract #{contract.id} for #{contract.applicant.full_name}"
    end
  end

  def convert_lease_to_credit(contract=nil, amount_approved=nil, available_amount=nil)
    contract ||= Lease.last
    amount_approved ||= contract.amount_approved
    available_amount ||= contract.amount_approved

    puts "Creating CreditContract..."
    credit_contract = CreditContract.create!(amount_approved:, available_amount:)
    contract.update!(amount_approved:, credit_contract_id: credit_contract.id)

    # Add necessary conditions or it won't go
    conditions = [LeaseConditionType::ID_VERIFICATION, LeaseConditionType::CONFIRM_PURCHASE]
    puts "Adding lease conditions #{conditions}"
    types = LeaseConditionType.where(code: conditions)
    puts "Types to add: #{types.map(&:code).inspect}"

    types.each {|type| LeaseCondition.create!(lease_condition_type: type, lease: contract, how_many_required: 1, required_by_workflow_state: ::Lease::WAITING_FOR_SUPPORTING_DOCUMENTS, is_optional: false )}

    # enum is going away, keep this around for old branches
    # contract.credit! if contract.respond_to? :credit!

    puts "Converted lease #{contract.lease_number}: #{contract.applicant.full_name} approved for $#{contract.amount_approved}".yellow
  end

  def add_lease_contract_to_lease(contract=nil)
    contract ||= Lease.last

    lease_contract = LeaseContract.new lease: contract
    lease_contract.max_approval_amount = lease_contract.amount_approved = lease_contract.available_amount = contract.amount_approved
    lease_contract.save!

    contract.lease_contract = lease_contract
    contract.save!
  end

  def signature_url_for_lease(lease=nil)
    lease ||= Lease.last
    signature_url(lease.id)
  end

  def signature_url(lease_id)
    token = ::Legacy::Leasing::LeaseToken.create_token('sign-lease', lease_id)
    url = Rails.application.routes.url_helpers.new_customer_lease_agreements_signatures_url(id: token.to_s)
    url
  end

  # Cadged from Ramses
  def apply!(merchant_id = nil)
    access_token = ::Scripts::Api::Helpers::Auth0Token.generate_access_token(application: :aperture)
    api_user = ::Scripts::Api::Helpers::ApiUser.setup(handle: :api_test)
    headers = ::Scripts::Api::Helpers::Headers.setup(access_token: access_token, user: api_user)
    merchant = merchant_id ? ::Merchant.find(merchant_id) : ::Scripts::Api::Helpers::Merchant.default
    merchant = if merchant_id.present?
                 ::Merchant.find(merchant_id)
               else
                 ::Scripts::Api::Helpers::Merchant.default
               end
    location = merchant.locations.first

    body = generate_application_body(merchant, location)
    path = "/services/api/private/contracts"

    response = ::Scripts::Api::Helpers::Request.post(
      body:    body,
      headers: headers,
      path:    path,
    )
    body = JSON.parse(response.body)
    message = if body["response"].present?
                {
                  status:       body["status"],
                  code:         body["code"],
                  message:      body["message"],
                  lease_id:     body["response"]["id"],
                  guid:         body["response"]["guid"],
                  lease_number: body["response"]["lease_number"],
                  merchant_id:  merchant.id,
                  location_dba: location.dba,
                }
              else
                {
                  status:  body["status"],
                  code:    body["code"],
                  message: body["message"],
                }
              end
    pp(message)
  end

  def explain_conditions(lease=nil)
    conditions ||= Lease.last
    conditions = conditions.lease_conditions

    table = []

    format = "| %3s | %-35s | %-35s | %-9s | %-12s |"
    bar = (format % ["","","","",""]).gsub(/\s/, '-').gsub(/\|/, '+')
    table << bar
    table << format % ["idx", "condition", "required_by_workflow_state", "satisfied", "required_now"]
    table << bar

    conditions.each.with_index do |condition, index|
      color = (condition.required_now? && !condition.satisfied?) ? :red : :green

      table << (format % [
                  index,
                  condition.code,
                  condition.required_by_workflow_state,
                  condition.satisfied?,
                  condition.required_now?
                ]).send(color)
    end
    table << bar

    table.join("\n")

    # table = Text::Table.new
    # table.head = ["idx", "condition", "required_by_workflow_state", "satisfied", "required_now"]
    # table.rows = []

    # conditions.each.with_index do |condition, index|
    #   table.rows << [index, condition.code, condition.required_by_workflow_state, condition.satisfied?, condition.required_now?]
    # end

    puts table
  end

  def generate_application_body(merchant, location)
    {
      contract: {
        mobile_apply_phone:                  "",
        card_application:                    false,
        trustev_session_id:                  "",
        manual_pay:                          nil,
        applicant:                           {
          first_name:                    ::Faker::Name.safe_first_name,
          middle_name:                   "",
          last_name:                     ::Faker::Name.safe_last_name,
          address_1:                     "384 LOGAN AVE",
          address_2:                     "",
          city:                          "SALT LAKE CITY",
          state:                         "UT",
          zip:                           "84115",
          verified_address:              false,
          email:                         "test#{::Faker::Number.digits(9)}@example.com",
          main_phone:                    ::Faker::PhoneNumber.clean_phone_number,
          main_phone_type:               "mobile",
          dob:                           "1935-08-20",
          id_document_number:            "991231231214",
          id_document_state_code:        "UT",
          id_document_type:              "drivers_license",
          id_document_expiry_date:       (DateTime.now + 5.years).strftime("%F"),
          ssn:                           ::Faker::Number.digits(9),
          bank_name:                     "First Utah Bank",
          routing_number:                ::Faker::Bank.routing_number,
          account_number:                ::Faker::Bank.account_number,
          income_source:                 "full_time_job",
          employment_net_monthly_income: "4000",
          income_net_per_paycheck:       "1846",
          income_payment_method:         "direct_deposit",
          last_payday_on:                DateTime.now.strftime("%F"),
          next_payday_on:                (DateTime.now + 1.month).strftime("%F"),
          pay_frequency:                 "monthly",
          income_schedule_recur_on:      "day_of_week",
          income_schedule_recurrence:    {
            start_time: {
              time: "2019-06-02T06:00:00.000Z",
              zone: "Mountain Time (US & Canada)",
            },
            rrules:     [
              {
                validations: {
                  day: [
                    3,
                  ],
                },
                rule_type:   "IceCube::WeeklyRule",
                interval:    2,
                week_start:  0,
              },
            ],
            rtimes:     [],
            extimes:    [],
          },
          income_details_attributes:     {
            transformed_weekly_pay: false,
          },
          application_source:            "merchant",
          referrer_url:                  "http:\/\/localhost:3000\/merchant\/contracts\/2185266",
          tongue_code:                   "en",
        },
        campaign_source:                     {
          utm_source:   "",
          utm_medium:   "",
          utm_campaign: "",
          utm_term:     "",
          utm_content:  "",
          gclid:        "",
        },
        consent_to_automated_communications: false,
        location_guid:                       location.guid,
        merchant_guid:                       merchant.guid,
      },
    }
  end

  def prequal_split(merchant_id: nil)
    merchant_id ||= DAVE_MERCHANT_ID
    puts "::Scripts::Api::EndPoints::Applications::PrequalSplit.run(merchant_id: #{merchant_id})".cyan
    ::Scripts::Api::EndPoints::Applications::PrequalSplit.run(merchant_id:)
  end

  def accept_credit_offer(lease_or_guid: nil)
    lease_guid = if lease_or_guid.is_a? Lease
              lease_or_guid.guid
            elsif lease_or_guid.present?
              lease_or_guid
            else
              Lease.last.guid
            end
    puts "::Scripts::Api::EndPoints::Contracts::SatisfyConditions::AcceptCreditOffer.run(#{lease_guid})".cyan
    ::Scripts::Api::EndPoints::Contracts::SatisfyConditions::AcceptCreditOffer.run(lease_guid)
  end

  def build_signing_url(lease_or_id: nil)
    lease_id = if lease_or_id.is_a? Lease
                   lease_or_id.id
                 elsif lease_or_id.present?
                   lease_or_id
                 else
                   Lease.last.guid
                 end
    puts "::Process::TextMessages::Signatures::BuildSigningUrl.build(#{lease_id})"
    ::Process::TextMessages::Signatures::BuildSigningUrl.build(lease_id)
  end

  def who
    Lease.last.applicant.full_name
  end

end
# End Rails

# jp - like pp, but in JSON.
# - if it response to as_json, it calls that, so jp rails_object will work.
# - if it's a string, tries to JSON parse it first. So jp '{"pants": 42}' will work, and so will jp object.to_json (even though as_json would be more efficient)
def jp(object)
  data = if object.respond_to? :as_json
           object.as_json
         else
           begin
             JSON.parse(object)
           rescue JSON::ParserError
             object
           end
         end

  # TODO: COLORIZE ME. Sadly we don't get that for free from pretty_generate.
  puts JSON.pretty_generate(data)
end

# array_to_table - poor man's text-table
def array_to_table(rows)
  return "" if rows.empty?

  left_justify = Hash.new(false)
  longests = Hash.new(0)

  rows.each do |row|
    row.each.with_index do |item, index|
      left_justify[index] ||= item.to_s =~ /[^0-9\-+.,]/
      longests[index] = [(longests[index] || 0), item.to_s.size].max
    end
  end

  formats = longests.keys.map do |key|
    size = longests[key]
    sign = left_justify[key] ? "-" : ""

    "%#{sign}#{size}s"
  end

  format = "| #{formats.join(' | ')} |"

  rows.each do |row|
    puts format % row
  end

  nil
end

# hash_to_table - poor man's text-table
#
# TODO: Do we care if the rows have different keys? Nah. You get what you get.
def hash_to_table(rows)
  return "" if rows.empty?

  left_justify = Hash.new(false)
  longests = Hash.new(0)

  rows.each do |row|
    row.each_pair do |key, value|
      left_justify[key] ||= value.to_s =~ /[^0-9+.,]/
      longests[key] = [key.size, longests[key], value.size].max
    end
  end

  formats = longests.keys.map do |key|
    size = longests[key]
    sign = left_justify[key] ? "-" : ""

    "%#{sign}#{size}s"
  end

  format = "| #{formats.join(' | ')} |"

  puts format % rows.first.keys

  rows.each do |row|
    puts format % row.values
  end

  nil
end

def to_table(rows)
  return "" if rows.empty?

  longests = Hash.new(0)

  rows.each do |row|
    if row.is_a? Hash
      row.keys.each_pair {|key, value| longests[key] = [key.size, value.to_s.size, longests[key]].max }
    else
      row.each.with_index {|value, index| longests[index] = [value.to_s.size, longests[index]].max }
    end
  end

  format = "| " + longests.values.map {|size| "%#{size}s" }.join(" | ") + " |"

  rows.each do |row|
    values = row.values rescue row
    puts format % values
  end

  nil
end
