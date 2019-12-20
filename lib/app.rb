require_relative 'router'
require_relative 'controller'
require 'dotenv/load'


controller = Controller.new
router = Router.new(controller)

router.run
