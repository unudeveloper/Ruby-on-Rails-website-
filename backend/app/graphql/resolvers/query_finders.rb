# frozen_string_literal: true

module Resolvers
  module QueryFinders
    def filter_name(name)
      return db_query if name.blank?

      @db_query = db_query.where('NAME LIKE ?', "%#{name}%")
    end

    def filter_slug(slug)
      return db_query if slug.blank?

      @db_query = db_query.where(slug: slug)
    end

    def filter_uuid(uuid)
      return db_query if uuid.blank?

      @db_query = db_query.where(uuid: uuid)
    end

    def filter_translation(lang)
      return db_query if lang.blank?

      @db_query = db_query.joins(:translations).where('translations.language': lang)
    end
  end
end
