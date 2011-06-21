module FbGraph
  class Domain < Node
    include Connections::Insights

    attr_accessor :name

    def initialize(identifier, attributes = {})
      super
      @name = attributes[:name]
    end

    # NOTE:
    #  Don't use Searchable here.
    #  Domain search doesn't return paginatable array.
    def self.search(domains)
      fake_domain = 'fake.com'
      domains = Array(domains)
      unless domains.include?(fake_domain)
        @using_fake = true
        domains << fake_domain
      end
      results = Node.new(nil).send(:get, :domains => domains.join(','))
      results = results.map do |identifier, attributes|
        if @using_fake && attributes[:name] == fake_domain
          next
        end
        new(identifier, attributes)
      end
      results.compact
    end
  end
end