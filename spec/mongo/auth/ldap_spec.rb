require 'spec_helper'

describe Mongo::Auth::LDAP do

  let(:address) do
    Mongo::Address.new(DEFAULT_ADDRESS)
  end

  let(:monitoring) do
    Mongo::Monitoring.new(monitoring: false)
  end

  let(:listeners) do
    Mongo::Event::Listeners.new
  end

  let(:topology) do
    double('topology')
  end

  let(:cluster) do
    double('cluster', topology: topology)
  end

  let(:server) do
    Mongo::Server.new(address, cluster, monitoring, listeners, TEST_OPTIONS)
  end

  let(:connection) do
    Mongo::Server::Connection.new(server, TEST_OPTIONS)
  end

  let(:user) do
    Mongo::Auth::User.new(database: TEST_DB, user: 'driver', password: 'password')
  end

  describe '#login' do

    context 'when the user is not authorized for the database' do

      let(:cr) do
        described_class.new(user)
      end

      let(:login) do
        cr.login(connection).documents[0]
      end

      it 'logs the user into the connection' do
        expect {
          cr.login(connection)
        }.to raise_error(Mongo::Auth::Unauthorized)
      end
    end
  end
end
