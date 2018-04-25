require 'test_helper'

module Steem
  class AccountHistoryApiTest < Steem::Test
    def setup
      @api = Steem::AccountHistoryApi.new rescue skip('AccountHistoryApi is disabled.')
      @jsonrpc = Jsonrpc.new
      @methods = @jsonrpc.get_api_methods[@api.class.api_name]
    end
    def test_api_class_name
      assert_equal 'AccountHistoryApi', Steem::AccountHistoryApi::api_class_name
    end
    
    def test_inspect
      assert_equal "#<AccountHistoryApi [@chain=steem, @url=https://api.steemit.com]>", @api.inspect
    end
    
    def test_method_missing
      assert_raises NoMethodError do
        @api.bogus
      end
    end
    
    def test_all_respond_to
      @methods.each do |key|
        assert @api.respond_to?(key), "expect rpc respond to #{key}"
      end
    end
    
    def test_get_account_history
      vcr_cassette('get_account_history') do
        options = {
          account: 'steemit',
          start: 0,
          limit: 0
        }
        
        @api.get_account_history(options) do |result|
          assert_equal Hashie::Array, result.history.class
        end
      end
    end
    
    def test_get_ops_in_block
      vcr_cassette('get_ops_in_block') do
        options = {
          block_num: 0,
          only_virtual: true
        }
        
        @api.get_ops_in_block(options) do |result|
          assert_equal Hashie::Array, result.history.class
        end
      end
    end
    
    def test_get_transaction
      vcr_cassette('get_transaction') do
        options = {
          id: '0000000000000000000000000000000000000000',
        }
        
        @api.get_transaction(options) do |result|
          assert_equal Hashie::Array, result.history.class
        end
      end
    end
  end
end
