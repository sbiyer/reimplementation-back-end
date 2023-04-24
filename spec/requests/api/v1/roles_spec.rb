require 'swagger_helper'

RSpec.describe 'Roles API', type: :request do

  path '/api/v1/roles' do
    get('list roles') do
      tags 'Roles'
      produces 'application/json'

      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create role') do
      tags 'Roles'
      consumes 'application/json'
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          parent_id: { type: :integer },
          default_page_id: { type: :integer }
        },
        required: [ 'name' ]
      }

      response(201, 'Created a role') do
        let(:role) { { name: 'Role 1' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'invalid request') do
        let(:role) { { name: '' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/roles/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id of the role'

    get('show role') do
      tags 'Roles'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update role') do
      tags 'Roles'
      consumes 'application/json'
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          parent_id: { type: :integer },
          default_page_id: { type: :integer }
        },
        required: [ 'name' ]
      }
      
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'invalid request') do
        let(:role) { { name: '' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update role') do 
      tags 'Roles'
      consumes 'application/json'
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          parent_id: { type: :integer },
          default_page_id: { type: :integer }
        },
        required: [ 'name' ]
      }

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'invalid request') do
        let(:role) { { name: '' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete role') do
      tags 'Roles'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
