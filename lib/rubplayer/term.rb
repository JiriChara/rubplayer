module Rubplayer
  class Term
    attr_accessor :queue, :thread, :callbacks

    def initialize(session_id=Process.pid, init_cmd=nil, &block)
      @shell     = init_cmd || ENV['SHELL'] || 'bash'
      @sesson_id = session_id
      @callbacks = Hash.new
      @queue     = Queue.new

      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval(&block)
        end
      end

      start_pty
    end

    def <<(stdin)
      @queue << stdin
    end

    def destroy
      Process.kill('TERM', @term_pid)
      @thread.kill
    rescue Errno::EIO, PTY::ChildExited, Errno::ESRCH
    end

    def start_pty
      @thread = Thread.new do
        PTY.spawn(@shell) do |r, w, pid|
          @term_pid = pid

          Thread.new do
            while chunk = @queue.shift
              w.print(chunk)
              w.flush
            end
          end

          begin
            loop do
              c = r.sysread(1 << 15)
              trigger(:read, c) if c
            end
          rescue Errno::EIO
            destroy
          end
        end
      end
    rescue Errno::EIO, PTY::ChildExited
      destroy
    end

    def on(name, &block)
      (@callbacks[name.to_sym] ||= []) << block
    end

    def trigger(name, *args)
      (@callbacks[name.to_sym] || []).each { |block| block.call(*args) }
    end
  end
end
