class Router
  def initialize(controller)
    @controller = controller
    @running = true
  end

  def run
    @controller.welcome
    @controller.login
    while @running
      action = @controller.start_menu
      route_action(action)
    end
  end

  def route_action(action)
    case action
    when 1 then @controller.list("tweets")
    when 2 then @controller.list("likes")
    when 3 then @controller.list_dms
    when 4 then @running = false
    end
  end
end

