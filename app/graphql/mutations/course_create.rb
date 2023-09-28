# frozen_string_literal: true

module Mutations
  class CourseCreate < BaseMutation
    description "Creates a new course"

    field :course, Types::CourseType, null: false

    argument :input, Types::CourseInputType, required: true

    def resolve(input:)
      puts "input is hash ?: #{input.is_h?}"
      puts "hash of input #{input.class}"
      course_attrs= input.to_h.except(:chapters)
      course = ::Course.new(course_attrs)
      
      chapter_attrs = input[:chapters]

      chapters = chapter_attrs.map do |chapter_attr|
        Chapter.new(chapter_attr)
      end

      return { user: nil, errors: course.errors.full_messages } unless course.valid?

      course.chapters = chapters

      raise GraphQL::ExecutionError.new "Error creating course", extensions: course.errors.to_hash unless course.save

      { course: course }
    end
    #
    # def resolve(name:, lecturer:, description:, chapters:)
    #   # TODO: insert chapter
    #   course = ::Course.new(name:, lecturer:, description:)
    #   return { user: nil, errors: course.errors.full_messages } unless course.valid?
    #
    #   course.chapters.build(chapters.map(&:to_h))
    #
    #   puts "course: #{course.inspect}"
    #
    #   if course.save
    #     puts "#{course.inspect} issaved"
    #     { course:, errors: [] }
    #   else
    #     logger.debug 'has some error'
    #
    #     { course: nil, errors: course.errors.full_messages }
    #   end
    # end

  end
end
#
# module Mutations
#   class CreateCourse < Mutations::BaseMutation
#     argument :name, String, required: true
#     argument :lecturer, String, required: true
#     argument :description, String, required: true
#     argument :chapters, [Types::ChapterInputType], required: true
#
#     field :course, Types::CourseType, null: false
#     field :errors, [String], null: false
#
#     def resolve(name:, lecturer:, description:, chapters:)
#       # TODO: insert chapter
#       course = ::Course.new(name:, lecturer:, description:)
#       return { user: nil, errors: course.errors.full_messages } unless course.valid?
#
#       course.chapters.build(chapters.map(&:to_h))
#
#       puts "course: #{course.inspect}"
#
#       if course.save
#         puts "#{course.inspect} issaved"
#         { course:, errors: [] }
#       else
#         logger.debug 'has some error'
#
#         { course: nil, errors: course.errors.full_messages }
#       end
#     end
#   end
# end
