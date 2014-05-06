require 'spec_helper'
require 'pry'

describe Podunk::App::Router::Route do
  before do
    described_class.init_routes!
  end

  describe '#match' do
    let(:route) { described_class.new 'GET', route_path, route_method }

    let(:match) { route.match(request_path) }

    subject { match.method }

    context 'static route' do
      let(:route_method)  { 'foo_bar' }
      let(:route_path)    { "/foo/bar" }
      let(:request_path)  { route_path }

      context 'matching route - method' do
        subject { match.method }
        it { should eq route_method }
      end

      context 'not matching route' do
        subject { route.match '/boof' }
        it { should be_nil }
      end
    end

    context 'route w/ param' do
      let(:param_name)   { 'id' }
      let(:route_method) { 'hoge' }
      let(:route_path)   { "/hogera/:#{param_name}" }

      let(:param_value)  { "123" }
      let(:request_path) { "/hogera/#{param_value}" }

      let(:params) { { param_name => param_value } }

      context 'matching route' do
        context 'method' do
          it { should eq route_method }
        end

        context 'params' do
          subject { match.params }
          it { should eq params }
        end
      end

      context 'not matching route' do
        subject { route.match '/boof' }
        it { should be_nil }
      end
    end
  end

  describe '.for' do
    context 'w/ index & show routes' do
      let(:index_path) { "/hogera" }
      let(:show_path)  { "/hogera/:id" }

      let(:index_method) { "hogera_index" }
      let(:show_method)  { "hogera_show" }

      let!(:index_route) { described_class.new 'GET', index_path, index_method }
      let!(:show_route)  { described_class.new 'GET', show_path, show_method }

      context 'index route' do
        subject { described_class.for('GET', '/hogera').method }
        it { should eq index_method }
      end

      context 'show route' do
        subject { described_class.for('GET', '/hogera/123').method }
        it { should eq show_method }
      end
    end
  end
end
