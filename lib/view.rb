class View

  def welcome
    puts "***************************************"
    puts "*Welcome to Delete your Tweet ruby app*"
    puts "***************************************"
    puts "With this app you'll be able to delete"
    puts "your Tweets and likes so nobody can fire"
    puts "you for something stupid you said once"
    puts "five years ago while drunk and angry."
    puts ""
    puts ""
  end

  def login
    puts "To delete your tweets you will have to login"
    puts "Please enter your username"
    username = gets.chomp
    puts "Hi, #{username}"
    puts "Next, we need you to login to your Twitter account to give the app access to your data"
    puts "Twitter doesn't give us your password, don't worry, there's this"
    puts "neat mechanism called OAuth to get access without it."
    puts "Press Enter and a web browser window will open for you to login."
    puts "Please press Enter to continue"
    loop do
      input = gets
      puts "Press Enter, nothing else" if input != "\n"
      break if input == "\n"
    end
    return username
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
    puts "请稍后"
    puts "..."
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
    loop do
      input = gets
      puts "Press Enter, nothing else" if input != "\n"
      break if input == "\n"
    end
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
    puts "As it happens, Direct Messages in Twitter can't be deleted."
    puts "All you can do is delete them from *your* Twitter, but any recipient can still see them, forever."
    puts "Moreover, only DMs up to 30 days old can be deleted at all!"
    puts "As such it's pretty much pointless, but if you still wanna do it, please press Enter, else, press any other key."
    return gets
  end
end
