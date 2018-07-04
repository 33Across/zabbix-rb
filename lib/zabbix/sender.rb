class Zabbix::Sender

  DEFAULT_SERVER_PORT = 10051

  attr_reader :configured

  def initialize(opts={})
    @client_host = Socket.gethostbyname(Socket.gethostname)[0]

    if opts.has_key? :config_file
      config = Zabbix::Agent::Configuration.read(opts[:config_file])
      @server_host  = config.server
      @server_port  = config.server_port || DEFAULT_SERVER_PORT
      @client_host  = config.hostname if config.hostname
    end

    #if host specified, ignore port if defined in config file?
    if opts[:host]
      @server_host = opts[:host]
      @server_port = opts[:port] || DEFAULT_SERVER_PORT
    end

  end


  def configured?
    @configured ||= !(@server_host.nil? and @server_port.nil?)
  end


  def connect
    @socket ||= TCPSocket.new(@server_host, @server_port)
  end

  def disconnect
    if @socket
      @socket.close unless @socket.closed?
      @socket = nil
    end
    return true
  end

  def send_start(key, opts={})
    send_data("#{key}.start", 1, opts)
  end


  def send_stop(key, opts={})
    send_data("#{key}.stop", 1, opts)
  end

  def send_break(key, err, opts={})
    send_data("#{key}.break", err, opts)
  end

  def send_heartbeat(key, msg="", opts={})
    send_data("#{key}.heartbeat", msg, opts)
  end

  def send_data(key, value, opts={})
    return false unless configured?
    return send_zabbix_request([
      cons_zabbix_data_element(key, value, opts)
    ])
  end

  def send_data_verbose(key, value, opts={})
    return false unless configured?
    return send_zabbix_request([
      cons_zabbix_data_element(key, value, opts)
    ], {verbose: true})
  end

  private

  def cons_zabbix_data_element(key, value, opts={})
    return {
      :key   => key,
      :value => value,
      :host  => opts[:host] || @client_host,
      :clock => opts[:ts  ] || Time.now.to_i,
    }
  end

  def send_zabbix_request(data, options={})
    status  = false
    request = Yajl::Encoder.encode({
      :request => 'agent data' ,
      :clock   => Time.now.to_i,
      :data    => data
    })

    begin
      sock = connect
      sock.write "ZBXD\x01"
      sock.write [request.size].pack('q')
      sock.write request
      sock.flush

      # FIXME: check header to make sure it's the message we expect?
      header   = sock.read(5)
      len      = sock.read(8)
      len      = len.unpack('q').shift
      response = Yajl::Parser.parse(sock.read(len))
      #response = {"response"=>"success", "info"=>"processed: 0; failed: 1; total: 1; seconds spent: 0.000054"}
      status = build_status(response, options)
    rescue => e
      Zabbix.logger.info "Error: #{e.message}"
      Zabbix.logger.info e.backtrace
    ensure
      disconnect
    end

    return status
  end

  def build_status(response, options)
    if options[:verbose]
      #Return status with info from socket
      #Caller is expected to handle response when using this option
      #Called from `send_data_verbose`
      return  response.merge!("info" => response["info"].split(";").map(&:strip).collect{|status_str| status_str.split(": ")}.inject({}) {|ha, (k, v)| ha[k] = v; ha})
    else
      return true if response['response'] == 'success'
    end
  end
end
