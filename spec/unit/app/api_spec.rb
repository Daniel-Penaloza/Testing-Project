require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
    RSpec.describe API do
        include Rack::Test::Methods

        def app
            API.new(ledger: ledger)
        end

        let(:ledger) { instance_double('ExpenseTracker::Ledger') }

        describe 'POST /expenses' do
            def parsing(instruction)
                parsed = JSON.parse(last_response.body)
                expect(parsed).to instruction
            end
            
            let(:expense) { { 'some' => 'data' } }
            # Before HOOK for DRYING the app.
            before do
                allow(ledger).to receive(:record)
                .with(expense)
                .and_return(RecordResult.new(true, 417, nil))
            end
    
            context 'when the expense is successfully recorded' do
                it 'returns the expense id' do
                    post '/expenses', JSON.generate(expense)
                    parsing(include('expense_id' => 417))
                end

                it 'responds with a 200(OK)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(200)
                end
            end

            context 'when the expense fails validation' do
                let(:expense) { { 'some' => 'data' } }
                # Before HOOK for DRYING the app.
                before do
                    allow(ledger).to receive(:record)
                    .with(expense)
                    .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
                end

                it 'returns and error message' do
                    post '/expenses', JSON.generate(expense)
                    parsing(include('error' => "Expense incomplete"))
                end

                it 'returns with a 422 (Unprocessable entity)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(422)
                end
            end
        end
    end
end