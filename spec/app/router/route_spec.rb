require 'spec_helper'

describe Podunk::App::Router::Route do
  describe '#match' do
    let(:match) { route.match(request_path) }
    subject { match.method }

    context 'static route' do
      let(:route_method)  { 'foo_bar' }
      let(:route_path)    { "/foo/bar" }
      let(:request_path)  { route_path }

      let(:route) { described_class.new route_path, route_method  }

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

      let(:route) { described_class.new route_path, route_method  }

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
end
