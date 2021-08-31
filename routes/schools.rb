# frozen_string_literal: true

# Route 'schools'
class App
  hash_branch 'schools' do |r|
    # schools
    r.get do
      @schools = if r.params['type']
                   opts[:students].list_schools_by_type(r.params['type'])
                 else
                   opts[:students].list_schools
                 end
      view('schools')
    end
  end
end
