version = '1.0.1'

local home = os.getenv 'HOME'
package.path = home .. '/.config/xplr/plugins/?/init.lua;' .. home .. '/.config/xplr/plugins/?.lua;' .. package.path

require('icons').setup()
