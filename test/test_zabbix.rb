$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class TestZabbix < Test::Unit::TestCase

  should "not be configured" do 
    zbx = Zabbix::Sender.new 
    assert_equal false, zbx.configured?
  end

  should "be configured by args" do
    zbx = Zabbix::Sender.new :host => 'localhost'
    assert_equal true, zbx.configured?
  end
 
  should "be configured by zabbix_agentd.conf" do
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx = Zabbix::Sender.new :config_file => config_file
    assert_equal true, zbx.configured?
  end 

  should "use client_host from config file" do
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx = Zabbix::Sender.new :config_file => config_file
    assert_equal "myfancyhostname", zbx.send(:cons_zabbix_data_element, 'k', 'v')[:host]
  end

  should "should send start stop and heartbeat" do
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx  = Zabbix::Sender.new :config_file => config_file
    key  = :"foo.bar.baz"
    host = "testhost.example.com"
    assert_equal true, zbx.send_start(key, :host => host)
    assert_equal true, zbx.send_heartbeat(key, "8==D", :host => host)
    assert_equal true, zbx.send_stop(key, :host => host)
  end

  should "should return response hash for send_data_verbose" do
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx  = Zabbix::Sender.new :config_file => config_file
    key  = :"foo.bar.baz"
    host = "testhost.example.com"
    assert_equal Hash, zbx.send_data_verbose(key, 0).class
  end

  should "should return response true for send_data" do
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx  = Zabbix::Sender.new :config_file => config_file
    key  = :"foo.bar.baz"
    host = "testhost.example.com"
    assert_equal true, zbx.send_data(key, 0)
  end

  should "should bulk send data" do 
    config_file = "#{File.dirname(__FILE__)}/zabbix_agentd.conf"
    zbx  = Zabbix::Sender::Buffer.new :config_file => config_file
    key  = :"foo.bar.baz"
    host = "testhost.example.com"
    zbx.append key, "8===D",   :host => host 
    zbx.append key, "8====D",  :host => host 
    zbx.append key, "8=====D", :host => host 
    assert_equal true, zbx.flush   
  end
end
