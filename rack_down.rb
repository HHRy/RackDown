module RackDown
  class Application
    def call(env)
      @router = Router.new(File.expand_path(File.dirname(__FILE__) + '/posts'))
      @router.route(env['REQUEST_PATH'])
    end
  end
  
  class Router
    
    attr_reader :root, :index
    
    def initialize(root)
      @root = root
      @index = root + '/index.md'
      @not_found = root + '/404.md'
      build_routing_hash
    end
    
    def route(request_path)
      if request_path == '/'
        [200, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(@index)).to_html]
      elsif @allowed_files.include?(@root + request_path + '.md')
        [200, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(@root + request_path + '.md')).to_html]
      else
        [404, { 'Content-Type' => 'text/html' }, RDiscount.new(IO.read(@not_found)).to_html]
      end
    end
    
    private 
    
    def build_routing_hash
      @allowed_files = (Dir.glob(@root + '/*.md') + Dir.glob(@root + '/*.mdown') + Dir.glob(@root + '/*.test'))
    end
  end
end