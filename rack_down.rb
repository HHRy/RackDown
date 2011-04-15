module RackDown
  class Application
    def call(env)
      root = File.expand_path(File.dirname(__FILE__) + '/posts')
      if env['REQUEST_PATH'] == '/'
        [200, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(root + '/index.md')).to_html]
      elsif File.exists?(root + env['REQUEST_PATH'] + '.md')
        [200, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(root + env['REQUEST_PATH'] + '.md')).to_html]
      else
        [404, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(root + '/404.md')).to_html]
      end
    end
  end
end