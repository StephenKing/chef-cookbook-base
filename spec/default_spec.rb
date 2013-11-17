require 'chefspec'

describe 'base::default' do
  
  context 'default' do
    let (:chef_run) do
      ChefSpec::Runner.new.converge 'base::default'
    end
  
    it 'should always include recipe operatingsystem::default' do
      chef_run.should include_recipe 'operatingsystem::default'
    end
  
  end

  context 'physical' do
    let (:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.automatic.delete(:virtualization)
      runner.converge('base::default')
    end

    it 'should include recipe base::physical' do
      chef_run.should include_recipe 'base::physical'
    end
  end

  context 'virtualization' do
    let (:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.automatic[:virtualization][:system] = 'myvirtualization'
      runner.converge('base::default')
    end

    it 'should include recipe myvirtualization::default' do
      chef_run.should include_recipe 'myvirtualization::default'
    end
  end
end

