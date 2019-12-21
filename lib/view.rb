class View

  def welcome
    puts "                ***************************************"
    puts "                *Welcome to Delete your Tweet ruby app*"
    puts "                ***************************************"
    puts ""
    puts "With this app you'll be able to delete your Tweets and likes so nobody can"
    puts "fire you for something stupid you said once five years ago while drunk and angry."
    puts ""
    puts "Remember, the only way to have real privacy is to not leave your data around."
    puts ""
  end

  def press_enter
    puts ""
    puts "Please press Enter to continue."
    puts ""
    loop do
      input = gets
      puts "Press Enter, nothing else" if input != "\n"
      break if input == "\n"
    end
  end

  def login
    puts "To delete your tweets we need you to login to your Twitter account"
    puts "so the app can have access to your data."
    puts ""
    puts "Twitter doesn't give us your password, don't worry, there's this"
    puts "neat mechanism called OAuth to get access without it."
    puts ""
    puts "Press Enter and a web browser window will open for you to login."
    puts "After logging in to Twitter, it will show a 6 digit PIN number."
    puts "Come back to the APP and enter it."
    puts ""
    press_enter
  end

  def logged_in(user)
    puts "You are now logged in. Your username is #{user[:screen_name]}."
    puts "We will now start fetching your tweets."
    press_enter
  end

  def authenticate_failed
    puts "Seems there was an error logging you in."
    puts "Please try again"
    press_enter
  end

  def choose_action
    puts "So, what are we doing?"
    puts "1. Delete Tweets"
    puts "2. Delete Likes"
    puts "3. Delete DMs"
    puts "4. Quit"
    return gets.chomp.to_i
  end

  def preamble(type)
    puts "First we will gather all your #{type.capitalize} from the Twitter API"
    puts "Gathering..."
    puts "This may take a while if you have a lot. But not more than a few minutes."
    puts ""
  end

  def not_found(type)
    puts "No #{type} found in that time frame"
    puts "Please press Enter to return to the main menu"
    loop do
      input = gets
      puts "Press Enter, nothing else" if input != "\n"
      break if input == "\n"
    end
  end

  def api_error
    puts "Something went wrong with the API, please try again later."
    puts "Please press Enter to return to the main menu"
    loop do
      input = gets
      puts "Press Enter, nothing else" if input != "\n"
      break if input == "\n"
    end
  end

  def confirm(type, number, time)
    puts "You have a total of #{number} #{type} to delete which are older than #{time}."
    puts "Are you sure you want to delete all that?"
    puts "Note: Once deleted they can't be recovered."
    puts "Confirm? Press Y or N"
    input = gets.chomp
    until input.downcase == "y" || input.downcase == "n"
      input = gets.chomp
      puts "Press Y or N, nothing else"
    end
    return input.downcase
  end

  def delete(type, number)
    puts "---"
    puts "Let's get to it then"
    puts "You want to delete #{number} #{type}."
    puts "Deleting..."
  end

  def finished
    puts "Well, finished deleting."
    puts "Press Enter to go back to the main menu"
    press_enter
  end

  def set_time
    puts 'Please select a time frame.'
    puts "Only tweets or likes older than the time chosen will be deleted."
    puts "1.- One week ago"
    puts "2.- One month ago"
    puts "3.- Three months ago"
    puts "4.- Six months ago"
    puts "5.- One year ago"
    puts "6.- Custom time frame"
    puts "7.- DELETE EVERYTHING"
    time_choice = gets.chomp.to_i
    return time_choice
  end

  def custom_time
    puts "Choose your time frame, in days"
    input = gets.chomp.to_i
    until input.to_i.positive?
      input = gets.chomp.to_i
      puts "Please enter a number bigger than 0, nothing else."
    end
    return (Time.now - 60 * 60 * 24 * input)
  end


  def dms_preamble
    puts "As it happens, Direct Messages in Twitter can't be really deleted."
    puts "All you can do is delete them from *your* Twitter, but any recipient can still see them, forever."
    puts "Moreover, only DMs up to 30 days old can be deleted at all!"
    puts ""
    puts "As such it's pretty much pointless, but if you still wanna do it, please press Enter, else, press any other key."
    return gets
  end
end
