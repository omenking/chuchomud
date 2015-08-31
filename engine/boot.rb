def handle_signal(sig)
  $stdout.puts("Handling #{sig}")
  finish
  exit
end

def finish
  $game.shutdown
  $game.save_all
  save_game
end

def load_game
  File.open(CONF.module_directory.join('game.yaml')) do |file|
    YAML::load(file)
  end
end

def save_game
  File.open(CONF.module_directory.join('game.yaml'),'w') do |file|
    YAML::dump($game,file)
  end
  $stdout.puts("dumped game")
end

def load_modules
  module_dir = CONF.module_directory.join('lib')

  module_logic_dir   = module_dir+'logic'
  module_command_dir = module_dir+'commands'
  logic_dir = File.join($ROOT_PATH,'lib', 'logic')

  $:.unshift 'lib/commands'
  $:.unshift 
  $:.unshift module_command_dir
  $:.unshift module_logic_dir

  mdir = File.join module_logic_dir, '*.rb'
  ldir = File.join logic_dir       , '*.rb'
  Dir.glob(mdir){|l| require l}
  Dir.glob(ldir){|l| require l}

  $stdout.puts "Using Library Path: #{$:.join(',')}"
end

def parse_args(argv)
  options = OpenStruct.new
  options.module = "Default"

  opts = OptionParser.new do |opts|
      opts.banner = "Usage: chucho_mud.rb [options]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-m","--module MODULE",
          "Indicate which Module to load") do |module_name|
              options.module = module_name
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print
      # an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
      end

      opts.on_tail("--version","Show version") do
          puts Version.join('.')
          exit
      end
  end

  begin
      opts.parse(argv)
  rescue => e
      $stderr.puts e
      puts opts
      exit
  end
  options
end

if RUBY_VERSION == "2.1.1"
  class Bignum
      def to_yaml( opts = {} )
          YAML::quick_emit( nil, opts ) { |out|
              out.scalar( nil, to_s, :plain )
          }
      end
  end
end

Signal.trap "INT" , method(:handle_signal)
Signal.trap "TERM", method(:handle_signal)
Signal.trap "KILL", method(:handle_signal)

CONF             =  ChuchoMUD::Config.instance
options          = parse_args(ARGV)
CONF.module_name = options.module

if not CONF.module_directory.exist? then
  $stderr.puts "#{CONF.module_name} does not exist"
  exit 1
end

CHAR_DIR          = "#{CONF.module_directory}/players".gsub!('/',File::SEPARATOR)
CHAR_TEMPLATE_DIR = "#{CONF.module_directory}/templates/characters".gsub!('/',File::SEPARATOR)
ITEM_TEMPLATE_DIR = "#{CONF.module_directory}/templates/items".gsub!('/',File::SEPARATOR)
REGION_DIR        = "#{CONF.module_directory}/regions".gsub!('/',File::SEPARATOR)

load_modules

log4r_config = YAML.load_file(File.join($ROOT_PATH,'conf', "logging.yaml"))
Log4r::YamlConfigurator.decode_yaml(log4r_config['log4r_config'])

$log     = Log4r::Logger["game_log"]
$evt_log = Log4r::Logger["event_log"]

srand Time.now.to_i

$game = load_game
$game.setup
$game.load_all
manager = NetManager.new($game, 4000)
while $game.running?
    manager.manage
end
finish
