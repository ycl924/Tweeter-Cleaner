require_relative 'view'
require_relative 'api'

class Controller
  def initialize
    @view = View.new
    @api_call = API_Call.new
    @token = ""
  end

  def welcome
    @view.welcome
  end

  def login
    @view.login
    go_login
  end

  def go_login
    oauth_headers = @api_call.login
    if oauth_headers != "error"
      @view.logged_in(oauth_headers[0])
      @token = oauth_headers[1]
    else
      @view.authenticate_failed
      go_login
    end
  end

def choose_time
  one_week_ago = (Time.now - 60 * 60 * 24 * 7)
  one_month_ago = (Time.now - 60 * 60 * 24 * 30)
  three_months_ago = (Time.now - 60 * 60 * 24 * 30 * 3)
  six_months_ago = (Time.now - 60 * 60 * 24 * 31 * 6)
  one_year_ago = (Time.now - 60 * 60 * 24 * 31 * 12)
  time_choice = @view.set_time
  case time_choice
  when 1 then older_than = one_week_ago
  when 2 then older_than = one_month_ago
  when 3 then older_than = three_months_ago
  when 4 then older_than = six_months_ago
  when 5 then older_than = one_year_ago
  when 6
    older_than = @view.custom_time
  when 7 then older_than = Time.now
  else
    puts "Let's try this again."
    choose_time
  end
  return older_than
end

  def start_menu
    return @view.choose_action
  end

  def list(type)
    time = choose_time
    @view.preamble(type)
    collection = @api_call.collect(type, time, @token)
    if collection.empty?
      @view.not_found(type)
    elsif collection == "error"
      @view.api_error
    else
      confirm = @view.confirm(type, collection.size, time)
      delete(type, collection) if confirm == "y"
    end
  end

  def list_dms
    input = @view.dms_preamble
    if input == "\n"
      timestamp = @view.custom_time.to_i * 1000 # Fucking Ruby is in seconds not ms
      dm_list = @api_call.get_dms(timestamp, @token)
      if dm_list.empty?
        @view.not_found("dms")
      elsif dm_list == "error"
        @view.api_error
      else
        confirm = @view.confirm("dms", dm_list.size, Time.at(timestamp / 1000))
        delete_dms(dm_list) if confirm == "y"
      end
    end
  end

  def delete(type, list)
    @view.delete(type, list.size)
    @api_call.delete(type, list, @token)
    finish
  end

  def delete_dms(list)
    @view.delete("dms", list.size, @token)
    @api_call.delete_dms(list)
    finish
  end

  def finish
    @view.finished
  end


end
