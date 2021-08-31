# frozen_string_literal: true

# Route 'school'
class App
  hash_branch 'school' do |r|
    r.on Integer do |school_id|
      @school_id = school_id
      @asc_or_desc = r.params['sort']&.include?('asc') ? 1 : -1
      @school = opts[:students].school_by_id(school_id, @asc_or_desc)

      # school/ID
      r.is do
        r.get do
          view('school')
        end
      end

      # school/ID/class/ID
      r.on 'class', Integer do |class_id|
        r.is do
          r.get do
            @class_id = class_id
            @school_class = @school[:list_classes][class_id]
            @students_by_class = if r.params['filter']
                                   opts[:students]
                                     .students_by_school_class(@school[:school_name], @school_class, r.params['filter'])
                                 else
                                   opts[:students].students_by_school_class(@school[:school_name], @school_class)
                                 end

            view('school_class')
          end
        end
      end
    end
  end
end
