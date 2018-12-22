require 'mongo'
require 'bson'

Mongo::Logger.logger.level = Logger::FATAL

class FAQ
  # { :id, :name, :email } - поля хранимых контактов
  def initialize(client)
    @client = client
  end

  def all
    @client[:faq].find
  end

  def create(title, text)
    @client[:faq].insert_one({ title: title, text: text })
  end

  def find(faq_id)
    return @client[:faq].find({ _id: BSON::ObjectId(faq_id) }).first
  end
end