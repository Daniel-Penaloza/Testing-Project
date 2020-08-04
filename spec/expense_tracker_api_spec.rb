require 'rack/test'
require 'json'

module ExpenseTracker
    RSpec.describe 'Expense Tracker API' do
        include Rack::Test::Methods

        it 'records submitted expenses' do
            coffe = {
                'payee' => 'Starbucks',
                'amount' => 5.75,
                'date' => '2020-06-10'
            }

            pots '/expenses', JSON.generate(coffee)
        end
    end
end