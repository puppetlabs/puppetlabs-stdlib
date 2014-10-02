require 'spec_helper'

describe 'filter_hash' do
    @params=[
      {
        'initial_hash' => { 'a' => {'b' => 'c'}, 'bd' => {'b' => 'd'}, 'dc' => {'b' => 'd'} },
        'grep'         => 'd',
        'result'       => { 'bd' => {'b' => 'd'}, 'dc' => {'b' => 'd'} },
      },
      {
        'initial_hash' => { 'a' => {'b' => 'c'}, 'bd' => {'b' => 'd'}, 'dc' => {'b' => 'd'} },
        'grep'         => '^d',
        'result'       => { 'dc' => {'b' => 'd'} },
      },
    ]
    @params.each do | k |
      it "should convert #{k['initial_hash']} to #{k['result']}" do
        should run.with_params(k['initial_hash'], k['grep']).and_return(k['result'])
      end
    end
end

