module Zabbix::Agent
  class Configuration
    def initialize(config={})
      @config = config
    end

    # From the zabbix_sender 3.0 / 4.0 man page
    #-c, --config config-file
    #Use config-file. Zabbix sender reads server details from the agentd configuration file. By default Zabbix sender does not read any configuration file. Absolute path should be specified. Only parameters Hostname, ServerActive, SourceIP, TLSConnect, TLSCAFile, TLSCRLFile, TLSServerCertIssuer, TLSServerCertSubject, TLSCertFile, TLSKeyFile, TLSPSKIdentity and TLSPSKFile are supported. First entry from the ServerActive parameter is used.

    def hostname
      @config['Hostname']
    end

    def server_active
      @config['ServerActive']
    end

    def source_ip
      @config['SourceIP']
    end

    def tls_connect
      @config['TLSConnect']
    end

    def tls_cafile
      @config['TLSCAFile']
    end

    def tls_crl_file
      @config['TLSCRLFile']
    end

    def tls_server_cert_issuer
      @config['TLSServerCertIssuer']
    end

    def tls_server_cert_subject
      @config['TLSServerCertSubject']
    end

    def tls_cert_file
      @config['TLSCertFile']
    end

    def tls_key_file
      @config['TLSKeyFile']
    end

    def tls_psk_identity
      @config['TLSPSKIdentity']
    end

    def tls_psk_file
      @config['TLSPSKFile']
    end

    def arbitrary(key)
      @config[key]
    end 

    def self.read(zabbix_conf_file=nil)
      zabbix_conf_file ||= "/etc/zabbix/zabbix_agentd.conf"
      zabbix_conf        = {} 

      File.open(zabbix_conf_file).each do |line|
        ## skip comments
        next if line =~ /^(\s+)?#/ 

        ## strip tail comments
        line.gsub!(/#.*/, '')
        line.strip!
        next if line.empty?

        ## zabbix splits on equals 
        key, value = line.split("=", 2)
        key.chomp! if key
        value.chomp! if value

        ## zabbix keys look like strings
        next unless key  =~ /[A-Za-z0-9]+/

        ## cool
        zabbix_conf[key] = value
      end

      Configuration.new(zabbix_conf)
    end
  end
end
