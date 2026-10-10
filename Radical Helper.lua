---@diagnostic disable: undefined-global, lowercase-global

script_name("Arizona&Rodina Helper")
script_description('Óíèâåðñàëüíûé õåëïåð äëÿ èãðîêîâ Arizona Online è Rodina Online')
script_author("STRIPTISFUNCLUB")
script_version("1 VERSION DEVELOPERS")
----------------------------------------------- INIT ---------------------------------------------
local worked_dir = getWorkingDirectory():gsub('\\','/')
local IS_MOBILE = MONET_VERSION ~= nil
print('Èíèöèàëèçàöèÿ ñêðèïòà âåðñèè ' .. thisScript().version)
print('Äèðåêòîðèÿ: ' .. worked_dir .. '/')
------------------------------------------ INIT CRASH INFO ---------------------------------------
local errors_handler_path = worked_dir .. '/.Radical Helper Handler.lua'
if not doesFileExist(errors_handler_path) then
	local helper_prefix = '/.Radical Helper '
	local content = [[
-- DONT SEND ME THIS FILE, THIS IS NOT AN ERROR, BUT A SCRIPT TO DISPLAY THE ERROR IN DIALOG
-- ÍÅ ÎÒÏÐÀÂËßÉÒÅ ÌÍÅ ÝÒÎÒ ÔÀÉË, ÝÒÎ ÍÅ ÎØÈÁÊÀ, ÝÒÎ ÑÊÐÈÏÒ ÄËß ÂÛÂÎÄÀ ÎØÈÁÊÈ ÂÀÌ Â ÄÈÀËÎÃÅ
function onSystemMessage(msg, type, script)
	if script and script.name == 'Arizona&Rodina Helper' and msg and ((msg:find('stack traceback')) or (type == 3 and not msg:find('Script died due to an error'))) then
		local errorMessage = ('{ffffff}Ïðîèçîøëà íåïðåäóñìîòðåííàÿ îøèáêà â ðàáîòå ñêðèïòà, èç-çà ÷åãî îí áûë îòêëþ÷¸í!\n\n' ..
		'Îòïðàâüòå ñêðèíøîò ýòîãî äèàëîãà â {ff9900}òåõ.ïîääåðæêó STRIPTISFUNCLUB (Telegram/Discord){ffffff}.\n\n' ..
		'Äåòàëè âîçíèêøåé îøèáêè:\n{ff6666}' .. msg .. '{ffffff}\n\n' ..
		'Ïîëíûé ëîã ðàáîòû ñêðèïòà: \n{66BB6A}' .. getLog())
		sampShowDialog(123123, '{009EFF}Arizona&Rodina Helper [' .. script.version .. ']', errorMessage, 'Çàêðûòü äèàëîã', '', 0)
	end
end
function getLog()
	local worked_dir = getWorkingDirectory():gsub('\\','/')
	local IS_MOBILE = MONET_VERSION ~= nil
	local log_path = worked_dir .. (IS_MOBILE and '/logs/monetloader.log' or '/moonloader.log')
    if not doesFileExist(log_path) then return 'Ôàéë ëîãîâ íå íàéäåí:\n- ' .. log_path end
    local file = io.open(log_path, 'r') if not file then return 'Íå óäàëîñü îòêðûòü ôàéë ëîãîâ:\n- ' .. log_path end
    local lines = {}
    local start_index = 1
    for line in file:lines() do table.insert(lines, line) end
    file:close()
    for i = #lines, 1, -1 do
        if lines[i]:find('Èíèöèàëèçàöèÿ ñêðèïòà', 1, true) then
            start_index = i
            break
        end
    end
    local result = {}
    for i = start_index, #lines do
        local line = lines[i]
        if line:find('Arizona&Rodina Helper', 1, true) then
			if not (line:find('Script died') or line:find('.lua%:') or line:find('Loaded successfully')) then
				local clean = line:match('Arizona&Rodina Helper%: (.+)')
				if clean then table.insert(result, clean) end
			end
        end
    end
    if #result == 0 then return 'Ñòðîêè ñ Arizona&Rodina Helper íå íàéäåíû.' end
    return table.concat(result, '\n')
end
    ]]
	local file, errstr = io.open(errors_handler_path, 'w')
	if file then
		file:write(content)
		file:close()
		os.remove(worked_dir .. helper_prefix .. 'Crash Info.lua')
		os.remove(worked_dir .. helper_prefix .. 'Error Handler.lua')
		os.remove(worked_dir .. helper_prefix .. 'Errors Handler.lua')
		os.remove(worked_dir .. helper_prefix .. 'Crash Informer.lua')
	else
		print('Íå óäàëîñü ñîçäàòü ôàéë äëÿ îáðàáîòêè îøèáîê, îøèáêà: ', errstr)
	end
end
-------------------------------------------- CONNECT LIBS ----------------------------------------
print('Ïîäêëþ÷åíèå áèáëèîòåê...')
require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local effil = require('effil')
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sampev = require('samp.events')
local dkok, dkjson = pcall(require, "dkjson")
local vkeys_no_errors, vkeys = pcall(require, 'vkeys')
local monet_no_errors, moon_monet = pcall(require, 'MoonMonet')
local hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
local pie_no_errors, pie = pcall(require, IS_MOBILE and 'imgui_piemenu' or 'mimgui_piemenu_mod')
local sizeX, sizeY = getScreenResolution()
print('Áèáëèîòåêè óñïåøíî ïîäêëþ÷åíû!')
-------------------------------------------- JSON SETTINGS ---------------------------------------
local config_dir = worked_dir .. '/Radical Helper'
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
		analytics = true,
        custom_dpi = 1.0,
		autofind_dpi = false,
        helper_theme = 0,
		message_color = 662052,
		moonmonet_theme_color = 662052,
		transparent = 70,
		fraction_mode = '',
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_action = '[13]',
		bind_command_stop = '[123]',
		piemenu = true,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		auto_uninvite = false,
		ping = true,
		rp_guns = true,
		rp_chat = true,
		auto_accept_docs = true,
	},
    mj = {
		auto_time = true,
		anti_screpki = true,
		auto_doklad_damage = true,
		auto_change_code_siren = true,
    },
	md = {
		auto_doklad_damage = true,
	},
	mh = {
		price = {
			ant = 50000,
			recept = 100000,
			heal = 100000,
			heal_vc = 1000,
			healactor = 800000,
			healactor_vc = 1000,
			healbad = 400000,
			medosm = 800000,
			mticket = 400000,
			med7 = 50000,
			med14 = 100000,
			med30 = 150000,
			med60 = 200000,
		},
		heal_in_chat = {
			enable = true,
			auto_heal = false
		},
	},
	smi = {
		ads_buttons = true,
		ads_history = true,
		notify_new_ads = true,
		auto_select_first_ad = false,
	},
	lc = {
		price = {
			avto1 = 200000,
			avto2 = 360000,
			avto3 = 410000,
			moto1 = 300000,
			moto2 = 350000,
			moto3 = 450000,
			fish1 = 500000,
			fish2 = 550000,
			fish3 = 590000,
			swim1 = 500000,
			swim2 = 550000,
			swim3 = 590000,
			gun1 = 1000000,
			gun2 = 1090000,
			gun3 = 1150000,
			hunt1 = 1000000,
			hunt2 = 1100000,
			hunt3 = 1190000,
			klad1 = 1100000,
			klad2 = 1200000,
			klad3 = 1250000,
			taxi1 = 800000,
			taxi2 = 1150000,
			taxi3 = 1250000,
			mexa1 = 800000,
			mexa2 = 1150000,
			mexa3 = 1250000,
			fly1 = 1200000,
			fly2 = 1200000,
			fly3 = 1200000,
			train1 = 500000 -- rodina
		},
		auto_find_clorest_znak = true,
	},
	fd = {
		doklads = {
			togo = true,
			here = true,
			fire = true,
			stretcher = true,
			npc_save = true,
			file_end = true,
		},
	}, 
	gov = {
		anti_trivoga = true,
		custom_zeks = true,
	},
	ins = {
		anti_trivoga = true,
		hint_in_sort = true,
		notify_new_ticket = true,
		auto_input_ticket = true,
	},
	windows_pos = {
		pie = {x = sizeX * 0.7, y = sizeY * 0.7},
		patrool_menu = {x = sizeX / 2, y = sizeY / 2},
		post_menu = {x = sizeX / 2, y = sizeY / 2},
		wanteds_menu = {x = sizeX / 1.2, y = sizeY / 2},
		zeks_menu = {x = sizeX / 1.2, y = sizeY / 2},
		mobile_fastmenu_button = {x = sizeX / 8.5, y = sizeY / 2.3},
	},
}
function safe_encode_json(array) 
	if dkok then
		local ok, encoded = pcall(dkjson.encode, array, {indent = true})
		if ok then return encoded end
	end
	local ok, encoded = pcall(encodeJson, array)
	if ok then return encoded end
end
function merge_defaults(default, loaded)
	local has_changes = false
    for key, value in pairs(default) do
        if type(value) == "table" then
            if type(loaded[key]) ~= "table" then
				has_changes = true
				print('Â âàø ëîêàëüíûé êîíôèã èìïîðòèðîâàíî íîâîå çíà÷åíèå: ' .. key .. ' = ' .. tostring(value))
                loaded[key] = {}
            end
            merge_defaults(value, loaded[key])
        else
            if loaded[key] == nil then
                loaded[key] = value
				print('Â âàø ëîêàëüíûé êîíôèã èìïîðòèðîâàíî íîâîå çíà÷åíèå: ' .. key .. ' = ' .. tostring(value))
				has_changes = true
            end
        end
    end
	return has_changes
end
function load_default_settings()
	settings = default_settings
	print('Èñïîëüçóþòñÿ ñòàíäàðòíûå íàñòðîéêè!')
end
function save_settings()
    local file, errstr = io.open(config_dir .. "/Settings.json", 'w')
    if file then
		local content = safe_encode_json(settings)
		if content then
			file:write(content)
			print('Íàñòðîéêè õåëïåðà ñîõðàíåíû!')
		else
			print('Íå óäàëîñü ñîõðàíèòü íàñòðîéêè õåëïåðà! Îøèáêà êîäèðîâêè json')
		end
		file:close()
    else
        print('Íå óäàëîñü ñîõðàíèòü íàñòðîéêè õåëïåðà, îøèáêà: ', (errstr or "Unknown"))
    end
end
function load_settings()
    if not doesDirectoryExist(config_dir) then createDirectory(config_dir) end
    if not doesFileExist(config_dir .. "/Settings.json") then
        load_default_settings()
    else
        local file = io.open(config_dir .. "/Settings.json", 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents ~= 0 then
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					if settings.general.version ~= thisScript().version then
						settings.general.version = thisScript().version
						print('Èìïîðòèðóþ íîâûå ïàðàìåòðû â ëîêàëüíûé êîíôèã...')
						merge_defaults(default_settings, settings)
						save_settings()
					end
					print('Íàñòðîéêè õåëïåðà óñïåøíî çàãðóæåíû!')
				else
					load_default_settings()
				end
			else
                load_default_settings()
			end
        else
            load_default_settings()
        end
    end
end
function isMode(mode)
	return settings.general.fraction_mode == mode
end
load_settings()
---------------------------------------------- AUTO DPI ------------------------------------------
if not settings.general.autofind_dpi then
	print('Àâòîìàòè÷åñêîå îïðåäåëåíèå DPI èíòåðôåéñà...')
	if IS_MOBILE then
		settings.general.custom_dpi = MONET_DPI_SCALE
	else
		local width_scale = sizeX / 1366
		local height_scale = sizeY / 768
		settings.general.custom_dpi = (width_scale + height_scale) / 2
	end
	settings.general.autofind_dpi = true
	settings.general.custom_dpi = tonumber(string.format('%.3f', settings.general.custom_dpi))
	print('DPI èíòåðôåéñà: ' .. settings.general.custom_dpi)
	save_settings()
end
------------------------------------------ JSON & MODULES ----------------------------------------
local modules = {
	player = {
		name = 'Èãðîê',
		path = config_dir .. "/Player.json",
		data = {
			nick = '',
			name_surname = '',
			sex = 'Ìóæ÷èíà',
			fraction = 'none',
			fraction_tag = '',
			fraction_rank = '',
			fraction_rank_number = 0,
		}
	},
	departament = {
		name = 'Ðàöèÿ Äåïàðòàìåíòà',
		path = config_dir .. "/Departament.json",
		data = {
			anti_skobki = false,
			dep_fm = '-',
			dep_tag1 = '',
			dep_tag2 = '[Âñåì]',
			dep_tags = {
				"[Âñåì]",
				"[Ïîõèòèòåëè]",
				"[Òåðîðèñòû]",
				"[Äèñïåò÷åð]",
				'skip',
				"[ÌÞ]",
				"[Ìèí.Þñò.]",
				"[ËÑÏÄ]",
				"[ÑÔÏÄ]",
				"[ËÂÏÄ]",
				"[ÐÊØÄ]",
				"[ÑÂÀÒ]",
				"[ÔÁÐ]",
				'skip',
				"[ÌÎ]",
				"[Ìèí.Îáîðîíû]",
				"[ËÑà]",
				"[ÑÔà]",
				"[ÒÑÐ]",
				'skip',
				"[ÌÇ]",
				"[ÌÇÏ]",
				"[Ìèí.Çäðàâ.]",
				"[ËÑÌÖ]",
				"[ÑÔÌÖ]",
				"[ËÂÌÖ]",
				"[ÄÌÖ]",
				"[ÏÄ]",
				'skip',
				"[ÖÀ]",
				"[ÖË]",
				"[ÑÊ]",
				"[Ïðà-âî]",
				"[Ãóáåðíàòîð]",
				"[Ïðîêóðîð]",
				"[Cóäüÿ]",
				'skip',
				"[ÑÌÈ]",
				"[ÑÌÈ ËÑ]",
				"[ÑÌÈ ÑÔ]",
				"[ÑÌÈ ËÂ]",
			},
			dep_tags_en = {
				"[ALL]",
				'skip',
				"[MJ]",
				"[Min.Just.]",
				"[LSPD]",
				"[SFPD]",
				"[LVPD]",
				"[RCSD]",
				"[SWAT]",
				"[FBI]",
				'skip',
				"[MD]",
				"[Mid.Def.]",
				"[LSa]",
				"[SFa]",
				"[MSP]",
				'skip',
				"[MH]",
				"[MHF]",
				"[Min.Healt]",
				"[LSMC]",
				"[SFMC]",
				"[LVMC]",
				"[JMC]",
				"[FD]",
				'skip',
				"[GOV]",
				'[Governor]',
				"[Prosecutor]",
				"[Judge]",
				"[LC]",
				"[INS]",
				'skip',
				"[CNN]",
				"[CNN LS]",
				"[CNN LV]",
				"[CNN SF]",
			},
			dep_tags_custom = {},
			dep_fms = {
				'-',
				'- ç.ê. -',
			}
		}
	},
	commands = {
		name = 'Êîìàíäû',
		path = config_dir .. "/Commands.json",
		data = {
			commands = {
				my = {},
				police = {
					{cmd = '55', description = 'Ïðîâåäåíèå 10-55', text = '/r {my_doklad_nick} íà CONTROL. Ïðîâîæó 10-55 â ðàéîíå {get_area} ({get_square}), ÑODE 4.&/m Âîäèòåëü {get_drived_car} âíèìàíèå!&/m Ãîâîðèò {fraction}! Ñíèçüòå ñêîðîñòü è ïðèæìèòåñü ê îáî÷èíå.&/m Ïîñëå îñòàíîâêè çàãëóøèòå äâèãàòåëü, è íå âûõîäèòå èç òðàíñïîðòà.&/m Â ñëó÷àå íåïîä÷èíåíèÿ âû áóäåòå îáúÿâëåíû â ðîçûñê!', arg = '', enable = true, waiting = '2', bind = "[101]"},
					{cmd = '66', description = 'Ïðîâåäåíèå 10-66', text = '/r {my_doklad_nick} íà CONTROL. Ïðîâîæó 10-66 â ðàéîíå {get_area} ({get_square}), ÑODE 3!&/m Âîäèòåëü {get_drived_car} âíèìàíèå!&/m Ãîâîðèò {fraction}! Íåìåäëåííî ïðèæìèòåñü ê îáî÷èíå!&/m Â ñëó÷àå íåïîä÷èíåíèÿ ïî âàì áóäåò îòêðûò îãîíü!', arg = '', enable = true, waiting = '2', bind = "[102]"},
					{cmd = 'zd', description = 'Ïðèâåòñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'bk', description = 'Çàïðîñ ïîìîùè ñ êîîðäèíàòàìè', text = '/me äîñòàë{sex} ñâîé ÊÏÊ è îòïðàâèë{sex} êîîðäèíàòû â áàçó äàííûõ {fraction_tag}&/bk 10-20&/r {my_doklad_nick} íà CONTROL. Ñðî÷íî íóæíà ïîìîùü, îòïðàâèë{sex} ñâîè êîîðäèíàòû!', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'siren', description = 'Âêë/âûêë ìèãàëîê â ò/ñ', text = '{switchCarSiren}', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'fara', description = 'Îñòàâèòü îòïå÷àòîê íà ôàðå', text = '/me êîñíóëñÿ ëåâîé ôàðû {get_nearest_car}&/do Îòïå÷àòîê óñïåøíî îñòàâëåí íà ëåâîé ôàðå òðàíñïîðòíîãî ñðåäñòâà.', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'pas', description = 'Çàïðîñ äîêóìåíòîâ',  text = 'Çäðàâñòâóéòå, óïðàâëåíèå {fraction_tag}, ÿ {fraction_rank} {my_ru_nick}&/do Cëåâà íà ãðóäè æåòîí ïîëèöåéñêîãî, ñïðàâà èìåííàÿ íàøèâêà ñ èìåíåì.&/me äîñòà¸ò ñâî¸ óäîñòîâåðåíèå èç êàðìàíà&/showbadge {id}&Ïðîøó ïðåäúÿâèòü äîêóìåíò, óäîñòîâåðÿþùèé âàøó ëè÷íîñòü.&/n @{get_nick({id})}, ââåäèòå /showpass {my_id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'ts', description = 'Âûïèñàòü øòðàô',  text = '/do Ïëàíøåò íàõîäèòñÿ â êàðìàíå ôîðìû.&/writeticket {id} {arg}&/me âíîñèò èçìåíåíèÿ â áàçó øòðàôîâ&/todo Îïëàòèòå øòðàô*óáèðàÿ ïëàíøåò îáðàòíî â êàðìàí', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'find', description = 'Ïîèñê èãðîêà',  text = '/me äîñòàë{sex} ñâîé ÊÏÊ è çàéäÿ â áàçó äàííûõ {fraction_tag} îòêðûë{sex} äåëî ãðàæäàíèíà N{id}&/me íàæàë{sex} íà êíîïêó GPS îòñëåæèâàíèÿ ìåñòîïîëîæåíèÿ ãðàæäàíèíà&/find {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'prs', description = 'Ïîãîíÿ çà ïðåñòóïíèêîì',  text = '/me äîñòàë{sex} ñâîé ÊÏÊ è çàéäÿ â áàçó äàííûõ {fraction_tag} îòêðûë{sex} äåëî ïðåñòóïíèêà N{id}&/me íàæàë{sex} íà êíîïêó GPS îòñëåæèâàíèÿ ìåñòîïîëîæåíèÿ ãðàæäàíèíà&/pursuit {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'su', description = 'Âûäàòü ðîçûñê',  text = '/me äîñòàë{sex} ñâîé ÊÏÊ è îòêðûë{sex} áàçó äàííûõ ïðåñòóïíèêîâ&/me âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/su {id} {number} {arg}&/z {id}&/todo Îòëè÷íî, ïðåñòóïíèê â ðîçûñêå*óáèðàÿ ÊÏÊ', arg = '{id} {number} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'fsu', description = 'Çàïðîñèòü âûäà÷ó ðîçûñêà',  text = '/do Ðàöèÿ íà òàêòè÷åñêîì ïîÿñå.&/me äîñòàë{sex} ðàöèþ c ïîÿñà, è ñâÿçàâàøèñü ñ äèñïåò÷åðîì, çàïðîñèë{sex} îáüÿâëåíèå ÷åëîâåêà â ðîçûñê&/r {my_doklad_nick} íà CONTROL.&/r Ïðîøó îáüÿâèòü â ðîçûñê {number} ñòåïåíè äåëî N{id}. Ïðè÷èíà: {arg}', arg = '{id} {number} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'givefsu', description = 'Âûäà÷à ðîçûñêà ïî çàïðîñó',  text = '/r 10-4, îáüÿâëÿþ ãðàæäàíèíà â ðîçûñê ïî çàïðîñó îôèöåðà {get_rp_nick({id})}!&/me äîñòàë{sex} ñâîé ÊÏÊ è îòêðûë{sex} áàçó äàííûõ ïðåñòóïíèêîâ&/me âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/su {get_form_su} (ïî çàïðîñó îôèöåðà {get_rp_nick({id})})&/todo Îòëè÷íî, ðîçûñê ïî çàïðîñó îôèöåðà {get_rp_nick({id})} âûäàí*óáèðàÿ ÊÏÊ', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unsu', description = 'Ïîíèçèòü ðîçûñê',  text = '/me äîñòàë{sex} ñâîé ÊÏÊ è îòêðûë{sex} áàçó äàííûõ ïðåñòóïíèêîâ&/me íàéäÿ äåëî N{id} âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/unsu {id} {number} {arg}', arg = '{id} {number} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'clear', description = 'Ñíÿòü ðîçûñê',  text = '/me äîñòà¸ò ñâîé ÊÏÊ è îòêðûâàåò áàçó äàííûõ ïðåñòóïíèêîâ&/me íàéäÿ äåëî N{id} âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/clear {id}&/do Äåëî N{id} áîëüøå íå íàõîäèòñÿ â ñïèñêå ðàçûñêèâàåìûõ ïðåñòóïíèêîâ.', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'gcuff', description = 'Íàäåòü íàðó÷íèêè è âåñòè çà ñîáîé',  text = '/do Íàðó÷íèêè íà òàêòè÷åñêîì ïîÿñå.&/todo ß íàäåíó íà âàñ íàðó÷íèêè*ñíèìàÿ íàðó÷íèêè ñ òàêòè÷åñêîãî ïîÿñà&/cuff {id}&/todo Íå äâèãàéòåñü*íàäåâàÿ íàðó÷íèêè íà ÷åëîâåêà&/me ñõâàòûâàåò çàäåðæàííîãî çà ðóêè è âåä¸ò åãî çà ñîáîé&/gotome {id}&/do Çàäåðæàííûé èä¸ò â êîíâîå.', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'cuff', description = 'Íàäåòü íàðó÷íèêè',  text = '/do Íàðó÷íèêè íà òàêòè÷åñêîì ïîÿñå.&/todo ß íàäåíó íà âàñ íàðó÷íèêè*ñíèìàÿ íàðó÷íèêè ñ òàêòè÷åñêîãî ïîÿñà&/cuff {id}&/todo Íå äâèãàéòåñü*íàäåâàÿ íàðó÷íèêè íà ÷åëîâåêà', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'uncuff', description = 'Ñíÿòü íàðó÷íèêè',  text = '/do Íà òàêòè÷åñêîì ïîÿñå ïðèêðåïëåíû êëþ÷è îò íàðó÷íèêîâ.&/me âçÿâ ñ ïîÿñà êëþ÷è îò íàðó÷íèêîâ ïðîêðóòèë{sex} çàìîê íàðó÷íèêîâ çàäåðæàííîãî&/uncuff {id}&/todo Âàøè ðóêè ñâîáîäíû*óáèðàÿ êëþ÷è îò íàðó÷íèêè îáðàòíî íà ïîÿñ', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'gtm', description = 'Ïîâåñòè çà ñîáîé',  text = '/me êðåïêî ñõâàòèâ çàäåðæàííîãî, âçÿë{sex} åãî çà ðóêè&/gotome {id}&/do Çàäåðæàííûé èä¸ò â êîíâîå.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'ungtm', description = 'Ïåðåñòàòü âåñòè çà ñîáîé',  text = '/me îòïóñêàåò ðóêè çàäåðæàííîãî è ïåðåñòà¸ò âåñòè åãî çà ñîáîé&/ungotome {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'bot', description = 'Èçüÿòü ñêðåïêè ó èãðîêà (âçëîì íàðó÷íèêîâ)',  text = '/me óâèäåë{sex} ÷òî çàäåðæàííûé èñïîëüçóåò ñêðåïêè äëÿ âçëîìà íàðó÷íèêîâ&/bot {id}&/todo Âû ÷òî ñåáå ïîçâîëÿåòå?!*èçûìàÿ ñêðåïêè ó {get_rp_nick({id})}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'ss', description = 'Êðè÷àëêà',  text = '/s Âñåì ïîäíÿòü ðóêè ââåðõ, ðàáîòàåò {fraction_tag}!', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 't', description = 'Äîñòàòü òàçåð',  text = '/taser', arg = '', enable = true, waiting = '2', bind = "[18,49]" },
					{cmd = 'frl', description = 'Ïåðâè÷íûé îáûñê',  text = 'Ñåé÷àñ ÿ ïðîâåðþ ó âàñ íàëè÷èå îðóæèÿ èëè äðóãèõ îñòðûõ ïðåäìåòîâ, íå äâèãàéòåñü.&/me ïðîùóïûâàåò òåëî çàäåðæàííîãî ÷åëîâåêà&/me ïðîùóïûâàåò êàðìàíû çàäåðæàííîãî ÷åëîâåêà', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'fr', description = 'Ïîëíûé îáûñê',  text = '/do Ðåçèíîâûå ïåð÷àòêè íà òàêòè÷åñêîì ïîÿñå.&/todo Ñåé÷àñ ÿ ïîëíîñòüþ îáûùó âàñ, íà íàëè÷èå çàïðåùåííûõ ïðåäìåòîâ*íàäåâàÿ ðåçèíîâûå ïåð÷àòêè&/me ïðîùóïûâàåò òåëî è êàðìàíû çàäåðæàííîãî ÷åëîâåêà&/me äîñòà¸ò èç êàðìàíîâ çàäåðæàííîãî âñå åãî âåùè äëÿ èçó÷åíèÿ&/me âíèìàòåëüíî îñìàòðèâàåò âñå íàéäåííûå âåùè ó çàäåðæàííîãî ÷åëîâåêà&/frisk {id}&/me ñíèìàåò ðåçèíîâûå ïåð÷àòêè è óáèðàåò èõ íà òàêòè÷åñêèé ïîÿñê&/do Áëîêíîò ñ ðó÷êîé â íàãðóäíîì êàðìàíå.&/me áåðåò â ðóêè áëîêíîò ñ ðó÷êîé, è çàïèñûâàåò âñþ èíôîðìàöèþ ïðî îáûñê&/me ñäåëàâ ïîìåòêè, óáèðàåò áëîêíîò ñ ðó÷êîé â íàãðóäíûé êàðìàí', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'take', description = 'Èçüÿòü ïðåäìåòû ó èãðîêà (6+)', text = '/do Â ïîäñóìêå íàõîäèòñÿ íåáîëüøîé çèï-ïàêåò.&/me äîñòà¸ò èç ïîäñóìêà çèï-ïàêåò è îòðûâàåò åãî&/me êëàä¸ò â çèï-ïàêåò èçúÿòûå ïðåäìåòû çàäåðæàííîãî ÷åëîâåêà&/take {id}&/do Èçúÿòûå ïðåäìåòû â çèï-ïàêåòå.&/todo Îòëè÷íî*óáèðàÿ çèï-ïàêåò â ïîäñóìîê', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true },
					{cmd = 'camon', description = 'Âêëþ÷èòü cêðûòóþ áîäè êàìåðó',  text = '/do Ê ôîðìå ïðèêðåïëåíà ñêðûòàÿ áîäè êàìåðà.&/me íåçàìåòíûì äâèæåíèåì ðóêè âêëþ÷èë{sex} áîäè êàìåðó.&/do Ñêðûòàÿ áîäè êàìåðà âêëþ÷åíà è ñíèìàåò âñ¸ ïðîèñõîäÿùåå.', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'camoff', description = 'Âûêëþ÷èòü cêðûòóþ áîäè êàìåðó',  text = '/do Ê ôîðìå ïðèêðåïëåíà ñêðûòàÿ áîäè êàìåðà.&/me íåçàìåòíûì äâèæåíèåì ðóêè âûêëþ÷èë{sex} áîäè êàìåðó.&/do Ñêðûòàÿ áîäè êàìåðà âûêëþ÷åíà è áîëüøå íå ñíèìàåò âñ¸ ïðîèñõîäÿùåå.', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'inc', description = 'Çàòàùèòü â òðàíñïîðò',  text = '/me îòêðûâàåò çàäíþþ äâåðü òðàíñïîðòà&/todo Íàêëîíèòå ãîëîâó, çäåñü äâåðü*çàòàëêèâàÿ çàäåðæàííîãî â òðàíñïîðòíîå ñðåäñòâî&/incar {id} {arg}&/me çàêðûâàåò çàäíþþ äâåðü òðàíñïîðòà&/do Çàäåðæàííûé â òðàíñïîðòíîì ñðåäñòâå.', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'ej', description = 'Âûáðîñèòü èç òðàíñïîðòà',  text = '/me îòêðûâàåò äâåðü òðàíñïîðòà&/me ïîìîãàåò ÷åëîâåêó âûéòè èç òðàíñïîðòà&/eject {id}&/me çàêðûâàåò äâåðü òðàíñïîðòà', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},	
					{cmd = 'pl', description = 'Âûáðîñèòü èãðîêà èç åãî òðàíñïîðòà',  text = '/me ðåçêèì óäàðîì äóáèíêè ðàçáèâàåò ñòåëî òðàíñïîðòà çàäåðæàííîãî&/pull {id}&/me âûáðàñûâàåò çàäåðæàííîãî èç åãî òðàíñïîðòà è óäàðîì äóáèíêè îãëóøàåò åãî', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},	
					{cmd = 'mr', description = 'Çà÷èòàòü ïðàâèëî Ìèðàíäû',  text = 'Âû èìååòå ïðàâî õðàíèòü ìîë÷àíèå.&Âñ¸, ÷òî âû ñêàæåòå, ìîæåò è áóäåò èñïîëüçîâàíî ïðîòèâ âàñ â ñóäå.&Âû èìååòå ïðàâî íà 1 òåëåôîííûé çâîíîê, íàïðèìåð äëÿ âûçîâà ÷àñòíîãî àäâîêàòà.&Âàø àäâîêàò ìîæåò ïðèñóòñòâîâàòü ïðè äîïðîñå.&Åñëè âû íå ìîæåòå îïëàòèòü óñëóãè àäâîêàòà, îí áóäåò ïðåäîñòàâëåí âàì ãîñóäàðñòâîì.&Âàì ÿñíû Âàøè ïðàâà?', arg = '', enable = true, waiting = '2', bind = "{}"},	
					{cmd = 'unmask', description = 'Ñíÿòü áàëàêëàâó ñ èãðîêà',  text = '/do Çàäåðæàííûé â áàëàêëàâå.&/me ñòÿãèâàåò áàëàêëàâó ñ ãîëîâû çàäåðàæííîãî&/unmask {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'arr', description = 'Àðåñòîâàòü (â ó÷àñòêå)',  text = '/me âêëþ÷àåò ñâîé áîðòîâîé êîìïþòåð è ââîäèò êîä äîñòóïà ñîòðóäíèêà&/me çàõîäèò â ðàçäåë îôîðìëåíèÿ ïðîòîêîëîâ çàäåðæàíèé è óêàçûâàåò äàííûå&/do Ïðîòîêîë çàäåðæàíèÿ çàïîëíåí.&/me âûçûâàåò ïî ðàöèè äåæóðíûé íàðÿä ó÷àñòêà è ïåðåäà¸ò èì çàäåðæàííîãî ÷åëîâåêà&/arrest', arg = '', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'bribe', description = 'Ïîëó÷åíèå âçÿòêè îò èãðîêà',  text = '/do Ãðàæäàíèí ñåé÷àñ âåä¸ò çàïèñü ÷åðåç àóäèî-âèäåî óñòðîéñòâà?&/n @{get_nick({id})}, îòâå÷àéòå íà ÐÏ, íàïðèìåð /do Íåò.&{pause}&/do Òåëåôîí â êàðìàíå.&/me äîñòàë{sex} òåëåôîí, îòêðûë{sex} çàìåòêè, è ÷òî-òî òóäà íàïèñàë{sex}&/do Â çàìåòêàõ òåëåôîíà íàïèñàí òàêîé òåêñò: {arg}$&/todo ×òî ñêàæåòå?*ïîêàçàâ òåëåôîí ïðåñòóïíèêó âîçëå ñåáÿ&{pause}&/bribe {id} {arg} 1', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'drugs', description = 'Ïðîâåñòè ýêñïåðòèçó óêðîïà',  text = '/do Íà òàêòè÷åñêîì ïîÿñå ïðèêðåïë¸í ïîäñóìîê.&/me îòêðûâàåò ïîäñóìîê è äîñòà¸ò èç íåãî íàáîð äëÿ ýêñïåðòèçû óêðîïà&/me áåð¸ò èç íàáîðà ïðîáèðêó ñ ýòèëîâûì ñïèðîì&/me çàñûïàåò íàéäåííîå âåùåñòâî â ïðîáèðêó&/me äîñòà¸ò èç ïîäñóìêà òåñò Èìóíî-Õðîì-10 è äîáàâëÿåò åãî â ïðîáèðêó&/do Â ïðîáèðêå ñ ýòèëîâûì ñïèðòîì íàõîäèòñÿ íåèçâåñòíîå âåùåñòâî è Èìóíî-Õðîì-10.&/me àêêóðàòíûìè äâèæåíèÿìè âçáàëòûâàåò ïðîáèðêó&/do Îò òåñòà Èìóíî-Õðîì-10 ñîäåðæèìîå ïðîáèðêè èçìåíèëî öâåò.&/todo Äà, ýòî òî÷íî óêðîï*óâèäåâ ÷òî ñîäåðæèìîå ïðîáèðêè èçìåíèëî öâåò&/me óáèðàåò ïðîáèðêó îáðàòíî â ïîäñóìîê è çàêðûâàåò åãî', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'rbomb', description = 'Äåàêòèâèðîâàòü áîìáó',  text = '/do Íà òàêòè÷åñêîì ïîÿñå ïðèêðåïë¸í ñàï¸ðíûé íàáîð.&/me ñíèìàåò ñ ïîÿñà ñàï¸ðíûé íàáîð è êëàäåò åãî íà çåìëþ, çàòåì îòêðûâàåò åãî&/do Îòêðûòûé ñàï¸ðíûé íàáîð íàõîäèòñÿ íà çåìëå.&/me äîñòà¸ò èç ñàï¸ðíîãî íàáîðà ïàêåò ñ æèäêèì àçîòîì è êëàäåò åãî íà çåìëþ&/me äîñòà¸ò èç ñàï¸ðíîãî íàáîðà îòâ¸ðòêó&/do Îòâåðòêà â ðóêàõ, à ïàêåò ñ æèäêèì àçîòîì íà çåìëå.&/do Íà êîðïóñå áîìáû íàõîäèòñÿ 2 áîëòèêà.&/me îòêðó÷èâàåò áîëòèêè ñ áîìáû è óáèðàåò èõ âìåñòå ñ îòâ¸ðòêîé â ñòîðîíó&/me àêêóðàòíûì äâèæåíèåì ðóêè âñêðûâàåò êðûøêó áîìáû&/me âíèìàòåëüíî îñìàòðèâàåò áîìáó&/do Âíóòðè áîìáû âèäíà äåòîíèðóþùàÿ ÷àñòü.&/me äîñòà¸ò èç ñàï¸ðíîãî íàáîðà êóñà÷êè&/do Êóñà÷êè â ðóêàõ.&/me àêêóðàòíûì äâèæåíèåì êóñî÷îê ðàçðåçàåò êðàñíûé ïðîâîä áîìáû&/do Òàéìåð îñòàíîâèëñÿ, òèêàíüå ñî ñòîðîíû áîìáû íå ñëûøíî.&/me áåð¸ò â ðóêè îõëàæäàþùèé ïàêåò ñ æèäêèì àçîòîì è êëàä¸ò åãî äåòîíèðóþùóþ ÷àñòü áîìáû&/removebomb&/do Áîìáà îáåçâðåæåíà.&/me óáèðàåò êóñà÷êè è îòâ¸ðòêó îáðàòíî â ñàïåðíûé íàáîð è çàêðûâàåò åãî', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'delo', description = 'Ðàññëåäîâàíèå óáèéñòâà',  text = '/do Ñîòðóäíèê ïðèáûë íà ìåñòî óáèéñòâà.&/todo Òàêñ, ÷òî æå çäåñü ïðîèçîøëî*îñìàòðèâàÿ ìåñòî óáèéñòâà&/me îñìàòðèâàåò è  èçó÷àåò âñå óëèêè&{pause}&/me äîñòà¸ò èç ïîäñóìêà áëàíê äëÿ ðàññëåäîâàíèÿ è ðó÷êó&/me çàïîëíÿåò áëàíê ðàññëåäîâàíèÿ çàïèñûâàÿ âñå èçó÷åííûå óëèêè&{pause}&/me çàïèñûâàåò â áëàíê òî÷íóþ äàòó è âðåìÿ óáèéñòâà&{pause}&/do Íàéäåíî îðóäèå óáèéñòâà.&/me çàïèñûâàåò â áëàíê îðóäèå óáèéñòâà&{pause}&/do Áëàíê ðàññëåäîâàíèÿ óáèéñòâà ïîëíîñòüþ çàïîëíåí.&/todo Îòëè÷íî, ðàññëåäîâàíèå îêîí÷åíî*óáèðàÿ áëàíê â êàðìàí', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'giveplate', description = 'Âûäà÷à ðàçðåøåíèé íà íîìåðà',  text = '/do Áëàíê è ðó÷êà â íàãðóäíîì êàðìàíå.&/me äîñòà¸ò ðó÷êó è áëàíê èç íàãðóäíîãî êàðìàíà&/me çàïîëíÿåò áëàíê äëÿ âûäà÷ó ðàçðåøåíèÿ íà íîìåðíîé çíàê&/do Áëàíê ïîëíîñòüþ çàïîëíåí.&/todo Âîò âàøå ðàçðåøåíèå, áåðèòå*óáèðàÿ ðó÷êó â íàãðóäíûé êàðìàí&/giveplate {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'agenda', description = 'Âûäà÷à ïîâåñòêè èãðîêó',  text = '/do Â ïàïêå ñ äîêóìåíòàìè ëåæèò ðó÷êà è ïóñòîé áëàíê ñ íàäïèñüþ Ïîâåñòêà.&/me äîñòà¸ò èç ïàïêè ðó÷êó ñ ïóñòûì áëàíêîì ïîâåñòêè&/me íà÷èíàåò çàïîëíÿòü âñå íåîáõîäèìûå ïîëÿ íà áëàíêå ïîâåñòêè&/do Âñå äàííûå â ïîâåñòêå çàïîëíåíû.&/me ñòàâèò íà ïîâåñòêó øòàìï è ïå÷àòü {fraction_tag}&/do Ãîòîâûé áëàíê ïîâåñòêè â ðóêàõ.&/todo Íå çàáóäüòå ÿâèòüñÿ â âîåíêîìàò ïî óêàçàííîìó àäðåñó è âðåìåíè*ïåðåäàâàÿ ïîâåñòêó&/agenda {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
				},
				fbi = {
					{cmd = 'doc', description = 'Çàïðîñèòü äîêóìåíòû (FBI)',  text = 'Çäðàâñòâóéòå, ÿ {fraction_rank} {fraction_tag}&/do Cëåâà íà ãðóäè ñïåö-æåòîí ÔÁÐ.&/me óêàçûâàåò ïàëüöåì íà ñâîé ñïåö-æåòîí íà ãðóäè&Ïðîøó ïðåäúÿâèòü äîêóìåíò, óäîñòîâåðÿþùèé âàøó ëè÷íîñòü.&/n @{get_nick({id})}, ââåäèòå /showpass {my_id} èëè /showbadge {my_id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'priton1', description = 'Îáíàðóæåí ïðèòîí',  text = '/d ÔÁÐ - ÌÞ: Â îïàñíîì ðàéîíå íàéäåí ïðèòîí ñ óêðîïîì!&/d ÔÁÐ - ÌÞ: Æåëàþùèå ïðèñîåäåíèòüñÿ ê ðåéäó - â ãàðàæ ËÑÏÄ&/d ÔÁÐ - ÌÞ: Âîçüìèòå ñ ñîáîé îðóæèå, áðîíèæåëåò, è îáÿçàòåëüíî ìàñêó!', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'priton2', description = 'Ïðèáûòèå íà ïðèòîí',  text = '/d ÔÁÐ - ÌÞ: Ìû ïðèáûëè íà òåðèòîðèþ ïðèòîíà ñ óêðîïîì! ß êóðàòîð ñïåö-îïåðàöèè.&/d ÔÁÐ - ÌÞ: Îöåïëÿéòå òåðèòîðèþ, è íèêîãî íå âñòóïàéòå íà òåðèòîðèþ ïðèòîíà ñ óêðîïîì.&/d ÔÁÐ - ÌÞ: Êóñòû óêðîïà ñðåçàþò òîëüêî àãåíòû, îñòàëüíûå çàùèùàþò!', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'priton3', description = 'Êîíåö ïðèòîíà',  text = '/d ÔÁÐ - ÌÞ: Ñïåö-îïåðàöèÿ "Ïðèòîí" îêîí÷åíà!&/d ÔÁÐ - ÌÞ: Âñåì ñïàñèáî çà ó÷àñòèå, ìîæåòå áûòü ñâîáîäíû!&/d ÔÁÐ - ÌÞ: Íå çàáóäüòå óáðàòü îãðàæäåíèÿ ñ òåððèòîðèè.', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'gwarn', description = 'Âûäàòü ñïåö-âûãîâîð',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me îòêðûâ áàçó äàííûõ {fraction_tag} ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/gwarn {id} {arg}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'ungwarn', description = 'Ñíÿòü ñïåö-âûãîâîð',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me îòêðûâ áàçó äàííûõ {fraction_tag} ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/ungwarn {id}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'dismiss', description = 'Óâîëèòü ãîññëóæàùåãî (1-4)',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me îòêðûâ áàçó äàííûõ {fraction_tag} ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/dismiss {id} {arg}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
				},
				army = {
					{cmd = 'pas', description = 'Ïðîâåðêà äîêóìåíòîâ (êïï)', text = 'Çäðàâñòâóéòå, ÿ {fraction_rank} {fraction_tag} - {my_doklad_nick}.&/do Óäîñòîâåðåíèå íàõîäèòñÿ â ëåâîì êàðìàíå áðþê.&/me äîñòàë{sex} óäîñòîâåðåíèå è ðàñêðûë{sex} åãî ïåðåä ÷åëîâåêîì.&/do Â óäîñòîâåðåíèè óêàçàíî: {fraction} - {fraction_rank} {my_doklad_nick}.&Íàçîâèòå ïðè÷èíó ïðèáûòèÿ íà òåððèòîðèþ íà íàøó áàçó.&È ïðåäîñòàâüòå ìíå ñâîè äîêóìåíòû äëÿ ïðîâåðêè!', arg = '', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'agenda', description = 'Âûäà÷à ïîâåñòêè èãðîêó',  text = '/do Â ïàïêå ñ äîêóìåíòàìè ëåæèò ðó÷êà è ïóñòîé áëàíê ñ íàäïèñüþ Ïîâåñòêà.&/me äîñòà¸ò èç ïàïêè ðó÷êó ñ ïóñòûì áëàíêîì ïîâåñòêè&/me íà÷èíàåò çàïîëíÿòü âñå íåîáõîäèìûå ïîëÿ íà áëàíêå ïîâåñòêè&/do Âñå äàííûå â ïîâåñòêå çàïîëíåíû.&/me ñòàâèò íà ïîâåñòêó øòàìï è ïå÷àòü {fraction_tag}&/do Ãîòîâûé áëàíê ïîâåñòêè â ðóêàõ.&/todo Íå çàáóäüòå ÿâèòüñÿ â âîåíêîìàò ïî óêàçàííîìó àäðåñó è âðåìåíè*ïåðåäàâàÿ ïîâåñòêó&/agenda {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'siren', description = 'Âêë/âûêë ìèãàëîê â ò/ñ', text = '{switchCarSiren}', arg = '', enable = true, waiting = '2', bind = "{}"},
				},
				prison = {
					{cmd = 't', description = 'Äîñòàòü òàçåð',  text = '/taser', arg = '', enable = true, waiting = '2', },
					{cmd = 'cuff', description = 'Íàäåòü íàðó÷íèêè', text = '/do Íàðó÷íèêè íà òàêòè÷åñêîì ïîÿñå.&/me ñíèìàåò íàðó÷íèêè ñ ïîÿñà è íàäåâàåò èõ íà çàäåðæàííîãî&/cuff {id}&/do Çàäåðæàííûé â íàðó÷íèêàõ.', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'uncuff', description = 'Ñíÿòü íàðó÷íèêè', text = '/do Íà òàêòè÷åñêîì ïîÿñå ïðèêðåïëåíû êëþ÷è îò íàðó÷íèêîâ.&/me ñíèìàåò ñ ïîÿñà êëþ÷ îò íàðó÷íèêîâ è âñòàâëÿåò èõ â íàðó÷íèêè çàäåðæàííîãî&/me ïðîêðó÷èâàåò êëþ÷ â íàðó÷íèêàõ è ñíèìàåò èõ ñ çàäåðæàííîãî&/uncuff {id}&/do Íàðó÷íèêè ñíÿòû ñ çàäåðæàííîãî&/me êëàä¸ò êëþ÷ è íàðó÷íèêè îáðàòíî íà òàêòè÷åñêèé ïîÿñ', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'gotome', description = 'Ïîâåñòè çà ñîáîé', text = '/me ñõâàòûâàåò çàäåðæàííîãî çà ðóêè è âåä¸ò åãî çà ñîáîé&/gotome {id}&/do Çàäåðæàííûé èä¸ò â êîíâîå.', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'ungotome', description = 'Ïåðåñòàòü âåñòè çà ñîáîé', text = '/me îòïóñêàåò ðóêè çàäåðæàííîãî è ïåðåñòà¸ò âåñòè åãî çà ñîáîé&/ungotome {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'take', description = 'Èçüÿòü ïðåäìåòû ó èãðîêà (6+)', text = '/do Â ïîäñóìêå íàõîäèòñÿ íåáîëüøîé çèï-ïàêåò.&/me äîñòà¸ò èç ïîäñóìêà çèï-ïàêåò è îòðûâàåò åãî&/me êëàä¸ò â çèï-ïàêåò èçúÿòûå ïðåäìåòû çàäåðæàííîãî ÷åëîâåêà&/take {id}&/do Èçúÿòûå ïðåäìåòû â çèï-ïàêåòå.&/todo Îòëè÷íî*óáèðàÿ çèï-ïàêåò â ïîäñóìîê', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'carcer', description = 'Ïîñàäêà èãðîêà â êàðöåð',text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me ïðèñëîíèâ çàêëþ÷¸ííîãî ê ñòåíå, ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë äâåðöó êàìåðû&/me ë¸ãêèìè äâèæåíèÿìè ðóê çàòîëêíóë çàêëþ÷¸ííîãî â êàìåðó, ïîñëå ÷åãî çàêðûë å¸&/me ë¸ãêèìè äâèæåíèÿìè ðóê çàêðåïèë êëþ÷ ê ñâÿçêå&/carcer {id} {number} {arg}',arg = '{id} {number} {arg}', enable = true, waiting = '2'},
					{cmd = 'setcarcer', description = 'Ñìåíà êàðöåðà èãðîêó', text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me ë¸ãêèìè äâèæåíèÿìè ðóê ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë ñâîáîäíóþ êàìåðó è êàìåðó çàêëþ÷¸ííîãî&/me âûòîëêíóë çàêëþ÷¸ííîãî èç ïåðâîé êàìåðû, çàòîëêíóë âî âòîðóþ, çàêðûâ äâåðè îáîèõ êàìåð&/me ë¸ãêèìè äâèæåíèÿìè ðóê çàêðåïèë êëþ÷ ê ñâÿçêå&/setcarcer {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2'},
					{cmd = 'uncarcer', description = 'Âûïóñê èãðîêà èç êàðöåðà', text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me äâèæåíèÿìè ðóê ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë êàìåðó è âûòîëêíóë èç íå¸ çàêëþ÷¸ííîãî&/me çàêðûë äâåðöó êàìåðû, çàêðåïèë êëþ÷ ê ñâÿçêå&/uncarcer {id}', arg = '{id}', enable = true, waiting = '2' },
					{cmd = 'frisk', description = 'Îáûñê çàêëþ÷¸ííîãî', text = '/do Ïåð÷àòêè íà ïîÿñå.&/me ñõâàòèë ïåð÷àòêè è îäåë&/do Ïåð÷àòêè îäåòû.&/me íà÷àë íàùóïûâàòü ÷åëîâåêà íàïðîòèâ&/frisk {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'punishsu', description = 'Ïîâûñèòü óðîâåíü íàêàçàíèÿ.', text ='/me äîñòà¸ò ñâîé ÊÏÊ è îòêðûâàåò áàçó äàííûõ òþðüìû&/me âíîñèò èçìåíåíèÿ â áàçó äàííûõ òþðüìû&/do Èçìåíåíèÿ çàíåñåíû â áàçó äàííûõ òþðüìû.&/punish {id} {number} 2 {arg}', arg = '{id} {number} {arg}', enable = true, waiting = '2'},
					{cmd = 'punishclear', description = 'Ïîíèçèòü óðîâåíü íàêàçàíèÿ', text = '/me äîñòà¸ò áëîêíîò èç íàãðóäíîãî êàðìàíà&/do Áëîêíîò â ðóêå.&/me îòêðûâàåò åãî íà ñòðàíèöå ñ çàïèñÿìè î ïîâåäåíèè çàêëþ÷åííûõ.&/do Â áëîêíîòå âèäíà çàïèñü: "{get_rp_nick({id})}, ïðèìåðíîå ïîâåäåíèå...&/do ...ó÷àñòèå â óáîðêå òåððèòîðèè, îòñóòñòâèå íàðóøåíèé."&/me áåð¸ò ðó÷êó è çàïèñûâàåò íîâóþ èíôîðìàöèþ î çàêëþ÷¸ííîì.&/do Â áëîêíîòå äîáàâëåíà çàïèñü: "Ðåêîìåíäàöèÿ íà ñîêðàùåíèå ñðîêà...&/do ...íà {number} ãîäà çà äîáðîñîâåñòíîå âûïîëíåíèå îáÿçàííîñòåé."&/me çàêðûâàåò áëîêíîò è óáèðàåò åãî îáðàòíî â êàðìàí ôîðìû.&/do Äàííûå î çàêëþ÷¸ííîì çàôèêñèðîâàíû...&/do ...äëÿ ïîñëåäóþùåãî ðàññìîòðåíèÿ àäìèíèñòðàöèåé.&/punish {id} {number} 1 {arg}', arg = '{id} {number} {arg}', enable = true, waiting = '2'},
				},
				hospital = {
					{cmd = 'siren', description = 'Âêë/âûêë ìèãàëîê â ò/ñ', text = '{switchCarSiren}', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Ïîçâàòü èãðîêà çà ñîáîé', text = 'Õîðîøî {get_ru_nick({id})}, ñëåäóéòå çà ìíîé.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'hl', description = 'Îáû÷íîå ëå÷åíèå èãðîêà', text = '/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà íóæíîå ëåêàðñòâî è ïåðåäà¸ò åãî ÷åëîâåêó íàïðîòèâ&/todo Ïðèíèìàéòå ýòî ëåêàðñòâî, îíî âàì ïîìîæåò*óëûáàÿñü&/heal {id} {get_price_heal}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'hla', description = 'Ëå÷åíèå îõðàííèêà èãðîêà',  text = '/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà ëåêàðñòâî è ïåðåäà¸ò åãî ÷åëîâåêó íàïðîòèâ&/todo Äàâàéòå ñâîåìó îõðàííèêó ýòî ëåêàðñòâî, îíî åìó ïîìîæåò*óëûáàÿñü&/healactor {id} {get_price_actorheal}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'hlb', description = 'Ëå÷åíèå èãðîêà îò çàâèñèìîñòè óêðîïà',  text = '/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà òàáëåòêè îò çàâèñèìîñòè óêðîïà è ïåðåäà¸ò èõ ïàöèåíòó íàïðîòèâ&/todo Ïðèíèìàéòå ýòè òàáëåòêè, è â ñêîðîì âðåìåíè Âû èçëå÷èòåñü îò çàâèñèìîñòè óêðîïà*óëûáàÿñü&/healbad {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},	
					{cmd = 'mt', description = 'Ìåä.îcìîòð äëÿ âîåííîãî áèëåòà',  text = 'Õîðîøî, ñåé÷àñ ÿ ïðîâåäó âàì ìåä.îñìîòð äëÿ ïîëó÷åíèÿ âîåííîãî ... &... áèëåòà ïî ñòàíó çäîðîâüÿ, íî øàíñ íà óñïåõ âñåãî 1 ïðîöåíò!&/mticket {id} {get_price_mticket}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'pilot', description = 'Ìåä.îñìîòð äëÿ ïèëîòîâ',  text = 'Õîðîøî, ñåé÷àñ ÿ ïðîâåäó âàì ìåä.îñìîòð äëÿ ïèëîòîâ.&/medcheck {id} {get_price_medosm}&{pause}&È òàê...&/me äîñòà¸ò èç ìåä.êåéñà ñòåðèëüíûå ïåð÷àòêè è íàäåâàåò èõ íà ðóêè&/do Ïåð÷àòêè íà ðóêàõ.&/todo Íà÷í¸ì ìåä.îñìîòð*óëûáàÿñü.&Ñåé÷àñ ÿ ïðîâåðþ âàøå ãîðëî, îòêðîéòå ðîò è âûñóíèòå ÿçûê.&/me äîñòà¸ò èç ìåä.êåéñà ôîíàðèê è âêëþ÷èâ åãî îñìàòðèâàåò ãîðëî ÷åëîâåêà íàïðîòèâ&Õîðîøî, ìîæåòå çàêðûâàòü ðîò, ñåé÷àñ ÿ ïðîâåðþ âàøè ãëàçà.&/me ïðîâåðÿåò ðåàêöèþ ÷åëîâåêà íà ñâåò, ïîñâåòèâ ôîíàðèê â ãëàçà&/do Çðà÷êè ãëàç îáñëåäóåìîãî ÷åëîâåêà ñóçèëèñü.&/todo Îòëè÷íî*âûêëþ÷àÿ ôîíàðèê è óáèðàÿ åãî â ìåä.êåéñ&Òàêñ, ñåé÷àñ ÿ ïðîâåðþ âàøå ñåðäöåáèåíèå, ïîýòîìó ïðèïîäíèìèòå âåðõíóþ îäåæäó!&/me äîñòà¸ò èç ìåä.êåéñà ñòåòîñêîï è ïðèëîæèâ åãî ê ãðóäè ÷åëîâåêà ïðîâåðÿåò ñåðäöåáèåíèå&/do Ñåðäöåáèåíèå â ðàéîíå 65 óäàðîâ â ìèíóòó.&/todo Ñ ñåðäöåáèåíèåì ó âàñ âñå â ïîðÿäêå*óáèðàÿ ñòåòîñêîï îáðàòíî â ìåä.êåéñ&/me ñíèìàåò ñî ñâîèõ ðóê èñïîëüçîâàííûå ïåð÷àòêè è âûáðàñûâàåò èõ&Íó ÷òî-æ ÿ ìîãó âàì ñêàçàòü, ñî çäîðîâüåì ó âàñ âñå â ïîðÿäêå, âû ñâîáîäíû!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'medin', description = 'Îôîðìëåíèå èãðîêó ìåä.ñòðàõîâêè',  text = 'Äëÿ îôîðìëåíèÿ ìåä.ñòðàõîâêè Âàì íåîáõîäèìî îïëàòèòü îïðåäåëííóþ cóììó.&Ñòîèìîñòü çàâèñèò îò ñðîêà äåéñòâèÿ áóäóùåé ìåä.ñòðàõîâêè.&Íà 1 íåäåëþ - $4ÎÎ.ÎÎÎ. Íà 2 íåäåëè - $8ÎÎ.ÎÎÎ. Íà 3 íåäåëè - $1.2ÎÎ.ÎÎÎ.&È òàê, ñêàæèòå, íà êàêîé ñðîê Âàì îôîðìèòü ìåä.ñòðàõîâêó?&{pause}&/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà ïóñòîé áëàíê ìåä.ñòðàõîâêè, ðó÷êó è ïå÷àòü {fraction_tag}&/me îòêðûâàåò áëàíê ìåä.ñòðàõîâêè è íà÷èíàåò åãî çàïîëíÿòü, çàòåì ñòàâèò ïå÷àòü {fraction_tag}&/me ïîëíîñòüþ çàïîëíèâ áëàíê ìåä.ñòðàõîâêè óáèðàåò ðó÷êó è ïå÷àòü îáðàòíî â ñâîé ìåä.êåéñ&/givemedinsurance {id}&/todo Âîò âàøà ìåä.ñòðàõîâêà, áåðèòå*ïðîòÿãèâàÿ áëàíê ñ ìåä.ñòðàõîâêîé ÷åëîâåêó íàïðîòèâ ñåáÿ', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'med', description = 'Îôîðìëåíèå èãðîêó ìåä.êàðòû',  text = 'Îôîðìëåíèå ìåä. êàðòû ïëàòíîå è çàâèñèò îò å¸ ñðîêà äåéñòâèÿ!&Ìåä. êàðòà íà 7 äíåé - ${get_price_med7}&Ìåä. êàðòà íà 14 äíåé - ${get_price_med14}&Ìåä. êàðòà íà 30 äíåé - ${get_price_med30}&Ìåä. êàðòà íà 60 äíåé - ${get_price_med60}&Ñêàæèòå, âàì íà êàêîé ñðîê îôîðìèòü ìåä. êàðòó?&{show_medcard_menu}&Õîðîøî, òîãäà ïðèñòóïèì ê îôîðìëåíèþ.&/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà ïóñòóþ ìåä.êàðòó, ðó÷êó è ïå÷àòü {fraction_tag}&/me îòêðûâàåò ïóñòóþ ìåä.êàðòó è íà÷èíàåò å¸ çàïîëíÿòü, çàòåì ñòàâèò ïå÷àòü {fraction_tag}&/me ïîëíîñòüþ çàïîëíèâ ìåä.êàðòó óáèðàåò ðó÷êó è ïå÷àòü îáðàòíî â ñâîé ìåä.êåéñ&/todo Âîò âàøà ìåä.êàðòà, áåðèòå*ïðîòÿãèâàÿ çàïîëíåííóþ ìåä.êàðòó ÷åëîâåêó íàïðîòèâ ñåáÿ&/medcard {id} {get_medcard_status} {get_medcard_days} {get_medcard_price}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'recept', description = 'Âûäà÷à èãðîêó ðåöåïòîâ',  text = 'Ñòîèìîñòü îäíîãî ðåöåïòà ñîñòàâëÿåò ${get_price_recept}&Ñêàæèòå ñêîëüêî Âàì òðåáóåòñÿ ðåöåïòîâ, ïîñëå ÷åãî ìû ïðîäîëæèì.&/n Âíèìàíèå! Â òå÷åíèè ÷àñà âûäà¸òñÿ ìàêñèìóì 5 ðåöåïòîâ!&{show_recept_menu}&Õîðîøî, ñåé÷àñ ÿ âûäàì âàì ðåöåïòû.&/me äîñòà¸ò èç ñâîåãî ìåä.êåéñà áëàíê äëÿ îôîðìëåíèÿ ðåöåïòîâ è íà÷àåò åãî çàïîëíÿòü&/me ñòàâèò íà áëàíê ðåöåïòà ïå÷àòü {fraction_tag}&/do Áëàíê óñïåøíî çàïîëíåí.&/todo Âîò, äåðæèòå!*ïåðåäàâàÿ áëàíê  ðåöåïòà ÷åëîâåêó íàïðîòèâ&/recept {id} {get_recepts}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'ant', description = 'Âûäà÷à èãðîêó àíòèáèîòèêîâ',  text = 'Ñòîèìîñòü îäíîãî àíòèáèîòèêà ñîñòàâëÿåò ${get_price_ant}&Ñêàæèòå ñêîëüêî Âàì òðåáóåòñÿ àíòèáèîòèêîâ, ïîñëå ÷åãî ìû ïðîäîëæèì.&/n Âíèìàíèå! Âû ìîæåòå êóïèòü îò 1 äî 20 àíòèáèòèêîâ çà îäèí ðàç!&{show_ant_menu}&Õîðîøî, ñåé÷àñ ÿ âûäàì âàì àíòèáèîòèêè.&/me îòêðûâàåò ñâîé ìåä.êåéñ è äîñòà¸ò èç íåãî ïà÷êó àíòèáèîòèêîâ, ïîñëå ÷åãî çàêðûâàåò ìåä.êåéñ&/do Àíòèáèîòèêè íàõîäÿòñÿ â ðóêàõ.&/todo Âîò äåðæèòå, óïîòðåáëÿéòå èõ ñòðîãî ïî ðåöåïòó!*ïåðåäàâàÿ àíòèáèîòèêè ÷åëîâåêó íàïðîòèâ&/antibiotik {id} {get_ants}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'osm', description = 'Ïîëíûé ìåä.îñìîòð èãðîêà (ÐÏ)',  text = 'Õîðîøî, ñåé÷àñ ÿ ïðîâåäó âàì ìåä.îñìîòð.&Äàéòå ìíå âàøó ìåä.êàðòó äëÿ ïðîâåðêè.&/n @{get_nick({id})}, ââåäèòå /showmc {my_id} ÷òîáû ïîêàçàòü ìíå ìåä.êàðòó.&{pause}&/me äîñòà¸ò èç ìåä.êåéñà ñòåðèëüíûå ïåð÷àòêè è íàäåâàåò èõ íà ðóêè&/do Ïåð÷àòêè íà ðóêàõ.&/todo Íà÷í¸ì ìåä.îñìîòð*óëûáàÿñü.&Ñåé÷àñ ÿ ïðîâåðþ âàøå ãîðëî, îòêðîéòå ðîò è âûñóíèòå ÿçûê.&/n Èñïîëüçóéòå /me îòêðûë(-à) ðîò ÷òîá ìû ïðîäîëæèëè&{pause}&/me äîñòà¸ò èç ìåä.êåéñà ôîíàðèê è âêëþ÷èâ åãî îñìàòðèâàåò ãîðëî ÷åëîâåêà íàïðîòèâ&Õîðîøî, ìîæåòå çàêðûâàòü ðîò, ñåé÷àñ ÿ ïðîâåðþ âàøè ãëàçà.&/me ïðîâåðÿåò ðåàêöèþ ÷åëîâåêà íà ñâåò, ïîñâåòèâ ôîíàðèê â ãëàçà&/do Çðà÷êè ãëàç îáñëåäóåìîãî ÷åëîâåêà ñóçèëèñü.&/todo Îòëè÷íî*âûêëþ÷àÿ ôîíàðèê è óáèðàÿ åãî â ìåä.êåéñ&Òàêñ, ñåé÷àñ ÿ ïðîâåðþ âàøå ñåðäöåáèåíèå, ïîýòîìó ïðèïîäíèìèòå âåðõíóþ îäåæäó!&{pause}&/me äîñòà¸ò èç ìåä.êåéñà ñòåòîñêîï è ïðèëîæèâ åãî ê ãðóäè ÷åëîâåêà ïðîâåðÿåò ñåðäöåáèåíèå&/do Ñåðäöåáèåíèå â ðàéîíå 65 óäàðîâ â ìèíóòó.&/todo Ñ ñåðäöåáèåíèåì ó âàñ âñå â ïîðÿäêå*óáèðàÿ ñòåòîñêîï îáðàòíî â ìåä.êåéñ&/me ñíèìàåò ñî ñâîèõ ðóê èñïîëüçîâàííûå ïåð÷àòêè è âûáðàñûâàåò èõ&Íó ÷òî-æ ÿ ìîãó âàì ñêàçàòü...&Ñî çäîðîâüåì ó âàñ âñå â ïîðÿäêå, âû ñâîáîäíû!', arg = '{id}', enable = true, waiting = '2', bind = "{}"}, 
					{cmd = 'gd', description = 'Ýêñòðåííûé âûçîâ (/godeath)',  text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me ïðîñìàòðèâàåò èíôîðìàöèþ è âêëþ÷àåò íàâèãàòîð ê âûáðàííîìó ìåñòó ýêñòðåííîãî âûçîâà&/godeath {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'exp', description = 'Âûãíàòü èãðîêà èç áîëüíèöû',  text = 'Âû áîëüøå íå ìîæåòå çäåñü íàõîäèòñÿ, ÿ âûãîíÿþ âàñ èç áîëüíèöû!&/me ñõâàòèâ ÷åëîâåêà âåä¸ò ê âûõîäó èç áîëüíèöû è çàêðûâàåò çà íèì äâåðü&/expel {id} Í.Ï.Á.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
				},
				smi = {
					{cmd = 'ads', description = 'Îòêðûòü ñïèñîê îáüÿâëåíèé',  text = '/newsredak', arg = '', enable = true, waiting = '2', bind = "[18,49]" },
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Ïîçâàòü èãðîêà çà ñîáîé', text = 'Õîðîøî {get_ru_nick({id})}, ñëåäóéòå çà ìíîé.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'expel', description = 'Âûãíàòü èãðîêà èç çäàíèÿ',  text = 'Âû áîëüøå íå ìîæåòå çäåñü íàõîäèòñÿ, ÿ âûãîíÿþ âàñ èç çäàíèÿ!&/me ñõâàòèâ ÷åëîâåêà âåä¸ò ê âûõîäó èç çäàíèÿ è çàêðûâàåò çà íèì äâåðü&/expel {id} Í.Ï.Ð.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'live_sobes', description = 'Ñîáåñåäîâàíèå', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ íîâîñòíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news [Ñîáåñåäîâàíèå]: Äîáðîãî âðåìåíè ñóòîê, óâàæàåìûå ãðàæäàíå Øòàòà!&/news [Ñîáåñåäîâàíèå]: Ñ Âàìè - ß, {fraction_rank} - {my_ru_nick}.&/news [Ñîáåñåäîâàíèå]: Äàâíî ìå÷òàëè èçìåíèòü ñâîþ æèçíü â ëó÷øóþ ñòîðîíó?&/news [Ñîáåñåäîâàíèå]: Ïîñòàâèòü íîâûå è íå çàïëàíèðîâàííûå öåëè?&/news [Ñîáåñåäîâàíèå]: Ñïåøó Âàñ îáðàäîâàòü! Âåäü èìåííî ñåé÷àñ ...&/news [Ñîáåñåäîâàíèå]: ... ïðîõîäèò ñîáåñåäîâàíèå â Ðàäèîöåíòð {fraction_tag}!&/news [Ñîáåñåäîâàíèå]: ×òî íóæíî èìåòü äëÿ ïðîõîæäåíèÿ ñîáåñåäîâàíèÿ?&/news [Ñîáåñåäîâàíèå]: Êðèòåðèè î÷åíü ïðîñòû, ïðè ñåáå íåîáõîäèìî èìåòü: ...&/news [Ñîáåñåäîâàíèå]: ... Ïàñïîðò, ìåä. êàðòó ñ îòìåòêîé Ïîëíîñòüþ çäîðîâ&/news [Ñîáåñåäîâàíèå]: Âåäü èìåííî ó íàñ: Äîáðîå è îòçûâ÷èâîå íà÷àëüñòâî ...&/news [Ñîáåñåäîâàíèå]: ... äîñòîéíûé êàðüåðíûé ðîñò è âûñîêèå çàðïëàòû!&/news [Ñîáåñåäîâàíèå]: Çàèíòåðåñîâàâøèõñÿ ïðîéòè ñîáåñåäîâàíèå îæèäàåì â ...&/news [Ñîáåñåäîâàíèå]: ... õîëëå ãëàâíîãî îôèñà {fraction_tag}.&/news [Ñîáåñåäîâàíèå]: À íà ýòîì íàø ýôèð ïîäõîäèò ê êîíöó!&/news [Ñîáåñåäîâàíèå]: Ñ Âàìè áûë - ß, {my_ru_nick}. Äî ñêîðûõ âñòðå÷!&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ íîâîñòíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_mp1', description = 'Âèêòîðèíà "Ñòîëèöû"', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ ýôèðíóþ âîëíó! Ïðîñüáà íå ïåðåáèâàòü.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news [Âèêòîðèíà]: Äîáðûé äåíü, óâàæàåìûå ðàäèîñëóøàòåëè!&/news [Âèêòîðèíà]: Ó ìèêðîôîíà - {my_ru_nick}!&/news [Âèêòîðèíà]: Ñåãîäíÿ ìû ïðîâåä¸ì - Ñòîëèöû.&/news [Âèêòîðèíà]: Ñóòü âèêòîðèíû òàêîâà: ß ãîâîðþ âàì ñòðàíó, À âû ìíå å¸ ñòîëèöó.&/news [Âèêòîðèíà]: Îòâåòû ïðèñûëàòü íà íîìåð ñòóäèè, åãî âû ìîæåòå íàéòè...&/news [Âèêòîðèíà]: ...â ñâî¸ì òåëåôîíå, â ðàçäåëå: Êîíòàêòû.&/news [Âèêòîðèíà]: Ïðèçîâîé Ôîíä ñåãîäíÿ ñîñòàâëÿåò öåëûé 1 ìèëèîí äîëëàðîâ!&/news [Âèêòîðèíà]: Íó ÷òî æå, äàâàéòå íà÷èíàòü.&/news [Âèêòîðèíà]: Îòêðûâàåò ñåãîäíÿøíèé ìàðàôîí ñòðàí ïîèñòèíå ïðåêðàñíîå ãîñóäàðñòâî.&/news [Âèêòîðèíà]: Ñòðàíà, êîòîðàÿ ïîäàðèëà ìèðó íåîáû÷íóþ ïîï êóëüòóðó. È ýòî...&/news [Âèêòîðèíà]: ...Ðåñïóáëèêà Êîðåÿ. Èëè êàê å¸ íàçûâàþò åùå - Þæíàÿ Êîðåÿ.&{pause}&/news [Âèêòîðèíà]: Ñòîï! Íàøà ñòóäèÿ ïîëó÷èëà ïðàâèëüíûé îòâåò.&/news [Âèêòîðèíà]: Ïðàâèëüíûé îòâåò - Ñåóë...&/news [Âèêòîðèíà]: ...ãóñòî íàñåë¸ííûé ãîðîä ñ ìèëëèîíîì ðàçâëå÷åíèé íà ëþáîé âêóñ.&/news [Âèêòîðèíà]: Ïåðâûé ïðàâèëüíûé îòâåò ìû ïîëó÷èëè îò ãðàæäàíèíà...&{pause}&/news [Âèêòîðèíà]: Ïðîäîëæàåì. Ñëåäóþùåå Ãîñóäàðñòâî èçâåñòíî âî âñ¸ì ìèðå êàê ñòðàíà ôóòáîëà...&/news [Âèêòîðèíà]: ...è ñàìáû - Áðàçèëèÿ.&{pause}&/news [Âèêòîðèíà]: Ñòîï!&/news [Âèêòîðèíà]: Êàê áû àáñóðäíî ýòî íå çâó÷àëî, ñòîëèöà ñòðàíû Áðàçèëèÿ - Áðàçèëèà.&/news [Âèêòîðèíà]: Îòâåòîâ áûëî ìíîãî... Íî ñàìûì áûñòðûì îêàçàëñÿ ãðàæäàíèí...&{pause}&/news [Âèêòîðèíà]: Áîëüøóþ ÷àñòü ñëåäóþùåãî ãîñóäàðñòâà çàíèìàþò òðóäíî ïðîõîäèìûå Äæóíãëè...&/news [Âèêòîðèíà]: ß ãîâîðþ î Âüåòíàìå.&{pause}&/news [Âèêòîðèíà]: Íà ñòóäèþ ïîñòóïèë ïðàâèëüíûé îòâåò!&/news [Âèêòîðèíà]: Ñòîëèöåé Âüåòíàìà ÿâëÿåòñÿ ãîðîä Õàíîé.&/news [Âèêòîðèíà]: Ïðàâèëüíûé îòâåò íàì äàë ãðàæäàíèí...&{pause}&/news [Âèêòîðèíà]: Âû, óâàæàåìûé ðàäèîñëóøàòåëü, è ïðàâäà íå ïðîãóëèâàëè ãåîãðàôèþ â øêîëå.&/news [Âèêòîðèíà]: Èìåííî â ýòîé ñòðàíå íàõîäèòñÿ äåéñòâóþùèé âóëêàí 'Êðàêàòàó'.&/news [Âèêòîðèíà]: ...Èíäîíåçèÿ.&{pause}&/news [Âèêòîðèíà]: Ñòîï!&/news [Âèêòîðèíà]: È... Ïðàâèëüíûé îòâåò... Äæàêàðòà.&/news [Âèêòîðèíà]: Ãîðîä êîíòðàñòîâ, â êîòîðîì ïåðåïëåëèñü ðàçíûå ÿçûêè è êóëüòóðû...&/news [Âèêòîðèíà]: ...áîãàòñòâî è áåäíîñòü.&/news [Âèêòîðèíà]: Óâåðåí ñ ýòèì ãîðîäîì çíàêîì íàø ñëóøàòåëü ïîä èìåíåì...&{pause}&/news [Âèêòîðèíà]: Âåäü èìåííî îí è äàë ïðàâèëüíûé îòâåò!&/news [Âèêòîðèíà]: Ãóñòûå ëåñà, ñêàëèñòûå îñòðîâà, ãîðíîëûæíûå êóðîðòû. Ýòî âñ¸ ïðî...&/news [Âèêòîðèíà]: ...ñòðàíó - Ôèíëÿíäèÿ.&{pause}&/news [Âèêòîðèíà]: Ñòîï! Íàøà ñòóäèÿ ïîëó÷èëà ïðàâèëüíûé îòâåò.&/news [Âèêòîðèíà]: Ïðàâèëüíûì îòâåòîì ÿâëÿåòñÿ - Õåëüñèíêè! È ýòîò îòâåò äàë øòàòà ñ èìåíåì...&{pause}&/news [Âèêòîðèíà]: Áîëüøå âñåãî îá ýòîé ñòðàíå çíàþò ëûæíèêè è ñíîóáîðäèñòû...&/news [Âèêòîðèíà]: ...Àâñòðèÿ.&/news [Âèêòîðèíà]: Íà ñòóäèþ ïîñòóïèë ïðàâèëüíûé îòâåò!&/news [Âèêòîðèíà]: Ëþáîé ðàçãîâîð îá Àâñòðèè âñåãäà ñâîäèòñÿ ê åå ñòîëèöå, è íå ñïðîñòà.&/news [Âèêòîðèíà]: Âåäü 'Âåíà' - êðóïíåéøèé êóëüòóðíî-èñòîðè÷åñêèé öåíòð Åâðîïû.&/news [Âèêòîðèíà]: Ïåðâûì ïðàâèëüíûé îòâåò â ñòóäèþ ïðèñëàë ãðàæäàíèí ñ èìåíåì...&{pause}&/news [Âèêòîðèíà]: È òàê, ñåé÷àñ ÿ îçâó÷ó ïîáåäèòåëÿ íàøåé âèêòîðèíû, âû ãîòîâû?&{pause}&/news [Âèêòîðèíà]: Ïðîñèì ïîáåäèòåëÿ ïðèåõàòü ê íàì çà íàãðàäîé...&/news [Âèêòîðèíà]: Íà ýòîì íàøà âèêòîðèíà îêîí÷åíà, ñïàñèáî âñåì âàì çà ó÷àñòèå!&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ ýôèðíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_mp2', description = 'Âèêòîðèíà "Ìàòåìàòèêà"', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ ýôèðíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news [Âèêòîðèíà]: Äîáðûé äåíü, óâàæàåìûå ðàäèîñëóøàòåëè!&/news [Âèêòîðèíà]: Ó ìèêðîôîíà - {my_ru_nick}!&/news [Âèêòîðèíà]: Ñåãîäíÿ ìû ïðîâåä¸ì âèêòîðèíó - Ìàòåìàòèêà.&/news [Âèêòîðèíà]: Ñóòü âèêòîðèíû: ß ãîâîðþ âàì ïðèìåðû, à âû ìíå îòâåòû íà íèõ.&/news [Âèêòîðèíà]: Â ïðèìåðàõ ìîãóò èñïîëüçîâàòüñÿ òàêèå îïåðàòîðû, êàê...&/news [Âèêòîðèíà]: ...ñëîæåíèå +, óìíîæåíèå *, âû÷èòàíèå -, äåëåíèå /.&/news [Âèêòîðèíà]: Îòâåòû ïðèñûëàòü íà íîìåð ñòóäèè, åãî âû ìîæåòå íàéòè...&/news [Âèêòîðèíà]: ...â ñâî¸ì òåëåôîíå, â ðàçäåëå: Êîíòàêòû.&/news [Âèêòîðèíà]: Ïðèçîâîé Ôîíä ñåãîäíÿ ñîñòàâëÿåò àæ öåëûõ 500.000$!&/news [Âèêòîðèíà]: Íó ÷òî æå, äàâàéòå íà÷èíàòü.&/news [Âèêòîðèíà]: Ïåðâûé ïðèìåð...&/news [Âèêòîðèíà]: ... '3 + 3 * 3'.&{pause}&/news [Âèêòîðèíà]: Ñòîï! Íà ñòóäèþ ïîñòóïèë âåðíûé îòâåò.&/news [Âèêòîðèíà]: Ïðàâèëüíûé îòâåò - '12'.&/news [Âèêòîðèíà]: Âåðíûé îòâåò íàì äàë ãðàæäàíèí ñ èìåíåì ...&{pause}&/news [Âèêòîðèíà]: Ìû òîëüêî íà÷èíàåì ðàçãîíÿòüñÿ...&/news [Âèêòîðèíà]: ... '66 - 44 + 1'.&{pause}&/news [Âèêòîðèíà]: Ñòîï!&/news [Âèêòîðèíà]: Êîððåêòíûì îòâåòîì ÿâëÿåòñÿ - '23'.&/news [Âèêòîðèíà]: Ïåðâûé ïðàâèëüíûé îòâåò ìû ïîëó÷èëè îò ãðàæäàíà ...&{pause}&/news [Âèêòîðèíà]: Ñëåäóþùèé ïðèìåð...&/news [Âèêòîðèíà]: ... '35 + 75'.&/news [Âèêòîðèíà]: È... Ó íàñ åñòü êîððåêòíûé îòâåò!&/news [Âèêòîðèíà]: È òàê, ïðàâèëüíûé îòâåò '110', è ìû ïîëó÷èëè ýòîò îòâåò îò ãðàæäàíèíà ...&{pause}&/news [Âèêòîðèíà]: Áåç ëèøíèõ ñëîâ, ñëåäóþùèé ïðèìåð...&/news [Âèêòîðèíà]: ... '25 - 28 + 1'.&{pause}&/news [Âèêòîðèíà]: Ñòîï!&/news [Âèêòîðèíà]: Íå îæèäàëè îòðèöàòåëüíûõ ÷èñåë â îòâåòå? Ïðàâèëüíûé îòâåò - '-2'.&/news [Âèêòîðèíà]: Ýòîò îòâåò íàì ïîäàðèë ãðàæäèíèí ñ èìåíåì ...&{pause}&/news [Âèêòîðèíà]: Äàâàéòå äîáàâèì ðàçíîîáðàçèÿ. ß çàãàäàþ ïðèìåð ïðè ïîìîùè...&/news [Âèêòîðèíà]: ...ðèìñêèõ ÷èñåë. Îòâåò äîëæåí áûòü â âèäå ðèìñêîãî ÷èñëà!&/news [Âèêòîðèíà]: ... 'X - IV'.&{pause}&/news [Âèêòîðèíà]: Ñòîï! Íà ñòóäèþ ïîñòóïèë ïðàâèëüíûé îòâåò!&/news [Âèêòîðèíà]: Êîððåêòíûì îòâåòîì ÿâëÿåòñÿ - 'VI'.&/news [Âèêòîðèíà]: Ñàìûì áûñòðûì áûë ãðàæäèíèí ...&{pause}&/news [Âèêòîðèíà]: Îïÿòü ðèìñêèå ÷èñëà.&/news [Âèêòîðèíà]: ... 'XV - VIII'.&{pause}&/news [Âèêòîðèíà]: Ñòîï!&/news [Âèêòîðèíà]: 'VII' - âåðíûé îòâåò.&/news [Âèêòîðèíà]: Ýòîò îòâåò íàì ïîäàðèë ãðàæäàíèí øòàòà -&{pause}&/news [Âèêòîðèíà]: È... Ïîñëåäíèé ïðèìåð ñ ðèìñêèìè ÷èñëàìè íà ñåãîäíÿ.&/news [Âèêòîðèíà]: ... 'XII - III'.&{pause}&/news [Âèêòîðèíà]: Ñòîï! Íàøà ñòóäèÿ ïîëó÷èëà ïðàâèëüíûé îòâåò.&/news [Âèêòîðèíà]: Âåðíûé îòâåò - 'IX'. À ïåðâûé îòâåò÷èê - ãðàæäàíèí ...&{pause}&/news [Âèêòîðèíà]: È òàê, ñåé÷àñ ÿ îçâó÷ó ïîáåäèòåëÿ íàøåé âèêòîðèíû, âû ãîòîâû?&{pause}&/news [Âèêòîðèíà]: Ïðîñèì ïîáåäèòåëÿ ïðèåõàòü ê íàì çà íàãðàäîé...&/news [Âèêòîðèíà]: Íà ýòîì íàøà âèêòîðèíà îêîí÷åíà, ñïàñèáî âñåì âàì çà ó÷àñòèå!/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ ýôèðíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather1', description = 'Ïðîãíîç ïîãîäû (óòðåííèé äîæäü)', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ íîâîñòíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news Äîáðîå óòðî, óâàæàåìûå ðàäèîñëóøàòåëè!&/news Ó ìèêðîôîíà {fraction_rank} - {my_ru_nick}.&/news Ñåãîäíÿøíèé äåíü íà÷àëñÿ ñ ïàñìóðíîé ïîãîäû è äîæäÿ.&/news Ñèíîïòèêè ñîîáùàþò, ÷òî îñàäêè ïðîäëÿòñÿ äî ïîëóäíÿ, òàê ÷òî íå çàáóäüòå âçÿòü çîíò!&/news Âåòåð ñåâåðî-çàïàäíûé, óìåðåííûé, íî ìîæåò óñèëèâàòüñÿ ïîðûâàìè äî 15 ì/c.&/news Òåìïåðàòóðà âîçäóõà +16°C, îäíàêî îùóùàåòñÿ êàê +13°C.&/news Âíèìàíèå âîäèòåëÿì: äîðîãè ìîãóò áûòü ñêîëüçêèìè, ñîáëþäàéòå äèñòàíöèþ!&/news Áëèæå ê îáåäó òó÷è íà÷íóò ðàññåèâàòüñÿ, à äîæäü ïðåêðàòèòñÿ.&/news À ïîêà äåðæèòåñü òåïëåå è íå çàáûâàéòå íàñëàæäàòüñÿ ñâåæåñòüþ ïîñëå äîæäÿ!&/news Íà ýòîì íàø óòðåííèé ïðîãíîç ïîãîäû çàâåðøàåòñÿ.&/news Ñ âàìè áûë {fraction_rank} - {my_ru_nick}.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ íîâîñòíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '2', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather2', description = 'Ïðîãíîç ïîãîäû (äíåâíîé)', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ íîâîñòíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news Äîáðûé äåíü, äîðîãèå ðàäèîñëóøàòåëè!&/news Ó ìèêðîôîíà {fraction_rank} - {my_ru_nick}.&/news Ñåé÷àñ ñàìîå âðåìÿ óçíàòü, êàêàÿ ïîãîäà æä¸ò íàñ äí¸ì.&/news Òåìïåðàòóðà âîçäóõà â äàííûé ìîìåíò ñîñòàâëÿåò +22°C, ñîëíå÷íî, íî âîçìîæíà ïåðåìåííàÿ îáëà÷íîñòü.&/news Âåòåð þæíûé, ñëàáûé, îêîëî 5 ì/ñ, êîìôîðòíûå óñëîâèÿ äëÿ ïðîãóëîê.&/news Îñàäêîâ íå îæèäàåòñÿ, íî ê âå÷åðó âîçìîæíû ë¸ãêèå ïîðûâû âåòðà.&/news Åñëè ïëàíèðîâàëè ïðîâåñòè äåíü íà ñâåæåì âîçäóõå  îòëè÷íàÿ âîçìîæíîñòü!&/news Íà ýòîì íàø äíåâíîé ïðîãíîç çàâåðøàåòñÿ.&/news Ñ âàìè áûë {fraction_rank} - {my_ru_nick}. Äî ñêîðûõ âñòðå÷!&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ íîâîñòíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather3', description = 'Ïðîãíîç ïîãîäû (âå÷åðíèé òîðíàäî)', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ íîâîñòíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news Äîáðûé âå÷åð, äîðîãèå ðàäèîñëóøàòåëè!&/news Ó ìèêðîôîíà {fraction_rank} - {my_ru_nick}.&/news È â íàøåì âå÷åðíåì ýôèðå ðå÷ü ïîéä¸ò î ïðîãíîçå ïîãîäû.&/news Ñåé÷àñ ÿ âàì çà÷èòàþ, ÷òî ãîâîðÿò íàì íàøè ñèíîïòèêè...&/news Â 21:52 ïðåäïîëàãàåòñÿ ïåñ÷àíàÿ áóðÿ, êîòîðàÿ ïðîäëèòñÿ âñåãî íåñêîëüêî ìèíóò.&/news Â ñâÿçè ñ ýòèì ïðîñèì âàñ îñòàòüñÿ äîìà è ïëîòíî çàêðûòü îêíà è äâåðè.&/news Òàêæå â ðàéîíå Ïàëîìèíî Êðèò çàìå÷åíî òîðíàäî.&/news Ïðèçûâàåì Âàñ èçáåãàòü ïîåçäîê â ýòîò ðàéîí Øòàòà.&/news È óæå â 22:10 íàñ îæèäàåò ñïîêîéíàÿ, íî÷íàÿ ïîãîäà.&/news Íî íå ñòîèò òàê ñèëüíî ðàäîâàòüñÿ, áëèæå ê íî÷è ÷åðåäîâàíèå ñïîêîéíîé ïîãîäû è ïåñ÷àíîé áóðè ïðîäîëæèòñÿ.&/news Ñ ÷åì ýòî ñâÿçàíî - íåèçâåñòíî! Íî ìû ïîïûòàåìñÿ óâåäîìèòü Âàñ îá èçìåíåíèÿõ êàê ìîæíî ñêîðåå.&/news À íà ýòîì íàø ýôèð ïîäõîäèò ê êîíöó.&/news Ñ âàìè áûë {fraction_rank} - {my_ru_nick}.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ íîâîñòíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_int1', description = 'Èíòåðâüþ (íà÷àëî)', text = "/me íàæèìàåò íà íåîáõîäèìûå êíîïêè â àïïàðàòóðå, òåì ñàìûì âêëþ÷àåò åå&/do Àïïàðàòóðà âêëþ÷åíà è ðàáîòàåò èñïðàâíî.&/me ïðîâåðÿåò íà èñïðàâíîñòü àïïàðàòóðó è ìèêðîôîí&/me áåðåò íàóøíèêè ñî ñòîëèêà è íàäåâàåò èõ íà ñâîþ ãîëîâó&/todo Ðàç, ðàç, ðàç*ñòó÷à ïî ìèêðîôîíó.&/do Ìèêðîôîí èñïðàâåí è ãîòîâ ê ðàáîòå.&/d [{fraction_tag}] - [ÑÌÈ]: Çàíèìàþ ýôèðíóþ âîëíó.&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/news [Èíòåðâüþ]: Çäðàâñòâóéòå, óâàæàåìûå ðàäèîñëóøàòåëè!&/news [Èíòåðâüþ]: Ó ìèêðîôîíà - {my_ru_nick}!&/news [Èíòåðâüþ]: Ñåãîäíÿ ó íàñ â ãîñòÿõ îñîáûé ãîñòü íà èíòåðâüþ...&/news [Èíòåðâüþ]: Âîçìîæíî ìíîãèå èç âàñ äàæå çíàþò åãî, è òàê, íàø ãîñòü ýòî ...", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_int2', description = 'Èíòåðâüþ (êîíåö)', text = "/news [Èíòåðâüþ]: È íàø ýôèð ê ñîæàëåíèþ ïîäõîäèò ê êîíöó.&/news [Ïðåôèêñ]: Ñ âàìè áûë ß - {my_ru_nick}.&/news [Èíòåðâüþ]: Äî ñâèäàíèÿ, øòàò! Íå ïåðåêëþ÷àéòåñü!&/news °°°° Ìóçûêàëüíàÿ çàñòàâêà ðàäèîñòàíöèè {fraction_tag} °°°°&/d [{fraction_tag}] - [ÑÌÈ]: Îñâîáîæäàþ ýôèðíóþ âîëíó!&/me íàæèìàåò íà íåîáõîäèìûå êëàâèøè è âûõîäèò èç ýôèðà, ïîñëå ÷åãî îòêëþ÷àåò ìèêðîôîí&/do Ýôèð îêîí÷åí è ìèêðîôîí îòêëþ÷åí.&/me ñíèìàåò ñ ãîëîâû íàóøíèêè è êëàäåò èõ íà ìåñòî", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
				},
				fd = {
					{cmd = 'siren', description = 'Âêë/âûêë ìèãàëîê â ò/ñ', text = '{switchCarSiren}', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
				},
				lc = {
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü? Åñëè íóæíà ëèöåíçèÿ - ñêàæèòå òèï è ñðîê', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Ïîçâàòü èãðîêà çà ñîáîé', text = 'Õîðîøî {get_ru_nick({id})}, ñëåäóéòå çà ìíîé.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'gl', description = 'Âûäà÷à ëèöåíçèè èãðîêó', text = '/me âçÿë{sex} ñî ñòîëà áëàíê íà ïîëó÷åíèå ëèöåíçèè è çàïîëíèë{sex} åãî&/do Ñïóñòÿ íåêîòîðîå âðåìÿ áëàíê íà ïîëó÷åíèå ëèöåíçèè áûë çàïîëíåí.&/me ðàñïå÷àòàâ ëèöåíçèþ ïåðåäàë{sex} å¸ ÷åëîâåêó íàïðîòèâ&/givelicense {id}&Âîò âàøà ëèöåíçèÿ, âñåãî Âàì õîðîøåãî!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'prices', description = 'Îçíàêîìèòü èãðîêà ñ öåíàìè', text = '/todo Ñåé÷àñ ÿ ñêàæó âàì öåíû íà ëèöåíçèè*äîñòàâàÿ èçïîä ñòîéêè áëàíê ñ öåíàìè&/do Áëàíê ñ öåíàìè âñåõ ëèöåíçèé â ðóêàõ.&/me ïîäâèíóë{sex} áëàíê ïîáëèæå ê ñåáå è íà÷àë{sex} ÷èòàòü öåíû&Íà àâòîìîáèëü: 1 ìåñÿö - ${get_price_avto1}, 2 ìåñÿöà - ${get_price_avto2}, 3 ìåñÿöà - ${get_price_avto3}&Íà ìîòî: 1 ìåñÿö - ${get_price_moto1}, 2 ìåñÿöà - ${get_price_moto2}, 3 ìåñÿöà - ${get_price_moto3}&Íà âîäíûé: 1 ìåñÿö - ${get_price_swim1}, 2 ìåñÿöà - ${get_price_swim2}, 3 ìåñÿöà - ${get_price_swim3}&Íà ïîë¸òû: 1 ìåñÿö - ${get_price_fly1}&Íà îðóæèå: 1 ìåñÿö - ${get_price_gun1}, 2 ìåñÿöà - ${get_price_gun2}, 3 ìåñÿöà - ${get_price_gun3}&Íà îõîòó: 1 ìåñÿö - ${get_price_hunt1}, 2 ìåñÿöà - ${get_price_hunt2}, 3 ìåñÿöà - ${get_price_hunt3}&Íà ðûáàëêó: 1 ìåñÿö - ${get_price_fish1}, 2 ìåñÿöà - ${get_price_fish2}, 3 ìåñÿöà - ${get_price_fish3}&Íà êëàäû: 1 ìåñÿö - ${get_price_klad1}, 2 ìåñÿöà - ${get_price_klad2}, 3 ìåñÿöà - ${get_price_klad3}&Íà òàêñè: 1 ìåñÿö - ${get_price_taxi1}, 2 ìåñÿöà - ${get_price_taxi2}, 3 ìåñÿöà - ${get_price_taxi3}&Íà ìåõàíèêà: 1 ìåñÿö - ${get_price_mexa1}, 2 ìåñÿöà - ${get_price_mexa2}, 3 ìåñÿöà - ${get_price_mexa3}&/todo Âîò òàêèå ó íàñ öåíû*óáèðàÿ áëàíê ñ öåíàìè', arg = '', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'medka', description = 'Çàïðîñèòü ìåäêàðòó äëÿ ïðîâåðêè', text = '×òîáû ïîëó÷èòü ýòó ëèöåíçèþ, ïîêàæèòå ìíå âàøó ìåä.êàðòó&/n @{get_nick({id})}, ââåäèòå êîìàíäó /showmc {my_id} ÷òîáû ïîêàçàòü ìíå ìåä.êàðòó', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'exp', description = 'Âûãíàòü èãðîêà èç ÖË',  text = 'Âû áîëüøå íå ìîæåòå çäåñü íàõîäèòñÿ, ÿ âûãîíÿþ âàñ èç ÖË!&/me ñõâàòèâ ÷åëîâåêà âåä¸ò ê âûõîäó èç ÖË è çàêðûâàåò çà íèì äâåðü&/expel {id} Í.Ï.Ö.Ë.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
				},
				ins = {
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü? Åñëè íóæíà ëèöåíçèÿ - ñêàæèòå òèï è ñðîê', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Ïîçâàòü èãðîêà çà ñîáîé', text = 'Õîðîøî {get_ru_nick({id})}, ñëåäóéòå çà ìíîé.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'ins', description = 'Ïðåäëîæèòü äîï.óñëóãè',  text = 'ß ìîãó îôîðìèòü "Ñåìåéíûé ñåðòèôèêàò" èëè "Ïåíñèîííîå ñòðàõîâàíèå"&×òî âàì íóæíî? Ñòðàõîâàíèå äëÿ äåïîçèòà, ñåðòèôèêàò äëÿ âûïëàò&/insurance {id}&/me äîñòà¸ò íóæíûå áóìàãè äëÿ îôîðìëåíèÿ è ïåðåäà¸ò èõ ÷åëîâåêó íàïðîòèâ', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'exp', description = 'Âûãíàòü èãðîêà èç ÑÒÊ',  text = 'Âû áîëüøå íå ìîæåòå çäåñü íàõîäèòñÿ, ÿ âûãîíÿþ âàñ èç ÑÒÊ!&/me ñõâàòèâ ÷åëîâåêà âåä¸ò ê âûõîäó èç ÑÒÊ è çàêðûâàåò çà íèì äâåðü&/expel {id} Í.Ï.Ñ.Ê.', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
				},
				gov = {		
					{cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàâñòâóéòå, ÿ {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'go', description = 'Ïîçâàòü èãðîêà çà ñîáîé', text = 'Õîðîøî {get_ru_nick({id})}, ñëåäóéòå çà ìíîé.', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'visit', description = 'Ïîêàçàòü âèçèòêó àäâîêàòà',  text = '/me âûòàùèë{sex} èç íàãðóäíîãî êàðìàíà âèçèòêó àäâîêàòà&/do Íà âèçèòêå íàïèñàíî: "{my_ru_nick}, àäâîêàò øòàòà".&/showvisit {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'freely', description = 'Ïðåäëîæèòü óñëóãè àäâîêàòà',  text = '/do Ïàïêà ñ äîêóìåíòàìè íàõîäèòñÿ â ëåâîé ðóêå.&/me îòêðûâ ïàïêó, âûòàùèë{sex} èç íå¸ áëàíê äëÿ îñâîáîæäåíèÿ çàêëþ÷¸ííîãî&/me äîñòàâ èç êàðìàíà ðó÷êó, çàïîëíèë{sex} äîêóìåíò è ïåðåäàë{sex} ÷åëîâåêó íàïðîòèâ&/todo Âïèøèòå ñþäà ñâîè äàííûå è ïîñòàâüòå ïîäïèñü ñíèçó*ïåðåäàâàÿ ëèñò ñ ðó÷êîé&/free {id} 500000', arg = '{id}', enable = true, waiting = '2'},
					{cmd = 'visa', description = 'Âûäàòü ðàáî÷óþ âèçó äëÿ VC',  text = 'Ñòîèìîñòü óñëóãè ñîñòàâëÿåò 600 òûñÿ÷. Âû ñîãëàñíû?&Åñëè äà, òî ïðèñòóïàåì ê îôîðìëåíèþ&{pause}&/do Áëàíê äëÿ îôîðìëåíèÿ âèçû íàõîäèòñÿ â êàðìàíå.&/me çàñóíóâ ðóêó â êàðìàí, âçÿë{sex} áëàíê, ïîñëå ÷åãî ïðîòÿíóë{sex} åãî ÷åëîâåêó íàïðîòèâ&/todo Âïèøèòå ñþäà Âàøè äàííûå è ïîñòàâüòå ïîäïèñü ñíèçó*ïðîòÿãèâàÿ ëèñò ñ ðó÷êîé&/givevisa {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'tsr', description = 'Îïîâåùåíèå ÒÑÐ ïðî ïðèáûòèå',  text = '/d [Ïðà-âî] - [ÒÑÐ] Çàåçæàþ íà âàøó òåðèòîðèþ äëÿ îêàçàíèÿ àäâîêàòñêèõ óñëóã!', arg = '', enable = true, waiting = '2'},
					{cmd = 'car', description = 'Ïðåâðàòèòü ëè÷íûé ò/c â ñåðòèôèêàò', text = 'Ïåðåä òåì, êàê íà÷àòü, ïîïðîøó ïîëíîñòüþ îïóñòîøèòü áàãàæíèê è ñíÿòü âåñü òþíèíã&À òàêæå óáåäèòüñÿ, ÷òî ïðîáåã ìåíüøå ëèáî ðàâåí 200 êì&Åñëè Âû âñå ñäåëàëè, òî ìîæåì ïðèñòóïàòü&{pause}&Îêåé, ïðèñòóïàåì&/do Áëàíê äëÿ ïîëó÷åíèÿ ñåðòèôèêàòà íàõîäèòñÿ ïîä â êàðìàíå.&/me çàñóíóâ ðóêó â êàðìàí, âçÿë{sex} áëàíê, ïîñëå ÷åãî ïðîòÿíóë{sex} åãî ÷åëîâåêó íàïðîòèâ&/todo Âïèøèòå ñþäà Âàøè äàííûå è ïîñòàâüòå ïîäïèñü ñíèçó*ïðîòÿãèâàÿ ëèñò ñ ðó÷êîé&/givepass {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'wed', description = 'Çàêëþ÷åíèå áðàêà',  text = 'Äîáðûé äåíü, óâàæàåìûå íîâîáðà÷íûå è ãîñòè!&Óâàæàåìûå íåâåñòà è æåíèõ!&Ñåãîäíÿ - ñàìîå ïðåêðàñíîå è íåçàáûâàåìîå ñîáûòèå â âàøåé æèçíè.&Ñîçäàíèå ñåìüè  ýòî íà÷àëî äîáðîãî ñîþçà äâóõ ëþáÿùèõ ñåðäåö.&Ñ ýòîãî äíÿ âû ïîéä¸òå ïî æèçíè ðóêà îá ðóêó, âìåñòå ïåðåæèâàÿ è ðàäîñòü ñ÷àñòëèâûõ äíåé, è îãîð÷åíèÿ.&Ñîçäàâàÿ ñåìüþ, âû äîáðîâîëüíî ïðèíÿëè íà ñåáÿ âåëèêèé äîëã äðóã ïåðåä äðóãîì è ïåðåä áóäóùèì âàøèõ äåòåé.&Ïåðåä íà÷àëîì ðåãèñòðàöèè ïðîøó âàñ åù¸ ðàç ïîäòâåðäèòü, ÿâëÿåòñÿ ëè âàøå ðåøåíèå ñòàòü ñóïðóãàìè, ñîçäàòü ñåìüþ&{pause}&Ñ âàøåãî âçàèìíîãî ñîãëàñèÿ, âûðàæåííîãî â ïðèñóòñòâèè ñâèäåòåëåé, âàø áðàê ðåãèñòðèðóåòñÿ.&Ïðîøó âàñ â çíàê ëþáâè è ïðåäàííîñòè äðóã äðóãó îáìåíÿòüñÿ îáðó÷àëüíûìè êîëüöàìè.&/wedding {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2'},
					{cmd = 'pass', description = 'Èñïðàâèòü äàòó ðîæäåíèÿ â ïàñïîðòå',  text = '/do Áëàíê äëÿ çàìåíû èíôîðìàöèè â ïàñïîðòå íàõîäèòñÿ â êàðìàíå.&/me çàñóíóâ ðóêó â êàðìàí, âçÿë{sex} áëàíê, ïîñëå ÷åãî ïðîòÿíóë{sex} åãî ÷åëîâåêó íàïðîòèâ&/todo Âïèøèòå ñþäà íîâóþ äàòó è ïîñòàâüòå ïîäïèñü ñíèçó*ïðîòÿãèâàÿ ëèñò ñ ðó÷êîé&/givepass {id}', arg = '{id}', enable = true, waiting = '2'},	
					{cmd = 'givesocial', description = 'Âûäàòü ñîö.æèëü¸ íîâè÷êó',  text = '/me âçÿë{sex} äîêóìåíòû íà Ñîöèàëüíîå Æèëü¸ ó {get_ru_nick({id})} äëÿ ïîäïèñàíèÿ&/do Äîêóìåíòû â ðóêàõ.&/me äîñòàë{sex} ðó÷êó èç ïðàâîãî êàðìàíà ïèäæàêà, çàòåì ïîäïèñàë{sex} äîêóìåíò&/do Äîêóìåíò íà Ñîöèàëüíîå Æèëü¸ ïîäïèñàí.&/me ïåðåäàë{sex} ïîäïèñàííûå äîêóìåíòû íà Ñîö.Æèëü¸ {get_ru_nick({id})}&/givesocial {id}', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
					{cmd = 'frisk', description = 'Îáûñê (7+)', text = '/do Ïåð÷àòêè íàõîäÿòñÿ â êàðìàíå.&/me âçÿë{sex} ïåð÷àòêè ñ êàðìàíà è íàäåë{sex} èõ&/do Ïåð÷àòêè îäåòû.&/me íà÷àë íàùóïûâàòü ÷åëîâåêà íàïðîòèâ&/frisk {id}&/me ïîëíîñòüþ ïðîùóïàâ ÷åëîâåêà óáðàë{sex} ïåð÷àòêè îáðàòíî â êàðìàí', arg = '{id}', enable = false, waiting = '2' },
					{cmd = 'gwarn', description = 'Âûäàòü ñïåö-âûãîâîð (8+)',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me îòêðûâ áàçó äàííûõ {fraction_tag} ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/gwarn {id} {arg}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = false, waiting = '2', bind = "{}"},
					{cmd = 'ungwarn', description = 'Ñíÿòü ñïåö-âûãîâîð (8+)',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me îòêðûâ áàçó äàííûõ {fraction_tag} ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/ungwarn {id}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = false, waiting = '2', bind = "{}"},
					{cmd = 'exp', description = 'Âûãíàòü èãðîêà èç ïðàâèòåëüñòâà',  text = 'Âû áîëüøå íå ìîæåòå çäåñü íàõîäèòñÿ, ÿ âûãîíÿþ âàñ èç Ìýðèè!&/me ñõâàòèâ ÷åëîâåêà âåä¸ò ê âûõîäó èç ìýðèè è çàêðûâàåò çà íèì äâåðü&/expel {id} Í.Ï.Ï.', arg = '{id}', enable = true, waiting = '2', in_fastmenu = true},
				},
				judge = {		
					{cmd = 'ud', description = 'Ïîêàçàòü óäîñòîâåðåíèå', text = '/do Â êàðìàíå ïèäæàêà ëåæèò óäîñòîâåðåíèå.&/me ñóíóë{sex} ðóêó â êàðìàí è äîñòàë{sex} óäîñòîâåðåíèå&/todo Îçíàêîìòåñü*ïîêàçàâ óäîñòîâåðåíèå ÷åëîâåêó íàïðîòèâ&/do Îáëîæêà «Ñóäåéñêàÿ êîëëåãèÿ øòàòà Ñàí-Ñèòè».&/do «J2025 - <{my_ru_nick}> - Ñóäüÿ øòàòà».', arg = '', enable = true, waiting = '2'},
				},
				mafia = {
					{cmd = 'tie', description = 'Ñâÿçàòü æåðòâó', text = '/do Â êàðìàíå áðîíåæèëåòà ëåæèò øïàãàò.&/me ëåãêèì äâèæåíèåì ðóêè äîñòàë{sex} èç êàðìàíà øïàãàò&/me îáâÿçûâàåò ðóêè æåðòâû âåðåâêîé è ñòÿãèâàåò å¸&/tie {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'untie', description = 'Ðàçâÿçàòü æåðòâó', text = '/do Íà ïðàâîì áåäðå çàêðåïëåíî òàêòè÷åñêîå êðåïëåíèå äëÿ íîæà.&/me äâèæåíèåì ïðàâîé ðóêè îòêðåïèâ íîæ, áåð¸ò åãî â ðóêè&/do Â ïðàâîé ðóêå äåðæèò íîæ.&/me ïîäîéäÿ ê æåðòâå ñî ñïèíû, îòðåçàë{sex} âåð¸âêó&/untie {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'lead', description = 'Âåñòè æåðòâó çà ñîáîé', text = '/me äâèæåíèåì ðóêè ñõâàòèâ çà øêèðêó æåðòâû, âåä¸ò åãî çà ñîáîé&/lead {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'unlead', description = 'Ïðåêðàòèòü âåñòè æåðòâó', text = '/me ðàññëàáèâ ñõâàòêó, ïåðåñòà¸ò êîíòðîëèðîâàòü æåðòâó&/unlead {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'gag', description = 'Çàòêíóòü ðîò æåðòâå òðÿïêîé', text = '/do Íà ïîÿñå çàêðåïëåíà ñóìêà.&/me ïðàâîé ðóêîé îòñòåãíóâ ìîëíèþ, îòêðûâàåò ñóìêó&/do Âíóòðè ñóìêè ëåæèò òðÿïêà.&/me ïîäõîäÿ ê æåðòâå, ïîïóòíî äîñòàë{sex} èç ñóìêè òðÿïêó&/do Òðÿïêà â ðóêàõ â ðàçâ¸ðíóòîì âèäå.&/me îáåèìè ðóêàìè çàâåðíóâ òðÿïêó, çàïèõíóë{sex} â ðîò æåðòâû&/gag {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'ungag', description = 'Âûòàùèòü òðÿïêó èçî ðòà æåðòâû', text = '/me ïîäîéäÿ áëèæå ê æåðòâå, äâèæåíèåì ïðàâîé ðóêè ïîòÿíóë{sex} çà òðÿïêó è çàáðàë{sex} ñåáå&/ungag {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'bag', description = 'Íàäåòü ïàêåò íà ãîëîâó æåðòâû', text = '/do Â êàðìàíå êóðòêè ëåæèò ìóñîðíûé ïàêåò.&/me äîñòàë{sex} ìóñîðíûé ïàêåò èç êàðìàíà, ðàçâåðíóë{sex} åãî&/me íàäåâàåò ìóñîðíûé ïàêåò íà ãîëîâó æåðòâû, íå çàòÿãèâàÿ åãî&/bag {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'unbag', description = 'Ñíÿòü ïàêåò ñ ãîëîâû æåðòâû', text = '/me ëåãêèì äâèæåíèåì ðóêè ñõâàòèâ çà ïàêåò, ïîòÿíóë{sex} åãî ââåðõ, òåì ñàìûì ñòÿíóâ ïàêåò ñ ãîëîâû æåðòâû&/unbag {id}', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
					{cmd = 'inñ', description = 'Çàòîëêàòü æåðòâó â ôóðãîí', text = '/me îòêðûâàåò äâåðè ôóðãîíà&/me áåðåò æåðòâó ïîä ðóêè è çàòàëêèâàåò âïåð¸ä ãîëîâîé â ôóðãîí&/me çàêðûâàåò äâåðè è ñàäèòñÿ â ôóðãîí&/incar {id} 3', arg = '{id}', enable = true, waiting = '2', bind = '{}', in_fastmenu = true},
				},
				ghetto = {}
			},
			commands_manage = {
				my = {},
				goss = {
					{cmd = 'inv', description = 'Ïðèíÿòèå èãðîêà â îðãàíèçàöèþ', text = '/do Â êàðìàíå åñòü ñâÿçêà ñ êëþ÷àìè îò ðàçäåâàëêè.&/me äîñòà¸ò èç êàðìàíà îäèí êëþ÷ èç ñâÿçêè êëþ÷åé îò ðàçäåâàëêè&/todo Âîçüìèòå, ýòî êëþ÷ îò íàøåé ðàçäåâàëêè*ïåðåäàâàÿ êëþ÷ ÷åëîâåêó íàïðîòèâ&/invite {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true  },
					{cmd = 'sr', description = 'Ïðîäàæà ðàíãà (÷àñòíûå)', text = '/me äîñòà¸ò äîêóìåíòû íà ïîäïèñü è ïåðåäà¸ò èõ ÷åëîâåêó íàïðîòèâ&{sellrank({id})}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true },
					{cmd = 'rp', description = 'Âûäà÷à ñîòðóäíèêó /fractionrp', text = '/fractionrp {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'gr', description = 'Ïîâûøåíèå/ïîíèæåíèå cîòðóäíèêà', text = '{show_rank_menu}&/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/giverank {id} {get_rank}&/r Ñîòðóäíèê {get_ru_nick({id})} ïîëó÷èë íîâóþ äîëæíîñòü!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'vize', description = 'Óïðàâëåíèå Vice City âèçîé ñîòðóäíèêà', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&{lmenu_vc_vize}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'cjob', description = 'Ïîñìîòðåòü óñïåøíîñòü ñîòðóäíèêà', text = '/checkjobprogress {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},	
					{cmd = 'fmutes', description = 'Âûäàòü ìóò ñîòðóäíèêó (10 min)', text = '/fmutes {id} Í.Ó.&/r Ñîòðóäíèê {get_ru_nick({id})} ëèøèëñÿ ïðàâà èñïîëüçîâàòü ðàöèþ íà 10 ìèíóò!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true },
					{cmd = 'funmute', description = 'Ñíÿòü ìóò ñîòðóäíèêó', text = '/funmute {id}&/r Ñîòðóäíèê {get_ru_nick({id})} òåïåðü ìîæåò ïîëüçîâàòüñÿ ðàöèåé!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'vig', description = 'Âûäà÷à âûãîâîðà cîòðóäíèêó', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/fwarn {id} {arg}&/r Ñîòðóäíèêó {get_ru_nick({id})} âûäàí âûãîâîð! Ïðè÷èíà: {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unvig', description = 'Ñíÿòèå âûãîâîðà cîòðóäíèêó', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/unfwarn {id}&/r Ñîòðóäíèêó {get_ru_nick({id})} áûë ñíÿò âûãîâîð!', arg = '{id}', enable = true, waiting = '2', bind = "{}", in_fastmenu = true},
					{cmd = 'unv', description = 'Óâîëüíåíèå èãðîêà èç ôðàêöèè', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò ñâîé òåëåôîí îáðàòíî â êàðìàí&/uninvite {id} {arg}&/r Ñîòðóäíèê {get_ru_nick({id})} áûë óâîëåí ïî ïðè÷èíå: {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'point', description = 'Óñòàíîâèòü ìåòêó äëÿ ñîòðóäíèêîâ', text = '/r Ñðî÷íî âûäâèãàéòåñü êî ìíå, îòïðàâëÿþ âàì êîîðäèíàòû...&/point', arg = '', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'govka', description = 'Ñîáåñåäîâàíèå ïî ãîññ.âîëíå', text = '/d [{fraction_tag}] - [Âñåì]: Çàíèìàþ ãîñóäàðñòâåííóþ âîëíó, ïðîñüáà íå ïåðåáèâàòü!&/gov [{fraction_tag}]: Äîáðîãî âðåìåíè ñóòîê, óâàæàåìûå æèòåëè íàøåãî øòàòà!&/gov [{fraction_tag}]: Ñåé÷àñ ïðîõîäèò ñîáåñåäîâàíèå â îðãàíèçàöèþ {fraction}&/gov [{fraction_tag}]: Äëÿ âñòóïëåíèÿ âàì íóæíî èìåòü äîêóìåíòû è ïðèåõàòü ê íàì â õîëë.&/d [{fraction_tag}] - [Âñåì]: Îñâîáîæäàþ  ãîñóäàðñòâåííóþ âîëíó, ñïàñèáî ÷òî íå ïåðåáèâàëè.', arg = '', enable = true, waiting = '2', bind = "{}"},
				},
				goss_fbi = {
					{cmd = 'demoute', description = 'Óâîëèòü ãîññëóæàùåãî',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me çàõîäèò â áàçó äàííûõ {fraction_tag} è ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/demoute {id} {arg}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = false, waiting = '2', bind = "{}"},
				},
				goss_prison = {
					{cmd = 'unpunish', description = 'Âûïóñê çàêëþ÷åííûõ èç ÒÑÐ', text = '/me ë¸ãêèìè äâèæåíèÿìè ðóê áåð¸ò äåëî çàêëþ÷¸ííîãî ñ ïîëêè, êëàä¸ò åãî íà ñòîë&/do Íà ñòîëå ëåæèò ðó÷êà è ïå÷àòü.&/me ë¸ãêèì äâèæåíèåì ïðàâîé ðóêè áåð¸ò ðó÷êó, çàïîëíÿåò ïîëå â äåëå çàêëþ÷¸ííîãî&/me ë¸ãêèìè äâèæåíèÿìè ðóê êëàä¸ò ðó÷êó íà ñòîë, áåð¸ò ïå÷àòü è ñòàâèò å¸ â äåëå&/me ë¸ãêèìè äâèæåíèÿìè ðóê ñòàâèò ïå÷àòü íà ñòîë, ïîñëå ÷åãî çàêðûâàåò äåëî&Âàø ñðîê óêîðî÷åí, âîçâðàùàéòåñü â êàìåðó è îæèäàéòå ...&... òðàíñïîðòèðîâêè äî áëèæàéøåãî íàñåë¸ííîãî ïóíêòà.&/unpunish {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2'},
					{cmd = 'rjailreklama', description = 'Ðåêëàìà ÓÄÎ', text = '/rjail Äîáðîãî âðåìåíè ñóòîê çàêëþ÷åííûå.&/rjail Â äàííûé ìîìåíò Âû ìîæåòå ïîêèíóòü òþðüìó äîñðî÷íî, ÷åðåç êàáèíåò íà÷àëüñòâà òþðüìû.&/rjail Îáðàòèòå âíèìàíèå, ÓÄÎ (óñëîâíî äîðî÷íîå îñâîáîæåíèå) ïëàòíîå!&/rjail Ñïàñèáî çà âíèìàíèå.', arg = '', enable = true, waiting = '2'}
				},
				goss_gov = {
					{cmd = 'lic', description = 'Âûäàòü ëèöåíçèþ àäâîêàòà', text = '/do Áëàíê äëÿ âûäà÷è ëèöåíçèè íàõîäèòñÿ ïîä ñòîëîì.&/me çàñóíóâ ðóêó ïîä ñòîë, âçÿë{sex} áëàíê, ïîñëå ÷åãî çàïîëíèë{sex} åãî íóæíîé èíôîðìàöèåé&/todo Âïèøèòå ñþäà Âàøè äàííûå è ïîñòàâüòå ïîäïèñü ñíèçó*ïåðåäàâàÿ áëàíê è ðó÷êó&/givelicadvokat {id}', arg = '{id}', enable = true, waiting = '2', },
					{cmd = 'demoute', description = 'Óâîëèòü ãîññëóæàùåãî',  text = '/do ÊÏÊ íàõîäèòñÿ íà ïîÿñíîì äåðæàòåëå.&/me áåð¸ò â ðóêè ñâîé ÊÏÊ è âêëþ÷àåò åãî&/me çàõîäèò â áàçó äàííûõ {fraction_tag} è ïåðåõîäèò â ðàçäåë óïðàâëåíèå ñîòðóäíèêàìè äðóãèõ îðãàíèçàöèé&/me îòêðûâàåò äåëî íóæíîãî ñîòðóäíèêà è âíîñèò â íåãî èçìåíåíèÿ&/do Èçìåíåíèÿ óñïåøíî ñîõðàíåíû.&/demoute {id} {arg}&/me âûõîäèò ñ áàçû äàííûõ {fraction_tag} è âûêëþ÷èâ ÊÏÊ óáèðàåò åãî íà ïîÿñíîé äåðæàòåëü', arg = '{id} {arg}', enable = false, waiting = '2', bind = "{}"},
				},
				mafia = {
					{cmd = 'inv', description = 'Ïðèíÿòèå èãðîêà â ìàôèþ', text = '/do Â êàðìàíå åñòü ñâÿçêà ñ êëþ÷àìè îò ðàçäåâàëêè.&/me äîñòà¸ò èç êàðìàíà îäèí êëþ÷ èç ñâÿçêè êëþ÷åé îò ðàçäåâàëêè&/todo Âîçüìèòå, ýòî êëþ÷ îò íàøåé ðàçäåâàëêè*ïåðåäàâàÿ êëþ÷ ÷åëîâåêó íàïðîòèâ&/invite {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'rp', description = 'Âûäà÷à /fractionrp', text = '/fractionrp {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'gr', description = 'Ïîâûøåíèå/ïîíèæåíèå cîòðóäíèêà', text = '{show_rank_menu}&/todo Âîò òåáå íîâàÿ ôîðìà!*ïðîòÿãèâàÿ ôîðìó ÷åëîâåêó íàïðîòèâ &/giverank {id} {get_rank}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'fmutes', description = 'Âûäàòü ìóò (10 min)', text = '/fmutes {id} Ïîäóìàé î ñâî¸ì ïîâåäåíèè', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'funmute', description = 'Ñíÿòü ìóò', text = '/funmute {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'vig', description = 'Âûäà÷à âûãîâîðà', text = '/f {get_ru_nick({id})}, òû ïðîâèíèëñÿ(-ëàñü) â {arg}!&/fwarn {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unvig', description = 'Ñíÿòèå âûãîâîðà', text = '/f {get_ru_nick({id})}, òû ïðîù¸í(-à)!&/unfwarn {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unv', description = 'Óâîëüíåíèå èãðîêà', text = '/me çàáèðàåò îðãàíèçàöèîííóþ ôîðìó ó ÷åëîâåêà&/uninvite {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'point', description = 'Óñòàíîâèòü ìåòêó äëÿ ñîòðóäíèêîâ', text = '/f Ñðî÷íî âûäâèãàéòåñü êî ìíå, îòïðàâëÿþ âàì êîîðäèíàòû...&/point', arg = '', enable = true, waiting = '2', bind = "{}"},
				},
				ghetto = {
					{cmd = 'inv', description = 'Èíâàéò', text = '/todo Áåðè, ýòî òåïåðü òâîÿ*ïðîòÿãèâàÿ áàíäàíó ÷åëîâåêó íàïðîòèâ.&/invite {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'rp', description = 'Êâåñò ÐÏ', text = '/fractionrp {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'gr', description = 'Ñìåíèòü ðàíã', text = '{show_rank_menu}&/todo Âîò òåáå íîâàÿ ôîðìà!*ïðîòÿãèâàÿ ôîðìó ÷åëîâåêó íàïðîòèâ &/giverank {id} {get_rank}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'fmutes', description = 'Âûäàòü ìóò (10ì)', text = '/fmutes {id} Ïîäóìàé î ñâî¸ì ïîâåäåíèè', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'funmute', description = 'Ñíÿòü ìóò', text = '/funmute {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'vig', description = 'Äàòü âûãîâîð', text = '/f {get_ru_nick({id})}, òû ïðîâèíèëñÿ(-ëàñü) â {arg}!&/fwarn {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unvig', description = 'Ñíÿòü âûãîâîð', text = '/f {get_ru_nick({id})}, òû ïðîù¸í(-à)!&/unfwarn {id}', arg = '{id}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'unv', description = 'Óâîëèòü', text = '/r Àðèâèäåð÷è, {get_ru_nick({id})}&/uninvite {id} {arg}', arg = '{id} {arg}', enable = true, waiting = '2', bind = "{}"},
					{cmd = 'point', description = 'Óñòàíîâèòü ìåòêó', text = '/f Ôàñòîì âñå êî ìíå!&/point', arg = '', enable = true, waiting = '2', bind = "{}"},
				}
			}
		}
	},
	piemenu = {
		name = 'Êðóãîâîå ìåíþ',
		path = config_dir .. "/PieMenu.json",
		data = {}
	},
	buttons = {
		name = 'Êíîïî÷êè',
		path = config_dir .. "/Buttons.json",
		data = {
			{
				enable = true,
				name = 'Áðîíèê',
				icon = 'SHIELD',
				action = '/armour',
				size = {x = 100, y = 25},
				pos = {x = 100, y = 400}
			}
		}
	},
	notes = {
		name = 'Çàìåòêè',
		path = config_dir .. "/Notes.json",
		data = {}
	},
	rpgun = {
		name = 'RP îðóæèå',
		path = config_dir .. "/Guns.json",
		data = {
            rp_guns = {
                {id = 0, name = 'êóëàêè', enable = true, rpTake = 2},
				{id = 1, name = 'êàñòåòû', enable = false, rpTake = 2},
				{id = 2, name = 'êëþøêó äëÿ ãîëüôà', enable = false, rpTake = 1},
				{id = 3, name = 'äóáèíêó', enable = true, rpTake = 3},
				{id = 4, name = 'îñòðûé íîæ', enable = false, rpTake = 3},
				{id = 5, name = 'áèòó', enable = false, rpTake = 1},
				{id = 6, name = 'ëîïàòó', enable = true, rpTake = 1},
				{id = 7, name = 'êèé', enable = false, rpTake = 1},
				{id = 8, name = 'êàòàíó', enable = false, rpTake = 1},
				{id = 9, name = 'áåíçîïèëó', enable = false, rpTake = 1},
				{id = 10, name = 'èãðóøêó', enable = false, rpTake = 2},
				{id = 11, name = 'áîëüøóþ èãðóøêó', enable = false, rpTake = 2},
				{id = 12, name = 'ìîòîðíóþ èãðóøêó', enable = false, rpTake = 2},
				{id = 13, name = 'áîëüøóþ èãðóøêó', enable = false, rpTake = 2},
				{id = 14, name = 'áóêåò öâåòîâ', enable = true, rpTake = 1},
				{id = 15, name = 'òðîñòü', enable = false, rpTake = 1},
				{id = 16, name = 'îñêîëî÷íóþ ãðàíàòó', enable = false, rpTake = 3},
				{id = 17, name = 'äûìîâóþ ãðàíàòó', enable = true, rpTake = 3},
				{id = 18, name = 'êîêòåéëü Ìîëîòîâà', enable = true, rpTake = 3},
				{id = 22, name = 'ïèñòîëåò Colt45', enable = false, rpTake = 4},
				{id = 23, name = "ïèñòîëåò ñ ãëóøèòåëåì", enable = true, rpTake = 4},
				{id = 24, name = 'ïèñòîëåò Desert Eagle', enable = true, rpTake = 4},
				{id = 25, name = 'äðîáîâèê', enable = true, rpTake = 1},
				{id = 26, name = 'îáðåç', enable = true, rpTake = 4},
				{id = 27, name = 'óëó÷øåííûé îáðåç', enable = false, rpTake = 1},
				{id = 28, name = 'ÏÏ Micro Uzi', enable = true, rpTake = 3},
				{id = 29, name = 'ÏÏ MP5', enable = true, rpTake = 4},
				{id = 30, name = 'àâòîìàò AK47', enable = true, rpTake = 1},
				{id = 31, name = 'àâòîìàò M4', enable = true, rpTake = 1},
				{id = 32, name = 'ÏÏ Tec9', enable = true, rpTake = 4},
				{id = 33, name = 'âèíòîâêó Rifle', enable = true, rpTake = 1},
				{id = 34, name = 'ñíàéïåðñêóþ âèíòîâêó', enable = true, rpTake = 1},
				{id = 35, name = 'ÐÏÃ', enable = false, rpTake = 1},
				{id = 36, name = 'ÏÒÓÐ', enable = false, rpTake = 1},
				{id = 37, name = 'îãíåì¸ò', enable = false, rpTake = 1},
				{id = 38, name = 'ìèíèãàí', enable = false, rpTake = 1},
				{id = 39, name = 'äèíàìèò', enable = false, rpTake = 3},
				{id = 40, name = 'äåòîíàòîð', enable = false, rpTake = 3},
				{id = 41, name = 'ïåðöîâûé áàëîí÷èê', enable = true, rpTake = 2},
				{id = 42, name = 'îãíåòóøèòåëü', enable = true, rpTake = 1},
				{id = 43, name = 'ôîòîàïàðàò', enable = true, rpTake = 2},
				{id = 44, name = 'ÏÍÂ', enable = false, rpTake = 3},
				{id = 45, name = 'òåïëîâèçîð', enable = false, rpTake = 3},
				{id = 46, name = 'ïàðàøóò', enable = true, rpTake = 1},
				-- gta sa damage reason
				{id = 49, name = 'ò/ñ', enable = false, rpTake = 1},
				{id = 50, name = 'ëîïàñòè âåðòîë¸òà', enable = false, rpTake = 1},
				{id = 51, name = 'ãðàíàòó', enable = false, rpTake = 1},
				{id = 54, name = 'êîëëèçèþ/òþíèíã', enable = false, rpTake = 1},
				-- ARZ CUSTOM GUN
				{id = 71, name = 'ïèñòîëåò Desert Eagle Steel', enable = true, rpTake = 4},
				{id = 72, name = 'ïèñòîëåò Desert Eagle Gold', enable = true, rpTake = 4},
				{id = 73, name = 'ïèñòîëåò Glock Gradient', enable = true, rpTake = 4},
				{id = 74, name = 'ïèñòîëåò Desert Eagle Flame', enable = true, rpTake = 4},
				{id = 75, name = 'ïèñòîëåò Python Royal', enable = true, rpTake = 4},
				{id = 76, name = 'ïèñòîëåò Python Silver', enable = true, rpTake = 4},
				{id = 77, name = 'àâòîìàò AK-47 Roses', enable = true, rpTake = 1},
				{id = 78, name = 'àâòîìàò AK-47 Gold', enable = true, rpTake = 1},
				{id = 79, name = 'ïóëåì¸ò M249 Graffiti', enable = true, rpTake = 1},
				{id = 80, name = 'çîëîòóþ Ñàéãó', enable = true, rpTake = 1},
				{id = 81, name = 'ÏÏ Standart', enable = true, rpTake = 4},
				{id = 82, name = 'ïóëåì¸ò M249', enable = true, rpTake = 1},
				{id = 83, name = 'ÏÏ Skorp', enable = true, rpTake = 4},
				{id = 84, name = 'àâòîìàò AKS74 êàìóôëÿæíûé', enable = true, rpTake = 1},
				{id = 85, name = 'àâòîìàò AK47 êàìóôëÿæíûé', enable = true, rpTake = 1},
				{id = 86, name = 'äðîáîâèê Rebecca', enable = true, rpTake = 1},
				{id = 87, name = 'Doomgun', enable = true, rpTake = 1},
				{id = 88, name = 'ëåäÿíîé ìå÷', enable = true, rpTake = 1},
				{id = 89, name = 'ïîðòàëüíóþ ïóøêó', enable = true, rpTake = 4},
				{id = 90, name = 'îãëóøàþùóþ ãðàíàòó', enable = true, rpTake = 3},
				{id = 91, name = 'îñëåïëÿþùóþ ãðàíàòó', enable = true, rpTake = 3},
				{id = 92, name = 'ñíàéïåðñêóþ âèíòîâêó TAC50', enable = true, rpTake = 1},
				{id = 93, name = 'îãëóøàþùèé ïèñòîëåò', enable = true, rpTake = 4},
				{id = 94, name = 'ñíåæíóþ ïóøêó', enable = true, rpTake = 1},
				{id = 95, name = 'ïèêñåëüíûé áëàñòåð', enable = true, rpTake = 3},
				{id = 96, name = 'àâòîìàò M4 Gold', enable = true, rpTake = 1},
				{id = 97, name = 'áàíäèòñêèé äðîáîâèê', enable = true, rpTake = 1},
				{id = 98, name = 'ÏÏ Uzi Graffiti', enable = true, rpTake = 4},
				{id = 99, name = 'çîëîòóþ ìîíòèðîâêó', enable = true, rpTake = 1},
				{id = 100, name = 'áèòó Compton', enable = true, rpTake = 1},
				{id = 101, name = 'ïèñòîëåò SciFi Deagle', enable = true, rpTake = 4},
				{id = 102, name = 'àâòîìàò SciFi AK47', enable = true, rpTake = 1},
				{id = 103, name = 'äðîáîâèê SciFi', enable = true, rpTake = 1},
				{id = 104, name = 'íîæ SciFi', enable = true, rpTake = 3},
				{id = 105, name = 'ñêàíåð', enable = false, rpTake = 4},
				{id = 106, name = 'çîëîòîé íîæ', enable = true, rpTake = 3},
				{id = 107, name = 'êàòàíó Íèð', enable = true, rpTake = 1},
				{id = 108, name = 'íåâèäèìûé íîæ', enable = true, rpTake = 3},
				{id = 109, name = "ýëåêòðîøîêåð Taser X26P", enable = true, rpTake = 4},
				{id = 110, name = 'îãíåííóþ êèðêó', enable = true, rpTake = 1},
            },
            rpTakeNames = {
				{"èç-çà ñïèíû", "çà ñïèíó"},
				{"èç êàðìàíà", "â êàðìàí"},
				{"èç ïîÿñà", "íà ïîÿñ"},
				{"èç êîáóðû", "â êîáóðó"}
			},
            gunActions = {
                on = {},
                off = {},
                partOn = {},
                partOff = {}
            },
			byId = {},
            oldGun = nil,
            nowGun = 0
        }
	},
    smart_uk = {
		name = 'Óìíûé Ðîçûñê',
		path = config_dir .. "/SmartUK.json",
		data = {}
	},
    smart_pdd = {
		name = 'Óìíûå Øòðàôû',
		path = config_dir .. "/SmartPDD.json",
		data = {}
	},
    smart_rptp = {
		name = 'Óìíûé Ñðîê',
		path = config_dir .. "/SmartRPTP.json",
		data = {}
	},
	arz_veh = {
		name = 'Òðàíñïîðò',
		path = config_dir .. "/Vehicles.json",
		data = {},
		byId = {},	
		cache = {}
	},
	ads_history = {
		name = 'Èñòîðèÿ Îáúÿâëåíèé',
		path = config_dir .. "/ADS.json",
		data = {}
	}
}
function save_module(key)
	local module = modules[key]
	if not module then print('Íåèçâåñòíûé ìîäóëü: ' .. tostring(key)) return false end

	local content = safe_encode_json(module.data)
	if not content then print('Íå óäàëîñü ñîõðàíèòü ìîäóëü "' .. module.name .. '" - îøèáêà êîäèðîâêè JSON') return false end

	local file, errstr = io.open(module.path, 'w')
	if not file then print('Íå óäàëîñü ñîõðàíèòü ìîäóëü "' .. module.name .. '": ' .. tostring(errstr or 'Unknown')) return false end

	file:write(content)
	file:close()

	print('Ìîäóëü "' .. module.name .. '" ñîõðàí¸í')
	return true
end
function load_module(key)
	local module = modules[key]
	if not module then print('Íåèçâåñòíûé ìîäóëü: ' .. tostring(key)) return end

	if not doesFileExist(module.path) then print('Ìîäóëü "' .. module.name .. '" èíèöèàëèçèðîâàí') save_module(key) return end

	local file, errstr = io.open(module.path, 'r')
	if not file then print('Íå óäàëîñü îòêðûòü ìîäóëü "' .. module.name .. '": ' .. tostring(errstr or 'Unknown')) return end

	local contents = file:read('*a') file:close()
	if #contents == 0 then print('Íå óäàëîñü çàãðóçèòü ìîäóëü "' .. module.name .. '" - ôàéë ïóñòîé') return end

	local ok, loaded = pcall(decodeJson, contents)
	if not ok or type(loaded) ~= 'table' then print('Íå óäàëîñü çàãðóçèòü ìîäóëü "' .. module.name .. '" - îøèáêà decode JSON') return end

	local changed = merge_defaults(module.data, loaded)
	module.data = loaded

	if changed then
		save_module(key)
		print('Ìîäóëü "' .. module.name .. '" îáíîâë¸í ïîä íîâóþ âåðñèþ')
	else
		print('Ìîäóëü "' .. module.name .. '" çàãðóæåí')
	end
end
------------------------------------------- GUI & MODULES ----------------------------------------
local MODULE = {
	Initial = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		slider = imgui.new.int(0),
		step = 0,
		fraction_type_selector = 0,
		fraction_type_selector_text = 'Áåç îðãàíèçàöèè',
		fraction_type_icon = nil,
		step2_result = 0,
		fraction_selector = 0,
		fraction_selector_text = '',
	},
	Main = {
		Window = imgui.new.bool(),
		theme = imgui.new.int(tonumber(settings.general.helper_theme)),
		input = imgui.new.char[256](),
		checkbox = {
			mobile_stop_button = imgui.new.bool(settings.general.mobile_stop_button or false),
			mobile_fastmenu_button = imgui.new.bool(settings.general.mobile_fastmenu_button or false),
			mobile_piemenu_button = imgui.new.bool(settings.general.piemenu or false),
		},
		slider = {
			transparent = imgui.new.int(tonumber(settings.general.transparent)),
			rank = imgui.new.int(),
			dpi = imgui.new.float(tonumber(settings.general.custom_dpi)),
		},
		mmcolor = imgui.new.float[3](),
		msgcolor = imgui.new.float[3](),
	},
	Binder = {
		Window = imgui.new.bool(),
		waiting_slider = imgui.new.float(0),
		ComboTags = imgui.new.int(),
		input_cmd = imgui.new.char[256](),
		input_description = imgui.new.char[256](),
		input_text = imgui.new.char[8192](),
		item_list = {
			u8('Áåç àðãóìåíòîâ'),
			u8('Ëþáîå çíà÷åíèå'),
			u8('ID èãðîêà'),
			u8('ID èãðîêà è ëþáîå çíà÷åíèå (ïðèìåð /vig 429 Áåç áåéäæèêà)'),
			u8('ID èãðîêà è ëþáîå ÷èñëî è ëþáîå çíà÷åíèå  (ïðèìåð /su 429 2 Íåïîä÷èíåíèå)')
		},
		ImItems = nil,
		data = {
			change_waiting = nil,
			change_cmd = nil,
			change_text = nil,
			change_arg = nil,
			change_bind = nil,
			create_command_9_10 = false,
			input_description = nil
		},
		state = {
			isActive = false,
			isStop = false,
			isPause = false
		},
		input_search_tag = imgui.new.char[64](),
		tag = {},
		tags = {},
	},
	Note = {
		Window = imgui.new.bool(),
		input_text = imgui.new.char[1048576](),
		input_name = imgui.new.char[256](),
		show_note_name = '',
		show_note_text = '',
	},
	Buttons = {
		Editor = {
			icon = '',
			name = imgui.new.char[256](),
			action = imgui.new.char[256](),
			size = {x = imgui.new.int(75), y = imgui.new.int(25)}
		}
	},
	Members = {
		Window = imgui.new.bool(),
		all = {},
		new = {},
		upd = {},
		info = {fraction = '', check = false},
	},
	RPWeapon = {
		Window = imgui.new.bool(),
		ComboTags = imgui.new.int(),
		item_list = {u8'Ñïèíà', u8'Êàðìàí', u8'Ïîÿñ', u8'Êîáóðà'},
		ImItems = imgui.new['const char*'][4]({u8'Ñïèíà', u8'Êàðìàí', u8'Ïîÿñ', u8'Êîáóðà'}),
		input_search = imgui.new.char[256]('')
	},
	CruiseControl = {
		active = false,
		wait_point = false,
		point = {x = 0, y = 0, z = 0}
	},
	-- goss
	Departament = {
		Window = imgui.new.bool(),
		text = imgui.new.char[256](),
		fm = imgui.new.char[32](u8(modules.departament.data.dep_fm)),
		tag1 = imgui.new.char[32](u8(modules.departament.data.dep_tag1)),
		tag2 = imgui.new.char[32](u8(modules.departament.data.dep_tag2)),
		new_tag = imgui.new.char[32](),
		checkbox = {anti_skobki = imgui.new.bool(modules.departament.data.anti_skobki or false)},
		selector = {tag = imgui.new.int(0), fm = imgui.new.int(0)}
	},
	Post = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		ComboCode = imgui.new.int(5),
		codes = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'},
		ImItemsCode = nil,
		name = '',
		code = 'CODE 4',
		active = false,
		start_time = 0,
		current_time = 0,
		time = 0,
		process_doklad = false,
	},
	-- mj
	Wanted = {
		Window = imgui.new.bool(),
		updwanteds = {},
		all = {},
		new = {},
		checker = false,
	},
	Patrool = {
		Window = imgui.new.bool(),
		ComboMark = imgui.new.int(1),
		marks = {'ADAM', 'LINCOLN', 'MARY', 'KING', 'HENRY', 'AIR', 'ASD', 'CHARLIE', 'ROBERT', 'SUPERVISOR', 'DAVID', 'EDWARD', 'NORA'},
		ImItemsMark = nil,
		ComboCode = imgui.new.int(5),
		codes = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'},
		ImItemsCode = nil,
		active = false,
		start_time = 0,
		current_time = 0,
		time = 0,
		process_doklad = false,
		code = 'CODE 4',
		mark = 'ADAM',
	},
	SumMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		form_su = '',
		player_id = nil
	},
	TsmMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		player_id = nil
	},
	-- prison
	ArmyPatrool = {
		post = ''
	},
	PumMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		player_id = nil
	},
	-- hospital
	MedCard = {
		Window = imgui.new.bool(),
		days = imgui.new.int(3),
		status = imgui.new.int(3),
		player_id = nil
	},
	Recept = {
		Window = imgui.new.bool(),
		recepts = imgui.new.int(1),
		player_id = nil
	},
	Antibiotik = {
		Window = imgui.new.bool(),
		ants = imgui.new.int(1),
		player_id = nil
	},
	HealChat = {
		Window = imgui.new.bool(),
		bool = false,
		player_id = nil,
		worlds = {'âûëå÷è', 'ëå÷è', 'õèë', 'ëåê', 'heal', 'hil', 'lek', 'òàáë', 'áîëèò', 'ãîëîâà', 'ëåêíè', 'ktr', 'ktxb', 'ujkjdf'},
	},
	GoDeath = {
		player_id = nil,
		locate = '',
		city = ''
	},
	MedicalPrice = {
		heal         = imgui.new.char[12](u8(settings.mh.price.heal)),
		heal_vc      = imgui.new.char[12](u8(settings.mh.price.heal_vc)),
		healactor    = imgui.new.char[12](u8(settings.mh.price.healactor)),
		healactor_vc = imgui.new.char[12](u8(settings.mh.price.healactor_vc)),
		medosm       = imgui.new.char[12](u8(settings.mh.price.medosm)),
		mticket      = imgui.new.char[12](u8(settings.mh.price.mticket)),
		healbad      = imgui.new.char[12](u8(settings.mh.price.healbad)),
		recept       = imgui.new.char[12](u8(settings.mh.price.recept)),
		ant          = imgui.new.char[12](u8(settings.mh.price.ant)),
		med7         = imgui.new.char[12](u8(settings.mh.price.med7)),
		med14        = imgui.new.char[12](u8(settings.mh.price.med14)),
		med30        = imgui.new.char[12](u8(settings.mh.price.med30)),
		med60        = imgui.new.char[12](u8(settings.mh.price.med60)),
	},
	-- SMI
	SmiEdit = {
		Window = imgui.new.bool(),
		input_edit_text = imgui.new.char[512](),
		input_search = imgui.new.char[256](),
		ad_message = '',
		ad_from = '',
		ad_dialog_id = '',
		adshistory_orig = '',
		adshistory_input_text = imgui.new.char[512](),
		skip_dialogd = true,
		ad_repeat_count = 0,
		last_ad_text = "",
		vip_pause = true,
		is_active_ad = true,
	},
	-- AS
	LicensePrice = {
		avto1 = imgui.new.char[12](u8(settings.lc.price.avto1)),
		avto2 = imgui.new.char[12](u8(settings.lc.price.avto2)),
		avto3 = imgui.new.char[12](u8(settings.lc.price.avto3)),
		moto1 = imgui.new.char[12](u8(settings.lc.price.moto1)),
		moto2 = imgui.new.char[12](u8(settings.lc.price.moto2)),
		moto3 = imgui.new.char[12](u8(settings.lc.price.moto3)),
		fish1 = imgui.new.char[12](u8(settings.lc.price.fish1)),
		fish2 = imgui.new.char[12](u8(settings.lc.price.fish2)),
		fish3 = imgui.new.char[12](u8(settings.lc.price.fish3)),
		swim1 = imgui.new.char[12](u8(settings.lc.price.swim1)),
		swim2 = imgui.new.char[12](u8(settings.lc.price.swim2)),
		swim3 = imgui.new.char[12](u8(settings.lc.price.swim3)),
		gun1 = imgui.new.char[12](u8(settings.lc.price.gun1)),
		gun2 = imgui.new.char[12](u8(settings.lc.price.gun2)),
		gun3 = imgui.new.char[12](u8(settings.lc.price.gun3)),
		hunt1 = imgui.new.char[12](u8(settings.lc.price.hunt1)),
		hunt2 = imgui.new.char[12](u8(settings.lc.price.hunt2)),
		hunt3 = imgui.new.char[12](u8(settings.lc.price.hunt3)),
		klad1 = imgui.new.char[12](u8(settings.lc.price.klad1)),
		klad2 = imgui.new.char[12](u8(settings.lc.price.klad2)),
		klad3 = imgui.new.char[12](u8(settings.lc.price.klad3)),
		taxi1 = imgui.new.char[12](u8(settings.lc.price.taxi1)),
		taxi2 = imgui.new.char[12](u8(settings.lc.price.taxi2)),
		taxi3 = imgui.new.char[12](u8(settings.lc.price.taxi3)),
		mexa1 = imgui.new.char[12](u8(settings.lc.price.mexa1)),
		mexa2 = imgui.new.char[12](u8(settings.lc.price.mexa2)),
		mexa3 = imgui.new.char[12](u8(settings.lc.price.mexa3)),
		fly1 = imgui.new.char[12](u8(settings.lc.price.fly1)),
		fly2 = imgui.new.char[12](u8(settings.lc.price.fly2)),
		fly3 = imgui.new.char[12](u8(settings.lc.price.fly3)),
		train1 = imgui.new.char[12](u8(settings.lc.price.train1)) -- rodina
	},
	-- FD
	Fires = {
		isZone = false,
		isDialog = false,
		dialogId = -1,
		location = '',
		locations = '',
		lvl = '-1',
	},
	-- INS
	Ins = {
		catch_ticket = {enable = false, nickname = nil},
	},
	-- GOV
	Zeks = {
		Window = imgui.new.bool(),
		updzeks = {},
		all = {},
		new = {},
		checker = false,
	},
	-- 9/10
	GiveRank = {
		Window = imgui.new.bool(),
		number = imgui.new.int(5),
		player_id = nil
	},
	Sobes = {
		Window = imgui.new.bool(),
		player_id = nil
	},
	LeadTools = {
		vc_vize = {bool = false, player_id = nil},
		auto_uninvite = {checker = false, msg1 = '', msg2 = '', msg3 = '', player_id = nil},
		spawncar = false,
		platoon = {check = false, player_id = nil},
		cleaner = {day_afk = 0, reason_day = 0, uninvite = false, players_to_kick = {}},
		sell_rank = {checker = false, player_id = nil},
	},
	-- others
	Update = {
		Window = imgui.new.bool(),
		is_need_update = false,
		version = "",
		url = "",
		info = "",
		download_file = ""
	},
	CommandStop = {
		Window = imgui.new.bool()
	},
	CommandPause = {
		Window = imgui.new.bool()
	},
	LeaderFastMenu = {
		Window = imgui.new.bool(),
		player_id = nil
	},
	FastMenu = {
		Window = imgui.new.bool(),
		player_id = nil
	},
	PieMenu = {
		Window = imgui.new.bool(),
		editor = {
			icon = imgui.new.char[32](),
			name = imgui.new.char[32](),
			action = imgui.new.char[256](),
			selector = imgui.new.int(0),
			current = nil,
			history = {},
			title = '',
			item = nil
		}
	},
	FastMenuButton = {
		Window = imgui.new.bool()
	},
	FastMenuPlayers = {
		Window = imgui.new.bool()
	},
	Icons = {
		keys = {},
		input = imgui.new.char[32](),
		
	},
	InfraredVision = false,
	NightVision = false,
	INPUT = {
		CURSOR_POS = 0,
		SELECTION_START = 0,
		SELECTION_END = 0,
		USER_MOVED_CURSOR = false,
	},
	FONT = nil,
	DEBUG = false,
	MOBILE_PLAYER_ID = -1
}
MODULE.Patrool.ImItemsMark = imgui.new['const char*'][#MODULE.Patrool.marks](MODULE.Patrool.marks)
MODULE.Patrool.ImItemsCode = imgui.new['const char*'][#MODULE.Patrool.codes](MODULE.Patrool.codes)
MODULE.Post.ImItemsCode = imgui.new['const char*'][#MODULE.Post.codes](MODULE.Post.codes)
MODULE.Binder.ImItems = imgui.new['const char*'][#MODULE.Binder.item_list](MODULE.Binder.item_list)
MODULE.Binder.tags = {
	-- Èãðîê
    {
        key = "my_id",
        description = "Âàø ID",
        category = "Èãðîê",
		mode = 'all',
        func = function()
			if IS_MOBILE then
				return MODULE.MOBILE_PLAYER_ID
			else
				return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
			end
        end
    },
	{
		key = "my_ru_nick",
		description = "Âàøå Èìÿ Ôàìèëèÿ",
		category = "Èãðîê",
		mode = "all",
		func = function() return modules.player.data.name_surname end
	},
    {
        key = "my_nick",
        description = "Âàø íèêíåéì",
        category = "Èãðîê",
		mode = 'all',
        func = function()
            return modules.player.data.nick
        end
    },
	{
		key = "my_rp_nick",
		description = "Âàø íèêíåéì áåç _",
		category = "Èãðîê",
		mode = "all",
		func = function()
			return modules.player.data.nick:gsub('_',' ')
		end
	},
	{
		key = "my_doklad_nick",
		description = "Âàøå È.Ôàìèëèÿ ïî ôîðìå",
		category = "Èãðîê",
		mode = "all",
		func = function()
			local nick = modules.player.data.nick
			local name, surname = nick:match('^(.+)%_(.+)$')
			if name and surname then
				return name:sub(1,1).."."..surname
			end
			return nick
		end
	},
	{
		key = "sex",
		description = "Ñèìâîë 'à' åñëè æåíñêèé ïîë",
		category = "Èãðîê",
		mode = "all",
		func = function()
			return (modules.player.data.sex == 'Æåíùèíà') and 'a' or ''
		end
	},
	-- Ôðàêöèÿ
	{
		key = "fraction",
		description = "Íàçâàíèå âàøåé ôðàêöèè",
		category = "Ôðàêöèÿ",
		mode = "all",
		func = function() return modules.player.data.fraction end
	},
	{
		key = "fraction_rank",
		description = "Íàçâàíèå âàøåãî ðàíãà",
		category = "Ôðàêöèÿ",
		mode = "all",
		func = function() return modules.player.data.fraction_rank end
	},
	{
		key = "fraction_rank_number",
		description = "Íîìåð âàøåãî ðàíãà",
		category = "Ôðàêöèÿ",
		mode = "all",
		func = function() return modules.player.data.fraction_rank_number end
	},
	{
		key = "fraction_tag",
		description = "Òåã âàøåé ôðàêöèè",
		category = "Ôðàêöèÿ",
		mode = "all",
		func = function() return modules.player.data.fraction_tag end
	},
	-- Îáùèå
	{
		key = "get_nick({id})",
		description = "Íèêíåéì èãðîêà èç ID",
		category = "Îáùåå",
		mode = "all",
		func = function() return '' end
	},
	{
		key = "get_rp_nick({id})",
		description = "Íèêíåéì èãðîêà èç ID áåç _",
		category = "Îáùåå",
		mode = "all",
		func = function() return '' end
	},
	{
		key = "get_ru_nick({id})",
		description = "Èìÿ Ôàìèëèÿ èãðîêà èç ID",
		category = "Îáùåå",
		mode = "all",
		func = function() return '' end
	},
	{
		key = "get_time",
		description = "Òåêóùåå âðåìÿ",
		category = "Îáùåå",
		mode = "all",
		func = function() return os.date("%H:%M:%S") end
	},
	{
		key = "get_date",
		description = "Òåêóùàÿ äàòà",
		category = "Îáùåå",
		mode = "all",
		func = function() return os.date("%d.%m.%Y") end
	},
	{
		key = "get_rank",
		description = "Âûáðàííûé ðàíã",
		category = "Îáùåå",
		mode = "all",
		func = function() return MODULE.GiveRank.number[0] end
	},
	{
		key = "get_square",
		description = "Òåêóùèé êâàäðàò",
		category = "Îáùåå",
		mode = "all",
		func = function()
			local KV = {[1]="À",[2]="Á",[3]="Â",[4]="Ã",[5]="Ä",[6]="Æ",[7]="Ç",[8]="È",[9]="Ê",[10]="Ë",[11]="Ì",[12]="Í",[13]="Î",[14]="Ï",[15]="Ð",[16]="Ñ",[17]="Ò",[18]="Ó",[19]="Ô",[20]="Õ",[21]="Ö",[22]="×",[23]="Ø",[24]="ß"}
			local X,Y,Z = getCharCoordinates(playerPed)
			X = math.ceil((X+3000)/250)
			Y = math.ceil((Y*-1+3000)/250)
			Y = KV[Y]
			if Y then return (Y .. '-' .. X) else return X end
		end
	},
	{
		key = "get_area",
		description = "Òåêóùèé ðàéîí",
		category = "Îáùåå",
		mode = "all",
		func = function()
			local x,y,z = getCharCoordinates(PLAYER_PED)
			return get_area(x,y,z)
		end
	},
	{
		key = "get_city",
		description = "Òåêóùèé ãîðîä",
		category = "Îáùåå",
		mode = "all",
		func = function()
			local city = {[0]="Âíå ãîðîäà",[1]="Ëîñ Ñàíòîñ",[2]="Ñàí Ôèåððî",[3]="Ëàñ Âåíòóðàñ"}
			return city[getCityPlayerIsIn(PLAYER_PED)]
		end
	},
	{
		key = "get_nearest_car",
		description = "Áëèæàéøèé ò/ñ",
		category = "Îáùåå",
		mode = "all",
		func = function() return get_near_car() end
	},
	{
		key = "get_drived_car",
		description = "Áëèæàéøèé ò/ñ ñ âîäèòåëåì",
		category = "Îáùåå",
		mode = "all",
		func = function() return get_near_car(true) end
	},
	-- ÒÐÀÍÑÏÎÐÒ
	{
		key = "get_car_units",
		description = "Íàïàðíèêè â âàøåì ò/ñ",
		category = "Òðàíñïîðò",
		mode = "all",
		func = function()
			if isCharInAnyCar(PLAYER_PED) then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local success, passengers = getNumberOfPassengers(car)
				if IS_MOBILE and success and passengers == nil then
					passengers = success
				end
				if success and passengers and tonumber(passengers) > 0 then
					local my_passengers = {}
					for k, v in ipairs(getAllChars()) do
						local res, id = sampGetPlayerIdByCharHandle(v)
						if res and id ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
							if isCharInAnyCar(v) then
								if car == storeCarCharIsInNoSave(v) then
									table.insert(my_passengers, id)
								end
							end
						end
					end
					if #my_passengers ~= 0 then
						local units = ''
						for _, idd in ipairs(my_passengers) do
							local nickname = sampGetPlayerNickname(idd)
							local first_letter = nickname:sub(1, 1)
							local last_name = nickname:match(".*_(.*)")
							if last_name then
								units = units .. first_letter .. "." .. last_name .. ' '
							else
								units = units .. nickname .. ' '
							end
						end
						return units
					else
						return 'Íåòó'
					end
				else
					return 'Íåòó'
				end
			else
				return 'Íåòó'
			end
		end
	},
	{
		key = "switchCarSiren",
		description = "Ïåðåêëþ÷èòü ìèãàëêè",
		category = "Òðàíñïîðò",
		mode = "all",
		func = function()
			if isCharInAnyCar(PLAYER_PED) then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				if getDriverOfCar(car) == PLAYER_PED then
					switchCarSiren(car, not isCarSirenOn(car))
					return '/me ' .. (isCarSirenOn(car) and 'âêëþ÷àåò' or 'âûêëþ÷àåò') .. ' ìèãàëêè'
				else
					return (isCarSirenOn(car) and 'Âûêëþ÷è' or 'Âðóáàé') .. ' ìèãàëêè!'
				end
			else
				return "Êõì"
			end
		end
	},
	-- Ïîñò
	{
		key = "get_post_name",
		description = "Íàçâàíèå âàøåãî ïîñòà",
		category = "Ïîñò",
		mode = "all",
		func = function() return MODULE.Post.name end
	},
	{
		key = "get_post_code",
		description = "Âàø òåêóùèé òåí-êîä",
		category = "Ïîñò",
		mode = "all",
		func = function() return MODULE.Post.code end
	},
	{
		key = "get_post_time",
		description = "Âðåìÿ íà ïîñòó",
		category = "Ïîñò",
		mode = "all",
		func = function()
			local hours = math.floor(MODULE.Post.time / 3600)
			local minutes = math.floor(( MODULE.Post.time % 3600) / 60)
			local secs = MODULE.Post.time % 60
			if hours > 0 then
				return string.format("%02d:%02d:%02d", hours, minutes, secs)
			else
				return string.format("%02d:%02d", minutes, secs)
			end
		end
	},
	{
		key = "get_post_format_time",
		description = "Âðåìÿ íà ïîñòó ñëîâàìè",
		category = "Ïîñò",
		mode = "all",
		func = function()
			local hours = math.floor(MODULE.Post.time / 3600)
			local minutes = math.floor((MODULE.Post.time % 3600) / 60)
			local secs = MODULE.Post.time % 60
			if hours > 0 then
				return string.format("%d ÷àñîâ %d ìèíóò %d ñåêóíä", hours, minutes, secs)
			elseif minutes > 0 then
				return string.format("%d ìèíóò %d ñåêóíä", minutes, secs)
			else
				return string.format("%d ñåêóíä(-û)", secs)
			end
		end
	},
	-- Ïîëèöèÿ
	{
		key = "get_form_su",
		description = "Çàïðîñ íà âûäà÷ó ðîçûñêà",
		category = "Ïîëèöèÿ",
		mode = "police",
		func = function() return MODULE.SumMenu.form_su end
	},
	{
		key = "get_patrool_mark",
		description = "Ìàêðèðîâêà ïàòðóëÿ",
		category = "Ïîëèöèÿ",
		mode = "police",
		func = function()
			if IS_MOBILE then
				return MODULE.Patrool.mark .. '-' .. MODULE.MOBILE_PLAYER_ID
			else
				return MODULE.Patrool.mark .. '-' .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
			end
		end
	},
	{
		key = "get_patrool_code",
		description = "Âàø òåêóùèé òåí-êîä",
		category = "Ïîëèöèÿ",
		mode = "police",
		func = function() return MODULE.Patrool.code end
	},
	{
		key = "get_patrool_time",
		description = "Âðåìÿ ïàòðóëÿ",
		category = "Ïîëèöèÿ",
		mode = "police",
		func = function()
			local hours = math.floor(MODULE.Patrool.time / 3600)
			local minutes = math.floor((MODULE.Patrool.time % 3600) / 60)
			local secs = MODULE.Patrool.time % 60
			if hours > 0 then
				return string.format("%02d:%02d:%02d", hours, minutes, secs)
			else
				return string.format("%02d:%02d", minutes, secs)
			end
		end
	},
	{
		key = "get_patrool_format_time",
		description = "Âðåìÿ ïàòðóëÿ ñëîâàìè",
		category = "Ïîëèöèÿ",
		mode = "police",
		func = function()
			local hours = math.floor(MODULE.Patrool.time / 3600)
			local minutes = math.floor((MODULE.Patrool.time % 3600) / 60)
			local secs = MODULE.Patrool.time % 60
			if hours > 0 then
				return string.format("%d ÷àñîâ %d ìèíóò %d ñåêóíä", hours, minutes, secs)
			elseif minutes > 0 then
				return string.format("%d ìèíóò %d ñåêóíä", minutes, secs)
			else
				return string.format("%d ñåêóíä(-û)", secs)
			end
		end
	},
	-- ÁÎËÜÍÈÖÀ
	{
		key = "get_price_heal",
		description = "Öåíà ëå÷åíèÿ èãðîêà",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			if sampGetCurrentServerName():find("Vice City") then
				return settings.mh.price.heal_vc
			else
				return settings.mh.price.heal
			end
		end
	},
	{
		key = "get_price_actorheal",
		description = "Öåíà ëå÷åíèÿ îõðàííèêà",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			if u8(sampGetCurrentServerName()):find("Vice City") then
				return settings.mh.price.healactor_vc
			else
				return settings.mh.price.healactor
			end
		end
	},
	{
		key = "get_price_medosm",
		description = "Öåíà ìåäîñìîòðà",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.medosm
		end
	},
	{
		key = "get_price_mticket",
		description = "Öåíà âîåííîãî áèëåòà",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.mticket
		end
	},
	{
		key = "get_price_healbad",
		description = "Öåíà ëå÷åíèÿ îò ëîìêè",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.healbad
		end
	},
	{
		key = "get_price_ant",
		description = "Öåíà àíòèáèîòèêîâ",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.ant
		end
	},
	{
		key = "get_price_recept",
		description = "Öåíà ðåöåïòà",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.recept
		end
	},
	{
		key = "get_price_med7",
		description = "Öåíà ìåäêàðòû (7 äíåé)",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.med7
		end
	},
	{
		key = "get_price_med14",
		description = "Öåíà ìåäêàðòû (14 äíåé)",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.med14
		end
	},
	{
		key = "get_price_med30",
		description = "Öåíà ìåäêàðòû (30 äíåé)",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.med30
		end
	},
	{
		key = "get_price_med60",
		description = "Öåíà ìåäêàðòû (60 äíåé)",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return settings.mh.price.med60
		end
	},
	{
		key = "get_medcard_days",
		description = "Âûáðàííûé ñðîê ìåäêàðòû",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return MODULE.MedCard.days[0]
		end
	},
	{
		key = "get_medcard_status",
		description = "Ñòàòóñ ìåäêàðòû",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return MODULE.MedCard.status[0]
		end
	},
	{
		key = "get_medcard_price",
		description = "Öåíà âûáðàííîé ìåäêàðòû",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			if MODULE.MedCard.days[0] == 0 then
				return settings.mh.price.med7
			elseif MODULE.MedCard.days[0] == 1 then
				return settings.mh.price.med14
			elseif MODULE.MedCard.days[0] == 2 then
				return settings.mh.price.med30
			elseif MODULE.MedCard.days[0] == 3 then
				return settings.mh.price.med60
			else
				return 1000
			end
		end
	},
	{
		key = "get_recepts",
		description = "Êîëè÷åñòâî ðåöåïòîâ",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return MODULE.Recept.recepts[0]
		end
	},
	{
		key = "get_ants",
		description = "Êîëè÷åñòâî àíòèáèîòèêîâ",
		category = "Áîëüíèöà",
		mode = "hospital",
		func = function()
			return MODULE.Antibiotik.ants[0]
		end
	},
	-- Ëèöåíçèè
	{
		key = "get_price_avto1",
		description = "Öåíà ëèöåíçèè àâòî (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.avto1 end
	},
	{
		key = "get_price_avto2",
		description = "Öåíà ëèöåíçèè àâòî (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.avto2 end
	},
	{
		key = "get_price_avto3",
		description = "Öåíà ëèöåíçèè àâòî (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.avto3 end
	},
	{
		key = "get_price_moto1",
		description = "Öåíà ëèöåíçèè ìîòî (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.moto1 end
	},
	{
		key = "get_price_moto2",
		description = "Öåíà ëèöåíçèè ìîòî (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.moto2 end
	},
	{
		key = "get_price_moto3",
		description = "Öåíà ëèöåíçèè ìîòî (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.moto3 end
	},
	{
		key = "get_price_fish1",
		description = "Öåíà ëèöåíçèè ðûáàëêè (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fish1 end
	},
	{
		key = "get_price_fish2",
		description = "Öåíà ëèöåíçèè ðûáàëêè (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fish2 end
	},
	{
		key = "get_price_fish3",
		description = "Öåíà ëèöåíçèè ðûáàëêè (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fish3 end
	},
	{
		key = "get_price_swim1",
		description = "Öåíà ëèöåíçèè ïëàâàíèÿ (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.swim1 end
	},
	{
		key = "get_price_swim2",
		description = "Öåíà ëèöåíçèè ïëàâàíèÿ (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.swim2 end
	},
	{
		key = "get_price_swim3",
		description = "Öåíà ëèöåíçèè ïëàâàíèÿ (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.swim3 end
	},
	{
		key = "get_price_gun1",
		description = "Öåíà ëèöåíçèè îðóæèÿ (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.gun1 end
	},
	{
		key = "get_price_gun2",
		description = "Öåíà ëèöåíçèè îðóæèÿ (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.gun2 end
	},
	{
		key = "get_price_gun3",
		description = "Öåíà ëèöåíçèè îðóæèÿ (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.gun3 end
	},
	{
		key = "get_price_hunt1",
		description = "Öåíà ëèöåíçèè îõîòû (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.hunt1 end
	},
	{
		key = "get_price_hunt2",
		description = "Öåíà ëèöåíçèè îõîòû (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.hunt2 end
	},
	{
		key = "get_price_hunt3",
		description = "Öåíà ëèöåíçèè îõîòû (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.hunt3 end
	},
	{
		key = "get_price_klad1",
		description = "Öåíà ëèöåíçèè íà êëàäû (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.klad1 end
	},
	{
		key = "get_price_klad2",
		description = "Öåíà ëèöåíçèè íà êëàäû (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.klad2 end
	},
	{
		key = "get_price_klad3",
		description = "Öåíà ëèöåíçèè íà êëàäû (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.klad3 end
	},
	{
		key = "get_price_taxi1",
		description = "Öåíà ëèöåíçèè òàêñè (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.taxi1 end
	},
	{
		key = "get_price_taxi2",
		description = "Öåíà ëèöåíçèè òàêñè (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.taxi2 end
	},
	{
		key = "get_price_taxi3",
		description = "Öåíà ëèöåíçèè òàêñè (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.taxi3 end
	},
	{
		key = "get_price_mexa1",
		description = "Öåíà ëèöåíçèè ìåõàíèêà (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.mexa1 end
	},
	{
		key = "get_price_mexa2",
		description = "Öåíà ëèöåíçèè ìåõàíèêà (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.mexa2 end
	},
	{
		key = "get_price_mexa3",
		description = "Öåíà ëèöåíçèè ìåõàíèêà (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.mexa3 end
	},
	{
		key = "get_price_fly1",
		description = "Öåíà ëèöåíçèè ïèëîòà (1)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fly1 end
	},
	{
		key = "get_price_fly2",
		description = "Öåíà ëèöåíçèè ïèëîòà (2)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fly2 end
	},
	{
		key = "get_price_fly3",
		description = "Öåíà ëèöåíçèè ïèëîòà (3)",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.fly3 end
	},
	{
		key = "get_price_train1",
		description = "Öåíà ëèöåíçèè ìàøèíèñòà",
		category = "Ëèöåíçèè",
		mode = "lc",
		func = function() return settings.lc.price.train1 end
	},
}
for _, tag in ipairs(MODULE.Binder.tags) do MODULE.Binder.tag[tag.key] = tag.func end
----------------------------------------- MoonMonet & Colors -------------------------------------
function rgbToHex(rgb)
	return string.format("%02X%02X%02X", bit.band(bit.rshift(rgb, 16), 0xFF), bit.band(bit.rshift(rgb, 8), 0xFF), bit.band(rgb, 0xFF))
end
function color_to_float3(u32color)
    local temp = imgui.ColorConvertU32ToFloat4(u32color)
    return temp.z, temp.y, temp.x
end
if settings.general.helper_theme == 0 and monet_no_errors then
	message_color = settings.general.moonmonet_theme_color
	message_color_hex = '{' ..  rgbToHex(settings.general.moonmonet_theme_color) .. '}'
	MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.moonmonet_theme_color)
	MODULE.Main.mmcolor[0], MODULE.Main.mmcolor[1], MODULE.Main.mmcolor[2] = color_to_float3(settings.general.moonmonet_theme_color)
else
	if settings.general.helper_theme == 0 then
		print('Áèáëèîòåêà MoonMonet íå íàéäåíà, èñïîëüçóåòñÿ ñòàíäàðòíàÿ Dark Theme')
		settings.general.helper_theme = 1
		MODULE.Main.theme[0] = 1
	end
	message_color = settings.general.message_color
	message_color_hex = '{' ..  rgbToHex(settings.general.message_color) .. '}'
	MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.message_color)
	MODULE.Main.mmcolor[0], MODULE.Main.mmcolor[1], MODULE.Main.mmcolor[2] = color_to_float3(settings.general.moonmonet_theme_color)
	save_settings()
end
------------------------------------------- Mimgui PieMenu ---------------------------------------
if not pie_no_errors then
    if IS_MOBILE then 
		local path = worked_dir .. "/lib/imgui_piemenu.lua"
		if not doesFileExist(path) then
			local file, errstr = io.open(worked_dir .. "/lib/imgui_piemenu.lua", 'w')
			if file then
				file:write([[
-- ported to Lua by FYP
-- modified by BostKing102

local imgui = require 'mimgui'
local vmajor, vminor, vpatch = string.match(imgui._VERSION, '(%d+)%.(%d+)%.(%d+)')
local ImVec2 = imgui.ImVec2
local ImVec4 = imgui.ImVec4
local ImColor = imgui.ImColor

local function ImRectAdd(rect, rhs)
	local Min, Max = rect.Min, rect.Max
	if Min.x > rhs.x then Min.x = rhs.x end
	if Min.y > rhs.y then Min.y = rhs.y end
	if Max.x < rhs.x then Max.x = rhs.x end
	if Max.y < rhs.y then Max.y = rhs.y end
end

local function NewPieMenu(context)
	local obj = {
		m_iCurrentIndex = 0,
		m_fMaxItemSqrDiameter = 0,
		m_fLastMaxItemSqrDiameter = 0,
		m_iHoveredItem = 0,
		m_iLastHoveredItem = 0,
		m_iClickedItem = 0,
		m_oItemIsSubMenu = {}, -- [c_iMaxPieItemCount]
		m_oItemNames = {}, -- [c_iMaxPieItemCount]
		m_oItemSizes = {}, -- [c_iMaxPieItemCount]
	}
	return obj
end

local function NewPieMenuContext(MaxPieMenuStack, MaxPieItemCount, RadiusEmpty, RadiusMin, MinItemCount, MinItemCountPerLevel)
	local obj = {
		c_iMaxPieMenuStack = MaxPieMenuStack or 8,
		c_iMaxPieItemCount = MaxPieItemCount or 12,
		c_iRadiusEmpty = RadiusEmpty or 30 * MONET_DPI_SCALE,
		c_iRadiusMin = RadiusMin or 30 * MONET_DPI_SCALE,
		c_iMinItemCount = MinItemCount or 3,
		c_iMinItemCountPerLevel = MinItemCountPerLevel or 3,

		m_oPieMenuStack = {},
		m_iCurrentIndex = -1,
		m_iLastFrame = 0,
		m_iMaxIndex = 0,
		m_oCenter = ImVec2(0, 0),
		m_iMouseButton = 1,
		m_bClose = false,
	}
	for i = 0, obj.c_iMaxPieMenuStack - 1 do
		obj.m_oPieMenuStack[i] = NewPieMenu(obj)
	end
	return obj
end

--local menuCtx = NewPieMenuContext()

local function BeginPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieMenuStack)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex + 1
	menuCtx.m_iMaxIndex = menuCtx.m_iMaxIndex + 1
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	oPieMenu.m_iCurrentIndex = 0
	oPieMenu.m_fMaxItemSqrDiameter = 0
	if imgui.IsMouseClicked(0) then
		oPieMenu.m_iHoveredItem = -1
	end
	if menuCtx.m_iCurrentIndex > 0 then
		oPieMenu.m_fMaxItemSqrDiameter = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex - 1].m_fMaxItemSqrDiameter
	end
end

local function EndPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0)
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
end

local function BeginPiePopup(menuCtx, pName, iMouseButton)
	iMouseButton = iMouseButton or 0
	if imgui.IsPopupOpen(pName) then
		imgui.PushStyleColor(imgui.Col.WindowBg, ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.Border, ImVec4(0, 0, 0, 0))
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 0.0)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1.0)
		menuCtx.m_iMouseButton = iMouseButton
		menuCtx.m_bClose = false
		imgui.SetNextWindowPos( ImVec2( -100, -100 ), imgui.Cond.Appearing )
		imgui.SetNextWindowSize(ImVec2(0, 0), imgui.Cond.Always)
		local bOpened = imgui.BeginPopup(pName)
		if bOpened then
			local iCurrentFrame = imgui.GetFrameCount()
			if menuCtx.m_iLastFrame < (iCurrentFrame - 1) then
				menuCtx.m_oCenter = ImVec2(imgui.GetIO().MousePos)
			end
			menuCtx.m_iLastFrame = iCurrentFrame
			menuCtx.m_iMaxIndex = -1
			BeginPieMenuEx(menuCtx)
			return true
		else
			imgui.End()
			imgui.PopStyleColor(2)
			imgui.PopStyleVar(2)
		end
	end
	return false
end

local function EndPiePopup(menuCtx)
	EndPieMenuEx(menuCtx)
	local oStyle = imgui.GetStyle()
	local pDrawList = imgui.GetWindowDrawList()
	pDrawList:PushClipRectFullScreen()
	local oMousePos = imgui.GetIO().MousePos
	local oDragDelta = ImVec2(oMousePos.x - menuCtx.m_oCenter.x, oMousePos.y - menuCtx.m_oCenter.y)
	local fDragDistSqr = oDragDelta.x*oDragDelta.x + oDragDelta.y*oDragDelta.y
	local fCurrentRadius = menuCtx.c_iRadiusEmpty
	-- ImRect
	local oArea = {Min = ImVec2(menuCtx.m_oCenter), Max = ImVec2(menuCtx.m_oCenter)}
	local bItemHovered = false
	local c_fDefaultRotate = -math.pi / 2
	local fLastRotate = c_fDefaultRotate
	for iIndex = 0, menuCtx.m_iMaxIndex do
		local oPieMenu = menuCtx.m_oPieMenuStack[iIndex]
		local fMenuHeight = math.sqrt(oPieMenu.m_fMaxItemSqrDiameter)
		local fMinRadius = fCurrentRadius
		local fMaxRadius = fMinRadius + (fMenuHeight * oPieMenu.m_iCurrentIndex) / 2
		local item_arc_span = 2 * math.pi / math.max(menuCtx.c_iMinItemCount + menuCtx.c_iMinItemCountPerLevel * iIndex, oPieMenu.m_iCurrentIndex)
		local drag_angle = math.atan2(oDragDelta.y, oDragDelta.x)
		local fRotate = fLastRotate - item_arc_span * ( oPieMenu.m_iCurrentIndex - 1 ) / 2
		local item_hovered = -1
		for item_n = 0, oPieMenu.m_iCurrentIndex - 1 do
			local item_label = oPieMenu.m_oItemNames[ item_n ]
			local inner_spacing = oStyle.ItemInnerSpacing.x / fMinRadius / 2
			local fMinInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMinRadius * 2 )
			local fMaxInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMaxRadius * 2 )
			local item_inner_ang_min = item_arc_span * ( item_n - 0.5 + fMinInnerSpacing ) + fRotate
			local item_inner_ang_max = item_arc_span * ( item_n + 0.5 - fMinInnerSpacing ) + fRotate
			local item_outer_ang_min = item_arc_span * ( item_n - 0.5 + fMaxInnerSpacing ) + fRotate
			local item_outer_ang_max = item_arc_span * ( item_n + 0.5 - fMaxInnerSpacing ) + fRotate
			local hovered = false
			if fDragDistSqr >= fMinRadius * fMinRadius and fDragDistSqr < fMaxRadius * fMaxRadius  then
				while (drag_angle - item_inner_ang_min) < 0 do
					drag_angle = drag_angle + (2 * math.pi)
				end
				while (drag_angle - item_inner_ang_min) > 2 * math.pi do
					drag_angle = drag_angle - (2 * math.pi)
				end
				if drag_angle >= item_inner_ang_min and drag_angle < item_inner_ang_max  then
					hovered = true
					bItemHovered = not oPieMenu.m_oItemIsSubMenu[ item_n ]
				end
			end
			-- draw segments
			local arc_segments = math.floor(( 32 * item_arc_span / ( 2 * math.pi ) ) + 1)
			local iColor = imgui.GetColorU32( hovered and imgui.Col.ButtonHovered or imgui.Col.Button )
			local fAngleStepInner = (item_inner_ang_max - item_inner_ang_min) / arc_segments
			local fAngleStepOuter = ( item_outer_ang_max - item_outer_ang_min ) / arc_segments
			pDrawList:PrimReserve(arc_segments * 6, (arc_segments + 1) * 2)
			for iSeg = 0, arc_segments do
				local fCosInner = math.cos(item_inner_ang_min + fAngleStepInner * iSeg)
				local fSinInner = math.sin(item_inner_ang_min + fAngleStepInner * iSeg)
				local fCosOuter = math.cos(item_outer_ang_min + fAngleStepOuter * iSeg)
				local fSinOuter = math.sin(item_outer_ang_min + fAngleStepOuter * iSeg)

				if iSeg < arc_segments then
					local VtxCurrentIdx = pDrawList._VtxCurrentIdx
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 0)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 3)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
				end
				local pos = ImVec2(menuCtx.m_oCenter.x + fCosInner * (fMinRadius + oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinInner * (fMinRadius + oStyle.ItemInnerSpacing.x))
				local pos2 = ImVec2(menuCtx.m_oCenter.x + fCosOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x))
				pDrawList:PrimWriteVtx(pos, ImVec2(0, 0), iColor)
				pDrawList:PrimWriteVtx(pos2, ImVec2(0, 0), iColor)
			end

			local fRadCenter = ( item_arc_span * item_n ) + fRotate
			local oOuterCenter = ImVec2( menuCtx.m_oCenter.x + math.cos( fRadCenter ) * fMaxRadius, menuCtx.m_oCenter.y + math.sin( fRadCenter ) * fMaxRadius )
			ImRectAdd(oArea, oOuterCenter)
			if oPieMenu.m_oItemIsSubMenu[item_n] then
				local oTrianglePos = {ImVec2(), ImVec2(), ImVec2()}
				local fRadLeft = fRadCenter - 5 / fMaxRadius
				local fRadRight = fRadCenter + 5 / fMaxRadius
				oTrianglePos[ 0+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 0+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 1+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 1+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadRight ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadRight ) * ( fMaxRadius - 10 )
				pDrawList:AddTriangleFilled(oTrianglePos[1], oTrianglePos[2], oTrianglePos[3], 0xFFFFFFFF)
			end
			local text_size = ImVec2(oPieMenu.m_oItemSizes[item_n])
			local text_pos = ImVec2(
				menuCtx.m_oCenter.x + math.cos((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.x * 0.5,
				menuCtx.m_oCenter.y + math.sin((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.y * 0.5)
			pDrawList:AddText(text_pos, imgui.GetColorU32(imgui.Col.Text), item_label)
			if hovered then
				item_hovered = item_n
			end
		end
		fCurrentRadius = fMaxRadius
		oPieMenu.m_fLastMaxItemSqrDiameter = oPieMenu.m_fMaxItemSqrDiameter
		oPieMenu.m_iHoveredItem = item_hovered
		if fDragDistSqr >= fMaxRadius * fMaxRadius then
			item_hovered = oPieMenu.m_iLastHoveredItem
		end
		oPieMenu.m_iLastHoveredItem = item_hovered
		fLastRotate = item_arc_span * oPieMenu.m_iLastHoveredItem + fRotate
		if item_hovered == -1 or not oPieMenu.m_oItemIsSubMenu[item_hovered] then
			break
		end
	end
	pDrawList:PopClipRect()
	if oArea.Min.x < 0  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Min.x )
	end
	if oArea.Min.y < 0  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Min.y )
	end
	local oDisplaySize = imgui.GetIO().DisplaySize
	if oArea.Max.x > oDisplaySize.x  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Max.x ) + oDisplaySize.x
	end
	if oArea.Max.y > oDisplaySize.y  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Max.y ) + oDisplaySize.y
	end
	if menuCtx.m_bClose or ( not bItemHovered and imgui.IsMouseReleased( 0 ) ) then
		imgui.CloseCurrentPopup()
	end
	imgui.EndPopup()
	imgui.PopStyleColor(2)
	imgui.PopStyleVar(2)
end

local function BeginPieMenu(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
 	local fSqrDiameter = oTextSize.x * 15 * MONET_DPI_SCALE + oTextSize.y * 30 * MONET_DPI_SCALE
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = true
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	if oPieMenu.m_iLastHoveredItem == oPieMenu.m_iCurrentIndex then
		oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
		BeginPieMenuEx(menuCtx)
		return true
	end
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	return false
end

local function EndPieMenu(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
end

local function PieMenuItem(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
	local fSqrDiameter = oTextSize.x * 15 * MONET_DPI_SCALE + oTextSize.y * 30 * MONET_DPI_SCALE
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = false
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	local bActive = (oPieMenu.m_iCurrentIndex == oPieMenu.m_iHoveredItem) and imgui.IsMouseReleased(0)
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	if bActive then
		menuCtx.m_bClose = true
	end
	return bActive
end

local function New(...)
	local menuContext = NewPieMenuContext(...)
	return {
		BeginPiePopup = function(name, mouseButton)
			return BeginPiePopup(menuContext, name, mouseButton)
		end,
		EndPiePopup = function()
			return EndPiePopup(menuContext)
		end,
		PieMenuItem = function(name, enabled)
			return PieMenuItem(menuContext, name, enabled)
		end,
		BeginPieMenu = function(name, enabled)
			return BeginPieMenu(menuContext, name, enabled)
		end,
		EndPieMenu = function()
			return EndPieMenu(menuContext)
		end
	}
end

local defaultPieMenu = New()
defaultPieMenu.New = New
return defaultPieMenu
				]])
				file:close()
			end
		end
	else
		local path = worked_dir .. "/lib/mimgui_piemenu_mod.lua"
		if not doesFileExist(path) then
			local file, errstr = io.open(worked_dir .. "/lib/mimgui_piemenu_mod.lua", 'w')
			if file then
				file:write([[
-- ported to Lua by FYP, ported to mimgui by #Northn

local imgui = require 'mimgui'
local ImVec2 = imgui.ImVec2
local ImVec4 = imgui.ImVec4

local function ImRectAdd(rect, rhs)
local Min, Max = rect.Min, rect.Max
if Min.x > rhs.x then Min.x = rhs.x end
if Min.y > rhs.y then Min.y = rhs.y end
if Max.x < rhs.x then Max.x = rhs.x end
if Max.y < rhs.y then Max.y = rhs.y end
end

local function NewPieMenu(context)
	local obj = {
		m_iCurrentIndex = 0,
		m_fMaxItemSqrDiameter = 0,
		m_fLastMaxItemSqrDiameter = 0,
		m_iHoveredItem = 0,
		m_iLastHoveredItem = 0,
		m_iClickedItem = 0,
		m_oItemIsSubMenu = {}, -- [c_iMaxPieItemCount]
		m_oItemNames = {}, -- [c_iMaxPieItemCount]
		m_oItemSizes = {}, -- [c_iMaxPieItemCount]
	}
	return obj
end

local function NewPieMenuContext(MaxPieMenuStack, MaxPieItemCount, RadiusEmpty, RadiusMin, MinItemCount, MinItemCountPerLevel)
	local obj = {
		c_iMaxPieMenuStack = MaxPieMenuStack or 8,
		c_iMaxPieItemCount = MaxPieItemCount or 12,
		c_iRadiusEmpty = RadiusEmpty or 30,
		c_iRadiusMin = RadiusMin or 30,
		c_iMinItemCount = MinItemCount or 3,
		c_iMinItemCountPerLevel = MinItemCountPerLevel or 3,

		m_oPieMenuStack = {},
		m_iCurrentIndex = -1,
		m_iLastFrame = 0,
		m_iMaxIndex = 0,
		m_oCenter = ImVec2(0, 0),
		m_iMouseButton = 0,
		m_bClose = false,
	}
	for i = 0, obj.c_iMaxPieMenuStack - 1 do
		obj.m_oPieMenuStack[i] = NewPieMenu(obj)
	end
	return obj
end

local function BeginPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieMenuStack)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex + 1
	menuCtx.m_iMaxIndex = menuCtx.m_iMaxIndex + 1
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	oPieMenu.m_iCurrentIndex = 0
	oPieMenu.m_fMaxItemSqrDiameter = 0
	if not imgui.IsMouseReleased( menuCtx.m_iMouseButton ) then
		oPieMenu.m_iHoveredItem = -1
	end
	if menuCtx.m_iCurrentIndex > 0 then
		oPieMenu.m_fMaxItemSqrDiameter = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex - 1].m_fMaxItemSqrDiameter
	end
	end

	local function EndPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0)
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
	end

	local function BeginPiePopup(menuCtx, pName, iMouseButton)
	iMouseButton = iMouseButton or 0
	if imgui.IsPopupOpen(pName) then
		imgui.PushStyleColor(imgui.Col.WindowBg, ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.Border, ImVec4(0, 0, 0, 0))
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 0.0)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1.0)
		menuCtx.m_iMouseButton = iMouseButton
		menuCtx.m_bClose = false
		imgui.SetNextWindowPos( ImVec2( -100, -100 ), imgui.Cond.Appearing )
		imgui.SetNextWindowSize(ImVec2(0, 0), imgui.Cond.Always)
		local bOpened = imgui.BeginPopup(pName)
		if bOpened then
			local iCurrentFrame = imgui.GetFrameCount()
			if menuCtx.m_iLastFrame < (iCurrentFrame - 1) then
				-- menuCtx.m_oCenter = ImVec2(imgui.GetIO().MousePos)
				local display = imgui.GetIO().DisplaySize
    			menuCtx.m_oCenter = ImVec2(display.x * 0.5, display.y * 0.5)
			end
			menuCtx.m_iLastFrame = iCurrentFrame
			menuCtx.m_iMaxIndex = -1
			BeginPieMenuEx(menuCtx)
			return true
		else
			imgui.End()
			imgui.PopStyleColor(2)
			imgui.PopStyleVar(2)
		end
	end
	return false
end

local function EndPiePopup(menuCtx)
	EndPieMenuEx(menuCtx)
	local oStyle = imgui.GetStyle()
	local pDrawList = imgui.GetWindowDrawList()
	pDrawList:PushClipRectFullScreen()
	local oMousePos = imgui.GetIO().MousePos
	local oDragDelta = ImVec2(oMousePos.x - menuCtx.m_oCenter.x, oMousePos.y - menuCtx.m_oCenter.y)
	local fDragDistSqr = oDragDelta.x*oDragDelta.x + oDragDelta.y*oDragDelta.y
	local fCurrentRadius = menuCtx.c_iRadiusEmpty
	-- ImRect
	local oArea = {Min = ImVec2(menuCtx.m_oCenter), Max = ImVec2(menuCtx.m_oCenter)}
	local bItemHovered = false
	local c_fDefaultRotate = -math.pi / 2
	local fLastRotate = c_fDefaultRotate
	for iIndex = 0, menuCtx.m_iMaxIndex do
		local oPieMenu = menuCtx.m_oPieMenuStack[iIndex]
		local fMenuHeight = math.sqrt(oPieMenu.m_fMaxItemSqrDiameter)
		local fMinRadius = fCurrentRadius
		local fMaxRadius = fMinRadius + (fMenuHeight * oPieMenu.m_iCurrentIndex) / 2
		local item_arc_span = 2 * math.pi / math.max(menuCtx.c_iMinItemCount + menuCtx.c_iMinItemCountPerLevel * iIndex, oPieMenu.m_iCurrentIndex)
		local drag_angle = math.atan2(oDragDelta.y, oDragDelta.x)
		local fRotate = fLastRotate - item_arc_span * ( oPieMenu.m_iCurrentIndex - 1 ) / 2
		local item_hovered = -1
		for item_n = 0, oPieMenu.m_iCurrentIndex - 1 do
			local item_label = oPieMenu.m_oItemNames[ item_n ]
			local inner_spacing = oStyle.ItemInnerSpacing.x / fMinRadius / 2
			local fMinInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMinRadius * 2 )
			local fMaxInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMaxRadius * 2 )
			local item_inner_ang_min = item_arc_span * ( item_n - 0.5 + fMinInnerSpacing ) + fRotate
			local item_inner_ang_max = item_arc_span * ( item_n + 0.5 - fMinInnerSpacing ) + fRotate
			local item_outer_ang_min = item_arc_span * ( item_n - 0.5 + fMaxInnerSpacing ) + fRotate
			local item_outer_ang_max = item_arc_span * ( item_n + 0.5 - fMaxInnerSpacing ) + fRotate
			local hovered = false
			if fDragDistSqr >= fMinRadius * fMinRadius and fDragDistSqr < fMaxRadius * fMaxRadius  then
				while (drag_angle - item_inner_ang_min) < 0 do
					drag_angle = drag_angle + (2 * math.pi)
				end
				while (drag_angle - item_inner_ang_min) > 2 * math.pi do
					drag_angle = drag_angle - (2 * math.pi)
				end
				if drag_angle >= item_inner_ang_min and drag_angle < item_inner_ang_max  then
					hovered = true
					bItemHovered = not oPieMenu.m_oItemIsSubMenu[ item_n ]
				end
			end
			-- draw segments
			local arc_segments = math.floor(( 32 * item_arc_span / ( 2 * math.pi ) ) + 1)
			local iColor = imgui.GetColorU32( hovered and imgui.Col.ButtonHovered or imgui.Col.Button )
			local fAngleStepInner = (item_inner_ang_max - item_inner_ang_min) / arc_segments
			local fAngleStepOuter = ( item_outer_ang_max - item_outer_ang_min ) / arc_segments
			pDrawList:PrimReserve(arc_segments * 6, (arc_segments + 1) * 2)
			for iSeg = 0, arc_segments do
				local fCosInner = math.cos(item_inner_ang_min + fAngleStepInner * iSeg)
				local fSinInner = math.sin(item_inner_ang_min + fAngleStepInner * iSeg)
				local fCosOuter = math.cos(item_outer_ang_min + fAngleStepOuter * iSeg)
				local fSinOuter = math.sin(item_outer_ang_min + fAngleStepOuter * iSeg)

				if iSeg < arc_segments then
					local VtxCurrentIdx = pDrawList._VtxCurrentIdx
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 0)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 3)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
				end
				local pos = ImVec2(menuCtx.m_oCenter.x + fCosInner * (fMinRadius + oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinInner * (fMinRadius + oStyle.ItemInnerSpacing.x))
				local pos2 = ImVec2(menuCtx.m_oCenter.x + fCosOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x))
				pDrawList:PrimWriteVtx(pos, ImVec2(0, 0), iColor)
				pDrawList:PrimWriteVtx(pos2, ImVec2(0, 0), iColor)
			end

			local fRadCenter = ( item_arc_span * item_n ) + fRotate
			local oOuterCenter = ImVec2( menuCtx.m_oCenter.x + math.cos( fRadCenter ) * fMaxRadius, menuCtx.m_oCenter.y + math.sin( fRadCenter ) * fMaxRadius )
			ImRectAdd(oArea, oOuterCenter)
			if oPieMenu.m_oItemIsSubMenu[item_n] then
				local oTrianglePos = {ImVec2(), ImVec2(), ImVec2()}
				local fRadLeft = fRadCenter - 5 / fMaxRadius
				local fRadRight = fRadCenter + 5 / fMaxRadius
				oTrianglePos[ 0+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 0+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 1+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 1+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadRight ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadRight ) * ( fMaxRadius - 10 )
				pDrawList:AddTriangleFilled(oTrianglePos[1], oTrianglePos[2], oTrianglePos[3], 0xFFFFFFFF)
			end
			local text_size = ImVec2(oPieMenu.m_oItemSizes[item_n])
			local text_pos = ImVec2(
				menuCtx.m_oCenter.x + math.cos((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.x * 0.5,
				menuCtx.m_oCenter.y + math.sin((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.y * 0.5)
			pDrawList:AddText(text_pos, imgui.GetColorU32(imgui.Col.Text), item_label)
			if hovered then
				item_hovered = item_n
			end
		end
		fCurrentRadius = fMaxRadius
		oPieMenu.m_fLastMaxItemSqrDiameter = oPieMenu.m_fMaxItemSqrDiameter
		oPieMenu.m_iHoveredItem = item_hovered
		if fDragDistSqr >= fMaxRadius * fMaxRadius then
			item_hovered = oPieMenu.m_iLastHoveredItem
		end
		oPieMenu.m_iLastHoveredItem = item_hovered
		fLastRotate = item_arc_span * oPieMenu.m_iLastHoveredItem + fRotate
		if item_hovered == -1 or not oPieMenu.m_oItemIsSubMenu[item_hovered] then
			break
		end
	end
	pDrawList:PopClipRect()
	if oArea.Min.x < 0  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Min.x )
	end
	if oArea.Min.y < 0  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Min.y )
	end
	local oDisplaySize = imgui.GetIO().DisplaySize
	if oArea.Max.x > oDisplaySize.x  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Max.x ) + oDisplaySize.x
	end
	if oArea.Max.y > oDisplaySize.y  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Max.y ) + oDisplaySize.y
	end
	if menuCtx.m_bClose or ( not bItemHovered and imgui.IsMouseReleased( menuCtx.m_iMouseButton ) ) then
		imgui.CloseCurrentPopup()
	end
	imgui.EndPopup()
	imgui.PopStyleColor(2)
	imgui.PopStyleVar(2)
end

local function BeginPieMenu(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
	local fSqrDiameter = (oTextSize.x * oTextSize.x / 2) + (oTextSize.y * oTextSize.y / 2)
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = true
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	if oPieMenu.m_iLastHoveredItem == oPieMenu.m_iCurrentIndex then
		oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
		BeginPieMenuEx(menuCtx)
		return true
	end
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	return false
end

local function EndPieMenu(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
end

local function PieMenuItem(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
	local fSqrDiameter = (oTextSize.x * oTextSize.x / 3) + (oTextSize.y * oTextSize.y / 3)
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = false
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	local bActive = oPieMenu.m_iCurrentIndex == oPieMenu.m_iHoveredItem
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	if bActive then
		menuCtx.m_bClose = true
	end
	return bActive
end

local function New(...)
	local menuContext = NewPieMenuContext(...)
	return {
		_VERSION = '1.0',
		BeginPiePopup = function(name, mouseButton)
			return BeginPiePopup(menuContext, name, mouseButton)
		end,
		EndPiePopup = function()
			return EndPiePopup(menuContext)
		end,
		PieMenuItem = function(name, enabled)
			return PieMenuItem(menuContext, name, enabled)
		end,
		BeginPieMenu = function(name, enabled)
			return BeginPieMenu(menuContext, name, enabled)
		end,
		EndPieMenu = function()
			return EndPieMenu(menuContext)
		end
	}
end

local defaultPieMenu = New()
defaultPieMenu.New = New
return defaultPieMenu
				]])
				file:close()
			end
		end
	end
	pie_no_errors, pie = pcall(require, IS_MOBILE and 'imgui_piemenu' or 'mimgui_piemenu_mod')
end
if not pie_no_errors then print('Áèáëèîòåêà PieMenu íå íàéäåíà!') end
------------------------------------------- Mimgui Hotkey ----------------------------------------
local hotkeys = {}
if hotkey_no_errors and not isMode('') then
	hotkey.Text.NoKey = u8'< click and select keys >'
	hotkey.Text.WaitForKey = u8'< wait keys >'
	function getNameKeysFrom(keys)
		local result, keys = pcall(decodeJson, keys)
		if not result or type(keys) ~= 'table' then return '' end
		local keysStr = {}
		for _, keyId in ipairs(keys) do
			local keyName = vkeys_no_errors and vkeys.id_to_name(keyId) or ''
			table.insert(keysStr, keyName)
		end
		return table.concat(keysStr, ' + ') or ''
	end
	function loadHotkeys()
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			MODULE.Main.Window[0] = not MODULE.Main.Window[0]
		end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop), function() 
			sampProcessChatInput('/stop')
		end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu), function() 
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(ped) then
				local result, id = sampGetPlayerIdByCharHandle(ped)
				if result and id ~= -1 and not MODULE.LeaderFastMenu.Window[0] then
					show_fast_menu(id)
				end
			end
		end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if modules.player.data.fraction_rank_number >= 9 then 
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
				if valid and doesCharExist(ped) then
					local result, id = sampGetPlayerIdByCharHandle(ped)
					if result and id ~= -1 and not MODULE.FastMenu.Window[0] then
						show_leader_fast_menu(id)
					end
				end
			end
		end)
		ActionHotKey = hotkey.RegisterHotKey('Action Key', false, decodeJson(settings.general.bind_action), function()
			if MODULE.Binder.state.isPause and MODULE.CommandPause.Window[0] then
				MODULE.Binder.state.isPause = false
				MODULE.CommandPause.Window[0] = false
			elseif modules.player.data.fraction_rank_number >= 9 and MODULE.GiveRank.Window[0] then
				MODULE.GiveRank.Window[0] = false
			elseif MODULE.MedCard.Window[0] then
				MODULE.MedCard.Window[0] = false
			elseif MODULE.Recept.Window[0] then
				MODULE.Recept.Window[0] = false
			elseif MODULE.Antibiotik.Window[0] then
				MODULE.Antibiotik.Window[0] = false
			elseif MODULE.HealChat.bool and MODULE.HealChat.player_id and not sampIsCursorActive() then
				find_and_use_command("/heal {id}", MODULE.HealChat.player_id)
				MODULE.HealChat.bool = false
				MODULE.HealChat.player_id = nil
			end
		end)
		for _, command in ipairs(modules.commands.data.commands.my) do
			createHotkeyForCommand(command)
		end
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			createHotkeyForCommand(command)
		end
	end
	function createHotkeyForCommand(command)
		local hotkeyName = command.cmd .. "HotKey"
		if hotkeys[hotkeyName] then
			hotkey.RemoveHotKey(hotkeyName)
		end
		if command.arg == "" and command.bind ~= nil and command.bind ~= '{}' and command.bind ~= '[]' then
			hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(command.bind), function()
				if not sampIsCursorActive() then sampProcessChatInput('/' .. command.cmd) end
			end)
			print('Ñîçäàí õîòêåé äëÿ êîìàíäû /' .. command.cmd .. ' íà êëàâèøó ' .. getNameKeysFrom(command.bind))
			sampAddChatMessage('[Radical Helper] {ffffff}Ñîçäàí õîòêåé äëÿ êîìàíäû ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}íà êëàâèøó '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
		end
	end
	addEventHandler('onWindowMessage', function(msg, key, lparam)
		if msg == 641 or msg == 642 or lparam == -1073741809 then hotkey.ActiveKeys = {} end
		if msg == 0x0005 then hotkey.ActiveKeys = {} end
	end)
end
---------------------------------------------- RP GUNS  ------------------------------------------
function initialize_guns()
	local isFemale = (modules.player.data.sex == "Æåíùèíà")
	local data = modules.rpgun.data
	data.byId = {}
    data.gunActions = {on = {}, off = {}, partOn = {}, partOff = {}}
    for i, weapon in pairs(data.rp_guns) do
        local rpTakeType = data.rpTakeNames[weapon.rpTake]
		local id = weapon.id
		data.byId[id] = weapon
        data.gunActions.partOn[id] = rpTakeType[1]
        data.gunActions.partOff[id] = rpTakeType[2]
        if id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91) then
            data.gunActions.on[id] = isFemale and "ñíÿëà" or "ñíÿë"
        else
            data.gunActions.on[id] = isFemale and "äîñòàëà" or "äîñòàë"
        end
        if id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91) then
            data.gunActions.off[id] = isFemale and "ïîâåñèëà" or "ïîâåñèë"
        else
           	data.gunActions.off[id] = isFemale and "óáðàëà" or "óáðàë"
        end
    end
end
function get_name_weapon(id)
    if modules.rpgun.data and modules.rpgun.data.byId and modules.rpgun.data.byId[id] then
        return modules.rpgun.data.byId[id].name
    end
    return "îðóæèå"
end
function isExistsWeapon(id)
    return modules.rpgun.data.byId[id] ~= nil
end
function isEnableWeapon(id)
	local w = modules.rpgun.data.byId[id]
	return w and w.enable or false
end
function handleNewWeapon(weaponId)
    sampAddChatMessage('[Radical Helper] {ffffff}Îáíàðóæåíî íîâîå îðóæèå ñ ID ' .. message_color_hex .. weaponId .. '{ffffff}. Åìó àâòîìàòè÷åñêè íàçíà÷åíî èìÿ "îðóæèå" è ðàñïîëîæåíèå "ñïèíà"', message_color)
    sampAddChatMessage('[Radical Helper] {ffffff}Èçìåíèòü íàçâàíèå èëè ðàñïîëîæåíèå îðóæèÿ ìîæíî ÷åðåç êîìàíäó /rpguns', message_color)
    table.insert(modules.rpgun.data.rp_guns, {id = weaponId, name = "îðóæèå", enable = true, rpTake = 1})
	save_module('rpgun')
    initialize_guns()
end
function processWeaponChange(oldGun, nowGun)
	if not isExistsWeapon(oldGun) then handleNewWeapon(oldGun) end
	if not isExistsWeapon(nowGun) then handleNewWeapon(nowGun) end
    if not modules.rpgun.data.gunActions.off[oldGun] or not modules.rpgun.data.gunActions.on[nowGun] then
        sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Èíèöèàëèçàöèÿ îðóæèÿ...', message_color)
		initialize_guns()
		return
    end
    local actions = modules.rpgun.data.gunActions
    if oldGun == 0 and nowGun == 0 then
        return
    elseif oldGun == 0 and not isEnableWeapon(nowGun) then
        return
    elseif nowGun == 0 and not isEnableWeapon(oldGun) then
        return
    elseif not isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s", actions.on[nowGun], get_name_weapon(nowGun), actions.partOn[nowGun]))
    elseif isEnableWeapon(oldGun) and not isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s", actions.off[oldGun], get_name_weapon(oldGun), actions.partOff[oldGun]))
    elseif oldGun == 0 then
        sampSendChat(string.format("/me %s %s %s", actions.on[nowGun], get_name_weapon(nowGun), actions.partOn[nowGun]))
    elseif nowGun == 0 then
        sampSendChat(string.format("/me %s %s %s", actions.off[oldGun], get_name_weapon(oldGun), actions.partOff[oldGun]))
    elseif isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
		sampSendChat(string.format("/me %s %s %s, ïîñëå ÷åãî %s %s %s",
			actions.off[oldGun],
			get_name_weapon(oldGun),
			actions.partOff[oldGun],
			actions.on[nowGun],
			get_name_weapon(nowGun),
			actions.partOn[nowGun]
		))
    end
end
------------------------------------------------ Variables --------------------------------------- 
local isUpdateChecked = false
------------------------------------------------ Functions ---------------------------------------
function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	
	check_update()
	while not isUpdateChecked do wait(0) end

	check_resources()
	delete_old_helpers()

	if settings.general.fraction_mode == '' then
		repeat wait(0) until sampIsLocalPlayerSpawned()
		MODULE.Initial.Window[0] = true
		return
	end
	
	load_modules()
	initialize_guns()
	initialize_commands()
	if hotkey_no_errors then loadHotkeys() end
	if IS_MOBILE then render_buttons() end

	welcome_message()
	
	-- Ñáîð àíàëèòèêè (âåðñèÿ, ñåðâåð, óñòðîéñòâî ìîáàéë/ïê)
	if settings.general.analytics then sendAnalytics() end

	while true do
		wait(0)

		if IS_MOBILE and settings.general.mobile_fastmenu_button then
			if tonumber(#get_players()) > 0 and not MODULE.FastMenu.Window[0] and not MODULE.FastMenuPlayers.Window[0] then
				MODULE.FastMenuButton.Window[0] = true
			else
				MODULE.FastMenuButton.Window[0] = false
			end
		end

		if MODULE.Post.active then
			MODULE.Post.time = os.difftime(os.time(), MODULE.Post.start_time)
		end

		if isMode('police') or isMode('fbi') then
			if MODULE.Patrool.active then
				MODULE.Patrool.time = os.difftime(os.time(), MODULE.Patrool.start_time)
				if settings.mj.auto_change_code_siren and isCharInAnyCar(PLAYER_PED) then
					local currentSirenState = isCarSirenOn(storeCarCharIsInNoSave(PLAYER_PED))
					if firstCheck then
						lastSirenState = currentSirenState
						firstCheck = false
					end
					if currentSirenState ~= lastSirenState then
						lastSirenState = currentSirenState
						local newCode = currentSirenState and {'CODE 3', 4} or {'CODE 4', 5}
						sampAddChatMessage("[Radical Helper | Àññèñòåíò] {ffffff}Ïðîáëåñêîâûå ìàÿ÷êè " .. (currentSirenState and "àêòèâèðîâàíû (CODE 3)." or "äåàêòèâèðîâàíû (CODE 4)."), message_color)
						MODULE.Patrool.ComboCode[0] = newCode[2]
						MODULE.Patrool.code = newCode[1]
					end
				end
			end	
		end

		-- if isMode('fd') then
		-- 	if MODULE.Fires.isDialog and MODULE.Fires.dialogId ~= -1 then
		-- 		local result, button, list, input = sampHasDialogRespond(999)
		-- 		if result and button ~= -1 and list ~= -1 then
		-- 			sampSendDialogResponse(MODULE.Fires.dialogId, button, list, item)
		-- 			MODULE.Fires.dialogId = -1
		-- 			MODULE.Fires.isDialog = false
		-- 			if button ~= 0 then getFireLocation(tonumber(list)) end
		-- 		end
		-- 	end
		-- end

		if settings.general.rp_guns then
			local current = getCurrentCharWeapon(PLAYER_PED)
			if modules.rpgun.data.nowGun ~= current then
				modules.rpgun.data.oldGun = modules.rpgun.data.nowGun
				modules.rpgun.data.nowGun = current
				processWeaponChange(modules.rpgun.data.oldGun, current)
			end
        end
		
		if MODULE.CruiseControl.wait_point then
			local bool, x, y, z = getTargetBlipCoordinates()
			if bool then
				MODULE.CruiseControl.point = {x = x, y = y, z = z}
				MODULE.CruiseControl.wait_point = false
				sampAddChatMessage('[Radical Helper] {ffffff}Êîîðäèíàòû ìåñòà íàçíà÷åíèÿ óñïåøíî ïîëó÷åíû!', message_color)
				while isGamePaused() or isPauseMenuActive() do wait(0) end
				lua_thread.create(function()
					sampSendChat('/me âêëþ÷àåò â ñâî¸ì òñ àäàïòèâíûé CRUISE CONTROL è íàñòðàèâàåò GPS íàâèãàòîð')
					wait(1500)
					sampSendChat('/do Íà ýêðàíå çàãîðàåòñÿ íàäïèñü "GPS ìàðøðóò óñïåøíî ïðîëîæåí, ìîæíî åõàòü".')
					MODULE.CruiseControl.active = true
					wait(2000)
					sampSendChat('/do ' .. MODULE.Binder.tag.my_ru_nick() .. ' äåðæèò ðóêè íà ðóëå, CRUISE CONTROL ïîääåðæèâàåò ñêîðîñòü òñ.')
				end)
			end
		end
		if MODULE.CruiseControl.active then
			local function stop()
				MODULE.CruiseControl.active = false
				clearCharTasks(PLAYER_PED)
				if isCharInAnyCar(PLAYER_PED) then
					taskWarpCharIntoCarAsDriver(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED))
				end
			end
			if not isCharInAnyCar(PLAYER_PED) then
				sampAddChatMessage('[Radical Helper] {ffffff}Âû äîëæíû íàõîäèòñÿ â òðàíñïîðòíîì ñðåäñòâå!', message_color)
				stop()
			elseif not isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED)) then
				sampAddChatMessage('[Radical Helper] {ffffff}Äâèãàòåëü âàøåãî òðàíñïîðòíîãî ñðåäñòâà çàãëîõ!', message_color)
				stop()
			elseif locateCharInCar2d(PLAYER_PED, MODULE.CruiseControl.point.x, MODULE.CruiseControl.point.y, 15, 15, false) then
				sampSendChat('/me ïðèåõàâ ê ïóíêòó íàçíà÷åíèÿ îòêëþ÷àåò â òñ àäàïòèâíûé CRUISE CONTROL')
				stop()
			else
				taskCarDriveToCoord(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED), MODULE.CruiseControl.point.x, MODULE.CruiseControl.point.y, MODULE.CruiseControl.point.z, 28, 0, 0, 2)
			end
		end

	end

end
function load_modules()
	load_module('player')
	load_module('commands')
	if IS_MOBILE then load_module('buttons') end
	load_module('departament')
	load_module('notes')
	load_module('rpgun')
	load_module('arz_veh')
	cache_vehicles()
	if settings.general.piemenu then
		if pie_no_errors then 
			load_module('piemenu')
			MODULE.PieMenu.Window[0] = true
		else
			sampAddChatMessage('[Radical Helper] {ffffff}Ìîäóëü PieMenu îòêëþ÷¸í: îòñóòñòâóåò íåîáõîäèìàÿ áèáëèîòåêà!', message_color)
			print('Ìîäóëü PieMenu îòêëþ÷¸í: îòñóòñòâóåò íåîáõîäèìàÿ áèáëèîòåêà!')
			settings.general.piemenu = false
			save_settings()
		end
	end
	if isMode('police') or isMode('fbi') then
		load_module('smart_uk')
		load_module('smart_pdd')
	end
	if isMode('prison') then
		load_module('smart_rptp')
	end
	if isMode('smi') then
		load_module('ads_history')
	end
end
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ çàâåðøåíèÿ çàãðóçêè õåëïåðà âîéäèòå íà ñåðâåð.', message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end

	sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà õåëïåðà óñïåøíî çàâåðøåíà!', message_color)
	show_notify('info', 'Radical Helper', "Çàãðóçêà õåëïåðà óñïåøíî çàâåðøåíà!", 3000)
	print('Ïîëíàÿ çàãðóçêà õåëïåðà óñïåøíî çàâåðøåíà!')

	if hotkey_no_errors and settings.general.bind_mainmenu then	
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ îòêðûòèÿ ìåíþ õåëïåðà íàæìèòå ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}èëè èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/helper', message_color)
	else
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ îòêðûòèÿ ìåíþ õåëïåðà èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/helper', message_color)
	end

	if IS_MOBILE and modules.player.data.nick ~= '' then
		CHECK_ID = true
		sampSendChat('/id ' .. modules.player.data.nick)
	end
end
function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(args)
		if not MODULE.Binder.state.isActive then
			if MODULE.Binder.state.isStop then
				MODULE.Binder.state.isStop = false
			end
			local arg_check = false
			local id, number, arg
			local modifiedText = cmd_text
			local function apply_nick_formats(id)
				modifiedText = modifiedText:gsub('%{get_nick%(%{id%}%)%}', sampGetPlayerNickname(id) or "")
				modifiedText = modifiedText:gsub('%{get_rp_nick%(%{id%}%)%}', sampGetPlayerNickname(id):gsub('_',' ') or "")
				modifiedText = modifiedText:gsub('%{get_ru_nick%(%{id%}%)%}', translate(sampGetPlayerNickname(id)) or "")
			end
			if cmd_arg == '{arg}' then
				if args and args ~= '' then
					modifiedText = modifiedText:gsub('{arg}', args or "")
					arg_check = true
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ëþáîå çíà÷åíèå]', message_color)
					play_sound()
				end
			elseif cmd_arg == '{id}' then
				if isParamSampID(args) then
					id = tonumber(args)
					apply_nick_formats(id)
					modifiedText = modifiedText:gsub('%{id%}', id or "")
					arg_check = true
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà]', message_color)
					play_sound()
				end
			elseif cmd_arg == '{id} {arg}' then
				if args and args ~= '' then
					id, arg = args:match('(%d+) (.+)')
					if isParamSampID(id) and arg then
						id = tonumber(id)
						apply_nick_formats(id)
						modifiedText = modifiedText:gsub('%{id%}', id or "")
						modifiedText = modifiedText:gsub('%{arg%}', arg or "")
						arg_check = true
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [ëþáîå çíà÷åíèå]', message_color)
						play_sound()
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [ëþáîå çíà÷åíèå]', message_color)
					play_sound()
				end
            elseif cmd_arg == '{id} {number} {arg}' then
				if args and args ~= '' then
					id, number, arg = args:match('(%d+) (%d+) (.+)')
					if isParamSampID(id) and number and arg then
						id = tonumber(id)
						apply_nick_formats(id)
						modifiedText = modifiedText:gsub('%{id%}', id or "")
						modifiedText = modifiedText:gsub('%{number%}', number or "")
                        modifiedText = modifiedText:gsub('%{arg%}', arg or "")
						arg_check = true
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [ëþáîå ÷èñëî] [ëþáîå çíà÷åíèå]', message_color)
						play_sound()
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [ëþáîå ÷èñëî] [ëþáîå çíà÷åíèå]', message_color)
					play_sound()
				end
			elseif cmd_arg == '' then
				arg_check = true
			end
			if arg_check then
				lua_thread.create(function()
					MODULE.Binder.state.isActive = true
					MODULE.Binder.state.isPause = false
					if modifiedText:find('&.+&') then
						info_stop_command()
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					local ui_action = false
					for line_index, line in ipairs(lines) do
						if MODULE.Binder.state.isStop then 
							MODULE.Binder.state.isStop = false 
							MODULE.Binder.state.isActive = false
							if IS_MOBILE and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
							sampAddChatMessage('[Radical Helper] {ffffff}Îòûãðîâêà êîìàíäû /' .. chat_cmd .. " óñïåøíî îñòàíîâëåíà!", message_color) 
							break
						elseif line == "{pause}" then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà /' .. chat_cmd .. ' ïîñòàâëåíà íà ïàóçó!', message_color)
							if not IS_MOBILE then
								if hotkey_no_errors and settings.general.bind_action then
									sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ ïðîäîëæåíèÿ íàæìèòå ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_action) .. ' {ffffff}èëè âûçîâèòå êóðñîð îòêðûâ ÷àò (T/F6)', message_color)
								else
									sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ ïðîäîëæåíèÿ âûçîâèòå êóðñîð îòêðûâ ÷àò (T/F6)', message_color)
								end
							end
							MODULE.Binder.state.isPause = true
							MODULE.CommandPause.Window[0] = true
							while MODULE.Binder.state.isPause do wait(0) end
							if not MODULE.Binder.state.isStop then
								sampAddChatMessage('[Radical Helper] {ffffff}Ïðîäîëæàþ îòûãðîâêó êîìàíäû /' .. chat_cmd, message_color)	
							end	
						elseif line:find('{wait%((%d+)%)}') then
							wait(tonumber(string.match(line, '{wait%((%d+)%)}')))
						elseif line == '{show_medcard_menu}' then
							ui_action = true
							MODULE.MedCard.player_id = tonumber(id)
							MODULE.MedCard.Window[0] = true
							while MODULE.MedCard.Window[0] do wait(0) end
						elseif line == '{show_recept_menu}' then
							ui_action = true
							MODULE.Recept.player_id = tonumber(id)
							MODULE.Recept.Window[0] = true
							while MODULE.Recept.Window[0] do wait(0) end
						elseif line == '{show_ant_menu}' then
							ui_action = true
							MODULE.Antibiotik.player_id = tonumber(id)
							MODULE.Antibiotik.Window[0] = true
							while MODULE.Antibiotik.Window[0] do wait(0) end
						elseif line == '{show_rank_menu}' then
							ui_action = true
							MODULE.GiveRank.player_id = tonumber(id)
							MODULE.GiveRank.Window[0] = true
							while MODULE.GiveRank.Window[0] do wait(0) end
						elseif line == '{lmenu_vc_vize}' then
							MODULE.LeadTools.vc_vize.player_id = tonumber(id)
							MODULE.LeadTools.vc_vize.bool = true
							sampSendChat("/lmenu")
						elseif line == '{give_platoon}' then
							MODULE.LeadTools.platoon.player_id = tonumber(id)
							MODULE.LeadTools.platoon.check = true
							sampSendChat("/platoon")
						elseif line:find('%{sellrank%((%d+)%)%}') then
							MODULE.LeadTools.sell_rank.player_id = tonumber(string.match(line, '(%d+)'))
							MODULE.LeadTools.sell_rank.checker = true
							sampSendChat('/lmenu')
						elseif not MODULE.Binder.state.isStop then
							if line_index ~= 1 and not ui_action then
								local total_wait = cmd_waiting * 1000
								local waited = 0
								while waited < total_wait do
									if MODULE.Binder.state.isStop then break end
									if MODULE.DEBUG then
										local remaining = math.max(0, total_wait - waited) / 1000
										printStringNow(string.format("%d/%d - %.1fs", line_index - 1, #lines, remaining), 105)
									end
									wait(100)
									waited = waited + 100
								end
							end
							if ui_action then ui_action = false end
							if not MODULE.Binder.state.isStop then 
								for tag, replacement in pairs(MODULE.Binder.tag) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", function() return replacement() end)
										if success then
											line = result
										end
									end
								end
								if MODULE.DEBUG then sampAddChatMessage('[SendChat] {ffffff}' .. line, message_color) end
								sampSendChat(line)
							end
						end
					end
					MODULE.Binder.state.isActive = false
					if IS_MOBILE and settings.general.mobile_stop_button then
						MODULE.CommandStop.Window[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
			play_sound()
		end
	end)
end
function info_stop_command()
	if IS_MOBILE and settings.general.mobile_stop_button then
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ îñòàíîâêè îòûãðîâêè èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/stop {ffffff}èëè êíîïêó â íèæíåé ÷àñòè ýêðàíà.', message_color)
		MODULE.CommandStop.Window[0] = true
	elseif hotkey_no_errors and settings.general.bind_command_stop then
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ îñòàíîâêè îòûãðîâêè èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/stop {ffffff}èëè íàæìèòå ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop) .. '{ffffff}.', message_color)
	else
		sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ îñòàíîâêè îòûãðîâêè èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/stop{ffffff}.', message_color)
	end
end
function find_and_use_command(cmd, cmd_arg)
	for _, command in ipairs(modules.commands.data.commands.my) do
		if command.enable and command.text:find(cmd) then
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end 
	for _, command in ipairs(modules.commands.data.commands_manage.my) do
		if command.enable and command.text:find(cmd) then
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	sampAddChatMessage('[Radical Helper] {ffffff}Íå óäàëîñü íàéòè áèíä ýòîé êîìàíäû! Ïîïðîáóéòå ñáðîñèòü íàñòðîéêè õåëïåðà.', message_color)
	play_sound()
end
function initialize_commands()
	sampRegisterChatCommand("helper", function() 
		MODULE.Main.Window[0] = not MODULE.Main.Window[0]
	end)
	sampRegisterChatCommand("binder", function()
		MODULE.Main.Window[0] = true
		sampAddChatMessage('[Radical Helper] {ffffff}Áèíäåð íàõîäèòñÿ âî âêëàäêå "Êîìàíäû è RP îòûãðîâêè" - "RP êîìàíäû".', message_color)
	end)
	sampRegisterChatCommand("hm", show_fast_menu)
	sampRegisterChatCommand("stop", function()
		if MODULE.Binder.state.isActive then 
			MODULE.Binder.state.isStop = true
		else 
			sampAddChatMessage('[Radical Helper] {ffffff}Â äàííûé ìîìåíò íåò àêòèâíûõ êîìàíä èëè RP-îòûãðîâîê.', message_color)
		end
	end)
	sampRegisterChatCommand("fixsize", function()
		settings.general.custom_dpi = 1.0
		settings.general.autofind_dpi = false
		save_settings()
		sampAddChatMessage('[Radical Helper] {ffffff}Ðàçìåð èíòåðôåéñà õåëïåðà ñáðîøåí äî ñòàíäàðòíîãî çíà÷åíèÿ. Âûïîëíÿþ ïåðåçàïóñê...', message_color)
		reload_script = true
		thisScript():reload()
	end)
	sampRegisterChatCommand("rpguns", function()
		if settings.general.rp_guns then
			MODULE.RPWeapon.Window[0] = not MODULE.RPWeapon.Window[0] 
		else
			sampAddChatMessage('[Radical Helper] {ffffff}Âêëþ÷èòå ôóíêöèþ "RP îòûãðîâêà îðóæèÿ" â ðàçäåëå ' .. message_color_hex .. '/helper - Ôóíêöèè ' .. modules.player.data.fraction_tag, message_color)
		end
	end)
	sampRegisterChatCommand("pnv", function()
		MODULE.NightVision = not MODULE.NightVision
		setNightVision(MODULE.NightVision)
		MODULE.InfraredVision = false
		setInfraredVision(MODULE.InfraredVision)
		if MODULE.NightVision then
			sampSendChat('/me äîñòà¸ò èç êàðìàíà ïðèáîð íî÷íîãî âèäåíèÿ è íàäåâàåò åãî')
		else
			sampSendChat('/me ñíèìàåò ïðèáîð íî÷íîãî âèäåíèÿ è óáèðàåò åãî â êàðìàí')
		end
	end)
	sampRegisterChatCommand("irv", function()
		MODULE.InfraredVision = not MODULE.InfraredVision
		setInfraredVision(MODULE.InfraredVision)
		MODULE.NightVision = false
		setNightVision(MODULE.NightVision)	
		if MODULE.InfraredVision then
			sampSendChat('/me äîñòà¸ò èç êàðìàíà èíôðàêðàñíûé âèçîð è íàäåâàåò åãî')
		else
			sampSendChat('/me ñíèìàåò èíôðàêðàñíûé âèçîð è óáèðàåò åãî â êàðìàí')
		end
	end)
	sampRegisterChatCommand("cruise", function()
		local server = tonumber(getServerNumber())
		if server == 0 or server < 200 then
			if not MODULE.Binder.state.isActive then
				if MODULE.CruiseControl.active then
					MODULE.CruiseControl.active = false
					if isCharInAnyCar(PLAYER_PED) then
						taskWarpCharIntoCarAsDriver(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED))
					end
					sampAddChatMessage('[Radical Helper] {ffffff}Ðåæèì "CRUISE CONTROL" îòêëþ÷åí!', message_color)
				else
					if not isCharInAnyCar(PLAYER_PED) then
						sampAddChatMessage('[Radical Helper] {ffffff}Âû äîëæíû íàõîäèòñÿ â òðàíñïîðòíîì ñðåäñòâå!', message_color)
						return
					end
					local car = storeCarCharIsInNoSave(PLAYER_PED)
					if not (isCarEngineOn(car)) then
						sampAddChatMessage('[Radical Helper] {ffffff}Çàâåäèòå äâèãàòåëü âàøåãî òðàíñïîðòíîãî ñðåäñòâà!', message_color)
						return
					end
					local driver = getDriverOfCar(car)
					if driver ~= PLAYER_PED then
						sampAddChatMessage('[Radical Helper] {ffffff}Âû äîëæíû áûòü âîäèòåëåì òðàíñïîðòíîãî ñðåäñòâà!', message_color)
						return
					end
					local bool, x, y, z = getTargetBlipCoordinates()
					if bool then
						sampAddChatMessage('[Radical Helper] {ffffff}Óäàëèòå ñâîþ ñòàðóþ ìåòêó ñ êàðòû!', message_color)
						return
					end
					MODULE.CruiseControl.point = {x = 0, y = 0, z = 0}
					MODULE.CruiseControl.wait_point = true
					sampAddChatMessage('[Radical Helper] {ffffff}Âûáåðèòå ïóíêò íàçíàíåíèÿ, ïîñòàâèâ ìåòêó íà êàðòå', message_color)
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		else
			sampAddChatMessage('[Radical Helper] {ffffff}Äàííàÿ ôóíêöèÿ ïîääåðæèâàåòñÿ òîëüêî íà êàðòå GTA San Andreas. Êàðòû CRMP è Vice City íå ïîääåðæèâàþòñÿ.', message_color)
			play_sound()
		end
	end)
	sampRegisterChatCommand("debug", function()
		MODULE.DEBUG = not MODULE.DEBUG 
		sampAddChatMessage('[Radical Helper] {ffffff}Îòñëåæèâàíèå ñåðâåðíûõ äàííûõ ' .. (MODULE.DEBUG and 'âêëþ÷åíî.' or 'âûêëþ÷åíî.'), message_color)
	end)
	if not isMode('none') then
		sampRegisterChatCommand("mb", function(arg)
			if not MODULE.Binder.state.isActive then
				if MODULE.Members.Window[0] then
					MODULE.Members.Window[0] = false
					MODULE.Members.upd.check = false
					sampAddChatMessage('[Radical Helper] {ffffff}Ìåíþ ñïèñêà ñîòðóäíèêîâ çàêðûòî!', message_color)
				else
					MODULE.Members.new = {} 
					MODULE.Members.info.check = true 
					sampSendChat("/members")
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
		sampRegisterChatCommand("dep", function(arg)
			if not MODULE.Binder.state.isActive then
				MODULE.Departament.Window[0] = not MODULE.Departament.Window[0]
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
		sampRegisterChatCommand("sob", function(arg)
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					MODULE.Sobes.player_id = tonumber(arg)
					MODULE.Sobes.Window[0] = not MODULE.Sobes.Window[0]
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/sob [ID èãðîêà]', message_color)
					play_sound()
				end	
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
	end
	if isMode('police') or isMode('fbi') then
		sampRegisterChatCommand("sum", function(arg)
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_uk.data ~= 0 then
						MODULE.SumMenu.player_id = tonumber(arg)
						MODULE.SumMenu.Window[0] = true
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Ñíà÷àëà çàãðóçèòå/çàïîëíèòå ñèñòåìó óìíîãî ðîçûñêà â ' .. message_color_hex .. '/helper - Ôóíêöèè ' .. modules.player.data.fraction_tag, message_color)
						play_sound()
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/sum [ID èãðîêà]', message_color)
					play_sound()
				end	
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
		sampRegisterChatCommand("tsm", function(arg)
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_pdd.data ~= 0 then
						MODULE.TsmMenu.player_id = tonumber(arg)
						MODULE.TsmMenu.Window[0] = true
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Ñíà÷àëà çàãðóçèòå/çàïîëíèòå ñèñòåìó óìíûõ øòðàôîâ â ' .. message_color_hex .. '/helper - Ôóíêöèè ' .. modules.player.data.fraction_tag, message_color)
						play_sound()
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/tsm [ID èãðîêà]', message_color)
					play_sound()
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
		sampRegisterChatCommand("afind", function(arg)
		end)
		sampRegisterChatCommand("wanted", function(arg)
			sampSendChat('/wanted ' .. arg)
			sampAddChatMessage('[Radical Helper] {ffffff}Ðåêîìåíäóåòñÿ èñïîëüçîâàòü êîìàíäó ' .. message_color_hex .. '/wanteds {ffffff}äëÿ àâòîìàòè÷åñêîãî ñêàíèðîâàíèÿ âñåãî ñïèñêà ðîçûñêà.', message_color)
		end)
		sampRegisterChatCommand("wanteds", function(arg)
			if MODULE.Wanted.Window[0] or MODULE.Wanted.updwanteds.stop then
				MODULE.Wanted.Window[0] = false
				MODULE.Wanted.checker = false
				MODULE.Wanted.updwanteds.stop = false
				MODULE.Wanted.updwanteds.check = false
				sampAddChatMessage('[Radical Helper] {ffffff}Ìåíþ ñïèñêà ïðåñòóïíèêîâ çàêðûòî!', message_color)
			elseif not MODULE.Wanted.checker then
				lua_thread.create(function()
					local max_lvl = isMode('fbi') and 7 or 6
					sampAddChatMessage('[Radical Helper] {ffffff}Ñêàíèðîâàíèå /wanted, îæèäàéòå ' .. message_color_hex .. max_lvl .. ' {ffffff}ñåêóíä...', message_color)
					show_notify('info', 'Radical Helper', "Ñêàíèðîâàíèå /wanted...", 2500)
					MODULE.Wanted.new = {}
					MODULE.Wanted.checker = true
					for i = max_lvl, 1, -1 do
						printStringNow("CHECK WANTED " .. i, 1000)
						sampSendChat('/wanted ' .. i)
						wait(1000)
					end
					MODULE.Wanted.checker = false
					if #MODULE.Wanted.new == 0 then
						sampAddChatMessage('[Radical Helper] {ffffff}Ñåé÷àñ íà ñåðâåðå íåòó èãðîêîâ â ðîçûñêå!', message_color)
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Ñêàíèðîâàíèå ñïèñêà /wanted îêîí÷åíî! Íàéäåíî ïðåñòóïíèêîâ: ' .. message_color_hex .. #MODULE.Wanted.new, message_color)
						MODULE.Wanted.all = MODULE.Wanted.new
						MODULE.Wanted.updwanteds.stop = false
						MODULE.Wanted.updwanteds.time = 0
						MODULE.Wanted.updwanteds.last_time = os.time()
						MODULE.Wanted.updwanteds.check = true
						MODULE.Wanted.Window[0] = true
					end
				end)
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ñêàíèðîâàíèÿ!', message_color)
				play_sound()
			end
		end)
		sampRegisterChatCommand("patrool", function(arg)
			MODULE.Patrool.Window[0] = not MODULE.Patrool.Window[0]
		end)
	end
	if not (isMode('ghetto') or isMode('mafia') or isMode('judge')) then
		sampRegisterChatCommand("post", function(arg)
			if not MODULE.Binder.state.isActive then
				MODULE.Post.Window[0] = not MODULE.Post.Window[0]
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
	end
	if isMode('prison') then
		sampRegisterChatCommand("pum", function(arg)
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_rptp.data ~= 0 then
						MODULE.PumMenu.player_id = tonumber(arg)
						MODULE.PumMenu.Window[0] = true
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Ñíà÷àëà çàãðóçèòå/çàïîëíèòå ñèñòåìó óìíîãî ñðîêà â ' .. message_color_hex .. '/helper - Ôóíêöèè ' .. modules.player.data.fraction_tag, message_color)
						play_sound()
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/pum [ID èãðîêà]', message_color)
					play_sound()
				end	
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
				play_sound()
			end
		end)
	end
	if isMode('gov') then
		sampRegisterChatCommand('zeks', function()
			if settings.gov.custom_zeks then
				if MODULE.Zeks.Window[0] or MODULE.Zeks.updzeks.stop then
					MODULE.Zeks.Window[0] = false
					MODULE.Zeks.checker = false
					MODULE.Zeks.updzeks.stop = false
					MODULE.Zeks.updzeks.check = false
					sampAddChatMessage('[Radical Helper] {ffffff}Ìåíþ ñïèñêà çàêëþ÷åííûõ çàêðûòî!', message_color)
				elseif not MODULE.Zeks.checker then
					sampAddChatMessage('[Radical Helper] {ffffff}Ñêàíèðîâàíèå /zeks...', message_color)
					show_notify('info', 'Radical Helper', "Ñêàíèðîâàíèå /zeks...", 2500)
					MODULE.Zeks.new = {}
					MODULE.Zeks.checker = true
					sampSendChat('/zeks')
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ñêàíèðîâàíèÿ!', message_color)
					play_sound()
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Âû ìîæåòå âêëþ÷èòü êàñòîìíîå ìåíþ /zeks ñ àâòî-îáíîâëåíèåì â ' .. message_color_hex .. '/helper - Ôóíêöèè Ïðàâî', message_color)
				sampSendChat('/zeks')
			end
		end)
	end
	for _, command in ipairs(modules.commands.data.commands.my) do
		if command.enable then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
	if modules.player.data.fraction_rank_number >= 6 then
		sampRegisterChatCommand("frp", function()
			lua_thread.create(function()
				for _, h in pairs(getAllChars()) do
					_, id = sampGetPlayerIdByCharHandle(h)
					_, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
					id = tonumber(id)
					if id ~= -1 and id ~= m and doesCharExist(h) and sampIsPlayerConnected(id) then
						local x, y, z = getCharCoordinates(h)
						local mx, my, mz = getCharCoordinates(PLAYER_PED)
						local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
						if dist <= 5 then
							sampSendChat("/fractionrp " .. id)
							wait(1000)
						end
					end
				end
			end)
    	end)
	end
	if modules.player.data.fraction_rank_number >= 9 then
		sampRegisterChatCommand("lm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not MODULE.Binder.state.isActive then
				lua_thread.create(function()
					MODULE.Binder.state.isActive = true
					info_stop_command()
					sampSendChat("/rb Âíèìàíèå! ×åðåç 15 ñåêóíä áóäåò ñïàâí òðàíñïîðòà îðãàíèçàöèè.")
					wait(1500)
					if MODULE.Binder.state.isStop then 
						MODULE.Binder.state.isStop = false 
						MODULE.Binder.state.isActive = false
						if IS_MOBILE and settings.general.mobile_stop_button then
							MODULE.CommandStop.Window[0] = false
						end
						sampAddChatMessage('[Radical Helper] {ffffff}Îòûãðîâêà êîìàíäû /spcar óñïåøíî îñòàíîâëåíà!', message_color) 
						return
					end
					sampSendChat("/rb Çàéìèòå òðàíñïîðò, èíà÷å îí áóäåò çàñïàâíåí.")
					wait(13500)
					if MODULE.Binder.state.isStop then 
						MODULE.Binder.state.isStop = false 
						MODULE.Binder.state.isActive = false
						if IS_MOBILE and settings.general.mobile_stop_button then
							MODULE.CommandStop.Window[0] = false
						end
						sampAddChatMessage('[Radical Helper] {ffffff}Îòûãðîâêà êîìàíäû /spcar óñïåøíî îñòàíîâëåíà!', message_color) 
						return
					end
					MODULE.LeadTools.spawncar = true
					sampSendChat("/lmenu")
					MODULE.Binder.state.isActive = false
					if IS_MOBILE and settings.general.mobile_stop_button then
						MODULE.CommandStop.Window[0] = false
					end
				end)
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ ïðåäûäóùåé êîìàíäû.', message_color)
			end
		end)
		sampRegisterChatCommand('fcleaner', function (arg)
			if arg:find('(%d+)') then
				MODULE.LeadTools.cleaner.players_to_kick = {}
				MODULE.LeadTools.cleaner.day_afk = tonumber(arg)
				MODULE.LeadTools.cleaner.uninvite = true
				sampSendChat('/lmenu')
			else
				sampAddChatMessage('[Arizina Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/fcleaner [êîë-âî äíåé àôê äëÿ êèêà]', message_color)
			end
		end)
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			if command.enable then
				register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
			end
		end
	end
end
local cyrilic_characters = {
    [168] = '¨', [184] = '¸', [192] = 'À', [193] = 'Á', [194] = 'Â', [195] = 'Ã', [196] = 'Ä',
	[197] = 'Å', [198] = 'Æ', [199] = 'Ç', [200] = 'È', [201] = 'É', [202] = 'Ê', [203] = 'Ë',
	[204] = 'Ì', [205] = 'Í', [206] = 'Î', [207] = 'Ï', [208] = 'Ð', [209] = 'Ñ', [210] = 'Ò',
	[211] = 'Ó', [212] = 'Ô', [213] = 'Õ', [214] = 'Ö', [215] = '×', [216] = 'Ø', [217] = 'Ù',
	[218] = 'Ú', [219] = 'Û', [220] = 'Ü', [221] = 'Ý', [222] = 'Þ', [223] = 'ß', [224] = 'à',
	[225] = 'á', [226] = 'â', [227] = 'ã', [228] = 'ä', [229] = 'å', [230] = 'æ', [231] = 'ç',
	[232] = 'è', [233] = 'é', [234] = 'ê', [235] = 'ë', [236] = 'ì', [237] = 'í', [238] = 'î',
	[239] = 'ï', [240] = 'ð', [241] = 'ñ', [242] = 'ò', [243] = 'ó', [244] = 'ô', [245] = 'õ',
	[246] = 'ö', [247] = '÷', [248] = 'ø', [249] = 'ù', [250] = 'ú', [251] = 'û', [252] = 'ü',
	[253] = 'ý', [254] = 'þ', [255] = 'ÿ',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper cyrilic characters
            output = output .. cyrilic_characters[ch + 32]
        elseif ch == 168 then -- ¨
            output = output .. cyrilic_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower cyrilic characters
            output = output .. cyrilic_characters[ch - 32]
        elseif ch == 184 then -- ¸
            output = output .. cyrilic_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function translate(name)
	if name and name:match('%a+') then
		name = name:gsub("^%[%d+%]", "")
		local translit_table = {
       		['ph'] = 'ô',['Ph'] = 'Ô',['Ch'] = '×',['ch'] = '÷',['Th'] = 'Ò', ['liy'] = 'ëèé', 
			['th'] = 'ò',['Sh'] = 'Ø',['sh'] = 'ø',['Ae'] = 'Ý',['ae'] = 'ý', ['ame'] = 'åéì',
			['size'] = 'ñàéç', ['Jj'] = 'Äæåéäæåé',['Whi'] = 'Âàé',['lack'] = 'ëýê', ['ane'] = 'åéí',
			['whi'] = 'âàé',['Ck'] = 'Ê',['ck'] = 'ê',['Kh'] = 'Õ',['kh'] = 'õ', ['Alex'] = 'Àëåêñ',
			['hn'] = 'í',['Hen'] = 'Ãåí',['Zh'] = 'Æ',['zh'] = 'æ',['Yu'] = 'Þ', ['Jason'] = 'Äæåéñîí',
			['yu'] = 'þ',['Yo'] = '¨',['yo'] = '¸',['Cz'] = 'Ö',['cz'] = 'ö', ['Babe'] = 'Áýéáè', 
			['ia'] = 'ÿ', ['ea'] = 'è',['Ya'] = 'ß', ['ya'] = 'ÿ', ['ove'] = 'àâ',['ci'] = 'öè',
			['ay'] = 'ýé', ['rise'] = 'ðàéç',['oo'] = 'ó', ['Oo'] = 'Ó', ['rown'] = 'ðàóí',
			['Ee'] = 'È', ['ee'] = 'è', ['Un'] = 'Àí', ['un'] = 'àí', ['Ci'] = 'Öè',
			['yse'] = 'óç', ['cate'] = 'êåéò', ['eow'] = 'ÿó', ['yev'] = 'óåâ', ['Alexei'] = 'Àëåêñåé', 
		}
		for k, v in pairs(translit_table) do
            name = name:gsub(k, v) 
        end
		local char_table = {
			['B'] = 'Á',['Z'] = 'Ç',['T'] = 'Ò',['Y'] = 'É',['P'] = 'Ï',['J'] = 'Äæ',['X'] = 'Êñ',['G'] = 'Ã',
			['V'] = 'Â',['H'] = 'Õ',['N'] = 'Í',['E'] = 'Å',['I'] = 'È',['D'] = 'Ä',['O'] = 'Î',['K'] = 'Ê',['F'] = 'Ô',
			['y`'] = 'û',['e`'] = 'ý',['A'] = 'À',['C'] = 'Ê',['L'] = 'Ë',['M'] = 'Ì',['W'] = 'Â',['Q'] = 'Ê',
			['U'] = 'À',['R'] = 'Ð',['S'] = 'Ñ',['zm'] = 'çüì',['h'] = 'õ',['q'] = 'ê',['y'] = 'è',['a'] = 'à',
			['w'] = 'â',['b'] = 'á',['v'] = 'â',['g'] = 'ã',['d'] = 'ä',['e'] = 'å',['z'] = 'ç',['i'] = 'è',
			['j'] = 'æ',['k'] = 'ê',['l'] = 'ë',['m'] = 'ì',['n'] = 'í',['o'] = 'î',['p'] = 'ï',['r'] = 'ð',
			['s'] = 'ñ',['t'] = 'ò',['u'] = 'ó',['f'] = 'ô',['x'] = 'x',['c'] = 'ê',['``'] = 'ú',['`'] = 'ü',['_'] = ' '
		}
        for k, v in pairs(char_table) do
			name = name:gsub(k, v) 
        end
        return name
    end
	return name
end
function isParamSampID(id)
	id = tonumber(id) or nil
	if not id or id < 0 or id > 999 or id % 1 ~= 0 then return false end
	if id == MODULE.Binder.tag.my_id() then return true end
	return sampIsPlayerConnected(id)
end
function play_sound()
	local path_audio = config_dir .. "/Resourse/notify.mp3"
	if doesFileExist(path_audio) then
		local notify_sound = loadAudioStream(path_audio)
		setAudioStreamState(notify_sound, 1)
	end
end
function show_fast_menu(id)
	if isParamSampID(id) then 
		MODULE.FastMenu.player_id = tonumber(id)
		MODULE.FastMenu.Window[0] = true
	else
		if hotkey_no_errors and settings.general.bind_fastmenu then
			sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/hm [ID èãðîêà] {ffffff}èëè íàâåäèòåñü íà èãðîêà ÷åðåç ' .. message_color_hex .. 'ÏÊÌ + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color) 
		else
			sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/hm [ID èãðîêà]', message_color)
		end 
		play_sound()
	end 
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		MODULE.LeaderFastMenu.player_id = tonumber(id)
		MODULE.LeaderFastMenu.Window[0] = true
	else
		if hotkey_no_errors and settings.general.bind_leader_fastmenu then
			sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/lm [ID èãðîêà] {ffffff}èëè íàâåäèòåñü íà èãðîêà ÷åðåç ' .. message_color_hex .. 'ÏÊÌ + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/lm [ID èãðîêà]', message_color)
		end 
		play_sound()
	end
end
function get_players()
	local myId = MODULE.Binder.tag.my_id()
	local mx, my, mz = getCharCoordinates(PLAYER_PED)
	local playersInRange = {}
	for i, ped in pairs(getAllChars()) do
		local result, id = sampGetPlayerIdByCharHandle(ped)
		if result and id and id ~= myId and id ~= -1 and not sampGetPlayerNickname(id):find('^Player_') and not sampGetPlayerNickname(id):find('^' .. modules.player.data.nick) then
			local x, y, z = getCharCoordinates(ped)
			if getDistanceBetweenCoords3d(mx, my, mz, x, y, z) <= 8 then
				table.insert(playersInRange, id)
			end
		end
	end
	return playersInRange
end
function openLink(link)
	if IS_MOBILE then
		ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]]
		ffi.load('GTASA')._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end
local servers = {
	{name = 'Unknown server', number = '00'},
	-- Arizona
	{name = 'Phoenix', number = '01'},
	{name = 'Tucson', number = '02'},
	{name = 'Scottdale', number = '03'},
	{name = 'Chandler', number = '04'},
	{name = 'Brainburg', number = '05'},
	{name = 'SaintRose', number = '06'},
	{name = 'Mesa', number = '07'},
	{name = 'Red Rock', number = '08'},
	{name = 'Yuma', number = '09'},
	{name = 'Surprise', number = '10'},
	{name = 'Prescott', number = '11'},
	{name = 'Glendale', number = '12'},
	{name = 'Kingman', number = '13'},
	{name = 'Winslow', number = '14'},
	{name = 'Payson', number = '15'},
	{name = 'Gilbert', number = '16'},
	{name = 'Show Low', number = '17'},
	{name = 'Casa Grande', number = '18'},
	{name = 'Page', number = '19'},
	{name = 'Sun City', number = '20'},
	{name = 'Queen Creek', number = '21'},
	{name = 'Sedona', number = '22'},
	{name = 'Holiday', number = '23'},
	{name = 'Wednesday', number = '24'},
	{name = 'Yava', number = '25'},
	{name = 'Faraway', number = '26'},
	{name = 'Bumble Bee', number = '27'},
	{name = 'Christmas', number = '28'},
	{name = 'Mirage', number = '29'},
	{name = 'Love', number = '30'},
	{name = 'Drake', number = '31'},
	{name = 'Space', number = '32'},
	-- Arizona Mobile
	{name = 'Mobile III', number = '103'},
	{name = 'Mobile II', number = '102'},
	{name = 'Mobile I', number = '101'},
	-- Arizona VC
	{name = 'Vice City'	, number = '200'},
	-- Rodina
	{name = 'Öåíòðàëüíûé îêðóã'	, number = '301'},
	{name = 'Þæíûé îêðóã', number = '302'},
	{name = 'Ñåâåðíûé îêðóã', number = '303'},
	{name = 'Âîñòî÷íûé îêðóã', number = '304'},
	{name = 'Çàïàäíûé îêðóã', number = '305'},
	{name = 'Ïðèìîðñêèé îêðóã', number = '306'},
	{name = 'Ôåäåðàëüíûé îêðóã', number = '307'},
	-- Rodina Mobile
	{name = 'Ìîñêâà', number = '401'},
	{name = 'Ñàíêò Ïåòåðáóðã', number = '402'},
}
function getServerNumber()
	local name = sampGetCurrentServerName():gsub('%-', ' ')
	for _, s in ipairs(servers) do
		if name:find(s.name) then
			return s.number
		end
	end
	return '00'
end
function getServerName(number)
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			return s.name
		end
	end
	return ''
end
function sampGetPlayerIdByNickname(nick)
	if not nick then return -1 end
	local myid = MODULE.Binder.tag.my_id()
	if IS_MOBILE then
		if nick == modules.player.data.nick then return myid end
	else
		if sampGetPlayerNickname(myid):find(nick, 1, true) then return myid end
	end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick, 1, true) then
		   return i
	    end
	end
	return -1
end
local car_colors = {
	[0] = "÷¸ðíîãî", [1] = "áåëîãî", [2] = "áèðþçîâîãî", [3] = "áîðäîâîãî", [4] = "õâîéíîãî", [5] = "ïóðïóðíîãî", [6] = "æ¸ëòîãî", [7] = "ãîëóáîãî", [8] = "ñåðîãî", 
	[9] = "îëèâêîâîãî", [10] = "ñèíåãî", [11] = "ñåðîãî", [12] = "ãîëóáîãî", [13] = "ãðàôèòîâîãî", [14] = "ñâåòëîãî", [15] = "ñâåòëîãî", [16] = "õâîéíîãî", [17] = "áîðäîâîãî", 
	[18] = "áîðäîâîãî", [19] = "ñåðîãî", [20] = "ñèíåãî", [21] = "áîðäîâîãî", [22] = "áîðäîâîãî", [23] = "ñåðîãî", [24] = "ãðàôèòîâîãî", [25] = "ñåðîãî", [26] = "ñâåòëîãî", 
	[27] = "òóñêëîãî", [28] = "ñèíåãî", [29] = "ñâåòëîãî", [30] = "áîðäîâîãî", [31] = "áîðäîâîãî", [32] = "ãîëóáîâàòîãî", [33] = "ñåðîãî", [34] = "òóñêëîãî", 
	[35] = "êîðè÷íåâîãî", [36] = "ñèíåãî", [37] = "õâîéíîãî", [38] = "ñåðîãî", [39] = "ñèíåãî", [40] = "ò¸ìíîãî", [41] = "êîðè÷íåâîãî", [42] = "êîðè÷íåâîãî",
	[43] = "áîðäîâîãî", [44] = "õâîéíîãî", [45] = "áîðäîâîãî", [46] = "áåæåâîãî", [47] = "îëèâêîâîãî", [48] = "îëèâêîâîãî", [49] = "ñåðîãî", [50] = "ñåðåáðèñòîãî", 
	[51] = "õâîéíîãî", [52] = "ñèíåãî", [53] = "ñèíåãî", [54] = "ñèíåãî", [55] = "êîðè÷íåâîãî", [56] = "ãîëóáîãî", [57] = "îëèâêîâîãî", [58] = "ò¸ìíîêðàñíîãî", 
	[59] = "ñèíåãî", [60] = "ñâåòëîãî", [61] = "îðàíæåâîãî", [62] = "ò¸ìíîêðàñíîãî", [63] = "ñåðåáðèñòîãî", [64] = "ñâåòëîãî", [65] = "îëèâêîâîãî", [66] = "êîðè÷íåâîãî", 
	[67] = "àñôàëüòîâîãî", [68] = "îëèâêîâîãî", [69] = "êâàðöåâîãî", [70] = "ò¸ìíîêðàñíîãî", [71] = "ñâåòëîãî", [72] = "ò¸ìíîñåðîãî", [73] = "îëèâêîâîãî", [74] = "áîðäîâîãî", 
	[75] = "ñèíåãî", [76] = "îëèâêîâîãî", [77] = "îðàíæåâîãî", [78] = "áîðäîâîãî", [79] = "ñèíåãî", [80] = "ðîçîâîãî", [81] = "îëèâêîâîãî", [82] = "ò¸ìíîêðàñíîãî", 
	[83] = "áèðþçîâîãî", [84] = "êîðè÷íåâîãî", [85] = "ðîçîâîãî", [86] = "õâîéíîãî", [87] = "ñèíåãî", [88] = "âèííîãî", [89] = "îëèâêîâîãî", [90] = "ñâåòëîãî", 
	[91] = "ò¸ìíîñèíåãî", [92] = "ò¸ìíîñåðîãî", [93] = "ãîëóáîâàòîãî", [94] = "ñèíåãî", [95] = "ñèíåãî", [96] = "ñâåòëîãî", [97] = "àñôàëüòîâîãî", [98] = "ãîëóáîâàòîãî", 
	[99] = "êîðè÷íåâîãî", [100] = "áðèëëèàíòîâîãî", [101] = "êîáàëüòîâîãî", [102] = "êîðè÷íåâîãî", [103] = "ñèíåãî", [104] = "êîðè÷íåâîãî", [105] = "ñåðîãî", [106] = "ñèíåãî", 
	[107] = "îëèâêîâîãî", [108] = "áðèëëèàíòîâîãî", [109] = "ñåðîãî", [110] = "îëèâêîâîãî", [111] = "ñåðîãî", [112] = "ñåðîãî", [113] = "êîðè÷íåâîãî", [114] = "çåë¸íîãî", 
	[115] = "ò¸ìíîêðàñíîãî", [116] = "ñèíåãî", [117] = "áîðäîâîãî", [118] = "ãîëóáîãî", [119] = "êîðè÷íåâîãî", [120] = "îëèâêîâîãî", [121] = "áîðäîâîãî", [122] = "ò¸ìíîñåðîãî", 
	[123] = "êîðè÷íåâîãî", [124] = "ò¸ìíîêðàñíîãî", [125] = "ñèíåãî", [126] = "ðîçîâîãî", [127] = "÷¸ðíîãî", [128] = "çåë¸íîãî", [129] = "áîðäîâîãî", [130] = "ñèíåãî",
	[131] = "êîðè÷íåâîãî", [132] = "ò¸ìíîêðàñíîãî", [133] = "÷¸ðíîãî", [134] = "ôèîëåòîâîãî", [135] = "ÿðêîñèíåãî", [136] = "àìåòèñòîâîãî", [137] = "çåë¸íîãî", [138] = "ñåðîãî",
	[139] = "ïóðïóðíîãî", [140] = "ñâåòëîãî", [141] = "ò¸ìíîñåðîãî", [142] = "îëèâêîâîãî", [143] = "ôèîëåòîâîãî", [144] = "ôèîëåòîâîãî", [145] = "çåë¸íîãî", [146] = "ïóðïóðíîãî", 
	[147] = "ôèîëåòîâîãî", [148] = "îëèâêîâîãî", [149] = "ò¸ìíîãî", [150] = "ò¸ìíîçåë¸íîãî", [151] = "çåëåíîãî", [152] = "ñèíåãî", [153] = "çåë¸íîãî", [154] = "ñàëàòîâîãî", 
	[155] = "áèðþçîâîãî", [156] = "êîðè÷íåâîãî", [157] = "ñâåòëîãî", [158] = "îðàíæåâîãî", [159] = "êîðè÷íåâîãî", [160] = "ò¸ìíîçåë¸íîãî", [161] = "âèííîãî", [162] = "ñèíåãî",
	[163] = "ãðàôèòîâîãî", [164] = "÷¸ðíîãî", [165] = "áèðþçîâîãî", [166] = "áèðþçîâîãî", [167] = "ôèîëåòîâîãî", [168] = "áîðäîâîãî", [169] = "ôèîëåòîâîãî", [170] = "ôèîëåòîâîãî", 
	[171] = "ôèîëåòîâîãî", [172] = "õâîéíîãî", [173] = "êîðè÷íåâîãî", [174] = "êîðè÷íåâîãî", [175] = "êîðè÷íåâîãî", [176] = "ïóðïóðíîãî", [177] = "ïóðïóðíîãî", [178] = "ïóðïóðíîãî", 
	[179] = "ôèîëåòîâîãî", [180] = "êîðè÷íåâîãî", [181] = "êðàñíîãî", [182] = "îðàíæåâîãî", [183] = "îëèâêîâîãî", [184] = "ãîëóáîãî", [185] = "÷¸ðíîãî", [186] = "÷¸ðíîãî", 
	[187] = "çåë¸íîãî", [188] = "çåë¸íîãî", [189] = "çåë¸íîãî", [190] = "ïóðïóðíîãî", [191] = "ñàëàòîâîãî", [192] = "ñâåòëîãî", [193] = "ñâåòëîãî", [194] = "îëèâêîâîãî", 
	[195] = "îëèâêîâîãî", [196] = "ñåðîãî", [197] = "îëèâêîâîãî", [198] = "ñèíåãî", [199] = "îëèâêîâîãî", [200] = "ñòðàííîãî", [201] = "ñèíåãî", [202] = "çåë¸íîãî", [203] = "ñèíåãî",
	[204] = "ãîëóáîãî", [205] = "ñèíåãî", [206] = "ò¸ìíîñèíåãî", [207] = "ãîëóáîãî", [208] = "ñèíåãî", [209] = "ñèíåãî", [210] = "ñèíåãî", [211] = "ôèîëåòîâîãî", 
	[212] = "îðàíæåâîãî", [213] = "ñâåòëîãî", [214] = "îëèâêîâîãî", [215] = "÷¸ðíîãî", [216] = "îðàíæåâîãî", [217] = "áèðþçîâîãî", [218] = "áëåäíî-ðîçîâîãî", [219] = "îðàíæåâîãî", 
	[220] = "ðîçîâîãî", [221] = "îëèâêîâîãî", [222] = "îðàíæåâîãî", [223] = "ñèíåãî", [224] = "áîðäîâîãî", [225] = "õâîéíîãî", [226] = "ñàëàòîâîãî", [227] = "çåë¸íîãî", 
	[228] = "áëåäíîãî", [229] = "ñàëàòîâîãî", [230] = "áîðäîâîãî", [231] = "êîðè÷íåâîãî", [232] = "ðîçîâîãî", [233] = "ïóðïóðíîãî", [234] = "ò¸ìíîçåë¸íîãî", [235] = "îëèâêîâîãî",
	[236] = "õâîéíîãî", [237] = "ïóðïóðíîãî", [238] = "îðàíæåâîãî", [239] = "êîðè÷íåâîãî", [240] = "ãîëóáîãî", [241] = "çåëåíîãî", [242] = "ôèîëåòîâîãî", [243] = "çåë¸íîãî", 
	[244] = "êîðè÷íåâîãî", [245] = "õâîéíîãî", [246] = "ãîëóáîãî", [247] = "ñèíåãî", [248] = "áîðäîâîãî", [249] = "áîðäîâîãî", [250] = "ñåðîãî", [251] = "ñåðîãî", [252] = "÷¸ðíîãî", 
	[253] = "ñåðîãî", [254] = "êîðè÷íåâîãî", [255] = "ñèíåãî"
}
function get_vehicle_name(id)
	local map = modules.arz_veh.byId
	if map and map[id] then
		return map[id]
	end
	sampAddChatMessage('[Arizona Helper] {ffffff}Íå óäàëîñü ïîëó÷èòü ìîäåëü ò/c ' .. id .. " ID, îáíîâëÿþ êîíôèã òðàíñïîðòà...", message_color)
	download_file = 'arz_veh'
	downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/SmartVEH/Vehicles' .. 
	((tonumber(getServerNumber()) > 300) and 'Rodina.json' or '.json'), modules.arz_veh.path)
	return 'òðàíñïîðòíîãî ñðåäñòâà'
end
function get_near_car(only_with_driver)
	local closest_car = nil
	local closest_distance = 50
	local my_pos = {getCharCoordinates(PLAYER_PED)}
	local my_car = nil

	if isCharInAnyCar(PLAYER_PED) then my_car = storeCarCharIsInNoSave(PLAYER_PED) end

	for _, vehicle in ipairs(getAllVehicles()) do
		if vehicle ~= my_car then
			if (not only_with_driver) or doesCharExist(getDriverOfCar(vehicle)) then
				local vehicle_pos = {getCarCoordinates(vehicle)}
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1], vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance then
					closest_distance = distance
					closest_car = vehicle
				end
			end
		end
	end

	if not closest_car then return 'òðàíñïîðòíîãî ñðåäñòâà' end

	local clr1 = getCarColours(closest_car)
	local CarColorName = clr1 and (' ' .. car_colors[clr1] .. ' öâåòà') or ''
	
	local plateText = ''
	for _, plate in pairs(modules.arz_veh.cache) do
		local result, veh = sampGetCarHandleBySampVehicleId(plate.carID)
		if result and veh == closest_car then
			plateText = ' c íîìåðàìè ' .. plate.number
			break
		end
	end

	return (get_vehicle_name(getCarModel(closest_car)) .. CarColorName .. plateText)
end
function cache_vehicles()
	for _, v in ipairs(modules.arz_veh.data) do
		if v.model_id then
			modules.arz_veh.byId[v.model_id] = v.name
		end
	end
end
function get_area(x, y, z)
	local streets = {
		{"Ãîëüô-êëóá Àâèñïà", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
		{"Àýðîïîðò ÑÔ", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
		{"Ãîëüô-êëóá Àâèñïà", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
		{"Àýðîïîðò ÑÔ", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
		{"Ãàðñèÿ", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
		{"Òåíèñòûå ðó÷üè", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
		{"Âîñòî÷íûé ËÑ", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
		{"Ãðóçîâîé ñêëàä ËÂ", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
		{"Áëýêôèëäñêèé ïåðåêð¸ñòîê", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
		{"Ãîëüô-êëóá Àâèñïà", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
		{"Òåìïë äðàéâ", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
		{"Âîêçàë ËÑ", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
		{"Ãðóçîâîé ñêëàä ËÂ", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
		{"Ëîñ-Ôëîðåñ", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
		{"Àçàðòíûé ðàéîí", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
		{"Èñòåðáýéñêèé õèìçàâîä", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
		{"Âîñòî÷íàÿ Ýñïàëàíäà", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
		{"Ñòàíöèÿ Ìàðêåò", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
		{"Âîêçàë ËÂ", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
		{"Ïåðåêð¸ñòîê Ìîíòãîìåðè", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
		{"Ìîñò Ôðåäåðèê", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
		{"Ñòàíöèÿ Éåëëîó-Áåëë", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
		{"Îòåëü Íî÷íûå âîëêè", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
		{"Ãîðà Âàéíâóä", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
		{"Ãîëüô-êëóá Àâèñïà", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
		{"Áîëüíèöà Äæåôôåðñîí", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
		{"Çàïàäàíîå øîññå", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
		{"Äæåôôåðñîí", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
		{"Ðîäåî äðàéâ", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
		{"Âîêçàë ÑÔ", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
		{"Çàïàäíûé Ðåäñàíäñ", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
		{"Ìàëåíüêàÿ Ìåêñèêà", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
		{"Áëýêôèëäñêèé ïåðåêð¸ñòîê", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
		{"Àýðîïîðò ËÑ", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
		{"Áåêîí-Õèëë", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
		{"Ðîäåî äðàéâ", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
		{"Ãîðà Âàéíâóä", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
		{"Ñòðèï", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
		{"Áëýêôèëäñêèé ïåðåêð¸ñòîê", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
		{"Àâòîâîêçàë", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
		{"Ìîíòãîìåðè", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
		{"Ôîñòåðñêàÿ äîëèíà", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
		{"Áëýêôèëä", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
		{"Àýðîïîðò ËÑ", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
		{"Ãîðà Âàéíâóä", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
		{"Ãîëüô-êîðò Éåëëîóáåëë", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
		{"Ñòðèï", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
		{"Äæåôôåðñîí", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
		{"Ãîðà Âàéíâóä", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
		{"Ýëü-Êåáðàäîñ", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
		{"Ëàñ-Êîëèíàñ", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
		{"Ëàñ-Êîëèíàñ", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
		{"Ãîðà Âàéíâóä", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
		{"Ãðóçîâîé ñêëàä ËÂ", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
		{"Óèëëîóôèëä", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
		{"Òåìïë äðàéâ", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
		{"Ìàëåíüêàÿ Ìåêñèêà", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
		{"Êâèíñ", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
		{"Àýðîïîðò ËÂ", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
		{"Ãîðà Âàéíâóä", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
		{"Òåìïë äðàéâ", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
		{"Âîñòî÷íûé ËÑ", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
		{"Âîñòî÷íîå øîññå ËÂ", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
		{"Óèëëîóôèëä", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
		{"Ëàñ-Êîëèíàñ", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
		{"Âîñòî÷íîå øîññå ËÂ", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
		{"Ðîäåî äðàéâ", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
		{"Ïóñòûííûé îêðóã", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
		{"Âîñòî÷íîå øîññå ËÂ", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
		{"Ðîäåî äðàéâ", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
		{"Âàéíâóä", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
		{"Ðîäåî äðàéâ", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
		{"Ðîäåî äðàéâ", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
		{"Äæåôôåðñîí", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
		{"Òóìàííûé îêðóã", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
		{"Òåìïë äðàéâ", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
		{"Êðàñíûé æ/ä ìîñò", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
		{"Ïëÿæ Âåðîíà", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
		{"Öåíòðàëüíûé áàíê ËÑ", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
		{"Ãîðà Âàéíâóä", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
		{"Ðîäåî äðàéâ", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
		{"Ãîðà Âàéíâóä", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
		{"Ãîðà Âàéíâóä", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
		{"Þæíîå øîññå ËÂ", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
		{"Àéäëâóä", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
		{"Ïîðò ËÑ", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
		{"Êîììåð÷åñêèé ðàéîí", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
		{"Òåìïë äðàéâ", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
		{"Ãëåí Ïàðê", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
		{"Àýðîïîðò ËÂ", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
		{"Ìîñò Ìàðòèíà", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
		{"Ñòðèï", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
		{"Óèëëîóôèëä", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
		{"Êàíàë Ìàðèíà", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
		{"Àýðîïîðò ËÂ", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
		{"Àéäëâóä", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
		{"Âîñòî÷íàÿ Ýñïàëàíäà", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
		{"Ìîñò Ìàêî", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
		{"Ðîäåî äðàéâ", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
		{"Ïëîùàäü Ïåðøèíã", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
		{"Ãîðà Âàéíâóä", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
		{"Ìîñò Ãàíò", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
		{"Ëàñ-Êîëèíàñ", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
		{"Ãîðà Âàéíâóä", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
		{"Êîììåð÷åñêèé ðàéîí", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
		{"ÊÏÏ ËÑ-ÑÔ", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
		{"Ðîêà Ýñêàëàíòå", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
		{"ÊÏÏ ËÑ-ÑÔ", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
		{"Öåíòðàëüíûé Ðûíîê", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
		{"Ëàñ-Êîëèíàñ", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
		{"Ãîðà Âàéíâóä", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
		{"Êèíãñ", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
		{"Âîñòî÷íûé Ðåäñàíäñ", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
		{"Àâòîâîêçàë", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
		{"Ãîðà Âàéíâóä", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
		{"Îêåàíñêîå ïîáåðåæüå", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
		{"Ãðèíãëàññêèé êîëëåäæ", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
		{"Ãëåí Ïàðê", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
		{"Ãðóçîâîé ñêëàä ËÂ", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
		{"Ïóñòûííûé îêðóã", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
		{"Ïëÿæ Âåðîíà", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
		{"Âîñòî÷íûé ËÑ", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
		{"Äâîðåö Êàëèãóëû", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
		{"Àéäëâóä", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
		{"Ïèëèãðèì", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
		{"Àéäëâóä", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
		{"Êâèíñ", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
		{"Êîììåð÷åñêèé ðàéîí", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
		{"Âîñòî÷íûé ËÑ", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
		{"Êàíàë Ìàðèíà", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
		{"Ãîðà Âàéíâóä", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
		{"Âàéíâóä", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
		{"Âîñòî÷íûé ËÑ", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
		{"Ðîäåî äðàéâ", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
		{"Èñòåðñêèé Òîííåëü", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
		{"Ðîäåî äðàéâ", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
		{"Âîñòî÷íûé Ðåäñàíäñ", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
		{"Àçàðòíûé ðàéîí", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
		{"ÁÊ Ðèôà", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
		{"Ïåðåêð¸ñòîê Ìîíòãîìåðè", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
		{"Óèëëîóôèëä", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
		{"Òåìïë äðàéâ", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
		{"Ïðèêë Ïàéí", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
		{"Àýðîïîðò ËÑ", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
		{"Áåëûé ìîñò", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
		{"Áåëûé ìîñò", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
		{"Êðàñíûé æ/ä ìîñò", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
		{"Êðàñíûé æ/ä ìîñò", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
		{"Ïëÿæ Âåðîíà", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
		{"Çåë¸íûé óò¸ñ", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
		{"Ãîðà Âàéíâóä", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
		{"Ãîðà Âàéíâóä", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
		{"Êîììåð÷åñêèé ðàéîí", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
		{"Öåíòðàëüíûé Ðûíîê", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
		{"Çàïàäíûé Ðîêøîð", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
		{"Âîñòî÷íûé ïëÿæ ËÑ", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
		{"Ìîñò Ôàëëîó", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
		{"Óèëëîóôèëä", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
		{"×àéíàòàóí", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
		{"Ñêàëèñòûé ìàññèâ ËÂ", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
		{"ÁÊ Àöòåêè", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
		{"Èñòåðáýéñêèé õèìçàâîä", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
		{"Êàçèíî Âèñàäæ", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
		{"Îêåàíñêîå ïîáåðåæüå", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
		{"Ãîðà Âàéíâóä", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
		{"Íåôòÿíîé êîìïëåêñ", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
		{"Ãîðà Âàéíâóä", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
		{"Ïèëèãðèì", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
		{"ÁÊ Âàãîñ", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
		{"Äæåôôåðñîí", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
		{"Áåëûé ìîñò", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
		{"Þæíîå øîññå ËÂ", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
		{"Âîñòî÷íûé ËÑ", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
		{"Ãðèíãëàññêèé êîëëåäæ", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
		{"Ëàñ-Êîëèíàñ", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
		{"Ãîðà Âàéíâóä", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
		{"Ïîðò ËÑ", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
		{"Âîñòî÷íûé ËÑ", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
		{"Ãðóâ", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
		{"Ãîëüô-êëóá Àâèñïà", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
		{"Óèëëîóôèëä", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
		{"Ñåâåðíàÿ Ýñïëàíàäà", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
		{"Êàçèíî Øóëåð", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
		{"Ïîðò ËÑ", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
		{"Ìîòåëü Ïîñëåäíèé ãðîø", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
		{"Áýéñàéíä-Ìàðèíà", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
		{"Êèíãñ", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
		{"Ýëü-Êîðîíà", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
		{"Áëýêôèëäñêàÿ ÷àñîâíÿ", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
		{"Êàçèíî Ðîçîâûé êëþâ", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
		{"Çàïàäíîå øîññå", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
		{"Ëîñ-Ôëîðåñ", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
		{"Êàçèíî Âèñàäæ", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
		{"Ïðèêë Ïàéí", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
		{"Ïëÿæ Âåðîíà", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
		{"Ïåðåêð¸ñòîê Ðîáàäà", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
		{"Ëèíäåí-Ñàéä", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
		{"Ïîðò ËÑ", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
		{"Óèëëîóôèëä", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
		{"Êèíãñ", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
		{"Êîììåð÷åñêèé ðàéîí", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
		{"Ãîðà Âàéíâóä", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
		{"Êàíàë Ìàðèíà", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
		{"Áýòòåðè Ïîéíò", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
		{"Êàçèíî 4 Äðàêîíà", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
		{"Áëýêôèëä", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
		{"Ñåâåðíîå øîññå ËÂ", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
		{"Ãîëüô-êîðò Éåëëîóáåëë", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
		{"Àéäëâóä", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
		{"Çàïàäíûé Ðåäñàíäñ", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
		{"Àâòîøêîëà", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
		{"Âûñîêîãîðíàÿ ëåñîïèëêà", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
		{"Ëàñ-Áàððàíêàñ", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
		{"Êàçèíî Ïèðàòû", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
		{"Çàë ñóäà", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
		{"Ãîëüô-êëóá Àâèñïà", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
		{"Ñòðèï", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
		{"Õàøáåðè", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
		{"Àðåíäà àâèàòðàíñïîðòà ËÑ", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
		{"Êîìïëåêñ Óàéòâóä", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
		{"Âîäîõðàíèëèùå ËÂ", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
		{"Ýëü-Êîðîíà", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
		{"Ôîñòåðñêàÿ äîëèíà", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
		{"Ëàñ-Ïàéàñàäàñ", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
		{"Âàëëå Îêóëòàäî", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
		{"Áëýêôèëäñêèé ïåðåêð¸ñòîê", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
		{"Ãýíòîí", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
		{"ÀýðîÂîêçàë ÑÔ ÑÔ", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
		{"Âîñòî÷íûé Ðåäñàíäñ", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
		{"Âîñòî÷íàÿ Ýñïàëàíäà", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
		{"Äâîðåö Êàëèãóëû", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
		{"Êàçèíî Ðîÿëü", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
		{"Ãîðà Âàéíâóä", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
		{"Àçàðòíûé ðàéîí", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
		{"Ãîðà Âàéíâóä", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
		{"Õýíêèïýíêè ïîèíò", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
		{"Âîåííûé ñêëàä ÃÑÌ", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
		{"Øîññå Ãàððè-Ãîëä", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
		{"Òîííåëü Áýéñàéä", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
		{"Ïîðò ËÑ", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
		{"Ãîðà Âàéíâóä", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
		{"Ïðîìñêëàä Ðýíäîëüôà", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
		{"Âîñòî÷íûé ïëÿæ ËÑ", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
		{"Ïðîëèâ Ôëèíò-Óîòåð", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
		{"Áëóáåððè", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
		{"Âîêçàë ËÂ", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
		{"Ãëåí Ïàðê", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
		{"Çàïàäíûé Ðåäñàíäñ", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
		{"Ãîðà Âàéíâóä", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
		{"Ìîñò Ãàíò", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
		{"Áîëüøîé êðàòåð ËÂ", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
		{"Ïåðåñå÷åíèå Ôëèíò", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
		{"Ëàñ-Êîëèíàñ", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
		{"Æ/Ä äåïî ËÂ", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
		{"Êàçèíî Èçóìðóäíûé îñòðîâ", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
		{"Ñêàëèñòûé ìàññèâ ËÂ", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
		{"Ñàíòà-Ôëîðà", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
		{"Ñåâèëëüñêèé áóëüâàð", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
		{"Öåíòðàëüíûé Ðûíîê", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
		{"Êâèíñ", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
		{"Ïåðåñå÷åíèå Ïèëñîí", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
		{"Ñïàëüíûé ðàéîí ËÂ", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
		{"Ïèëèãðèì", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
		{"Áëýêôèëä", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
		{"Ðàäèîòåëåñêîï", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
		{"Äèëëèìîð", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
		{"Ýëü-Êåáðàäîñ", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
		{"Ñåâåðíàÿ Ýñïëàíàäà", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
		{"Àýðîïîðò ÑÔ", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
		{"Èçóìðóäíàÿ äåðåâíÿ", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
		{"ÊÏÏ ËÑ-ËÂ", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
		{"Âîñòî÷íûé ïëÿæ ËÑ", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
		{"Ïðîëèâ Ñàí-Àíäðåàñ", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
		{"Òåíèñòûå ðó÷üè", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
		{"Áîëüíèöà ËÑ", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
		{"Çàïàäíûé Ðîêøîð", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
		{"Ïðèêë Ïàéí", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
		{"Ïîðò Èñòåð Áåéçèí", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
		{"Êîíîïëÿíàÿ äîëèíà", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
		{"Ãðóçîâîé ñêëàä ËÂ", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
		{"Ïðèêë Ïàéí", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
		{"Áëóáåððè", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
		{"Ñêàëèñòûé ìàññèâ ËÂ", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
		{"Öåíòðàëüíûé ðàéîí ÑÔ", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
		{"Âîñòî÷íûé Ðîêøîð", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
		{"Çàëèâ ÑÔ", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
		{"Ïàðàäèçî", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
		{"Àçàðòíûé ðàéîí", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
		{"Ñòðèï-êëóá ËÂ", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
		{"Äæàíèïåð Õèëë", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
		{"Äæàíèïåð Õîëëîó", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
		{"Áàíêîâñêîå îòäåëåíèå ËÂ", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
		{"Âîñòî÷íîå øîññå ËÂ", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
		{"Ïëÿæ Âåðîíà", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
		{"Ôîñòåðñêàÿ äîëèíà", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
		{"Àðêî-äåëü-îåñòå", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
		{"Àâòîñàëîí ËÑ", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
		{"Çëîâåùèé äâîðåö", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
		{"Äàìáà Øåðìàíà", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
		{"Ñåâåðíàÿ Ýñïëàíàäà", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
		{"Ôèíàíñîâûé ðàéîí", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
		{"Ãàðñèÿ", -2411.220, -222.589, -1.14, 2173.040, 265.243, 200.000},
		{"Ìîíòãîìåðè", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
		{"Ò/Ö Ðó÷åé", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
		{"Àýðîïîðò ËÑ", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
		{"Ïëÿæ Ñàíòà-Ìàðèÿ", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
		{"ÊÏÏ ËÑ-ËÂ", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
		{"Ýéíäæåë-Ïàéí", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
		{"Çàáðîøåííûé àýðîäðîì", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
		{"Îêòàí-Ñïðèíãñ", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
		{"Ïèëèãðèì Êàì-ý-Ëîò", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
		{"Çàïàäíûé Ðåäñàíäñ", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
		{"Ïëÿæ Ñàíòà-Ìàðèÿ", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
		{"Çåë¸íûé óò¸ñ", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
		{"Àýðîïîðò ËÂ", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
		{"Îêðóã Ôëèíò", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
		{"Çåë¸íûé óò¸ñ", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
		{"Ïàëîìèíî Êðèê", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
		{"Âîåííàÿ áàçà ËÑ", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
		{"Àýðîïîðò ÑÔ", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
		{"Êîìïëåêñ Óàéòâóä", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
		{"Êàëòîí Õåéòñ", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
		{"Âîåííàÿ áàçà ÑÔ", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
		{"Çàëèâ ËÑ", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
		{"Äîýðòè", 2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
		{"Ãîðà ×èëèàä", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
		{"Ôîðò-Êàðñîí", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
		{"Àâòîáàçàð", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
		{"Îêåàíñêîå ïîáåðåæüå", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
		{"Ôåðí-Ðèäæ", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
		{"Áýéñàéä", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
		{"Àýðîïîðò ËÂ", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
		{"Ôåðìà Áëóáåððè", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
		{"Ïàëèñàäû", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
		{"Ñêàëà Íîðñòàð", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
		{"Êàðüåð Õàíòåð", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
		{"Àýðîïîðò ËÑ", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
		{"Ïîêëîííàÿ ãîðà", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
		{"Çàëèâ ÑÔ", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
		{"Òþðüìà ñòðîãîãî ðåæèìà", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
		{"Ãîðà ×èëèàä", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
		{"Ãîðà ×èëèàä", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
		{"Àýðîïîðò ÑÔ", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
		{"Ïàíîïòèêóì", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
		{"Òåíèñòûå ðó÷üè", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
		{"Áýê-î-Áåéîíä", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
		{"Ãîðà ×èëèàä", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
		{"Òüåððà Ðîáàäà", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
		{"Îêðóã Ôëèíò", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
		{"Ãîðà ×èëëèàä", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
		{"Ïóñòûííûé îêðóã", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
		{"Òüåððà Ðîáàäà", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
		{"Îêðóæíîñòü ÑÔ", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
		{"Îêðóæíîñòü ËÂ", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
		{"Òóìàííûé îêðóã", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
		{"Îêðóæíîñòü ËÑ", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
	}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Íåèçâåñòíî'
end
function split_text_into_lines(text, max_length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end
	if current_line ~= "" then
		table.insert(lines, current_line)
	end
	return table.concat(lines, "\n")
end
function count_lines_in_text(text, max_length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end
	if current_line ~= "" then
		table.insert(lines, current_line)
	end
	return tonumber(#lines)
end
function downloadFileFromUrlToPath(url, path)
	local function on_finish_download()
		if download_file == 'helper' then
			sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà íîâîé âåðñèè õåëïåðà óñïåøíî çàâåðøåíà! Ïåðåçàãðóçêà..',  message_color)
			reload_script = true
			thisScript():reload()
		elseif download_file == 'smart_uk' then
			sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà ñèñòåìû óìíîé âûäà÷è ðîçûñêà äëÿ ñåðâåðà ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}çàâåðøåíà óñïåøíî!',  message_color)
			sampAddChatMessage('[Radical Helper] {ffffff}Òåïåðü âû ìîæåòå èñïîëüçîâàòü êîìàíäó ' .. message_color_hex .. '/sum [ID èãðîêà]', message_color)
			MODULE.Main.Window[0] = false
			play_sound()
			load_module('smart_uk')
		elseif download_file == 'smart_pdd' then
			sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà ñèñòåìû óìíîé âûäà÷è øòðàôîâ äëÿ ñåðâåðà ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}çàâåðøåíà óñïåøíî!',  message_color)
			sampAddChatMessage('[Radical Helper] {ffffff}Òåïåðü âû ìîæåòå èñïîëüçîâàòü êîìàíäó ' .. message_color_hex .. '/tsm [ID èãðîêà]', message_color)
			MODULE.Main.Window[0] = false
			play_sound()
			load_module('smart_pdd')
		elseif download_file == 'smart_rptp' then
			sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà ñèñòåìû óìíîãî ñðîêà äëÿ ñåðâåðà ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}çàâåðøåíà óñïåøíî!',  message_color)
			sampAddChatMessage('[Radical Helper] {ffffff}Òåïåðü âû ìîæåòå èñïîëüçîâàòü êîìàíäó ' .. message_color_hex .. '/pum [ID èãðîêà]', message_color)
			MODULE.Main.Window[0] = false
			play_sound()
			load_module('smart_rptp')
		elseif download_file == 'arz_veh' then
			sampAddChatMessage('[Radical Helper] {ffffff}Çàãðóçêà âñåõ êàñòîìíûõ ò/ñ óñïåøíî çàâåðåøåíà!',  message_color)
			play_sound()
			load_module('arz_veh')
			cache_vehicles()
		elseif download_file == 'notify' then
			if doesFileExist(config_dir .. "/Resourse/notify.mp3") then
				print('Çâóê îïîâåùåíèé óñïåøíî çàãðóæåí!')
			end
		end
		download_file = ''
	end
	if IS_MOBILE then
		local function downloadToFile(url, path)
			local http = require("socket.http")
			local ltn12 = require("ltn12")
			local f, ferr = io.open(path, "wb")
			if not f then
				return false, "Íå óäàëîñü ñîçäàòü ôàéë: " .. tostring(ferr)
			end
			local ok, code, headers, status = http.request{
				method = "GET",
				url = url,
				sink = ltn12.sink.file(f)
			}
			if not ok then
				return false, "Îøèáêà çàïðîñà: " .. tostring(code)
			end
			if tonumber(code) ~= 200 then
				return false, "HTTP êîä: " .. tostring(code)
			end
			return true
		end
		local ok, err = downloadToFile(url, path)
		if ok then
			on_finish_download()
		else
			sampAddChatMessage("[Radical Helper] {ffffff}Îøèáêà çàãðóçêè ôàéëà: " .. tostring(err), message_color)
		end
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then
				on_finish_download()
			end
		end)
	end
end
function check_update()
    print('Ïðîâåðêà íà íàëè÷èå îáíîâëåíèé...')
    asyncHttpRequest(
        "GET",
        " ", --- òóò ññûëêó âñòàâèòü íà áóäóùèå îáíîâëåíèÿ!
		{timeout = 5},
        function(response)
            local ok, updateInfo = pcall(function() return decodeJson(response.text) end)
            if not ok or type(updateInfo) ~= "table" then print('Îøèáêà îáðàáîòêè Update.json') isUpdateChecked = true return end

            local isVip = thisScript().version:find('VIP')
			local uVer = isVip and updateInfo.vip_current_version or updateInfo.current_version
			local uText = isVip and updateInfo.vip_update_info or updateInfo.update_info
			local uUrl = isVip and '' or updateInfo.update_url
            if thisScript().version ~= uVer then
              	print('Äîñòóïíî îáíîâëåíèå! | Ëîêàëüíàÿ âåðñèÿ: ' ..  thisScript().version ..  ' | Â îáëàêå: ' .. tostring(uVer))
                sampAddChatMessage('[Radical Helper] {ffffff}Äîñòóïíà íîâàÿ âåðñèÿ õåëïåðà!', message_color)
                MODULE.Update.is_need_update = true
                MODULE.Update.url = uUrl
                MODULE.Update.version = uVer
                MODULE.Update.info = uText
                MODULE.Update.Window[0] = true
                play_sound()
            else
                print('Îáíîâëåíèå íå íóæíî!') isUpdateChecked = true
            end
        end,
        function(err) print('Îøèáêà ïðîâåðêè îáíîâëåíèÿ: ' .. tostring(err)) isUpdateChecked = true end
    )
end
function check_resources()
local res_dir = config_dir .. '/Resourse'
if not doesDirectoryExist(res_dir) then
print('Ñîçäàþ ïàïêó äëÿ ðåñóðñîâ õåëïåðà...')
createDirectory(res_dir)
end
if not doesFileExist(res_dir .. '/logo.png') then
print('Ïîäãðóæàþ ëîãîòèï õåëïåðà...')
download_file = 'logo'
downloadFileFromUrlToPath('https://raw.githubusercontent.com/KitsuneTamoe/radicalhelper/main/Resourse/logo.png', res_dir .. '/logo.png')
end
if not doesFileExist(res_dir .. '/notify.mp3') then
print('Ïîäãðóæàþ çâóê îïîâåùåíèé õåëïåðà...')
download_file = 'notify'
downloadFileFromUrlToPath('https://raw.githubusercontent.com/KitsuneTamoe/radicalhelper/main/Resourse/notify.mp3', res_dir .. '/notify.mp3')
end
if not doesFileExist(modules.arz_veh.path) then
print('Ïîäãðóæàþ ñïèñîê êàñòîìíûõ ò/ñ äëÿ îïðåäåëåíèÿ ìîäåëåé...')
download_file = 'arz_veh'
-- Âûáèðàåì ÌÅÆÄÓ äâóìÿ ôàéëàìè, à íå êëåèì ê Vehicles.json
downloadFileFromUrlToPath('https://raw.githubusercontent.com/KitsuneTamoe/radicalhelper/main/' ..
((tonumber(getServerNumber()) > 300) and 'Rodina.json' or 'Vehicles.json'), modules.arz_veh.path)
end
end
function import_fraction_data(mode)
	add_unique_cmd(modules.commands.data.commands.my, get_fraction_cmds(mode, false))
	add_unique_cmd(modules.commands.data.commands_manage.my, get_fraction_cmds(mode, true))
	add_default_notes(mode)
	import_data_from_old_helpers()
	save_module('commands')
	save_module('notes')
	modules.piemenu.data = get_fraction_pie(mode)
	save_module('piemenu')
end
function get_fraction_pie(mode)
	local default = {
		{
			name = 'Âðåìÿ',
			icon = 'CLOCK',
			action = '/time'
		},
		{
			name = 'Àíèìêà',
			icon = 'TOILET',
			action = '/piss'
		},
		{
			name = 'Ò/Ñ',
			icon = 'CAR',
			next = {
				{
					name = 'Ðåìêà',
					icon = '',
					action = '/repcar'
				},
				{
					name = 'Êàíèñòðà',
					icon = '',
					action = '/fillcar'
				}
			}
		},
		{
			name = 'Îðóæèå',
			icon = 'GUN',
			action = '/gun'
		}
	}
	local police = {
		{
			name = 'Êðè÷àëêà',
			icon = 'VOLUME_HIGH',
			action = '/ss'
		},
		{
			name = 'Ìèðàíäà',
			icon = '',
			action = '/mr'
		},
		{
			name = 'Òðàôôèê ñòîï',
			icon = 'BULLHORN',
			next = {
				{
					name = '10-55',
					icon = '',
					action = '/55'
				},
				{
					name = '10-66',
					icon = '',
					action = '/66'
				}
			}
		},
		{
			name = 'Òàéçåð',
			icon = 'GUN',
			action = '/t'
		}
	}
	return (mode == 'police' or mode == 'fbi') and police or default
end
function get_fraction_cmds(selected, is_manage)
    local cmds = {
		{cmd = 'time', description = 'Ïîñìîòðåòü âðåìÿ',  text = '/me âçãëÿíóë{sex} íà ñâîè ÷àñû ñ ãðàâèðîâêîé Bogati papochka!&/time&/do Íà ÷àñàõ âèäíî âðåìÿ {get_time}.', arg = '', enable = true, waiting = '2', bind = "{}"},
		{cmd = 'cure', description = 'Ïîäíÿòü èãðîêà èç ñòàäèè',  text = '/me íàêëîíÿåòñÿ íàä ÷åëîâåêîì, è ïðîùóïûâàåò åãî ïóëüñ íà ñîííîé àðòåðèè&/cure {id}&/do Ïóëüñ îòñóòñòâóåò.&/me íà÷èíàåò äåëàòü ÷åëîâåêó íåïðÿìîé ìàññàæ ñåðäöà, âðåìÿ îò âðåìåíè ïðîâåðÿÿ ïóëüñ&/do Ñïóñòÿ íåñêîëüêî ìèíóò ñåðäöå ÷åëîâåêà íà÷àëî áèòüñÿ.&/do ×åëîâåê ïðèøåë â ñîçíàíèå.&/todo Îòëè÷íî*óëûáàÿñü', arg = '{id}', enable = true, waiting = '2', bind = "{}"}
	}
    local function append_commands(from_table)
        for _, cmd in ipairs(from_table) do
			table.insert(cmds, cmd)
		end
    end
	if is_manage then
		if selected == 'mafia' then
			append_commands(modules.commands.data.commands_manage.mafia)
		elseif selected == 'ghetto' then
			append_commands(modules.commands.data.commands_manage.ghetto)
		else
			append_commands(modules.commands.data.commands_manage.goss)
			if selected == 'fbi' then
				append_commands(modules.commands.data.commands_manage.goss_fbi)
			elseif selected == 'prison' then
				append_commands(modules.commands.data.commands_manage.goss_prison)
			elseif selected == 'gov' then
				append_commands(modules.commands.data.commands_manage.goss_gov)
			end
		end
	else
		if selected == 'police' then
			append_commands(modules.commands.data.commands.police)
		elseif selected == 'fbi' then
			append_commands(modules.commands.data.commands.police)
			append_commands(modules.commands.data.commands.fbi)
			append_commands(modules.commands.data.commands.mafia)
			for index, value in ipairs(cmds) do
				if value.cmd == 'lead' or value.cmd == 'unlead' then
					table.remove(cmds, index)
					break
				end
			end
		elseif selected == 'hospital' then
			append_commands(modules.commands.data.commands.hospital)
			if tonumber(getServerNumber()) > 300 then -- óäàëåíèå íåíóæíûõ êîìàíäû äëÿ ðîäèíû ðï
				for index, value in ipairs(cmds) do
					if value.cmd == 'hla' or value.cmd == 'hlb' or value.cmd == 'ant' or value.cmd == 'pilot' or value.cmd == 'medin' or value.cmd == 'mt' then
						table.remove(cmds, index)
						break
					end
				end
			end
		elseif selected == 'smi' then
			append_commands(modules.commands.data.commands.smi)
		elseif selected == 'army' then
			append_commands(modules.commands.data.commands.army)
		elseif selected == 'prison' then
			append_commands(modules.commands.data.commands.prison)
			append_commands(modules.commands.data.commands.army)
		elseif selected == 'lc' then
			append_commands(modules.commands.data.commands.lc)
		elseif selected == 'gov' then
			append_commands(modules.commands.data.commands.gov)
		elseif selected == 'ins' then
			append_commands(modules.commands.data.commands.ins)
		elseif selected == 'fd' then
			append_commands(modules.commands.data.commands.fd)
		elseif selected == 'mafia' then
			append_commands(modules.commands.data.commands.mafia)
		elseif selected == 'ghetto' then
			append_commands(modules.commands.data.commands.ghetto)
		end
	end
    return cmds
end
function delete_default_fraction_cmds(my_cmds, default_cmds)
	for i = #my_cmds, 1, -1 do
		for _, def in ipairs(default_cmds) do
			if my_cmds[i].cmd == def.cmd then
				table.remove(my_cmds, i)
				break
			end
		end
	end
end
function add_unique_cmd(tbl, cmds)
	for _, cmd in ipairs(cmds) do
		local exists = false
		for _, v in ipairs(tbl) do
			if v.cmd == cmd.cmd then exists = true break end
		end
		if not exists then table.insert(tbl, cmd) end
	end
end
function add_unique_note(tbl, note)
	for _, v in ipairs(tbl) do
		if v.note_name == note.note_name then
			return
		end
	end
	table.insert(tbl, note)
end
function add_default_notes(module)
	if not module == 'none' then
		local money = {
			note_name = 'Çàðïëàòà â ôðàêöèè',
			note_text = 'Ïî÷åìó âàøà çàðïëàòà ìîæåò áûòü ìåíüøå, ÷åì óêàçàíî:&-20 ïðîöåíòîâ åñëè íåòó æèëüÿ (äîì/îòåëü/òðåéëåð)&-20/-40 ïðîöåíòîâ åñëè ó âàñ åñòü âûãîâîðû&-10 ïðîöåíòîâ èç-çà ôèêñà ýêîíîìèêè îò ðàçðàáîâ&&Ñïîñîáû ïîâûñèòü ñâîþ çàðïëàòó âî ôðàêöèè:&+10 ïðîöåíòîâ åñëè àðåíäîâàòü íîìåð â îòåëå&+7 ïðîöåíòîâ åñëè âñòóïèòü â ñåìüþ ñ ôàì.ôëàãîì&+15 ïðîöåíòîâ åñëè åñòü \"Âîåííûé áèëåò\"&+11 ïðîöåíòîâ åñëè åñòü \"Ãðàìîòà Âåòåðàíà\"&+3 ïðîöåíòà åñëè åñòü àêñ \"Îðàíæåâàÿ ìàãè÷åñêàÿ øëÿïà\"&+10/+15/+20/+25/+26/+30/+35 ïðîöåíòîâ åñëè êóïèòü îõðàííèêà&- Ïîâûøàéòåñü íà ðàíã ïîâûøå :)'
		}
		add_unique_note(modules.notes.data, money)
	end
	if module == 'police' or module == 'fbi' or module == 'prison' or module == 'army' then
		local situate_codes = {
			note_name = 'Ñèòóàöèîííûå êîäû',
			note_text = 'CODE 0 - Îôèöåð ðàíåí.&CODE 1 - Îôèöåð â áåäñòâåííîì ïîëîæåíèè, íóæíà ïîìîùü âñåõ þíèòîâ.&CODE 2 - Îáû÷íûé âûçîâ [áåç ñèðåí/ñòðîáîñêîïîâ/ñîáëþäåíèå ÏÄÄ].&CODE 2 HIGHT - Ïðèîðèòåòíûé âûçîâ [áåç ñèðåí/ñòðîáîñêîïîâ/ñîáëþäåíèå ÏÄÄ].&CODE 3 - Ñðî÷íûé âûçîâ [ñèðåíû, ñòðîáîñêîïû, èãíîðèðîâàíèÿ ÏÄÄ].&CODE 4 - Ñòàáèëüíî, ïîìîùü íå òðåáóåòñÿ.&Code 4 ADAM - Ïîìîùü íå òðåáóåòñÿ, íî îôèöåðû ïîáëèçîñòè äîëæíû áûòü ãîòîâû îêàçàòü ïîìîùü.&CODE 5 - Îôèöåðàì äåðæàòüñÿ ïîäàëüøå îò îïàñíîãî ìåñòà.&CODE 6 - Çàäåðæèâàþñü íà ìåñòå [âêëþ÷àÿ ëîêàöèþ è ïðè÷èíó,íàïðèìåð, 911].&CODE 7 - Ïåðåðûâ íà îáåä.&CODE 30 - Ñðàáàòûâàíèå "òèõîé" ñèãíàëèçàöèè íà ìåñòå ïðîèñøåñòâèÿ.&CODE 30 RINGER - Ñðàáàòûâàíèå "ãðîìêîé ñèãíàëèçàöèè íà ìåñòå ïðîèñøåñòâèÿ.&CODE 37 - Îáíàðóæåíèå óãíàííîãî ò/c.&Ñode TOM - Îôèöåðó òðåáóåòñÿ Òàéçåð.'
		}
		local teen_codes = {
			note_name = 'Òåí-êîäû',
			note_text = '10-1 - Ñáîð âñåõ îôèöåðîâ íà äåæóðñòâå.&10-2 - Âûøåë â ïàòðóëü.&10-2R - Çàêîí÷èë ïàòðóëü.&10-3 - Ðàäèîìîë÷àíèå.&10-4 - Ïðèíÿòî.&10-5 - Ïîâòîðèòå.&10-6 - Íå ïðèíÿòî/íåâåðíî/íåò.&10-7 - Îæèäàéòå.&10-8 - Íå äîñòóïåí/çàíÿò.&10-14 - Çàïðîñ òðàíñïîðòèðîâêè.&10-15 - Ïîäîçðåâàåìûå àðåñòîâàíû.&10-18 - Òðåáóåòñÿ ïîääåðæêà äîïîëíèòåëüíûõ þíèòîâ.&10-20 - Ëîêàöèÿ.&10-21 - Ñòàòóñ è ìåñòîíàõîæäåíèå.&10-22 - Âûäâèãàéòåñü ê ëîêàöèè.&10-27 - Ìåíÿþ ìàðêèðîâêó ïàòðóëÿ.&10-30 - Äîðîæíî-òðàíñïîðòíîå ïðîèñøåñòâèå.&10-40 - Áîëüøîå ñêîïëåíèå ëþäåé (áîëåå 4).&10-41 - Íåëåãàëüíàÿ àêòèâíîñòü.&10-46 - Ïðîâîæó îáûñê.&10-55 - Òðàôôèê ñòîï.&10-57 VICTOR - Ïîãîíÿ çà àâòîìîáèëåì.&10-57 FOXTROT - Ïåøàÿ ïîãîíÿ.&10-66 - Òðàôôèê ñòîï ïîâûøåííîãî ðèñêà.&10-70 - Çàïðîñ ïîääåðæêè.&10-71 - Çàïðîñ ìåäèöèíñêîé ïîääåðæêè.&10-88 - Òåðàêò/×Ñ.&10-99 - Ñèòóàöèÿ óðåãóëèðîâàíà.&10-100 Âðåìåííî íåäîñòóïåí äëÿ âûçîâîâ.'
		}
		add_unique_note(modules.notes.data, situate_codes)
		add_unique_note(modules.notes.data, teen_codes)
	end
	if module == 'police' or module == 'fbi' then
		local markup_patrool = { note_name = 'Ìàðêèðîâêè ïàòðóëÿ', note_text = 'Îñíîâíûå:&ADAM [A] - Ïàòðóëü èç 2/3 îôèöåðîâ íà êðóçåðå.&LINCOLN [L] - Îäèíî÷íûé ïàòðóëü íà êðóçåðå.&MARY [M] - Îäèíî÷íûé ïàòðóëü íà ìîòîöèêëå.&KING [K] - Ïàòðóëü SWAT (PLATOON-D) íà ëþáîì ñëóæåáíîì ò/ñ, âêëþ÷àÿ áðîíåòåõíèêó.&HENRY [H] - Âûñîêîñêîðîñòîé ïàòðóëü.&AIR [AIR] - Âîçäóøíûé ïàòðóëü.&Air Support Division [ASD] - Âîçäóøíàÿ ïîääåðæêà.&&Äîïîëíèòåëüíûå:&CHARLIE [C] - Ãðóïïà çàõâàòà.&ROBERT [R] - Îòäåë Äåòåêòèâîâ.&SUPERVISOR [SV] - Ðóêîâîäÿùèé ñîñòàâ.&DAVID [D] - Cïåöèàëüíûé îòäåë SWAT.&EDWARD [E] - Ýâàêóàòîð ïîëèöèè.&NORA [N] - íåìàðêèðîâàííàÿ åäèíèöà ïàòðóëÿ.'}
		add_unique_note(modules.notes.data, markup_patrool)
	end
	save_module('notes')
end
function import_data_from_old_helpers()	
	local base = getWorkingDirectory():gsub("\\", "/")
	local function readJsonSafe(p)
		if not doesFileExist(p) then return nil end
		local f = io.open(p, "r")
		if not f then return nil end
		local ok, data = pcall(decodeJson, f:read("*a"))
		f:close()
		return ok and data or nil
	end
	local function migrate_command_args(c)
		local hasArgId = c.arg:find("{arg_id}", 1, true)
		local hasArg2 = c.arg:find("{arg2}", 1, true)
		local hasArg3 = c.arg:find("{arg3}", 1, true)
		if hasArg2 and hasArg3 then
			c.arg = c.arg:gsub("{arg_id}", "{id}"):gsub("{arg2}", "{number}"):gsub("{arg3}", "{arg}")
			c.text = c.text:gsub("{arg_id}", "{id}"):gsub("{arg2}", "{number}"):gsub("{arg3}", "{arg}")
		elseif hasArg2 and not hasArg3 then
			c.arg = c.arg:gsub("{arg_id}", "{id}"):gsub("{arg2}", "{arg}")
			c.text = c.text:gsub("{arg_id}", "{id}"):gsub("{arg2}", "{arg}")
		elseif hasArgId then
			c.arg = c.arg:gsub("{arg_id}", "{id}")
			c.text = c.text:gsub("{arg_id}", "{id}")
		end
		return c
	end
	local function import_settings(folder)
		local settingsPath = base .. "/" .. folder .. "/Settings.json"
		if not doesFileExist(settingsPath) then return end
		local data = readJsonSafe(settingsPath)
		if not data then return end
		if data.note then
			for _, n in ipairs(data.note) do
				if not n.deleted then add_unique_note(n) end
			end
		end
		if data.commands then
			for _, c in ipairs(data.commands) do
				if not c.deleted then
					add_unique_cmd(modules.commands.data.commands.my, {migrate_command_args(c)})
				end
			end
		end
		if data.commands_manage then
			for _, c in ipairs(data.commands_manage) do
				if not c.deleted then
					migrate_command_args(c)
					add_unique_cmd(modules.commands.data.commands_manage.my, {migrate_command_args(c)})
				end
			end
		end
		sampAddChatMessage('[Radical Helper] {ffffff}Èìïîðò âàøèõ êîìàíä (áèíäîâ) è çàìåòîê èç ' .. message_color_hex .. folder .. '{ffffff} óñïåøíî çàâåðøåí!', message_color)
		os.remove(settingsPath)
	end
	import_settings("SMI Helper")
	import_settings("Hospital Helper")
	import_settings("AS Helper")
	local function import_split(folder)
		local notesPath = base .. "/" .. folder .. "/Notes.json"
		if doesFileExist(notesPath) then 
			local n = readJsonSafe(notesPath)
			if n and n.note then
				for _, note in ipairs(n.note) do
					if not note.deleted then add_unique_note(note) end
				end
				sampAddChatMessage('[Radical Helper] {ffffff}Èìïîðò âàøèõ çàìåòîê èç ' .. message_color_hex .. folder .. ' Helper {ffffff} óñïåøíî çàâåðøåí!', message_color)
				os.remove(notesPath)
			end
		end
		local cmdsPath = base .. "/" .. folder .. "/Commands.json"
		if doesFileExist(cmdsPath) then 
			local c = readJsonSafe(cmdsPath)
			if c then
				if c.commands then
					for _, cmd in ipairs(c.commands) do
						if not cmd.deleted then
							add_unique_cmd(modules.commands.data.commands.my, {migrate_command_args(cmd)})
						end
					end
				end
				if c.commands_manage then
					for _, cmd in ipairs(c.commands_manage) do
						if not cmd.deleted then
							add_unique_cmd(modules.commands.data.commands_manage.my, {migrate_command_args(cmd)})
						end
					end
				end
				sampAddChatMessage('[Radical Helper] {ffffff}Èìïîðò âàøèõ êîìàíä (áèíäîâ) èç ' .. message_color_hex .. folder .. ' Helper {ffffff} óñïåøíî çàâåðøåí!', message_color)
				os.remove(cmdsPath)
			end
		end
	end
	for _, helpers in ipairs({"Mafia", "FD", "Prison", "GOV", "Government", "Justice"}) do
		import_split(helpers .. " Helper")
	end
	local function safeMove(folder, file, target)
		local p = base .. "/" .. folder .. "/" .. file
		if readJsonSafe(p) then 
			os.rename(p, target)
			sampAddChatMessage('[Radical Helper] {ffffff}Èìïîðò "' .. file .. '" èç ' .. message_color_hex .. folder .. '{ffffff} óñïåøíî çàâåðøåí!', message_color)
		end
	end
	safeMove("SMI Helper", "Ads.json", modules.ads_history.path)
	safeMove("Justice Helper", "SmartUK.json", modules.smart_uk.path)
	safeMove("Justice Helper", "SmartPDD.json", modules.smart_pdd.path)
	safeMove("Prison Helper", "SmartRPTP.json", modules.smart_rptp.path)
end
function delete_old_helpers()
	local current_path = thisScript().path:gsub('\\','/')
    local correct_path = worked_dir .. "/Radical Helper.lua"
	if current_path ~= correct_path then
		sampAddChatMessage('[Radical Helper] {ffffff}Èñïðàâëÿþ íàçâàíèå ôàéëà õåëïåðà äëÿ êîððåêòíîé ðàáîòû îáíîâëåíèé...', message_color)
        if doesFileExist(correct_path) then os.remove(correct_path) end
        os.rename(current_path, correct_path)
    end

	local old_helpers = {"Justice", "Hospital", "SMI", "AS", "FD", "GOV", "Government", "Mafia", "Prison"}
	for _, name in ipairs(old_helpers) do
        local file1 = worked_dir .. "/" .. name .. " Helper.lua"
        local file2 = worked_dir .. "/" .. name .. "_Helper.lua"
        if doesFileExist(file1) then os.remove(file1) end
        if doesFileExist(file2) then os.remove(file2) end
    end
end
function delete_helper_data(checker)
	os.remove(config_dir .. "/Settings.json")
	os.remove(config_dir .. "/Player.json")
	os.remove(config_dir .. "/Commands.json")
	os.remove(config_dir .. "/Buttons.json")
	os.remove(config_dir .. "/Departament.json")
	os.remove(config_dir .. "/PieMenu.json")
	os.remove(config_dir .. "/Notes.json")
	os.remove(config_dir .. "/Vehicles.json")
	os.remove(config_dir .. "/Guns.json")
	os.remove(config_dir .. "/Ads.json")
	os.remove(config_dir .. "/Update.json")
	os.remove(config_dir .. "/SmartUK.json")
	os.remove(config_dir .. "/SmartPDD.json")
	os.remove(config_dir .. "/SmartRPTP.json")
	if checker then
		os.remove(config_dir .. "/Resourse/notify.mp3")
		os.remove(config_dir .. "/Resourse/logo.png")
		os.remove(thisScript().path)
		sampAddChatMessage('[Radical Helper] {ffffff}Õåëïåð ïîëíîñòüþ óäàë¸í èç âàøåãî óñòðîéñòâà!', message_color)
		reload_script = true
		thisScript():unload()
	else
		sampAddChatMessage('[Radical Helper] {ffffff}Ïåðåçàãðóçêà õåëïåðà...', message_color)
		reload_script = true
		thisScript():reload()
	end
end
if isMode('police') or isMode('fbi') then
	function form_su(name, playerID, message)
		local lvl, id, reason = message:match('Ïðîøó îáüÿâèòü â ðîçûñê (%d) ñòåïåíè äåëî N(%d+)%. Ïðè÷èíà%: (.+)')
		local rank = (isMode('fbi') and 4 or 5)
		if (modules.player.data.fraction_rank_number >= rank) then
			MODULE.SumMenu.form_su = id .. ' ' .. lvl .. ' ' .. reason
			sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/givefsu ' .. playerID .. '{ffffff} ÷òîáû âûäàòü ðîçûñê ïî çàïðîñó îôèöåðà ' .. message_color_hex .. name, message_color)
			play_sound()
		else
			sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Äëÿ âûäà÷è ðîçûñêà ïî çàïðîñó íóæíî èìåòü ' .. rank .. '-é ðàíã, íî âû òîëüêî ' .. modules.player.data.fraction_rank_number .. '-é ðàíã :(', message_color)
		end
	end
end
if isMode('hospital') then
	function heal_handler(nick, id, message)
		if (nick and id and message and tonumber(id) ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
			local function check_end_time()
				lua_thread.create(function()
					wait(5000)
					if MODULE.HealChat.bool then
						MODULE.HealChat.Window[0] = false
						MODULE.HealChat.bool = false
						sampAddChatMessage('[Radical Helper] {ffffff}Âû íå óñïåëè âûëå÷èòü èãðîêà ' .. sampGetPlayerNickname(id), message_color)
					end
				end)
			end
			for hello_bro, keyword in ipairs(MODULE.HealChat.worlds) do
				if (message:rupper():find(keyword:rupper())) then
					if IS_MOBILE then
						sampAddChatMessage('[Radical Helper] {ffffff}×òîá âûëå÷èòü èãðîêà ' .. sampGetPlayerNickname(id) .. ', â òå÷åíèè 5-òè ñåêóíä íàæìèòå êíîïêó', message_color)
						MODULE.HealChat.player_id = id
						MODULE.HealChat.bool = true
						MODULE.HealChat.Window[0] = true
						check_end_time()
					elseif hotkey_no_errors then
						sampAddChatMessage('[Radical Helper] {ffffff}×òîáû âûëå÷èòü èãðîêà ' .. sampGetPlayerNickname(id) .. ' íàæìèòå ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_action) .. ' {ffffff}â òå÷åíèè 5-òè ñåêóíä!', message_color)
						show_notify('info', 'Radical Helper', 'Íàæìèòå ' .. getNameKeysFrom(settings.general.bind_action) .. ' ÷òîáû áûñòðî âûëå÷èòü èãðîêà', 5000)
						MODULE.HealChat.player_id = id
						MODULE.HealChat.bool = true
						check_end_time()
					end
					return
				end
			end
		end
	end
end
if isMode('fd') then
	function getFireLocation(id)
		count = 0
		for line in MODULE.Fires.locations:gmatch('.-\n') do
			if id == count then
				local line2 = line:match('%].+%](.+){.+{.+{'):gsub("^%s+", ""):gsub("%s+$", "")
				MODULE.Fires.location = line2 or 'ïîæàð'
				if MODULE.Fires.lvl == -1 then
					if line:find('%*%*%*') then
						MODULE.Fires.lvl = 3
					elseif line:find('%*%*') then
						MODULE.Fires.lvl = 2
					elseif line:find('%*') then
						MODULE.Fires.lvl = 1
					end
				end
				if settings.fd.doklads.togo then
					sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', âûåõàë' .. MODULE.Binder.tag.sex() .. ' íà ' .. MODULE.Fires.location .. ' ' .. MODULE.Fires.lvl .. ' ñòåïåíè îïàñíîñòè')
				end
				return
			else
				count = count + 1
			end
		end
	end
end
if isMode('smi') then
	function try_send_ad(text)
		if text == '' then
			sampAddChatMessage('[Radical Helper] {ffffff}Íåëüçÿ îòïðàâèòü ïóñòîå îáüÿâëåíèå!', message_color)
			play_sound()
			return false
		end
		if text == MODULE.SmiEdit.last_ad_text then
			MODULE.SmiEdit.ad_repeat_count = MODULE.SmiEdit.ad_repeat_count + 1
		else
			MODULE.SmiEdit.ad_repeat_count = 0
			MODULE.SmiEdit.last_ad_text = text
		end
		if MODULE.SmiEdit.ad_repeat_count >= 51 then
			sampAddChatMessage('[Radical Helper] {ffffff}Íå óäàëîñü îòïðàâèòü îáüÿâó, ó âàñ ñëèøêîì ìíîãî ñïåö.ñèìâîëîâ (öèôðû/òî÷êè/êàâû÷êè)!', message_color)
			play_sound()
			MODULE.SmiEdit.last_ad_text = ''
			MODULE.SmiEdit.ad_repeat_count = 0
			if modules.ads_history.data then
				if settings.smi.ads_history then
					for index, ad in ipairs(modules.ads_history.data) do
						if ad and ad.text and ad.text == MODULE.SmiEdit.ad_message then
							ad.text = ad.my_text
							save_module('ads_history')
							break
						end
					end
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ñëîìàëñÿ ôàéë ' .. modules.ads_history.path, message_color)
				sampAddChatMessage('[Radical Helper] {ffffff}Óäàëèòå åãî, ëèáî åñëè øàðèòå, òî íàéäèòå îøèáêó è èñïðàâüòå (ôàéë â êîäèðîâêå 1251)', message_color)
				play_sound()
			end
			return false
		end
		MODULE.SmiEdit.is_active_ad = false
		sampSendDialogResponse(MODULE.SmiEdit.ad_dialog_id, 1, 0, text)
		imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
		return true
	end
end
--------------------------------------------- Events ---------------------------------------------
function emulationCEF(str)
	-- by wojciech?
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 220)
	raknetBitStreamWriteInt8(bs, 18)
	raknetBitStreamWriteInt16(bs, #str)
	raknetBitStreamWriteString(bs, str)
	raknetBitStreamWriteInt32(bs, 0)
	raknetSendBitStream(bs)
	raknetDeleteBitStream(bs)
end
function visualCEF(str, is_encoded)
	-- by wojciech?
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 17)
	raknetBitStreamWriteInt32(bs, 0)
	raknetBitStreamWriteInt16(bs, #str)
	raknetBitStreamWriteInt8(bs, is_encoded and 1 or 0)
	if is_encoded then
		raknetBitStreamEncodeString(bs, str)
	else
		raknetBitStreamWriteString(bs, str)
	end
	raknetEmulPacketReceiveBitStream(220, bs)
	raknetDeleteBitStream(bs)
end
function show_notify(type, title, text, time)
	if IS_MOBILE then
		--[[
		if type == 'info' then
			type = 3
		elseif type == 'error' then
			type = 2
		elseif type == 'success' then
			type = 1
		end
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, 62)
		raknetBitStreamWriteInt8(bs, 6)
		raknetBitStreamWriteBool(bs, true)
		raknetEmulPacketReceiveBitStream(220, bs)
		raknetDeleteBitStream(bs)
		local json = encodeJson({
			styleInt = type,
			title = title,
			text = text,
			duration = time
		})
		local interfaceid = 6
		local subid = 0
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, 84)
		raknetBitStreamWriteInt8(bs, interfaceid)
		raknetBitStreamWriteInt8(bs, subid)
		raknetBitStreamWriteInt32(bs, #json)
		raknetBitStreamWriteString(bs, json)
		raknetEmulPacketReceiveBitStream(220, bs)
		raknetDeleteBitStream(bs)
		]]
	else
		local function escape_js(s)
			return s:gsub("\\", "\\\\"):gsub('"', '\\"')
		end
		local safe_type = escape_js(type)
		local safe_title = escape_js(title)
		local safe_text = escape_js(text)
		local safe_time = tostring(time)
		local str = ('window.executeEvent("event.notify.initialize", "[\\"%s\\", \\"%s\\", \\"%s\\", \\"%s\\"]");'):format(safe_type, safe_title, safe_text, safe_time)
		visualCEF(str, true)
	end
end
function sampev.onShowTextDraw(id, data)
	if MODULE.DEBUG then
		sampAddChatMessage('[ShowTextDraw] {ffffff}ID ' .. id .. " | Text " .. data.text .. ' | ModelID ' .. data.modelId .. " |", message_color)
		print("[ShowTextDraw] ID " .. id .. " | Text " .. data.text .. ' | ModelID ' .. data.modelId .. " |")
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Radical Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Sport!', message_color)
		return false
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Radical Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Comfort!', message_color)
		return false
	end
end
function sampev.onSendClickTextDraw(textdrawId)
	if MODULE.DEBUG then
		sampAddChatMessage('[ClickTextDraw] {ffffff}ID ' .. textdrawId, message_color)
		print('[ClickTextDraw] ID ' .. textdrawId)
	end
end
--[[function sampev.onSendTakeDamage(playerId,damage,weapon)
	if MODULE.DEBUG then
		sampAddChatMessage('[TakeDamage] {ffffff}ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon, message_color)
		print('[TakeDamage] ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon)
	end
	if playerId ~= 65535 then
		playerId2 = playerId1
		playerId1 = playerId
		if isParamSampID(playerId) and playerId1 ~= playerId2 and tonumber(playerId) ~= 0 and weapon then
			local weapon_name = get_name_weapon(weapon)
			if weapon_name then
				sampAddChatMessage('[Radical Helper] {ffffff}Èãðîê ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '] íàïàë íà âàñ èñïîëüçóÿ ' .. weapon_name .. '['.. weapon .. ']!', message_color)
				if isMode('police') or isMode('fbi') or isMode('army') or isMode('prison') then
					if ((MODULE.Patrool.Window[0]) and (MODULE.Patrool.ComboCode[0] ~= 1)) then
						sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Âàø ñèòóàöèîííûé êîä èçìåí¸í íà CODE 0.', message_color)
						MODULE.Patrool.ComboCode[0] = 1
						MODULE.Patrool.code = 'CODE 0'
					end
					if ((MODULE.Post.Window[0]) and (MODULE.Post.ComboCode[0] ~= 1)) then
						sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Âàø ñèòóàöèîííûé êîä èçìåí¸í íà CODE 0.', message_color)
						MODULE.Post.ComboCode[0] = 1
						MODULE.Post.code = 'CODE 0'
					end
					if ((isMode('police') or isMode('fbi')) and settings.mj.auto_doklad_damage) or (((isMode('army') or isMode('prison')) and settings.md.auto_doklad_damage)) then
						if not MODULE.Binder.state.isActive then
							lua_thread.create(function()
								MODULE.Binder.state.isActive = true
								sampSendChat('/r ' .. MODULE.Binder.tag.my_doklad_nick() .. ' íà CONTROL. ' .. (weapon ~= 0 and 'Íàõîæóñü ïîä îãí¸ì' or 'Íà ìåíÿ íàïàëè') .. ' â ðàéîíå ' .. MODULE.Binder.tag.get_area() .. ' (' .. MODULE.Binder.tag.get_square() .. '), ñîñòîÿíèå CODE 0!')
								wait(2000)
								sampSendChat('/rb Íàïàäàþùèé: ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '], îí(-à) èñïîëüçóåò ' .. weapon_name .. '!')
								MODULE.Binder.state.isActive = false
							end)
						end
					end
				end
			end
		end
	end
end]]
function sampev.onSendGiveDamage(playerId, damage, weapon, bodypart)
	if MODULE.DEBUG then
		sampAddChatMessage('[GiveDamage] {ffffff}ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon .. " | Body " .. bodypart, message_color)
		print('[GiveDamage] ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon .. " | Body " .. bodypart)
	end
	if playerId ~= 65535 then
		if (sampGetPlayerNickname(playerId) == 'Maitreya_Hesoyam' and getServerNumber() == '20') or sampGetPlayerNickname(playerId):find('%[20%]Maitreya_Hesoyam') then
			sampAddChatMessage('[Radical Helper] {ffffff}Maitreya_Hesoyam - ýòî ðàçðàáîò÷èê Radical Helper!', message_color)
			sampAddChatMessage('[Radical Helper] {ffffff}Íå íóæíî íàíîñèòü óðîí ðàçðàáîò÷èêó õåëïåðà, ÀÑÒÀÍÀÂÈÒÅÑÜ :sob: :sob: :sob:', message_color)
			play_sound()
		end
	end
end
function sampev.onServerMessage(color, text)
	if MODULE.DEBUG then
		sampAddChatMessage('[ServerMessage] {ffffff}Color ' .. color .. " | Text " .. text, message_color)
		print('[ServerMessage] Color ' .. color .. " | Text " .. text)
	end

	if IS_MOBILE then -- ôèêñ ïîëó÷åíèÿ ID èãðîêà íà ìîáàéëå
		if text:find('{DFCFCF}[Ïîäñêàçêà] {DC4747}Âû ìîæåòå çàäàòü âîïðîñ â íàøó òåõíè÷åñêóþ ïîääåðæêó /report', 1, true) and modules.player.data.nick ~= '' then
			CHECK_ID = true
			sampSendChat('/id ' .. modules.player.data.nick)
		end
		if CHECK_ID and text:find('^%[(%d+)%]') then 
			MODULE.MOBILE_PLAYER_ID = text:match('^%[(%d+)%]')
			CHECK_ID = false
		end
	end

	if settings.general.ping and MODULE.Binder.tag.my_nick() ~= '' and text:find('@' .. MODULE.Binder.tag.my_nick(), 1, true) then
		sampAddChatMessage('[Radical Helper] {ffffff}Êòî-òî óïîìÿíóë âàñ â ÷àòå!', message_color)
		play_sound()
	end

	if modules.player.data.fraction_rank_number >= 9 then
		if settings.general.auto_uninvite then
			local function auto_uninvite_handler(tag, name, playerID, message)
				if not message:find("îòïðàâüòå (.+) +++ ÷òîáû óâîëèòñÿ ÏÑÆ!") and not message:find("Ñîòðóäíèê (.+) áûë óâîëåí ïî ïðè÷èíå") and message:rupper():find("ÏÑÆ") or message:rupper():find("ÓÂÎËÜÒÅ") or message:rupper():find("ÓÂÀË") then
					MODULE.LeadTools.auto_uninvite.msg3 = MODULE.LeadTools.auto_uninvite.msg2
					MODULE.LeadTools.auto_uninvite.msg2 = MODULE.LeadTools.auto_uninvite.msg1
					MODULE.LeadTools.auto_uninvite.msg1 = text
					MODULE.LeadTools.auto_uninvite.player_id = playerID
					if MODULE.LeadTools.auto_uninvite.msg3 == text then
						MODULE.LeadTools.auto_uninvite.checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 ÏÑÆ')
					elseif tag == "R" then
						sampSendChat("/rb " .. name .. "[" .. playerID .. "], îòïðàâüòå /rb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					elseif tag == "F" then
						sampSendChat("/fb " .. name .. "[" .. playerID .. "], îòïðàâüòå /fb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					end
				elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (MODULE.LeadTools.auto_uninvite.player_id == playerID)) then
					MODULE.LeadTools.checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 ÏÑÆ')
				end
			end
			if text:find("^%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb /r /rb áåç òåãà 
				local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				auto_uninvite_handler(tag, name, playerID, message)
			elseif text:find("^%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r /f ñ òåãîì
				local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				auto_uninvite_handler(tag, name, playerID, message)
			elseif text:find("(.+) çàãëóøèë%(à%) èãðîêà (.+) íà 1 ìèíóò. Ïðè÷èíà: ÏÑÆ") and MODULE.LeadTools.checker then
				local text2 = text:gsub('{......}', '')
				local DATA = text2:match("(.+) çàãëóøèë")
				local Name = DATA:match(" ([A-Za-z0-9_]+)%[")
				local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
				if Name == MyName then
					sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Óâîëüíÿþ èãðîêà ' .. sampGetPlayerNickname(MODULE.LeadTools.auto_uninvite.player_id) .. '!', message_color)
					MODULE.LeadTools.checker = false
					find_and_use_command("/uninvite {id} {arg}", (MODULE.LeadTools.auto_uninvite.player_id .. ' ÏÑÆ'))
				else
					sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Äðóãîé çàìåñòèòåëü/ëèäåð óæå óâîëüíÿåò èãðîêà ' .. sampGetPlayerNickname(MODULE.LeadTools.auto_uninvite.player_id) .. '!', message_color)
					MODULE.LeadTools.checker = false
				end
			end
		end
		
	end

	if settings.general.auto_accept_docs and text:find('^%[Íîâîå ïðåäëîæåíèå%].+offer') then
		sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Îòêðûâàþ ñïèñîê ïðåäëîæåíèé îò èãðîêà...', message_color)
		sampSendChat('/offer')
	end

	if isMode('smi') then
		if text:find('^Íà îáðàáîòêó îáúÿâëåíèé ïðèøëî ') or text:find('^{C17C2D}Íà îáðàáîòêó îáúÿâëåíèé ïðèøëî ñîîáùåíèå îò ðóêîâîäñòâà ñòðàõîâîé êîìïàíèè%: (.+)')
		or text:find('^VIP îáúÿâëåíèå:') or text:find('^Ñòàíäàðòíîå îáúÿâëåíèå:') then -- rodina
			local nick = text:match('îò: ([^{%(]+)') or text:match('êîìïàíèè: (.+)') or text:match('%, îò%: (.+)%[') or ''
			if settings.smi.notify_new_ads then play_sound() end
			sampAddChatMessage('[Radical Helper] {ffffff}Ïîñòóïèëî íîâîå îáüÿâëåíèå îò èãðîêà ' .. message_color_hex .. nick, message_color)
			return false
		end
		if (text:find('^%[Îøèáêà%] %{ffffff%}Ýòî îáúÿâëåíèå óæå ðåäàêòèðóåò (.+).')) then
			local nick = text:match('ðåäàêòèðóåò (.+).')
			sampAddChatMessage('[Radical Helper] {ffffff}Ýòî îáüÿâëåíèå óæå ðåäàêòèðóåò èãðîê ' .. message_color_hex  .. nick, message_color)
			return false
		end
		if text:find('^{FCAA4D}%[VIP%] Îáúÿâëåíèå%:') then
			lua_thread.create(function()
				MODULE.SmiEdit.vip_pause = true
				wait(10000)
				MODULE.SmiEdit.vip_pause = false
			end)
		end
	end

	if (isMode('police') or isMode('fbi')) then
		if text:find("^%[(.-)%] (.-) (.-)%[(.-)%]: Ïðîøó îáüÿâèòü â ðîçûñê (%d) ñòåïåíè äåëî N(%d+)%. Ïðè÷èíà%: (.+)") then
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			form_su(name, playerID, message)
		elseif text:find("^%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: Ïðîøó îáüÿâèòü â ðîçûñê (%d) ñòåïåíè äåëî N(%d+)%. Ïðè÷èíà%: (.+)") then
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			form_su(name, playerID, message)
		end
		if (text:find('^Ìåñòîïîëîæåíèå (.+) îòìå÷åíî íà êàðòå êðàñíûì ìàðêåðîì')) then
			printStringNow(MODULE.Wanted.afind and 'AUTO FIND' or 'FIND', 500)
			return false
		end
		if ((MODULE.Wanted.checker) and (text:find('^%[Îøèáêà%] %{FFFFFF%}Èñïîëüçóé: %/wanted %[óðîâåíü ðîçûñêà 1%-6%]') or text:find('^%[Îøèáêà%] %{FFFFFF%}Èñïîëüçóéòå: %/wanted %[óðîâåíü ðîçûñêà 1%-6%]'))) then
			return false
		end
		if ((MODULE.Wanted.checker) and (text:find('^%[Îøèáêà%].+Èãðîêîâ ñ òàêèì óðîâíåì ðîçûñêà íåòó'))) then 
			return false 
		end
		if ((MODULE.Patrool.active) and (text:find('^Íà ýòîì àâòîìîáèëå óæå óñòàíîâëåíà ìàðêèðîâêà.'))) then
			sampAddChatMessage('[Radical Helper] {ffffff}Ìåíÿþ ìàêðèðîâêó â òðàíñïîðòå...', message_color)
			sampSendChat('/delvdesc')
			lua_thread.create(function()
				wait(5000)
				sampSendChat('/vdesc ' .. MODULE.Binder.tag.get_patrool_mark())
			end)		
		end
		if (text:find('^%[Èíôîðìàöèÿ%] {ffffff}Âû ïîäîáðàëè îáëîìîê, òåïåðü âàì íóæíî îòíåñòè åãî è {ff0000}ïîëîæèòü â îáùóþ êó÷ó')) then
			sampAddChatMessage('[Radical Helper] {ffffff}Âû ïîäîáðàëè çàâàë, òåïåðü âàì íóæíî îòíåñòè åãî â îáùóþ êó÷ó!', message_color)
			return false
		end
		if (text:find('^%[Èíôîðìàöèÿ%] {ffffff}Âû ïîëîæèëè îáëîìîê â îáùóþ êó÷ó, îòïðàâëÿéòåñü ê ñëåäóþùåìó çàâàëó.')) then
			sampAddChatMessage('[Radical Helper] {ffffff}Âû ïîëîæèëè çàâàë â îáùóþ êó÷ó, òåïåðü îòïðàâëÿéòåñü ê ñëåäóþùåìó çàâàëó.', message_color)
			return false
		end
		if text:find('^>> Âû ïîñàäèëè èãðîêà (.+) â òþðüìó íà (%d+) ìèíóò') then
			if (settings.mj.auto_time) then
				lua_thread.create(function()
					wait(500)
					sampSendChat('/time')
				end)
			end
		end
		if settings.mj.auto_time then
			local nick = MODULE.Binder.tag.my_nick():gsub('%[.+%]', '')
			if text:find("^ " .. nick .. ' îáûñêèâàåò (.+)') 
			or text:find("^" .. nick .. ' ïðîâåðÿåò äîêóìåíòû ó (.+)') 
			or text:find("^%[Ðîçûñê%] (.+) Îáâèíèòåëü%: " .. nick) then
				sampSendChat('/time')
			end
		end
	end
 	
	if isMode('hospital') then
		if text:find('^Î÷åâèäåö ñîîáùàåò î ïîñòðàäàâøåì ÷åëîâåêå â ðàéîíå (.+) %((.+)%).') then
			MODULE.GoDeath.locate, MODULE.GoDeath.city = text:match('Î÷åâèäåö ñîîáùàåò î ïîñòðàäàâøåì ÷åëîâåêå â ðàéîíå (.+) %((.+)%).')
			return false
		elseif text:find('^Î÷åâèäåö ñîîáùàåò î ïîñòðàäàâøåì ÷åëîâåêå%, ãåîëîêàöèÿ%: (.+)') then -- rodina
			MODULE.GoDeath.locate, MODULE.GoDeath.city = "íåèçâåñòíîì", text:match('ãåîëîêàöèÿ%: (.+)')
			return false
		end
		if text:find('^%(%( ×òîáû ïðèíÿòü âûçîâ, ââåäèòå /godeath (%d+). Îïëàòà çà âûçîâ (.+) %)%)') then
			local price_godeath = ''
			MODULE.GoDeath.player_id, price_godeath = text:match('%(%( ×òîáû ïðèíÿòü âûçîâ, ââåäèòå /godeath (%d+). Îïëàòà çà âûçîâ (.+) %)%)')
			MODULE.GoDeath.player_id = tonumber(MODULE.GoDeath.player_id)
			local cmd = '/godeath'
			for _, command in ipairs(modules.commands.data.commands.my) do
				if command.enable and command.text:find('/godeath {id}') then
					cmd =  '/' .. command.cmd
				end
			end
			if MODULE.GoDeath.locate == 'íåèçâåñòíîì' then
				sampAddChatMessage('[Radical Helper] {ffffff}Èç ãîðîäà ' .. message_color_hex .. MODULE.GoDeath.city .. ' {ffffff}ïîñòóïèë âûçîâ î ïîñòðàäàâøåì ' .. message_color_hex .. sampGetPlayerNickname(MODULE.GoDeath.player_id), message_color)
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Èç ãîðîäà ' .. message_color_hex .. MODULE.GoDeath.city .. ' (' .. MODULE.GoDeath.locate .. ') {ffffff}ïîñòóïèë âûçîâ î ïîñòðàäàâøåì ' .. message_color_hex .. sampGetPlayerNickname(MODULE.GoDeath.player_id), message_color)
			end
			sampAddChatMessage('[Radical Helper] {ffffff}Âûëå÷èâ åãî âû ïîëó÷èòå ' .. price_godeath .. '! ×òîáû ïðèíÿòü âûçîâ, èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. cmd .. ' ' .. MODULE.GoDeath.player_id, message_color)
			return false
		end
		if text:find("^Ïàöèåíò (.+) âûçûâàåò âðà÷åé .+õîëë.+ýòàæ") then
			sampAddChatMessage('[Radical Helper] {ffffff}Ïàöèåíò ' .. text:match("Ïàöèåíò (.+) âûçûâàåò") .. ' âûçûâàåò âðà÷à â õîëë áîëüíèöû!', message_color)
			return false
		end
		if settings.mh.heal_in_chat.enable and not MODULE.HealChat.bool then	
			if text:find('^(.+)%[(%d+)%] ãîâîðèò:{......} (.+)') then
				local nick, id, message = text:match('^(.+)%[(%d+)%] ãîâîðèò:{......} (.+)')
				heal_handler(nick, id, message)
			elseif text:find('^(.+)%[(%d+)%] êðè÷èò: (.+)') then
				local nick, id, message = text:match('^(.+)%[(%d+)%] êðè÷èò: (.+)')
				heal_handler(nick, id, message)
			end
		end
	end	

	if isMode('lc') then
		if text:find('^Âû îòðåìîíòèðîâàëè äîðîæíûé çíàê: (.+) Âàøà çàðïëàòà%: (.+)') then
			local money = text:match('Âàøà çàðïëàòà%: (.+)')
			sampAddChatMessage('[Radical Helper] {ffffff}Çà ðåìîíò äîðîæíîãî çíàêà âû çàðàáîòàëè ' .. money, message_color)
			if AS_REMONT_DEBUG then
				sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Çàïîìíèë âñå âàøè äåéñòâèÿ ðåìîíòà çíàêà, è ãîòîâ èõ ïîâòîðÿòü!', message_color)
				AS_REMONT_DEBUG = false
				settings.lc.auto_repair_znak.enable = true
				save_settings()
			end
			return false
		end
		if text:find('^Âû óñòàíîâèëè äîðîæíûé çíàê: (.+) Âàøà çàðïëàòà%: (.+)') then
			local money = text:match('Âàøà çàðïëàòà%: (.+)')
			sampAddChatMessage('[Radical Helper] {ffffff}Çà óñòàíîâêó äîðîæíîãî çíàêà âû çàðàáîòàëè ' .. money, message_color)
			if AS_INSTALL_DEBUG then
				sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Çàïîìíèë âñå âàøè äåéñòâèÿ óñòàíîâêè çíàêà, è ãîòîâ èõ ïîâòîðÿòü!', message_color)
				AS_INSTALL_DEBUG = false
				settings.lc.auto_install_znak.enable = true
				save_settings()
			end
			return false
		end
		if text:find('^Âû âçÿëè èíñòðóìåíòû äëÿ ðåìîíòà äîðîæíîãî çíàêà.') then
			sampAddChatMessage('[Radical Helper] {ffffff}Âû âçÿëè èíñòðóìåíòû äëÿ ðåìîíòà äîðîæíîãî çíàêà.', message_color)
			return false
		end
		if text:find('^%[Îøèáêà%](.+)Ó èãðîêà óæå åñòü òàêàÿ ëèöåíçèÿ ñðîêîì áîëåå ÷åì (.+)') then
			local days = text:match('ñðîêîì áîëåå ÷åì (.+)')
			sampAddChatMessage('[Radical Helper] {ffffff}Ó èãðîêà óæå åñòü òàêàÿ ëèöåíçèÿ ñðîêîì áîëåå ÷åì ' .. days, message_color)
			sampSendChat('Ó âàñ óæå åñòü òàêàÿ ëèöåíçèÿ ñðîêîì áîëåå ÷åì ' .. days)
			return false
		end
		if (text:find('^%[Îøèáêà%](.+)Âû íå ìîæåòå ïðîäàâàòü ëèöåíçèè íà òàêîé ñðîê')) then
			sampAddChatMessage('[Radical Helper] {ffffff}Âàø ðàíã íèæå, ÷åì òðåáóåòñÿ äëÿ âûäà÷è äàííîé ëèöåíçèè!', message_color)
			sampSendChat('Èçâèíèòå, ÿ íå ìîãó âûäàòü äàííóþ ëèöåíçèþ èç-çà íèçêîé äîëæíîñòè.')
			return false
		end
	end	

	if isMode('fd') then
		if (text:find("Ïðîèñøåñòâèå(.+)Â øòàòå ïðîèçîøåë ïîæàð! Ðàíã îïàñíîñòè (%d) çâåçäû")) then
			MODULE.Fires.lvl = text:match('Ðàíã îïàñíîñòè (%d) çâåçäû')
			sampAddChatMessage('[Radical Helper] {ffffff}Â øòàòå íîâûé ïîæàð ' .. MODULE.Fires.lvl .. ' ñòåïåíè îïàñíîñòè!', message_color)
			if (tonumber(MODULE.Fires.lvl) >= 2) then
				sampAddChatMessage('[Radical Helper] {ffffff}Äåéñòâóåò ïîâûøåííàÿ âûïëàòà çà óñòðàíåíèå ïîæàðà èç-çà âûñîêîãî óðîâíÿ îïàñíîñòè.', message_color)
			end
			sampSendChat('/fires')
			return false
		end
		if (text:find("%[Èíôîðìàöèÿ%] {ffffff}Âû ïðèáûëè íà ìåñòî ïîæàðà")) then
			MODULE.Fires.isZone = true
			sampAddChatMessage('[Radical Helper] {ffffff}Âû ïðèáûëè íà ìåñòî ïîæàðà.', message_color)
			if (settings.fd.doklads.here) then 
				sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', ïðèáûë' .. MODULE.Binder.tag.sex() .. ' íà ìåñòî ïîæàðà ' .. MODULE.Fires.lvl .. ' ñòåïåíè îïàñíîñòè!')
			end
			return false
		end
		if (text:find("%[Èíôîðìàöèÿ%] {ffffff}Ïîæàðíàÿ ìàøèíà áóäåò çàðåñïàâíåíà ÷åðåç (%d+) ìèíóò")) then
			sampAddChatMessage('[Radical Helper] {ffffff}Ïîæàðíàÿ ìàøèíà áóäåò çàðåñïàâíåíà ÷åðåç ' .. text:match("÷åðåç (%d+) ìèíóò") .. ' ìèíóò!', message_color)
			return false
		end
		if (MODULE.Fires.isZone) then
			if text:find("%[Èíôîðìàöèÿ%] {......}Ïðîèñøåñòâèå ¹(%d+)%: Âñå î÷àãè âîçãîðàíèÿ ëèêâèäèðîâàíû") then
				sampAddChatMessage('[Radical Helper] {ffffff}Âñå î÷àãè âîçãîðàíèÿ ëèêâèäèðîâàíû!', message_color)
				if settings.fd.doklads.fire then
					sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', âñå î÷àãè âîçãîðàíèÿ ïîæàðà ' .. MODULE.Fires.lvl .. ' ñòåïåíè îïàñíîñòè ëèêâèäèðîâàíû!')
				end
				return false
			end
			if text:find("%[Èíôîðìàöèÿ%] {ffffff}Îòíåñèòå ïîñòðàäàâøåãî â ïàëàòêó.") then
				sampAddChatMessage('[Radical Helper] {ffffff}Îòíåñèòå ïîñòðàäàâøåãî â ïàëàòêó.', message_color)
				if settings.fd.doklads.stretcher then 
					sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', ïîãðóçèë' .. MODULE.Binder.tag.sex() .. ' ïîñòðàäàâøåãî íà íîñèëêè, îòíîøó â ïàëàòêó.')
				end
				return false
			end
			if text:find("%[Èíôîðìàöèÿ%] {ffffff}Îòëè÷íî! Âû ñïàñëè ïîñòðàäàâøåãî!") then
				sampAddChatMessage('[Radical Helper] {ffffff}Âû ñïàñëè ïîñòðàäàâøåãî!', message_color)
				if settings.fd.doklads.npc_save then 
					sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', ïîñòðàäàâøåìó óñïåøíî îêàçàíà ïîìîùü!')
				end
				return false
			end
			if text:find("%[Èíôîðìàöèÿ%] {ffffff}Âû çàðàáîòàëè íà ïðîèñøåñòâèå {90EE90}$(.+){FFFFFF}, çàáðàòü âîçíàãðàæäåíèå ìîæíî íà áàçå îðãàíèçàöèè") then
				MODULE.Fires.isZone = false
				sampAddChatMessage('[Radical Helper] {ffffff}Ïîæàð óñòðàí¸í, çà åãî ëèêâèäàöèþ âû çàðàáîòàëè: ' .. message_color_hex .. '$' .. (text:match('{90EE90}$(.+){FFFFFF}') or 'nil'), message_color)
				if settings.fd.doklads.file_end then
					lua_thread.create(function()
						wait(500)
						sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', ïîæàð ' .. MODULE.Fires.lvl .. ' ñòåïåíè îïàñíîñòè ïîëíîñòþ óñòðàí¸í!')
					end)
				end
				return false
			end
		end
		if (text:find("%[Èíôîðìàöèÿ%] {ffffff}Ïàëàòêà âîçâðàùåíà Âàì â èíâåíòàðü.")) then
			sampAddChatMessage('[Radical Helper] {ffffff}Ïàëàòêà âîçâðàùåíà âàì â èíâåíòàðü.', message_color)
			if (settings.fd.doklads.tent) then 
				sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. ', óáðàë' .. MODULE.Binder.tag.sex() .. ' ïàëàòêó ñ ìåñòà ïðîèøåñòâèÿ.')
			end
			return false
		end
	end

	if isMode('ins') then
		if (text:find('^(.+) ïîäàë çàÿâëåíèå íà ñòðàõîâàíèå èìóùåñòâà.') and color == -1048826369) then
			local nick = text:match('^(.+) ïîäàë')
			sampAddChatMessage('[Radical Helper] {ffffff}Èãðîê ' .. nick .. ' ïîäàë çàÿâëåíèå íà ñòðàõîâàíèå èìóùåñòâà!', message_color)
			if (settings.ins.notify_new_ticket) then
				play_sound()
			end
			return false
		end
		if (text:find('^Âû çàïîëíèëè âòîðóþ ÷àñòü äîêóìåíòîâ.')) then
			sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Ïðîõîæäåíèå ìèíè èãðû óñïåøíî çàâåðøåíî!', message_color)
			return false
		end
	end

	if isMode('gov') then
		if text:find('^%[Îøèáêà%].+Çàêëþ÷åííûõ íåò.') then
			MODULE.Zeks.Window[0] = false
			MODULE.Zeks.checker = false
			MODULE.Zeks.updzeks.stop = false
			MODULE.Zeks.updzeks.check = false
		end
	end

	if text:find('^%[Îøèáêà%] {ffffff}Ïîñëå ïðîøåäøåãî ïîäòâåðæäåíèå íå ïðîøëî 3 ÷àñà. {C0C0C0}%(Îñòàëîñü: (.+)%)') then
		sampSendChat('Âû íåäàâíî ïîëó÷àëè ïîäòâåðæäåíèå, ïîäîæäèòå ' .. text:match('Îñòàëîñü: (.+)%)'))
	end 

	if (text:find("^1%.{......} 111 %- {......}Ïðîâåðèòü áàëàíñ òåëåôîíà")) or
		(text:find("^2%.{......} 060 %- {......}Ñëóæáà òî÷íîãî âðåìåíè")) or
		(text:find("^3%.{......} 911 %- {......}Ïîëèöåéñêèé ó÷àñòîê")) or
		(text:find("^4%.{......} 912 %- {......}Ñêîðàÿ ïîìîùü")) or
		(text:find("^5%.{......} 914 %- {......}Òàêñè")) or
		(text:find("^5%.{......} 914 %- {......}Ìåõàíèê")) or
		(text:find("^6%.{......} 8828 %- {......}Ñïðàâî÷íàÿ öåíòðàëüíîãî áàíêà")) or
		(text:find("^7%.{......} 997 %- {......}Ñëóæáà ïî âîïðîñàì æèëîé íåäâèæèìîñòè %(óçíàòü âëàäåëüöà äîìà%)")) then
		return false
	end
	if (text:find("^%[Ïîäñêàçêà%] {......}Íîìåðà òåëåôîíîâ ãîñóäàðñòâåííûõ ñëóæá:")) then
		sampAddChatMessage('[Radical Helper] {ffffff}Íîìåðà òåëåôîíîâ ãîñóäàðñòâåííûõ ñëóæá:', message_color)
		sampAddChatMessage('[Radical Helper] {ffffff}111 Áàëàíñ | 60 Âðåìÿ | 911 ÌÞ | 912 ÌÇ | 913 Òàêñè | 914 Ìåõè | 8828 Áàíê | 997 Äîìà', message_color)
		return false
	end

	--[[if (text:find('Kurt_Simpson') and getServerNumber() == '31') or text:find('%[31%]Kurt_Simpson') then
		local lastColor = text:match("(.+){%x+}$")
		if text:find('%[VIP ADV%]') or text:find('%[FOREVER%]') then lastColor = "{FFFFFF}" end
   		if not lastColor then lastColor = "{" .. rgba_to_hex(color) .. "}" end
		if text:find('%[31%]Kurt_Simpson%[%d+%]') then
			local id = text:match('%[31%]Kurt_Simpson%[(%d+)%]') or ''
			text = string.gsub(text, '%[31%]Kurt_Simpson%[%d+%]', message_color_hex .. '[31]MTGMODS[' .. id .. ']' .. lastColor)
		elseif text:find('%[31%]Kurt_Simpson') then
			text = string.gsub(text, '%[31%]Kurt_Simpson', message_color_hex .. '[31]MTGMODS' .. lastColor)
		elseif text:find('Kurt_Simpson%[%d+%]') then
			local id = text:match('Kurt_Simpson%[(%d+)%]') or ''
			text = string.gsub(text, 'Kurt_Simpson%[%d+%]', message_color_hex .. 'MTGMODS[' .. id .. ']' .. lastColor)
		elseif text:find('Kurt_Simpson') then
			text = string.gsub(text, 'Kurt_Simpson', message_color_hex .. 'MTGMODS' .. lastColor)
		end
		return {color,text}
	end]]
end
function sampev.onSendChat(text)
	if MODULE.DEBUG then
		sampAddChatMessage('[SendChat] {ffffff}Text ' .. text, message_color)
		print('[SendChat] ' .. text)
	end
	local ignore = {
		[")"] = true,
		["))"] = true,
		["("] = true,
		["(("] = true,
		["q"] = true,
		["<3"] = true,
	}
	if ignore[text] then
		return {text}
	end
	-- Õóéíÿ îòâå÷àþùàÿ çà çàãëàâíóþ áóêâó ñ òî÷êîé â ÷àò
	--[[if settings.general.rp_chat then
		text = text:sub(1, 1):rupper()..text:sub(2, #text) 
		if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
			text = text .. '.'
		end
	end]]
	return {text}
end
function sampev.onSendCommand(text)
	if MODULE.DEBUG then
		sampAddChatMessage('[SendCommand] {ffffff}CMD ' .. text, message_color)
		print('[SendCommand] CMD ' .. text)
	end
	if isMode('smi') and MODULE.SmiEdit.is_active_ad and text:find('^%/newsredak') then
		sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Äîæäèòåñü îòïðàâêè ïðåäûäóùåãî îáüÿâëåíèÿ!', message_color)
		play_sound()
		return false
	end
	if settings.general.rp_chat then
		local chats =  { '/vr', '/fam', '/al', '/s', '/b', '/n', '/r', '/rb', '/f', '/fb', '/j', '/jb', '/m', '/do'} 
		for _, cmd in ipairs(chats) do
			if text:find('^'.. cmd .. ' ') then
				local cmd_text = text:match('^'.. cmd .. ' (.+)')
				if cmd_text ~= nil then
					cmd_text = cmd_text:sub(1, 1):rupper()..cmd_text:sub(2, #cmd_text)
					text = cmd .. ' ' .. cmd_text
					if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
						text = text .. '.'
					end
				end
			end
		end
		return {text}
	end
end
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	if MODULE.DEBUG then
		sampAddChatMessage('[ShowDialog] {ffffff}ID ' .. dialogid .. ' | Style ' .. style .. ' | Title ' .. title .. ' | Btn1 ' .. button1 .. ' | Btn2 ' .. button2 .. ' | Text ' .. text, message_color)
		print('[ShowDialog] ID ' .. dialogid .. ' | Style ' .. style .. ' | Title ' .. title .. ' | Btn1 ' .. button1 .. ' | Btn2 ' .. button2 .. ' | Text ' .. text)
	end

	if check_stats and (title:find('Îñíîâíàÿ ñòàòèñòèêà') or title:find('Ñòàòèñòèêà èãðîêà')) then
		if text:find("Èìÿ") then
			modules.player.data.nick = text:match("{FFFFFF}Èìÿ: {......}(.+) %[%¹%d+%] \n{FFFFFF}Ïîë") or text:match("{ffffff}Èìÿ %(en%.%):%s+{......}([^\n\r]+)")
			modules.player.data.name_surname = text:match("{ffffff}Èìÿ %(ðóñ%.%):%s+{......}([^\n\r]+)") or translate(modules.player.data.nick)
			sampAddChatMessage('[Radical Helper] {ffffff}Âàøå èìÿ è ôàìèëèÿ îáíàðóæåíû: ' .. modules.player.data.name_surname, message_color)
        end
		if text:find("Ïîë:") then
			modules.player.data.sex = text:match("{FFFFFF}Ïîë: {......}%[(.-)]") or text:match("{ffffff}Ïîë:%s+{......}([^\n\r]+)")
			sampAddChatMessage('[Radical Helper] {ffffff}Âàø ïîë îáíàðóæåí: ' .. modules.player.data.sex, message_color)
		end
		if text:find("Îðãàíèçàöèÿ:") then
			modules.player.data.fraction = text:match("{FFFFFF}Îðãàíèçàöèÿ: {......}%[(.-)]") or text:match("{ffffff}Îðãàíèçàöèÿ:%s+{......}([^\n\r]+)")
			local fraction_data = {
				['Ïîëèöèÿ ËÑ'] = {'ËÑÏÄ', 'police'}, ['Ïîëèöèÿ LS'] = {'ËÑÏÄ', 'police'},
				['Ïîëèöèÿ ËÂ'] = {'ËÂÏÄ', 'police'}, ['Ïîëèöèÿ LV'] = {'ËÂÏÄ', 'police'},
				['Ïîëèöèÿ ÑÔ'] = {'ÑÔÏÄ', 'police'}, ['Ïîëèöèÿ SF'] = {'ÑÔÏÄ', 'police'},
				['Ïîëèöèÿ ÂÑ'] = {'ÂÑÏÄ', 'police'}, ['Ïîëèöèÿ VC'] = {'ÂÑÏÄ', 'police'},
				['Îáëàñòíàÿ ïîëèöèÿ'] = {'ÐÊØÄ', 'police'}, ['FBI'] = {'ÔÁÐ', 'fbi'}, ['ÔÁÐ'] = {'ÔÁÐ', 'fbi'},
				['Òþðüìà ñòðîãîãî ðåæèìà LV'] = {'ÒÑÐ', 'prison'}, ['Òþðüìà ñòðîãîãî ðåæèìà ËÂ'] = {'ÒÑÐ', 'prison'},
				['Àðìèÿ ÑÔ'] = {'ÑÔà', 'army'}, ['Àðìèÿ SF'] = {'ÑÔà', 'army'},
				['Àðìèÿ ËÑ'] = {'ËÑà', 'army'}, ['Àðìèÿ LS'] = {'ËÑà', 'army'},
				['TV ñòóäèÿ'] = {'ÑÌÈ ËÑ', 'smi'},
				['TV ñòóäèÿ ËÑ'] = {'ÑÌÈ ËÑ', 'smi'}, ['TV ñòóäèÿ LS'] = {'ÑÌÈ ËÑ', 'smi'},
				['TV ñòóäèÿ ËÂ'] = {'ÑÌÈ ËÂ', 'smi'}, ['TV ñòóäèÿ LV'] = {'ÑÌÈ ËÂ', 'smi'},
				['TV ñòóäèÿ ÑÔ'] = {'ÑÌÈ ÑÔ', 'smi'}, ['TV ñòóäèÿ SF'] = {'ÑÌÈ ÑÔ', 'smi'},
				['TV ñòóäèÿ ÂÑ'] = {'ÑÌÈ ÂÑ', 'smi'}, ['TV ñòóäèÿ VC'] = {'ÑÌÈ ÂÑ', 'smi'},
				['Áîëüíèöà ËÑ'] = {'ËÑÌÖ', 'hospital'}, ['Áîëüíèöà LS'] = {'ËÑÌÖ', 'hospital'},
				['Áîëüíèöà ËÂ'] = {'ËÂÌÖ', 'hospital'}, ['Áîëüíèöà LV'] = {'ËÂÌÖ', 'hospital'},
				['Áîëüíèöà ÑÔ'] = {'ÑÔÌÖ', 'hospital'}, ['Áîëüíèöà SF'] = {'ÑÔÌÖ', 'hospital'},
				['Áîëüíèöà ÂÑ'] = {'ÂÑÌÖ', 'hospital'}, ['Áîëüíèöà VC'] = {'ÂÑÌÖ', 'hospital'},
				['Áîëüíèöà Jefferson'] = {'ÄÌÖ', 'hospital'}, ['Áîëüíèöà Äæåôôåðñîí'] = {'ÄÌÖ', 'hospital'},
				['Ïðàâèòåëüñòâî LS'] = {'Ïðàâî', 'gov'}, ['Ïðàâèòåëüñòâî ËÑ'] = {'Ïðàâî', 'gov'},
				['Ñóäüÿ'] = {'Ñóäüÿ', 'judge'},
				['Öåíòð ëèöåíçèðîâàíèÿ'] = {'ÃÖË', 'lc'},
				['Ïîæàðíûé äåïàðòàìåíò'] = {'ÏÄ', 'fd'},
				['Ñòðàõîâàÿ êîìïàíèÿ'] = {'ÑÒÊ', 'ins'},
				['Russian Mafia'] = {'RM', 'mafia'},
				['Yakuza'] = {'YKZ', 'mafia'},
				['La Cosa Nostra'] = {'LCN', 'mafia'},
				['Warlock MC'] = {'WMC', 'mafia'},
				['Tierra Robada Bikers'] = {'TRB', 'mafia'},
				['Grove Street'] = {'Ãðóâ', 'ghetto'},
				['Los Santos Vagos'] = {'Âàãîñ', 'ghetto'},
				['East Side Ballas'] = {'Áàëëàñ', 'ghetto'},
				['Varrios Los Aztecas'] = {'Àöòåê', 'ghetto'},
				['The Rifa'] = {'Ðèôà', 'ghetto'},
				['Night Wolves'] = {'ÍÂ', 'ghetto'},
				-- Rodina
				['ÔÑÁ'] = {'ÔÑÁ', 'fbi'},
				['Àðìèÿ'] = {'ÂÑ', 'army'},
				['Òþðüìà Ñòðîãîãî Ðåæèìà'] = {'ÔÑÈÍ', 'prison'},
				['Ïîëèöèÿ îêðóãà'] = {'ÃÈÁÄÄ', 'police'},
				['Ãîðîäñêàÿ ïîëèöèÿ'] = {'ÃÓÂÄ', 'police'},
				['Áîëüíèöà îêðóãà'] = {'ÌÓÑÑ', 'hospital'},
				['Ãîðîäñêàÿ áîëüíèöà'] = {'ÑÌÏ', 'hospital'},
				['Öåíòð Ëèöåíçèðîâàíèÿ'] = {'ÌÐÝÎ', 'lc'},
				['Ïðàâèòåëüñòâî'] = {'Ïðàâî', 'gov'},
				['Íîâîñòíîå àãåíñòâî'] = {'ÍÀ', 'smi'},
				['Óêðàèíñêàÿ ìàôèÿ'] = {'ÓÌ', 'mafia'},
				['Êàâêàçêàÿ ìàôèÿ'] = {'ÊÌ', 'mafia'},
			}
			local data = fraction_data[modules.player.data.fraction]
			local old_fraction_mode = settings.general.fraction_mode
			if data then
				sampAddChatMessage('[Radical Helper] {ffffff}Âàøà îðãàíèçàöèÿ îáíàðóæåíà, ýòî: '..modules.player.data.fraction, message_color)
				modules.player.data.fraction_tag = data[1]
				settings.general.fraction_mode = data[2]
				sampAddChatMessage('[Radical Helper] {ffffff}Âàøåé îðãàíèçàöèè ïðèñâîåí òåã '..modules.player.data.fraction_tag .. ". Íî âû ìîæåòå èçìåíèòü åãî.", message_color)
				if text:find("Äîëæíîñòü:") then
					local rank, rank_number = text:match("{FFFFFF}Äîëæíîñòü: {......}(.+)%((%d+)%)(.+)Óðîâåíü ðîçûñêà")
					if not rank or not rank_number then
						rank, rank_number = text:match("{ffffff}Äîëæíîñòü:%s+{......}([^(]+)%((%d+)%)")
					end
					modules.player.data.fraction_rank = rank
					modules.player.data.fraction_rank_number = tonumber(rank_number)
					sampAddChatMessage('[Radical Helper] {ffffff}Âàøà äîëæíîñòü îáíàðóæåíà, ýòî: ' .. modules.player.data.fraction_rank .. " (" .. modules.player.data.fraction_rank_number .. ")", message_color)
					if modules.player.data.fraction_rank_number >= 9 then
						settings.general.auto_uninvite = true
					end
				end
			else
				settings.general.fraction_mode = 'none'
				modules.player.data.fraction_tag = "ÆÄËÑ"
				modules.player.data.fraction_rank = "Áîìæ"
				modules.player.data.fraction_rank_number = 1
				sampAddChatMessage('[Radical Helper] {ffffff}Íå óäàëîñü ïîëó÷èòü âàøó îðãàíèçàöèþ è äîëæíîñòü!', message_color)
				sampAddChatMessage('[Radical Helper] {ffffff}Ïðèñâîèë âàì ðåæèì áåç îðãàíèçàöèè (ÆÄËÑ - Áîìæ - 1).', message_color)
				sampAddChatMessage('[Radical Helper] {ffffff}Åñëè âû äåéñòâèòåëüíî ñîñòîèòå â îðãàíèçàöèè - ïåðåíàñòðîéòå õåëïåð âðó÷íóþ.', message_color)
			end
			if old_fraction_mode ~= '' and old_fraction_mode ~= 'none' and old_fraction_mode ~= settings.general.fraction_mode then
				sampAddChatMessage('[Radical Helper] {ffffff}Âû òåïåðü â äðóãîé ôðàêöèè, ïîýòîìó óäàëÿþ êîìàíäû ' .. old_fraction_mode:rupper(), message_color)
				delete_default_fraction_cmds(modules.commands.data.commands.my, get_fraction_cmds(old_fraction_mode, false))
				delete_default_fraction_cmds(modules.commands.data.commands_manage.my, get_fraction_cmds(old_fraction_mode, true))
			end
			import_fraction_data(settings.general.fraction_mode)
		end
		save_settings()
		save_module('player')
		save_module('departament')
		sampSendDialogResponse(dialogid, 0, 0, 0)
		reload_script = true
		thisScript():reload()
		return false
	end

	if ((MODULE.Members.info.check) and (title:find('(.+)%(Â ñåòè: (%d+)%)') or title:find('Â ñåòè âñåãî .+ ÷ëå.+îðãàíèçàöèè'))) then
        local count = 0
        local next_page = false
        local next_page_i = 0
		MODULE.Members.info.fraction = string.match(title, '(.+)%(Â ñåòè')
		if MODULE.Members.info.fraction then
			MODULE.Members.info.fraction = string.gsub(MODULE.Members.info.fraction, '{(.+)}', '')
		else
			MODULE.Members.info.fraction = modules.player.data.fraction -- rodina
		end
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('ñòðàíèöà') and (not line:find('Íèê') or not line:find('Èìÿ')) then
				local optional_info = ''
				if line:find('{......}%(Âû%)') then
					line = line:gsub("{......}%(Âû%)", "")
					optional_info = '(Âû)'
				end
				if line:find(' %/ Â äåìîðãàíå') then
					line = line:gsub(" %/ Â äåìîðãàíå", "")
					optional_info = optional_info .. ' (JAIL)'
				end
				if line:find(' %/ MUTED') then
					line = line:gsub(" %/ MUTED", "")
					optional_info = optional_info .. ' (MUTE)'
				end
				if optional_info == '' then
					optional_info = '-'
				end
				if line:find('{......}%(%d+.+%)') then
					local color, nickname, id, rank, rank_number, color2, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}([%w_]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*{(%x%x%x%x%x%x)}%(([^%)]+)%)%s*{FFFFFF}(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ øò")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						if rank_time then
							rank_number = rank_number .. ') (' .. rank_time
						end
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
					end
				else
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ øò")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
					end
				end
				if not rank or not nickname then -- rodina
					local nickname, id, rank, rank_number, warns = line:match("(.+)%((%d+)%)%s+(.+)%((%d+)%).+(%d) / 3")
					if nickname and id and rank and rank_number and warns then
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = 0, working = true, info = optional_info})
					end
				end
            end
            if line:match('Ñëåäóþùàÿ ñòðàíèöà') then
                next_page = true
                next_page_i = count - 2
            end
        end
        if next_page then
            sampSendDialogResponse(dialogid, 1, next_page_i, 0)
            next_page = false
            next_pagei = 0
		elseif #MODULE.Members.new ~= 0 then
            sampSendDialogResponse(dialogid, 0, 0, 0)
			MODULE.Members.all = MODULE.Members.new
			MODULE.Members.info.check = false
			if not settings.general.auto_update_members then
				sampAddChatMessage('[Radical Helper] {ffffff}Âû ìîæåòå âêëþ÷èòü àâòî-îáíîâëåíèå ñïèñêà /mb /helper - Ôóíêöèè ' .. modules.player.data.fraction_tag .. '!', message_color)
			end
			MODULE.Members.Window[0] = true
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[Radical Helper]{ffffff} Ñïèñîê ñîòðóäíèêîâ ïóñò!', message_color)
			MODULE.Members.info.check = false
        end
        return false
    end

	if modules.player.data.fraction_rank_number >= 9 then
		if title:find('Âûáåðèòå ðàíã äëÿ (.+)') and text:find('âàêàíñèé') then
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		if MODULE.LeadTools.spawncar and title:find('$') and text:find('Ñïàâí òðàíñïîðòà') then
			local count = 0
			for line in text:gmatch('[^\r\n]+') do
				if line:find('Ñïàâí òðàíñïîðòà') then
					sampSendDialogResponse(dialogid, 1, count, 0)
					MODULE.LeadTools.spawncar = false
					return false
				else
					count = count + 1
				end
			end
		end
		if MODULE.LeadTools.vc_vize.bool then
			if text:find('Óïðàâëåíèå ðàçðåøåíèÿìè íà êîìàíäèðîâêó â Vice City') then
				local count = 0
				for line in text:gmatch('[^\r\n]+') do
					if line:find('Óïðàâëåíèå ðàçðåøåíèÿìè íà êîìàíäèðîâêó â Vice City') then
						sampSendDialogResponse(dialogid, 1, count, 0)
						return false 
					else
						count = count + 1
					end
				end
			end
			if title:find('Âûäà÷à ðàçðåøåíèé íà ïîåçäêè Vice City') then
				MODULE.LeadTools.vc_vize.bool = false
				sampSendDialogResponse(dialogid, 1, 0, tostring(MODULE.LeadTools.vc_vize.player_id))
				sampSendChat("/r Ñîòðóäíèêó "..translate(sampGetPlayerNickname(tonumber(MODULE.LeadTools.vc_vize.player_id))).." âûäàíà âèçà Vice City!")
				return false 
			end	
			if title:find('Çàáðàòü ðàçðåøåíèå íà ïîåçäêè Vice City') then
				MODULE.LeadTools.vc_vize.bool = false
				sampSendChat("/r Ó ñîòðóäíèêà "..translate(sampGetPlayerNickname(tonumber(MODULE.LeadTools.vc_vize.player_id))).." áûëà èçüÿòà âèçà Vice City!")
				sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(MODULE.LeadTools.vc_vize.player_id)))
				return false 
			end
		end
		if (MODULE.LeadTools.platoon.check) then
			if text:find('Íàçíà÷èòü âçâîä èãðîêó') and text:find('Ó÷àñòíèêè âçâîäà') then
				sampSendDialogResponse(dialogid, 1, 3, 0)
				return false 
			end
			if text:find('{FFFFFF}Ââåäèòå {FB8654}ID{FFFFFF} èãðîêà, êîòîðîãî õîòèòå íàçíà÷èòü') then
				sampSendDialogResponse(dialogid, 1, 0, MODULE.LeadTools.platoon.player_id)
				MODULE.LeadTools.platoon.check = false
				return false 
			end
		end
		if (MODULE.LeadTools.cleaner.uninvite) then
			if title:find('$') and text:find('Óïðàâëåíèå ÷ëåíàìè îðãàíèçàöèè') then
				sampSendDialogResponse(dialogid, 1, 1, 0)
				return false 
			end
			if text:find('Èãðîêè îíëàéí') and text:find("Èãðîêè îôôëàéí") then
				sampSendDialogResponse(dialogid, 1, 1, 0)
				return false 
			end
			if title:find('Óâîëüíåíèå %(îôôëàéí%)') then
				local counter = -1
				for line in text:gmatch('([^\n\r]+)') do
					counter = counter + 1
					if line:find("{FFFFFF}(.+)%s+(%d+) äíåé") then
						local nick, days = line:match("{FFFFFF}(.+)%s+(%d+) äíåé")
						if days and tonumber(days) >= tonumber(MODULE.LeadTools.cleaner.day_afk) then
							table.insert(MODULE.LeadTools.cleaner.players_to_kick, {nickname = nick, day = days})
						end            
					elseif line:find('{B0E73A}Âïåðåä') then
						sampSendDialogResponse(dialogid, 1, counter - 1, "")
						return false
					end
				end 
				if #MODULE.LeadTools.cleaner.players_to_kick > 0 then
					sampAddChatMessage('[Radical Helper] {ffffff} Íàéäåíî ' .. #MODULE.LeadTools.cleaner.players_to_kick .. ' èãðîêîâ êîòîðûå ' .. MODULE.LeadTools.cleaner.day_afk .. " äíåé íå â ñåòè!", message_color)
					lua_thread.create(function()
						for index, value in ipairs(MODULE.LeadTools.cleaner.players_to_kick) do
							MODULE.LeadTools.cleaner.reason_day = value.day
							sampSendChat('/uninviteoff ' .. value.nickname)
							printStringNow(index .. '/' .. #MODULE.LeadTools.cleaner.players_to_kick, 2000)
							wait(2000)
						end
						MODULE.LeadTools.cleaner.uninvite = false
					end)
				else
					sampAddChatMessage('[Radical Helper] {ffffff} Íåòó èãðîêîâ êîòîðûå ' .. MODULE.LeadTools.cleaner.day_afk .. " äíåé íå â ñåòè!",  message_color)
				end
				sampSendDialogResponse(dialogid, 2, 0, 0)
				return false
			end
			if MODULE.LeadTools.cleaner.uninvite and text:find("Óêàæèòå ïðè÷èíó(.+)óâîëüíåíèÿ(.+)èãðîêà èç ôðàêöèè") then
				sampSendDialogResponse(dialogid, 1,  0, 'Ïðîïàë èç øòàòà (' .. MODULE.LeadTools.cleaner.reason_day .. ' äíåé íå â èãðå)')
				return false
			end
		end
		if (MODULE.LeadTools.sell_rank.checker) then
			if (title:find('$') and text:find('Ïðîäàòü ðàíã')) then
				local count = 0
				for line in text:gmatch('[^\r\n]+') do
					if (line:find('Ïðîäàòü ðàíã')) then
						sampSendDialogResponse(dialogid, 1, count, 0)
					else
						count = count + 1
					end
				end
			elseif (title:find('Âûáîð èãðîêà') and text:find(MODULE.LeadTools.sell_rank.player_id)) then
				local count = 0
				for line in text:gmatch('[^\r\n]+') do
					if (line:find(MODULE.LeadTools.sell_rank.player_id)) then
						sampSendDialogResponse(dialogid, 1, count-1, 0)
					else
						count = count + 1
					end
				end
				MODULE.LeadTools.sell_rank.checker = false
			end
			return false
		end
	end

	if isMode('gov') then
		if settings.gov.anti_trivoga and (text:find('Âû äåéñòâèòåëüíî õîòèòå âûçâàòü ñîòðóäíèêîâ ïîëèöèè?') or text:find('Âû äåéñòâèòåëüíî õîòèòå {FFA11C}âûçâàòü{FFFFFF} ïîëèöèþ?')) then
			sampAddChatMessage('[Radical Helper] {ffffff}Òðåâîæíàÿ êíîïêà îòêëþ÷åíà. Äëÿ âêëþ÷åíèÿ èñïîëüçóéòå /helper - Ôóíêöèè Ïðàâî', message_color)
			sampSendDialogResponse(dialogid, 2, 0, 0)
			return false
		end
		if MODULE.Zeks.checker and title:find("ííûå ïîä ñòðàæó") then
			for line in text:gmatch('[^\r\n]+') do
				local clean_line = line:gsub('{........}', ''):gsub('{......}', ''):gsub('{(...)}', '')
				local nick, id, time, kpz, adv = clean_line:match('([%w_]+)%((%d+)%)\t(%d+).-\t(.-)\t(.-)$')
				if nick and id and time and kpz and kpz ~= "Íåèçâåñòíî" and adv then
					if adv == 'Â îæèäàíèè àäâîêàòà' then adv = '-' else adv = adv:gsub('Àäâîêàò:', '')  end
					
					table.insert(MODULE.Zeks.new, {nick = nick, id = id, time = time, kpz = kpz, adv = adv})
				end
			end
			MODULE.Zeks.checker = false
			if #MODULE.Zeks.new == 0 then
				sampAddChatMessage('[Radical Helper] {ffffff}Ñåé÷àñ íà ñåðâåðå íåòó çàêëþ÷åííûõ èãðîêîâ!', message_color)
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ñêàíèðîâàíèå /zeks îêîí÷åíî! Íàéäåíî çàêëþ÷åííûõ èãðîêîâ: ' .. message_color_hex .. #MODULE.Zeks.new, message_color)
				MODULE.Zeks.all = MODULE.Zeks.new
				MODULE.Zeks.updzeks.stop = false
				MODULE.Zeks.updzeks.time = 0
				MODULE.Zeks.updzeks.last_time = os.time()
				MODULE.Zeks.updzeks.check = true
				MODULE.Zeks.Window[0] = true
			end
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
	end

	if settings.general.auto_accept_docs then
		if (title:find('Àêòèâíûå ïðåäëîæåíèÿ', 1, true) and (text:find('ïàñïîðò', 1, true) or text:find('ëèöåíçèè', 1, true) or text:find('ìåä', 1, true))) then
			if text:find('Êîãäà') then
				sampSendDialogResponse(dialogid, 1, 0, 0)
				return false
			elseif text:find('Ïðèíÿòü ïðåäëîæåíèå') then
				local doc_type = 'äîêóìåíò'
				if text:find('ïàñïîðò') then
					doc_type = 'ïàñïîðò'
				elseif text:find('ìåä') then
					doc_type = 'ìåä.êàðòó'
				elseif text:find('ëèöåíçèè') then
					doc_type = 'ëèöåíçèè'
				end
				sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Çàïóñêàþ îòûãðîâêó ïðîâåðêè äîêóìåíòîâ èãðîêà...', message_color)
				MODULE.Binder.state.isActive = true
				sampSendChat('/me áåð¸ò ' .. doc_type .. ' è âíèìàòåëüíî îñìàòðèâàåò, çàòåì âîçâðàùàåò îáðàòíî âëàäåëüöó')
				sampSendDialogResponse(dialogid, 1, 2, '')
				MODULE.Binder.state.isActive = false
				return false
			end
		end
		if (title:find('Ïîäòâåðæäåíèå äåéñòâèÿ') and (text:find('ïîñìîòðåòü åãî ïàñïîðò') or text:find('ïîñìîòðåòü åãî ëèöåíçèè') or text:find('ïîñìîòðåòü åãî ìåä(.+)êàðòó'))) then
			lua_thread.create(function()
				wait(1000)
				sampSendDialogResponse(dialogid, 1, 2, '')
			end)
			return false
		end
	end
	
	if isMode('police') or isMode('fbi') then
		if text:find('Íèê') and text:find('Óðîâåíü ðîçûñêà') and text:find('Ðàññòîÿíèå') and MODULE.Wanted.checker then
			local text = string.gsub(text, '%{......}', '')
			text = string.gsub(text, 'Íèê%s+Óðîâåíü ðîçûñêà%s+Ðàññòîÿíèå\n', '')
			for line in string.gmatch(text, '[^\n]+') do
				local nick, id, lvl, dist = string.match(line, '(%w+_%w+)%((%d+)%)%s+(%d) óðîâåíü%s+%[(.+)%]')
				if nick and id and lvl and dist then
					if dist:find('â èíòåðüåðå') then
						dist = 'Â èíòå'
					end
					table.insert(MODULE.Wanted.new, {nick = nick, id = id, lvl = lvl, dist = dist})
				end
			end
			sampSendDialogResponse(dialogid, 0, 0, 0)
			return false
		end
	end
	
	if (isMode('hospital')) then
		if text:find("Ïðîâåðüòå è ïîäòâåðäèòå äàííûå ïåðåä âûäà÷åé ìåä êàðòû") or text:find('Âû ñîáèðàåòåñü ïðåäëîæèòü êóïèòü ìåäêàðòó') then
			sampAddChatMessage('[Radical Helper] {ffffff}Îæèäàéòå ïîêà èãðîê ïîäòâåðäèò ïîëó÷åíèå ìåä. êàðòû', message_color)
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		-- rodina
		if title:find('Âûáåðèòå ìåäêàðòó') and text:find('Íå îïðåäåëåí') and text:find('Íàáëþäàþòñÿ îòêëîíåíèÿ') then
			sampSendDialogResponse(dialogid, 1, MODULE.Binder.tag.get_medcard_status(), 0)
			return false
		end
		if title:find('Âûáîð äëèòåëüíîñòè') and text:find('Âûáåðèòå êîëè÷åñòâî äíåé íà êîòîðîå áóäåò') then
			local days = {[0] = '7', [1] = '14', [2] = '30', [3] = '60'}
			local day = days[MODULE.Binder.tag.get_medcard_days()]
			sampSendDialogResponse(dialogid, 1, 0, day)
			return false
		end
		if title:find('Âûáîð ñòîèìîñòè') and text:find('Âûáåðèòå ñóììó.+Ââåäèòå ñóììó') then
			sampSendDialogResponse(dialogid, 1, 0, MODULE.Binder.tag.get_medcard_price())
			return false
		end
	end

	if isMode('smi') then
		if MODULE.SmiEdit.skip_dialog then
			sampSendDialogResponse(dialogid, 0, 0, 0)
			MODULE.SmiEdit.skip_dialog = false
			sampSendChat('/newsredak')
			return false
		end
		if title:find('Ðåäàêòèðîâàíèå') and text:find('Îáúÿâëåíèå îò') and text:find('Ñîîáùåíèå') then
			MODULE.SmiEdit.is_active_ad = true
			MODULE.SmiEdit.ad_dialog_id = dialogid
			for line in text:gmatch("[^\n]+") do
				if line:find('^{FFFFFF}Îáúÿâëåíèå îò {FFD700}ìàðêåòîëîãà (.+) %(áèçíåñ') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Îáúÿâëåíèå îò {FFD700}ìàðêåòîëîãà (.+) %(áèçíåñ')
				elseif line:find('^{FFFFFF}Îáúÿâëåíèå îò {FFD700}ðóêîâîäñòâà ñòðàõîâîé êîìïàíèè (.+),') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Îáúÿâëåíèå îò {FFD700}ðóêîâîäñòâà ñòðàõîâîé êîìïàíèè (.+),')
				elseif line:find('^{FFFFFF}Îáúÿâëåíèå îò {FFD700}(.+),') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Îáúÿâëåíèå îò {FFD700}(.+),')
				end
				if line:find('{FFFFFF}Ñîîáùåíèå:%s+{33AA33}(.+)') then
					MODULE.SmiEdit.ad_message = line:match('{FFFFFF}Ñîîáùåíèå:%s+{33AA33}(.+)')
				elseif line:find('Ñîîáùåíèå%:.+{33AA33}(.+){FFFFFF}') then -- rodina
					MODULE.SmiEdit.ad_message = line:match('Ñîîáùåíèå%:.+{33AA33}(.+){FFFFFF}')
				end
			end
			MODULE.SmiEdit.Window[0] = true
			return false
		end
		if (title:find('Ðåäàêòèðîâàíèå') and text:find('îáû÷íûõ') and text:find('àâòîìàòè÷åñêèõ')) then
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		if title:find('Ðåäàêöèÿ') or title:find('Âûáåðèòå îá.ÿâëåíèå%:') then
			if text:find('Íà äàííûé ìîìåíò ñîîáùåíèé íåò') then
				sampSendDialogResponse(dialogid, 1, 0, 0)
				sampAddChatMessage('[Radical Helper] {ffffff}Íà äàííûé ìîìåíò íåòó îáüÿâëåíèé äëÿ ðåäàêòèðîâàíèÿ!', message_color)
				return false
			end
		end 
		if title:find('Îïåðàöèè ñ îá.ÿâëåíèåì') and button1:find('Èçìåíèòü') then -- rodina
			sampSendDialogResponse(dialogid, 1, 0, 0)	
			return false
		end
	end
	
	if (isMode('lc')) then
		if title:find("Äîðîæíûå çíàêè") and (title:find("Los Santos") or title:find("San Fierro") or title:find("Las Venturas") or title:find("Lav Venturas")) and settings.lc.auto_find_clorest_znak then
			-- çà îñíîâó âçÿòî https://www.blast.hk/threads/231943/ by áåçëèêèé
			local count = 0
			local znaks = {}
			for line in text:gmatch('[^\r\n]+') do
				count = count + 1
				if not line:find('Íàçâàíèå çíàêà') and not line:find('Óñòàíîâëåí') then
					line = string.gsub(line, "%%", "")
					line = string.gsub(line, "{[0-9a-fA-F]+}", "")
					local num, name, dist, damage, status = string.match(line, '%[(%d+)%] ([^\t]+)\t([0-9%.]+)..ì\t(%d*)\t(.*)')
					if name == nil then
						num, name, dist, status = string.match(line, '%[(%d+)%] ([^\t]+)\t([0-9%.]+)..ì\t.*\t(.*)')
						damage = 100
					end
					table.insert(znaks, {number = num, name = name, distance = dist, health = damage, status = status})
				end
			end
			local min_dist = 999999
			local nearest = nil
			for i, znak in ipairs(znaks) do
				local dist = tonumber(znak.distance)
				if dist and dist < min_dist then
					min_dist = dist
					nearest = znak
				end
			end
			if not nearest then
				sampAddChatMessage("[Radical Helper | Àññèñòåíò] {ffffff}Â äàííîì ãîðîäå âñå äîðîæíûå çíàêè â íîðìå!", message_color)
				sampSendDialogResponse(dialogid, 0, 0, "")
			else
				sampAddChatMessage("[Radical Helper | Àññèñòåíò] {ffffff}Áëèæàéøèé ê âàì çíàê " .. message_color_hex .. "¹" .. nearest.number .. " {ffffff}(äèñòàíöèÿ " .. message_color_hex .. nearest.distance .. "ì{ffffff}, ñòàòóñ " .. message_color_hex .. nearest.status .. "{ffffff})", message_color)
				sampSendDialogResponse(dialogid, 1, nearest.number-1, "")
			end
			return false
		end
		
	end
	
	if isMode('fd') then
		if title:find('Ñïèñîê ïðîèñøåñòâèé') then
			if text:find('Â äàííûé ìîìåíò âñå ñïîêîéíî') then
				sampAddChatMessage('[Radical Helper] {ffffff}Â äàííûé ìîìåíò ïîæàðîâ íåòó, ìîæåòå îòäûõàòü', message_color)
				sampSendDialogResponse(dialogid, 1, 0, 0)
				return false
			else
			-- 	MODULE.Fires.dialogId = dialogid
			-- 	MODULE.Fires.isDialog = true
				MODULE.Fires.locations = text:match('Îñòàëîñü âðåìåíè\n(.+)') .. '\n'
			-- 	sampShowDialog(999, title, text, button1, button2, style)
			end
		end
	end

	if isMode('ins') then
		if settings.ins.anti_trivoga and (text:find('Âû äåéñòâèòåëüíî õîòèòå âûçâàòü ñîòðóäíèêîâ ïîëèöèè?') or text:find('Âû äåéñòâèòåëüíî õîòèòå {FFA11C}âûçâàòü{FFFFFF} ïîëèöèþ?')) then
			sampAddChatMessage('[Radical Helper] {ffffff}Òðåâîæíàÿ êíîïêà îòêëþ÷åíà. Äëÿ âêëþ÷åíèÿ èñïîëüçóéòå /helper - Ôóíêöèè ÑÒÊ', message_color)
			sampSendDialogResponse(dialogid, 2, 0, 0)
			return false
		end
		if (settings.ins.auto_input_ticket and title:find('Çàïîëíåíèå äîêóìåíòà')) then
			local nick = text:match("{ffff00}([%w_]+)")
			local types = text:match("{ffff00}(%w+)")
			local number = text:match("{ffff00}(%d+)")
			sampSendDialogResponse(dialogid, 1, 0, nick or types or number or '')
			return false
		end
		if title:find('Çàÿâêè íà ñòðàõîâàíèå') then
			if text:find('Íà äàííûé ìîìåíò íåò çàÿâîê íà ñòðàõîâàíèå') then
				sampAddChatMessage('[Radical Helper] {ffffff}Íà äàííûé ìîìåíò íåò çàÿâîê íà ñòðàõîâàíèå!', message_color)
				sampSendDialogResponse(dialogid, 1, 0, 0)
				return false
			end
		end
	end

end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text_3d)
	if text_3d and ((isMode('gov') and settings.gov.anti_trivoga) or (isMode())) then
		if text_3d:find('Òðåâîæíàÿ êíîïêà') or text_3d:find('Êíîïêà äëÿ âûçîâà ïîëèöèè') then
			sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Òðåâîæíàÿ êíîïêà óäàëåíà èç èíòåðüåðà, ïîñêîëüêó âû îòêëþ÷èëè å¸.', message_color)
			return false
		end	
	end
end
function sampev.onPlayerChatBubble(playerid, color, distance, duration, message)
	if MODULE.DEBUG then
		sampAddChatMessage('[ChatBubble] {ffffff}ID ' .. playerid .. ' | Color ' .. color .. ' | Dist ' .. distance .. ' | Duration ' .. duration .. ' | MSG ' .. message, message_color)
		print('[ChatBubble] {ffffff}ID ' .. playerid .. ' | Color ' .. color .. ' | Dist ' .. distance .. ' | Duration ' .. duration .. ' | MSG ' .. message)
	end
	if (isMode('police') or isMode('fbi') or isMode('prison')) and settings.mj.anti_screpki then
		if message:find("(.+) äîñòàë ñêðåïêè äëÿ âçëîìà íàðó÷íèêîâ") then
			local nick = message:match(' (.+) äîñòàë ñêðåïêè äëÿ âçëîìà íàðó÷íèêîâ')
			local id = sampGetPlayerIdByNickname(nick)
			sampAddChatMessage('[Radical Helper] {ffffff}Âíèìàíèå! ' .. nick .. '[' .. id .. '] èñïîëüçóåò ñêðåïêè è íà÷èíàåò âçëàìûâàòü íàðó÷íèêè!', message_color)
			play_sound()
			local result, handle = sampGetCharHandleBySampPlayerId(id)
			if result then
				local x, y, z = getCharCoordinates(handle)
				local mx, my, mz = getCharCoordinates(PLAYER_PED)
				if getDistanceBetweenCoords3d(mx, my, mz, x, y, z) <= 1.5 then
					sampAddChatMessage('[Radical Helper] {ffffff}Ïûòàþñü èçüÿòü ñêðåïêè ó ýòîãî èãðîêà...', message_color)
					find_and_use_command('/bot {id}', id)
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Ïîäîéäèòå ê èãðîêó ' .. nick .. ' è èñïîëüçóéòå êîìàíäó /bot ' .. id, message_color)
				end
			elseif (IS_MOBILE and modules.commands.path:find('git')) then -- x64 êîñòûëü äëÿ ìîíåòêè
				sampAddChatMessage('[Radical Helper] {ffffff}Ïîäîéäèòå ê èãðîêó ' .. nick .. ' è èñïîëüçóéòå êîìàíäó /bot ' .. id, message_color)
			end
		end
	end
end
function sampev.onTogglePlayerControllable(controllable)
  	if MODULE.CruiseControl.active and not controllable then
		MODULE.CruiseControl.active = false
		clearCharTasks(PLAYER_PED)
		if isCharInAnyCar(PLAYER_PED) then
			taskWarpCharIntoCarAsDriver(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED))
		end
  	end
end
addEventHandler('onSendPacket', function(id, bs, priority, reliability, orderingChannel)
	if id == 220 then
		local idd = raknetBitStreamReadInt8(bs)
		local packettype = raknetBitStreamReadInt8(bs)
		if IS_MOBILE then
			local subtype = raknetBitStreamReadInt8(bs)
			if packettype == 66 or packettype == 63 then
				if MODULE.DEBUG then
					local unr = raknetBitStreamGetNumberOfUnreadBits(bs)
					local unrs = {}
					for i = 1, 8, 1 do
						table.insert(unrs, raknetBitStreamReadInt8(bs))
					end
					print('[SendPacket] 220 ' .. packettype .. ' ' .. subtype .. ' | Unread bits ' .. unr .. ' : ' .. table.concat(unrs, ' '))
					sampAddChatMessage('[SendPacket] 220 ' .. packettype .. ' ' .. subtype .. ' | Unread bits ' .. unr .. ' : ' .. table.concat(unrs, ' '), message_color)
				end
			end
		else
			local strlen = raknetBitStreamReadInt16(bs)
			local str = raknetBitStreamReadString(bs, strlen)
			if packettype ~= 0 and packettype ~= 1 and #str > 2 then
				if MODULE.DEBUG then
					sampAddChatMessage('[SendPacket] {ffffff}' .. str, message_color)
					print("[SendPacket] " .. str)
				end
			end
		end
	end
end)
addEventHandler('onReceivePacket', function(id, bs)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
        local cmd = raknetBitStreamReadInt8(bs)
		-- if MODULE.DEBUG then
			-- local function dumpFullBitStream(bs)
			-- 	local bitsLeft = raknetBitStreamGetNumberOfUnreadBits(bs)
			-- 	if not bitsLeft then
			-- 		print("dumpFullBitStream: raknetBitStreamGetNumberOfUnreadBits îøèáêà!")
			-- 		return
			-- 	end
			-- 	local bytesLeft = math.floor(bitsLeft / 8)
			-- 	if bytesLeft == 0 then
			-- 		print("dumpFullBitStream: íåòó äîñòóïíûõ áàéòîâ äëÿ ÷òåíèÿ")
			-- 		return
			-- 	end
			-- 	local bytes = {}
			-- 	for i = 1, bytesLeft do
			-- 		bytes[i] = raknetBitStreamReadInt8(bs)
			-- 	end
			-- 	local hexStrParts = {}
			-- 	for i, b in ipairs(bytes) do
			-- 		hexStrParts[i] = string.format("%02X", b)
			-- 	end
			-- 	return(table.concat(hexStrParts, " "))
			-- end
			-- local dump = dumpFullBitStream(bs)
			-- sampAddChatMessage('[ReceivePacket] {ffffff}' .. dump, message_color)
			-- print("[ReceivePacket] " .. dump)
		-- end
		if cmd == 153 then
            local carId = raknetBitStreamReadInt16(bs)
            raknetBitStreamIgnoreBits(bs, 8)
            local numberlen = raknetBitStreamReadInt8(bs)
            local plate_number = raknetBitStreamReadString(bs, numberlen)
            local typelen = raknetBitStreamReadInt8(bs)
            local numType = raknetBitStreamReadString(bs, typelen)
            modules.arz_veh.cache[carId] = {
                carID = carId or 0,
                number = plate_number or "",
                region = numType or "",
            }
        end
		if IS_MOBILE then 
			if cmd == 84 then
				local unk1 = raknetBitStreamReadInt8(bs)
				local unk2 = raknetBitStreamReadInt8(bs)
				local len = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local string = encoded == 0 and raknetBitStreamReadString(bs, len) or raknetBitStreamDecodeString(bs, len + encoded)
				if MODULE.DEBUG then
					sampAddChatMessage('[ReceivePacket] {ffffff}' .. string, message_color)
					print("[ReceivePacket] " .. string)
				end
			end
		else
			if cmd == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local length = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local cmd = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
				
				if MODULE.DEBUG then
					sampAddChatMessage('[ReceivePacket] {ffffff}' .. cmd, message_color)
					print("[ReceivePacket] " .. cmd)
				end

				if (cmd:find('findGame') and cmd:find(' äîêóìåíòîâ","Íàéäèòå ')) then
					if ((not isMode('ins')) or (isMode('ins') and settings.ins.hint_in_sort)) then
						local find = cmd:match('%[.+%[(.+)%]%]')
						local nums = {}
						for n in find:gmatch("%d+") do table.insert(nums, tonumber(n)) end
						table.sort(nums)
						for i = 1, #nums do nums[i] = nums[i] + 1 end
						local result = table.concat(nums, ", ")
						sampAddChatMessage("[Radical Helper | Àññèñòåíò] {ffffff}Ïðàâèëüíûå êîíâåðòû: " .. result .. ". Ñ÷èòàòü èõ íóæíî ñëåâà íàïðàâî", message_color)
						sampShowDialog(897124, 'Radical Helper - Àññèñòåíò', "Ïðàâèëüíûå êîíâåðòû: " .. result .. ".\nÑ÷èòàòü èõ íóæíî ñëåâà íàïðàâî", '{009EFF}Çàêðûòü', '', 0)
					end
				end
			end
		end
	end
end)
addEventHandler('onReceiveRpc', function(id, bs)
	if id == 123 then
        local carId = raknetBitStreamReadInt16(bs)
        local numLen = raknetBitStreamReadInt8(bs)
		local plate_number = raknetBitStreamReadString(bs, numLen)
		modules.arz_veh.cache[carId] = {
			carID = carId or 0,
			number = plate_number or "",
			type = "ARZ"
		}
	end
end)
--------------------------------------------- INIT GUI --------------------------------------------
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	imgui.GetIO().Fonts:Clear()

	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	if IS_MOBILE then
		MODULE.FONT = imgui.GetIO().Fonts:AddFontFromFileTTF(worked_dir .. '/lib/mimgui/trebucbd.ttf', 14 * settings.general.custom_dpi, _, glyph_ranges)
	else
		MODULE.FONT = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 14 * settings.general.custom_dpi, _, glyph_ranges)
	end

	fa.Init(14 * settings.general.custom_dpi)
	for key, value in pairs(fa) do
		if key ~= 'Init' then table.insert(MODULE.Icons.keys, key) end
	end
	table.sort(MODULE.Icons.keys)

	if settings.general.helper_theme == 0 and monet_no_errors then
		apply_moonmonet_theme()
	elseif settings.general.helper_theme == 1 then
		apply_dark_theme()
	elseif settings.general.helper_theme == 2 then
		apply_white_theme()
	end

	imgui.GetIO().ConfigFlags = imgui.ConfigFlags.NoMouseCursorChange

	function TextEditCallback(data)
		MODULE.INPUT.CURSOR_POS = data.CursorPos
		if data.CursorPos ~= MODULE.INPUT.CURSOR_POS or data.SelectionStart ~= MODULE.INPUT.SELECTION_START or data.SelectionEnd ~= MODULE.INPUT.SELECTION_END then
			MODULE.INPUT.USER_MOVED_CURSOR = true
		end
		MODULE.INPUT.SELECTION_START = data.SelectionStart
		MODULE.INPUT.SELECTION_END = data.SelectionEnd
		return 0
	end
	TextEditCallback = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', TextEditCallback)

end)

imgui.OnFrame(
    function() return MODULE.Initial.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.GEARS .. u8' Ïåðâè÷íàÿ íàñòðîéêà õåëïåðà ' .. fa.GEARS, MODULE.Initial.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        change_dpi()
		if MODULE.Initial.step == 0 then
			if doesFileExist(config_dir .. '/Resourse/logo.png') then
				if (not _G.helper_logo) then
					local path = config_dir .. '/Resourse/logo.png'
					_G.helper_logo = imgui.CreateTextureFromFile(path)
				else
					imgui.Image(_G.helper_logo, imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi))
				end
			else
				if imgui.BeginChild('##init1_1', imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
					imgui.Text("\n\n\n")
					imgui.CenterTextDisabled(u8('Íå óäàëîñü çàãðóçèòü äîïîëíèòåëüíûå ðåñóðñû õåëïåðà!\n\n'))
					imgui.CenterTextDisabled(u8('Äëÿ àâòîìàòè÷åñêîé çàãðóçêè âðåìåííî âêëþ÷èòå VPN èëè ñêà÷àéòå ôàéëû âðó÷íóþ'))
					imgui.CenterUnderlineText("https://github.com/MTGMODS/arizona-helper")
					if imgui.IsItemClicked() then openLink('https://github.com/MTGMODS/arizona-helper/tree/main/Resourse') end
					imgui.EndChild()
				end
			end
			imgui.CenterText(u8("Íàñòðîèì õåëïåð äëÿ êîìôîðòíîé èãðû"))
			imgui.Separator()
			imgui.CenterText(u8("Âûáåðèòå ñïîñîá íàñòðîéêè:"))
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Àâòîìàòè÷åñêè ÷åðåç /stats ') .. fa.CIRCLE_ARROW_LEFT) then
				check_stats = true
				sampSendChat('/stats')
				MODULE.Initial.Window[0] = false
			end
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Íàñòðîèòü âðó÷íóþ ') .. fa.CIRCLE_ARROW_LEFT) then
				MODULE.Initial.fraction_type_selector = 0
				MODULE.Initial.step = 1
			end
			imgui.Separator()
			imgui.CenterText(u8("Ïðîäîëæàÿ èñïîëüçîâàíèå õåëïåðà, âû ñîãëàøàåòåñü ñ:"))
			imgui.CenterUnderlineText(u8("Ïîëüçîâàòåëüñêîå ñîãëàøåíèå è ïîëèòèêà êîíôèäåíöèàëüíîñòè"))
			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.Text('https://mtgmods.com/terms')
				imgui.EndTooltip()
			end
			if imgui.IsItemClicked() then openLink('https://mtgmods.com/terms') end
		elseif MODULE.Initial.step == 1 then
			imgui.CenterText(u8('Âûáåðèòå êàòåãîðèþ âàøåé îðãàíèçàöèè:'))

			local function render_org_block(org_num, icon, name, fractions, tags)
				if imgui.BeginChild('##init1_'..org_num, imgui.ImVec2(170 * settings.general.custom_dpi, 45 * settings.general.custom_dpi), (MODULE.Initial.fraction_type_selector == org_num)) then
					if not (MODULE.Initial.fraction_type_selector == org_num) then
						imgui.SetCursorPos(imgui.ImVec2(0, 5 * settings.general.custom_dpi))
					end
					imgui.CenterText(icon .. u8(' '..name))
					imgui.CenterTextDisabled(u8(fractions))
					imgui.EndChild()
				end
				if imgui.IsItemClicked() then
					MODULE.Initial.fraction_type_selector = org_num
					MODULE.Initial.fraction_type_selector_text = name
					MODULE.Initial.fraction_type_icon = icon
				end
			end
			render_org_block(1, fa.BUILDING_SHIELD, 'Ìèí.Þñòèöèè', 'ËÑÏÄ/ËÂÏÄ/ÑÔÏÄ/ÔÁÐ/ÐÊØ')
			imgui.SameLine()
			render_org_block(2, fa.HOSPITAL, 'Ìèí.Çäðàâ.', 'ËÑÌÖ/ËÂÌÖ/ÑÔÌÖ/ÄÌÖ')
			imgui.SameLine()
			render_org_block(3, fa.BUILDING_SHIELD, 'Ìèí.Îáîðîíû', 'ËÑà/ÑÔÀ/ÂÑ/ÒÑÐ/ÔÑÈÍ')
			render_org_block(4, fa.BUILDING_NGO, 'Ìàññ.Ìåäèà', 'ÑÌÈ ËÑ/ËÂ/ÑÔ/ÂÑ/ÀÇ')
			imgui.SameLine()
			render_org_block(5, fa.BUILDING_COLUMNS, 'Öåíòðàëüíûé àïïàðàò', 'Ïðàâî/ÃÖË/ÑÒÊ/ÌÐÝÎ')
			imgui.SameLine()
			render_org_block(6, fa.HOTEL, 'Ïîæàðíàÿ ÷àñòü', 'ÏÄ')
			render_org_block(7, fa.TORII_GATE, 'Ìàôèÿ', 'YKZ/LCN/RM/WMC/TRB')
			imgui.SameLine()
			render_org_block(8, fa.BUILDING_WHEAT, 'Áàíäà', 'Ãðóâ/Áàëàñ/Ðèôà/Âàãîñ')
			imgui.SameLine()
			render_org_block(0, fa.BUILDING_CIRCLE_XMARK, 'Áåç îðãàíèçàöèè', 'Áèíäåð & Çàìåòêè')

			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Íàçàä'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.step = 0
			end
			imgui.SameLine()
			if imgui.Button(u8('Ïîäòâåðäèòü âûáîð ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.slider[0] = 1
				if MODULE.Initial.fraction_type_selector == 6 then
					MODULE.Initial.step2_result = 61
					MODULE.Initial.step = 3
				elseif MODULE.Initial.fraction_type_selector == 0 then
					modules.player.data.fraction_rank = 'Íåòó'
					modules.player.data.fraction_rank_number = 0
					MODULE.Initial.step = 4
				else
					MODULE.Initial.step = 2
				end
			end
		elseif MODULE.Initial.step == 2 then
    		imgui.CenterText(u8('Âûáåðèòå îðãàíèçàöèþ èç êàòåãîðèè "' .. MODULE.Initial.fraction_type_selector_text .. '":'))

			local function render_fraction_block(org_num, name, fraction_tag)
				if imgui.BeginChild('##init2_'..org_num, imgui.ImVec2(170 * settings.general.custom_dpi, 45 * settings.general.custom_dpi), (MODULE.Initial.fraction_selector == org_num)) then
					if not (MODULE.Initial.fraction_selector == org_num) then
						imgui.SetCursorPos(imgui.ImVec2(0, 5 * settings.general.custom_dpi))
					end
					imgui.CenterText(u8(name))
					imgui.CenterTextDisabled(u8(fraction_tag))
					imgui.EndChild()
				end
				if imgui.IsItemClicked() then
					MODULE.Initial.fraction_selector = org_num
					MODULE.Initial.fraction_selector_text = name
					MODULE.Initial.step2_result = (MODULE.Initial.fraction_type_selector * 10) + org_num
				end
			end
			local orgs = {
				[1] = {
					{name = "Ïîëèöèÿ Ëîñ-Ñàíòîñà", 			tag = "ËÑÏÄ"},
					{name = "Ïîëèöèÿ Ëàñ-Âåíòóðàñà",		tag = "ËÂÏÄ"},
					{name = "Ïîëèöèÿ Ñàí-Ôèåððî", 			tag = "ÑÔÏÄ"},
					{name = "Îáëàñòíàÿ ïîëèöèÿ", 			tag = "ÐÊØÄ"},
					{name = "S.W.A.T.", 					tag = "ÑÂÀÒ"},
					{name = "Ôåä.Áþðî Ðàññëåäîâàíèé", 		tag = "ÔÁÐ"},
					{name = "Ãîðîäñêàÿ ïîëèöèÿ", 			tag = "ÃÓÂÄ"},
					{name = "Ïîëèöèÿ îêðóãà", 				tag = "ÊÒÖ"},
					{name = "Ôåä.Ñëóæáà Áåçîïàñíîñòè", 		tag = "ÔÑÁ"},
				},
				[2] = {
					{name = "Áîëüíèöà Ëîñ-Ñàíòîñà",   		tag = "ËÑÌÖ"},
					{name = "Áîëüíèöà Ëàñ-Âåíòóðàñà", 		tag = "ËÂÌÖ"},
					{name = "Áîëüíèöà Ñàí-Ôèåððî", 			tag = "ÑÔÌÖ"},
					{name = "Áîëüíèöà Äæåôôåðñîí", 			tag = "ÄÌÖ"},
					{name = "Áîëüíèöà Âàéñ-Ñèòè", 			tag = "ÂÑÌÖ"},
					{name = "Ãîðîäñêàÿ áîëüíèöà", 			tag = "ÑÌÏ"},
					{name = "Áîëüíèöà îêðóãà", 				tag = "ÌÓÑÑ"},
				},
				[3] = {
					{name = "Àðìèÿ Ëîñ-Ñàíòîñà", 			tag = "ËÑà"},
					{name = "Àðìèÿ Ñàí-Ôèåððî", 			tag = "ÑÔà"},
					{name = "Àðìèÿ Àðçàìàñà", 				tag = "ÂÑ"},
					{name = "Òþðüìà Ñòðîãî Ðåæèìà LV", 		tag = "ÒÑÐ"},
					{name = "Ôåä.Ñëóæáà Èñï.Íàêàçàíèé", 	tag = "ÔÑÈÍ"},
				},
				[4] = {
					{name = "ÑÌÈ Ëîñ-Ñàíòîñà", 				tag = "ÑÌÈ ËÑ"},
					{name = "ÑÌÈ Ëàñ-Âåíòóðàñà", 			tag = "ÑÌÈ ËÂ"},
					{name = "ÑÌÈ Ñàí-Ôèåððî", 				tag = "ÑÌÈ ÑÔ"},
					{name = "ÑÌÈ Âàéñ-Ñèòè", 				tag = "ÑÌÈ ÂÑ"},
					{name = "ÑÌÈ Àðçàìàñà", 				tag = "ÍÀ"},
				},
				[5] = {
					{name = "Ïðàâèòåëüñòâî", 				tag = "Ïðàâî"},
					{name = "Öåíòð ëèöåíçèðîâàíèÿ", 		tag = "ÃÖË"},
					{name = "Ñòðàõîâàÿ êîìïàíèÿ", 			tag = "ÑÒÊ"},
					{name = "Ñóäüÿ", 						tag = "Ñóäüÿ"},
					{name = "ÌÐÝÎ ÃÈÁÄÄ", 					tag = "ÌÐÝÎ"},
				},
				[6] = {
					{name = "Ïîæàðíûé äåïàðòàìåíò", 		tag = "ÏÄ"},
				},
				[7] = {
					{name = "Yakuza", 						tag = "YKZ"},
					{name = "La Cosa Nostra", 				tag = "LCN"},
					{name = "Russian Mafia", 				tag = "RM"},
					{name = "Warlock MC", 					tag = "WMC"},
					{name = "Tierra Robada Bikers", 		tag = "TRB"},
					{name = "Óêðàèíñêàÿ ìàôèÿ", 			tag = "ÓÌ"},
					{name = "Êàâêàçêàÿ ìàôèÿ", 				tag = "ÊÌ"},
					{name = "Ðóññêàÿ ìàôèÿ", 				tag = "ÐÌ"},
				},
				[8] = {
					{name = "Grove Street", 				tag = "Ãðóâ"},
					{name = "East Side Ballas", 			tag = "Áàëàñ"},
					{name = "Los Santos Vagos", 			tag = "Âàãîñ"},
					{name = "The Rifa", 					tag = "Ðèôà"},
					{name = "Varrios Los Aztecas", 			tag = "Àöòåê"},
					{name = "Night Wolves", 				tag = "Âîëêè"},
				},
			}
			local org_list = orgs[MODULE.Initial.fraction_type_selector]
			for i, org in ipairs(org_list) do
				render_fraction_block(i, org.name, org.tag)
				if ((i % 3 ~= 0) and i ~= #org_list) then imgui.SameLine() end
			end

			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Íàçàä'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.step = 1
			end
			imgui.SameLine()
			if imgui.Button(u8('Ïîäòâåðäèòü âûáîð ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				if MODULE.Initial.step2_result ~= 0 then
					MODULE.Initial.step = 3
				end
			end
		elseif MODULE.Initial.step == 3 then
			imgui.CenterText(u8('Óêàæèòå âàøó äîëæíîñòü è íîìåð ðàíãà:'))
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Ââåäèòå íàçâàíèå âàøåé äîëæíîñòè...'), MODULE.Initial.input, 256)
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.SliderInt('##fraction_rank_number', MODULE.Initial.slider, 1, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Íàçàä'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				if MODULE.Initial.fraction_type_selector == 6 then
					MODULE.Initial.step = 1 
				else
					imgui.StrCopy(MODULE.Initial.input, "")
					MODULE.Initial.step = 2
				end
			end
			imgui.SameLine()
			if imgui.Button(u8('Ïðîäîëæèòü ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				modules.player.data.fraction_rank = u8:decode(ffi.string(MODULE.Initial.input))
				modules.player.data.fraction_rank_number = MODULE.Initial.slider[0]
				if modules.player.data.fraction_rank_number >= 9 then
					settings.general.auto_uninvite = true
				end
				imgui.StrCopy(MODULE.Initial.input, "")
				MODULE.Initial.step = 4
			end
		elseif MODULE.Initial.step == 4 then
			imgui.CenterText(u8('Ââåäèòå âàø ïîëíûé èãðîâîé íèêíåéì (íà àíãëèéñêîì):'))
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.InputText(u8'##input_nick', MODULE.Initial.input, 256)
			imgui.CenterTextDisabled(u8(translate(u8:decode(ffi.string(MODULE.Initial.input)))))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Íàçàä'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.StrCopy(MODULE.Initial.input, "")
				if MODULE.Initial.fraction_type_selector == 0 then
					MODULE.Initial.step = 1
				else
					MODULE.Initial.step = 3
				end
			end
			imgui.SameLine()
			if imgui.Button(u8('Çàâåðøèòü íàñòðîéêó ') .. fa.FLAG_CHECKERED, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				modules.player.data.nick = u8:decode(ffi.string(MODULE.Initial.input))
				modules.player.data.name_surname = translate(modules.player.data.nick)
				MODULE.Initial.step = 5
			end
		elseif MODULE.Initial.step == 5 then
			local fraction_modes = {
				{id = 0,  name = "Îòñóòñòâóåò",         	   mode = "none",       tag = "Íåòó"},
				{id = 11, name = "Ïîëèöèÿ Ëîñ-Ñàíòîñà",        mode = "police", 	tag = "ËÑÏÄ"},
				{id = 12, name = "Ïîëèöèÿ Ëàñ-Âåíòóðàñà",      mode = "police", 	tag = "ËÂÏÄ"},
				{id = 13, name = "Ïîëèöèÿ Ñàí-Ôèåððî",         mode = "police", 	tag = "ÑÔÏÄ"},
				{id = 14, name = "Îáëàñòíàÿ ïîëèöèÿ",          mode = "police", 	tag = "ÐÊØÄ"},
				{id = 15, name = "S.W.A.T.",                   mode = "police", 	tag = "ÑÂÀÒ"},
				{id = 16, name = "Ôåä. Áþðî Ðàññëåäîâàíèé",    mode = "fbi",    	tag = "ÔÁÐ"},
				{id = 17, name = "Ãîðîäñêàÿ ïîëèöèÿ",          mode = "police",	 	tag = "ÃÓÂÄ"},
				{id = 18, name = "Ïîëèöèÿ îêðóãà",             mode = "police", 	tag = "ÊÒÖ"},
				{id = 19, name = "Ôåä. Ñëóæáà Áåçîïàñíîñòè",   mode = "fbi",    	tag = "ÔÑÁ"},
				{id = 21, name = "Áîëüíèöà Ëîñ-Ñàíòîñà",       mode = "hospital", 	tag = "ËÑÌÖ"},
				{id = 22, name = "Áîëüíèöà Ëàñ-Âåíòóðàñà",     mode = "hospital", 	tag = "ËÂÌÖ"},
				{id = 23, name = "Áîëüíèöà Ñàí-Ôèåððî",        mode = "hospital", 	tag = "ÑÔÌÖ"},
				{id = 24, name = "Áîëüíèöà Äæåôôåðñîí",        mode = "hospital", 	tag = "ÄÌÖ"},
				{id = 25, name = "Áîëüíèöà Âàéñ-Ñèòè",         mode = "hospital", 	tag = "ÂÑÌÖ"},
				{id = 26, name = "Ãîðîäñêàÿ áîëüíèöà",         mode = "hospital", 	tag = "ÑÌÏ"},
				{id = 27, name = "Áîëüíèöà îêðóãà",            mode = "hospital", 	tag = "ÌÓÑÑ"},
				{id = 31, name = "Àðìèÿ Ëîñ-Ñàíòîñà",          mode = "army", 		tag = "ËÑà"},
				{id = 32, name = "Àðìèÿ Ñàí-Ôèåððî",           mode = "army", 		tag = "ÑÔà"},
				{id = 33, name = "Àðìèÿ Àðçàìàñà",             mode = "army", 		tag = "ÂÑ"},
				{id = 34, name = "Òþðüìà Ñòðîãîãî Ðåæèìà LV",  mode = "prison", 	tag = "ÒÑÐ"},
				{id = 35, name = "Ôåä. Ñëóæáà Èñï. Íàêàçàíèé", mode = "prison", 	tag = "ÔÑÈÍ"},
				{id = 41, name = "ÑÌÈ Ëîñ-Ñàíòîñà",            mode = "smi",	 	tag = "ÑÌÈ ËÑ"},
				{id = 42, name = "ÑÌÈ Ëàñ-Âåíòóðàñà",          mode = "smi", 		tag = "ÑÌÈ ËÂ"},
				{id = 43, name = "ÑÌÈ Ñàí-Ôèåððî",             mode = "smi", 		tag = "ÑÌÈ ÑÔ"},
				{id = 44, name = "ÑÌÈ Âàéñ-Ñèòè",              mode = "smi", 		tag = "ÑÌÈ ÂÑ"},
				{id = 45, name = "ÑÌÈ Àðçàìàñà",               mode = "smi", 		tag = "ÍÀ"},
				{id = 51, name = "Ïðàâèòåëüñòâî",              mode = "gov", 		tag = "Ïðàâî"},
				{id = 52, name = "Öåíòð ëèöåíçèðîâàíèÿ",       mode = "lc", 		tag = "ÃÖË"},
				{id = 53, name = "Ñòðàõîâàÿ êîìïàíèÿ",         mode = "ins", 		tag = "ÑÒÊ"},
				{id = 54, name = "Ñóäüÿ",                      mode = "judge", 		tag = "Ñóäüÿ"},
				{id = 55, name = "ÌÐÝÎ ÃÈÁÄÄ",                 mode = "lc", 		tag = "ÌÐÝÎ"},
				{id = 61, name = "Ïîæàðíûé äåïàðòàìåíò",       mode = "fd", 		tag = "ÏÄ"},
				{id = 71, name = "Yakuza",                     mode = "mafia",		tag = "YKZ"},
				{id = 72, name = "La Cosa Nostra",             mode = "mafia", 		tag = "ËÊÍ"},
				{id = 73, name = "Russian Mafia",              mode = "mafia", 		tag = "ÐÌ"},
				{id = 74, name = "Warlock MC",                 mode = "mafia", 		tag = "WMC"},
				{id = 75, name = "Tierra Robada Bikers",       mode = "mafia", 		tag = "ÒÐÁ"},
				{id = 76, name = "Óêðàèíñêàÿ ìàôèÿ",           mode = "mafia", 		tag = "ÓÌ"},
				{id = 77, name = "Êàâêàçñêàÿ ìàôèÿ",           mode = "mafia", 		tag = "ÊÌ"},
				{id = 78, name = "Ðóññêàÿ ìàôèÿ",              mode = "mafia", 		tag = "ÐÌ"},
				{id = 81, name = "Grove Street",               mode = "ghetto", 	tag = "Ãðóâ"},
				{id = 82, name = "East Side Ballas",           mode = "ghetto", 	tag = "Áàëàñ"},
				{id = 83, name = "Los Santos Vagos",           mode = "ghetto", 	tag = "Âàãîñ"},
				{id = 84, name = "The Rifa",                   mode = "ghetto", 	tag = "Ðèôà"},
				{id = 85, name = "Varrios Los Aztecas",        mode = "ghetto", 	tag = "Àöòåê"},
				{id = 86, name = "Night Wolves",               mode = "ghetto", 	tag = "Âîëêè"},
			}
			for index, value in ipairs(fraction_modes) do
				if value.id == MODULE.Initial.step2_result then
					settings.general.fraction_mode = value.mode
					modules.player.data.fraction = value.name
					modules.player.data.fraction_tag = value.tag
					break
				end
			end
			import_fraction_data(settings.general.fraction_mode)
			save_settings()
			save_module('player')
			save_module('departament')
			reload_script = true
			thisScript():reload()
		end
        imgui.End()
    end
)
--------------------------------------------- MAIN GUI --------------------------------------------
imgui.OnFrame(
    function() return MODULE.Main.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 430	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. " Radical Helper " .. getHelperIcon() .. "##main", MODULE.Main.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar(u8'Ïðèâåò!') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' Ãëàâíîå ìåíþ') then
				if doesFileExist(config_dir .. '/Resourse/logo.png') then
					if (not _G.helper_logo) then
						local path = config_dir .. '/Resourse/logo.png'
						_G.helper_logo = imgui.CreateTextureFromFile(path)
					else
						imgui.Image(_G.helper_logo, imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi))
					end
				else
					if imgui.BeginChild('##1000000000000', imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi), true) then
						imgui.Text("\n\n\n")
						imgui.CenterTextDisabled(u8('Íå óäàëîñü çàãðóçèòü äîïîëíèòåëüíûå ðåñóðñû õåëïåðà!\n\n'))
						imgui.CenterTextDisabled(u8('Äëÿ àâòîìàòè÷åñêîé çàãðóçêè âðåìåííî âêëþ÷èòå VPN èëè ñêà÷àéòå ôàéëû âðó÷íóþ'))
						imgui.CenterUnderlineText("https://github.com/MTGMODS/arizona-helper")
						if imgui.IsItemClicked() then openLink('https://github.com/MTGMODS/arizona-helper/tree/main/Resourse') end
						imgui.EndChild()
					end
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 169 * settings.general.custom_dpi), true) then
					imgui.CenterText(getUserIcon() .. u8' Èíôîðìàöèÿ î âàøåì ïåðñîíàæå ' .. getUserIcon())
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Èìÿ è ôàìèëèÿ:")
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(modules.player.data.name_surname))
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##name_surname') then
						modules.player.data.name_surname = translate(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						imgui.StrCopy(MODULE.Main.input, u8(modules.player.data.name_surname))
						imgui.StrCopy(MODULE.Initial.input, u8(modules.player.data.nick))
						imgui.OpenPopup(getUserIcon() .. u8' Èìÿ è ôàìèëèÿ ' .. getUserIcon() .. '##name_surname')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Èçìåíèòü ñâîé íèê')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getUserIcon() .. u8' Èìÿ è ôàìèëèÿ ' .. getUserIcon() .. '##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##name_surname', u8('Ââåäèòå èìÿ è ôàìèëèþ âàøåãî ïåðñîíàæà...'), MODULE.Main.input, 256)
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						if imgui.InputTextWithHint(u8'##nickname', u8('Ââåäèòå âàø èãðîâîé íèêíåéì...'), MODULE.Initial.input, 256) then
							imgui.StrCopy(MODULE.Main.input, u8(translate(u8:decode(ffi.string(MODULE.Initial.input)))))
						end
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##save_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							modules.player.data.name_surname = u8:decode(ffi.string(MODULE.Main.input))
							modules.player.data.nick = u8:decode(ffi.string(MODULE.Initial.input))
							save_module('player')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.NextColumn()
					imgui.Columns(1)
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Ïîë:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(modules.player.data.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##sex') then
						modules.player.data.sex = (modules.player.data.sex ~= 'Ìóæ÷èíà') and 'Ìóæ÷èíà' or 'Æåíùèíà'
						save_module('player')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Èçìåíèòü ïîë ïåðñîíàæà')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Îðãàíèçàöèÿ:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(modules.player.data.fraction))
					imgui.NextColumn()
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. "##fraction") then
						imgui.StrCopy(MODULE.Main.input, u8(modules.player.data.fraction))
						imgui.OpenPopup(getHelperIcon() .. u8' Îðãàíèçàöèÿ ' .. getHelperIcon() .. '##fraction')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Îðãàíèçàöèÿ ' .. getHelperIcon() .. '##fraction', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_name', u8('Ââåäèòå íàçâàíèå âàøåé îðãàíèçàöèè...'), MODULE.Main.input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##save_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							modules.player.data.fraction = u8:decode(ffi.string(MODULE.Main.input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.GEAR .. '##fraction') then
						imgui.OpenPopup(getHelperIcon() .. u8' Ñìåíà îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Ïîëíàÿ ñìåíà îðãàíèçàöèè')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Ñìåíà îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8('Âû äåéñòâèòåëüíî õîòèòå èçìåíèòü îðãàíèçàöèþ?'))
						imgui.CenterText(u8('Âñå ñòàíäàðòíûå ôðàêöèîííûå RP êîìàíäû áóäóò ñáðîøåíû!'))
						imgui.CenterText(u8('Íî âàøè ëè÷íûå RP êîìàíäû, êîòîðûå âû äîáàâëÿëè, ñîõðàíÿòüñÿ'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_new_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.GEARS .. u8' Ñìåíèòü ôðàêöèþ##reset_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							delete_default_fraction_cmds(modules.commands.data.commands.my, get_fraction_cmds(settings.general.fraction_mode, false))
							delete_default_fraction_cmds(modules.commands.data.commands_manage.my, get_fraction_cmds(settings.general.fraction_mode, true))
							MODULE.Initial.Window[0] = true
							MODULE.Main.Window[0] = false
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Äîëæíîñòü:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(modules.player.data.fraction_rank) .. " (" .. modules.player.data.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. "##rank") then
						imgui.StrCopy(MODULE.Main.input, u8(modules.player.data.fraction_rank))
						MODULE.Main.slider.rank[0] = modules.player.data.fraction_rank_number
						imgui.OpenPopup(getHelperIcon() .. u8' Äîëæíîñòü â îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction_rank')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Äîëæíîñòü â îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction_rank', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Ââåäèòå íàçâàíèå âàøåé äîëæíîñòè...'), MODULE.Main.input, 256)
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.SliderInt('##fraction_rank_number', MODULE.Main.slider.rank, 1, 10) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##save_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							local old_rank_number = modules.player.data.fraction_rank_number
							modules.player.data.fraction_rank = u8:decode(ffi.string(MODULE.Main.input))
							modules.player.data.fraction_rank_number = MODULE.Main.slider.rank[0]
							save_module('player')
							if old_rank_number < 9 and modules.player.data.fraction_rank_number >= 9 then
								sampAddChatMessage("[ARZ HELPER BY MOONLITH] {FFFFFF}Ïîñêîëüêó âû ñòàëè " .. (modules.player.data.fraction_rank_number == 10 and 'ëèäåðîì' or 'çàìåñòèòåëåì') .. ", íóæíî ïåðåçàãðóçèòü õåëïåð äëÿ ïðåìåíåíèÿ äîï.ôóíêöèé. Ïåðåçàãðóçêà...", message_color)
								reload_script = true
								thisScript():reload()
							end	
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PASSPORT .. '##stats') then
						check_stats = true
						sampSendChat('/stats')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Ïîëó÷èòü äàííûå èç /stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Òåã îðãàíèçàöèè:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(modules.player.data.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##fraction_tag') then
						imgui.StrCopy(MODULE.Main.input, u8(modules.player.data.fraction_tag))
						imgui.OpenPopup(getHelperIcon() .. u8' Òåã îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction_tag')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Èçìåíèòü òåã îðãàíèçàöèè')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Òåã îðãàíèçàöèè ' .. getHelperIcon() .. '##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', MODULE.Main.input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##save_fraction_tag', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							modules.player.data.fraction_tag = u8:decode(ffi.string(MODULE.Main.input))
							save_module('player')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
				imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 27 * settings.general.custom_dpi), true) then
					if thisScript().version:find('SUPPORT') then
						imgui.SetCursorPosY(7 * settings.general.custom_dpi)
						imgui.CenterText(fa.CROWN .. u8("SUPPORT-ïîëüçîâàòåëü" .. MODULE.Activate.user .. "[" .. MODULE.Activate.uid .. "]. Âàì äîñòóïíû âñå ôóíêöèè. ") .. fa.CROWN)
					else
						imgui.Columns(2)
						imgui.Text(fa.CROWN .. u8"Âû ìîæåòå ïðèîáðåñòè ïîäïèñêó, ïîääåðæàâ ðàçâèòèå äàííîãî õåëïåðà " .. fa.CROWN)
						imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
						imgui.NextColumn()
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.CROWN .. u8' SUPPORT ïîäïèñêà íà õåëïåð ' .. fa.CROWN, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
							change_dpi()
							imgui.CenterUnderlineText(u8("https://mtgmods.com/vip"))
							if imgui.IsItemHovered() then
								imgui.SetTooltip('https://mtgmods.com/vip')
							end
							if imgui.IsItemClicked() then openLink('https://mtgmods.com/vip') imgui.CloseCurrentPopup() end
							imgui.Separator()
							imgui.CenterText(u8'Ëèáî ñâÿæèòåñü ñ STRIPTISFUNCLUB:')
							if imgui.Button(u8('Telegram'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
								openLink('https://t.me/mtgmods/60')
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(u8('Discord(Âðåìåííî îòñóñòâóåò)'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
								--openLink(' ')
								imgui.CloseCurrentPopup()
							end
							imgui.End()
						end
						imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
						imgui.Columns(1)
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' Êîìàíäû è RP-îòûãðîâêè') then 
				if imgui.BeginTabBar('Ñïèñîê âñåõ êîìàíä') then
					if imgui.BeginTabItem(fa.BARS..u8' Ñòàíäàðòíûå êîìàíäû') then 
						if imgui.BeginChild('##standart_cmds', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							imgui.Columns(2)
							imgui.CenterColumnText(u8"Êîìàíäà")
							imgui.SetColumnWidth(-1, 220 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Îïèñàíèå")
							imgui.SetColumnWidth(-1, 400 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							if settings.general.rp_guns then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/rpguns")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Íàñòðîéêà RP îòûãðîâîê îðóæèÿ")
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/pnv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Íàäåòü/ñíÿòü î÷êè íî÷íîãî âèäåíèÿ")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/irv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Íàäåòü/ñíÿòü èíôðàêðàñíûå î÷êè")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/cruise")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Àäàïòèâíûé êðóèç-êîíòðîëü")
							imgui.Columns(1)
							imgui.Separator()
							if not isMode('none') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/mb")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Êàñòîìíûé /members")
								imgui.Columns(1)
								imgui.Separator()
							end
							if modules.player.data.fraction_rank_number >= 6 then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/frp")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Âûäàòü /fractionrp â ðàäèóñå")
								imgui.Columns(1)
								imgui.Separator()
							end
							if not (isMode('ghetto') or isMode('mafia') or isMode('none')) then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/dep")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ðàöèÿ äåïàðòàìåíòà")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ïðîâåäåíèå ñîáåñåäîâàíèÿ")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/post")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ ñèñòåìû ïîñòîâ")
								imgui.Columns(1)
								imgui.Separator()
							end
							if isMode('gov') and settings.gov.custom_zeks then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/zeks")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ ñïèñêà çàêëþ÷åííûõ")
								imgui.Columns(1)
								imgui.Separator()
							end
							if isMode('prison') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/pum")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ óìíîãî ïîâûøåíèÿ ñðîêà")
								imgui.Columns(1)
								imgui.Separator()
							elseif isMode('police') or isMode('fbi') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/wanteds")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ îáùåãî ñïèñêà /wanted")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/patrool")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ ïàòðóëèðîâàíèÿ")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/sum")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ óìíîé âûäà÷è ðîçûñêà")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/tsm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ìåíþ óìíîé âûäà÷è øòðàôîâ")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/afind")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Ôëóäåð /find äëÿ ïîèñêà èãðîêà ïî ID")
								imgui.Columns(1)
							end
							imgui.EndChild()
						end
						imgui.EndTabItem()
					end
					function render_cmds(isManage)
						local cmd_array = (isManage and modules.commands.data.commands_manage.my or modules.commands.data.commands.my)
						if imgui.BeginChild('##' .. (isManage and 1 or 2), imgui.ImVec2(589 * settings.general.custom_dpi, 308 * settings.general.custom_dpi), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"Êîìàíäà")
							imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Îïèñàíèå")
							imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Äåéñòâèå")
							imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							if isManage then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Çàñïàâíèòü òðàíñïîðò îðãàíèçàöèè")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/fcleaner")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Óâîëèòü íåàêòèâíûõ ÷ëåíîâ îðãàíèçàöèè")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
							else
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/stop")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Îñòàíîâèòü îòûãðîâêó ëþáîé RP êîìàíäû")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
							end
							for index, command in ipairs(cmd_array) do
								imgui.Columns(3)
								if command.enable then imgui.CenterColumnText('/' .. u8(command.cmd)) else imgui.CenterColumnTextDisabled('/' .. u8(command.cmd)) end
								imgui.NextColumn()
								if command.enable then imgui.CenterColumnText(u8(command.description)) else imgui.CenterColumnTextDisabled(u8(command.description)) end
								imgui.NextColumn()
								imgui.Text('  ')
								imgui.SameLine()
								if imgui.SmallButton((command.enable and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##' .. index) then
									command.enable = not command.enable
									save_module('commands')
									if command.enable then
										register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
									else
										sampUnregisterChatCommand(command.cmd)
									end
								end
								if imgui.IsItemHovered() then
									local tooltip = command.enable and "Îòêëþ÷åíèå êîìàíäû /" or "Âêëþ÷åíèå êîìàíäû /"
									imgui.SetTooltip(u8(tooltip .. command.cmd))
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. index) then
									if command.arg == '' then
										MODULE.Binder.ComboTags[0] = 0
									elseif command.arg == '{arg}' then	
										MODULE.Binder.ComboTags[0] = 1
									elseif command.arg == '{id}' then
										MODULE.Binder.ComboTags[0] = 2
									elseif command.arg == '{id} {arg}' then
										MODULE.Binder.ComboTags[0] = 3
									elseif command.arg == '{id} {number} {arg}' then
										MODULE.Binder.ComboTags[0] = 4
									end
									MODULE.Binder.data = {
										change_waiting = command.waiting,
										change_cmd = command.cmd,
										change_text = command.text:gsub('&', '\n'),
										change_arg = command.arg,
										change_bind = command.bind,
										create_command_9_10 = isManage
									}
									MODULE.Binder.input_description = imgui.new.char[256](u8(command.description))
									MODULE.Binder.input_cmd = imgui.new.char[256](u8(command.cmd))
									MODULE.Binder.input_text = imgui.new.char[8192](u8(MODULE.Binder.data.change_text))
									MODULE.Binder.waiting_slider = imgui.new.float(tonumber(command.waiting))	
									MODULE.Binder.Window[0] = true
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Èçìåíåíèå êîìàíäû /"..command.cmd)
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.TRASH_CAN .. '##' .. index) then
									imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. index)
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Óäàëåíèå êîìàíäû /"..command.cmd)
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##'  .. index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
									change_dpi()
									imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' .. u8(command.cmd) .. '?')
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##delete_cmd' .. index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü##delete_cmd' .. index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										sampUnregisterChatCommand(command.cmd)
										table.remove(cmd_array, index)
										save_module('commands')
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8' Ñîçäàòü íîâóþ êîìàíäó##new_cmd' .. (isManage and 1 or 2), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local my_cmds = isManage and #modules.commands.data.commands_manage.my or #modules.commands.data.commands.my
							local max_cmds = #get_fraction_cmds(settings.general.fraction_mode, isManage) + 10
			
							local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '2', bind = "{}" }
							table.insert(cmd_array, new_cmd)
							MODULE.Binder.data = {
								change_waiting = new_cmd.waiting,
								change_cmd = new_cmd.cmd,
								change_text = new_cmd.text,
								change_arg = new_cmd.arg,
								change_bind = new_cmd.bind,
								create_command_9_10 = isManage
							}
							MODULE.Binder.ComboTags[0] = 0
							MODULE.Binder.input_description = imgui.new.char[256]("")
							MODULE.Binder.input_cmd = imgui.new.char[256]("")
							MODULE.Binder.input_text = imgui.new.char[8192]("")
							MODULE.Binder.waiting_slider = imgui.new.float(1.5)
							MODULE.Binder.Window[0] = true
						end
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP-êîìàíäû') then 
						render_cmds(false)
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP-êîìàíäû (9/10)') then 
						if modules.player.data.fraction_rank_number == 9 or modules.player.data.fraction_rank_number == 10 then
							render_cmds(true)
						else
							if imgui.BeginChild('##no_rank_access', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
								imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8" Âíèìàíèå " .. fa.TRIANGLE_EXCLAMATION)
								imgui.Separator()
								imgui.CenterText(u8"Ó âàñ íåòó äîñòóïà ê äàííûì êîìàíäàì!")
								imgui.CenterText(u8"Íåîáõîäèìî èìåòü 9 èëè 10 ðàíã, ó âàñ æå - " .. modules.player.data.fraction_rank_number .. u8" ðàíã!")
								imgui.Separator()
								imgui.EndChild()
							end
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.COMPASS .. u8' Ôàñò Ìåíþ') then 
						function render_fastmenu(name, use, text, text2)
							if imgui.BeginChild('##fastmenu'..name, imgui.ImVec2(193.3 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
								imgui.CenterText(u8(name))
								imgui.Separator()
								imgui.CenterText(u8("Èñïîëüçîâàíèå:"))
								if name == 'Leader FastMenu' and modules.player.data.fraction_rank_number < 9 then
									imgui.CenterText(u8"Âàì íåäîñòóïíî, âû íå 9/10")
								else
									imgui.CenterText(use)
								end
								imgui.SetCursorPosY(120 * settings.general.custom_dpi)
								imgui.CenterText(fa.CIRCLE_INFO .. u8(" Îïèñàíèå:"))
								imgui.CenterText(u8(text))
								imgui.SetCursorPosY(210 * settings.general.custom_dpi)
								imgui.CenterText(fa.TAG .. u8(" Òðåáóåòñÿ àðãóìåíò:"))
								imgui.CenterText(u8(text2))
								imgui.SetCursorPosY(308 * settings.general.custom_dpi)
								if imgui.Button(fa.GEAR .. u8(' Íàñòðîèòü êîìàíäû ìåíþ ') .. "##" .. name) then
									if name == 'Leader FastMenu' and modules.player.data.fraction_rank_number < 9 then
										sampAddChatMessage('[Radical Helper] {ffffff}Äàííîå ëèäåðñêîå ôàñòìåíþ äîñòóïíî òîëüêî äëÿ 9 èëè 10 ðàíãà!', message_color)
									else
										imgui.OpenPopup(fa.COMPASS .. u8' Íàñòðîéêà êîìàíä â ' .. u8(name) .. ' ' .. fa.COMPASS .. "##" .. name)
									end
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.COMPASS .. u8' Íàñòðîéêà êîìàíä â ' .. u8(name) .. ' ' .. fa.COMPASS .. "##" .. name, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
									change_dpi()
									if imgui.BeginChild('##fastmenu_configurige'..name, imgui.ImVec2(591 * settings.general.custom_dpi, 365 * settings.general.custom_dpi), true) then
										local arr = (name == 'Leader FastMenu') and modules.commands.data.commands_manage.my or modules.commands.data.commands.my
										imgui.Columns(3)
										imgui.CenterColumnText(u8"Íàõîæäåíèå â ìåíþ")
										imgui.SetColumnWidth(-1, 160 * settings.general.custom_dpi)
										imgui.NextColumn()
										imgui.CenterColumnText(u8"Êîìàíäà")
										imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
										imgui.NextColumn()
										imgui.CenterColumnText(u8"Îïèñàíèå")
										imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
										imgui.Columns(1)
										local no_id_commands = true
										for index, value in ipairs(arr) do
											if (value.arg == "{id}") then
												no_id_commands = false
												imgui.Separator()
												imgui.Columns(3)
												local btn = (value.in_fastmenu) and (fa.SQUARE_CHECK .. u8'  (åñòü)') or (fa.SQUARE .. u8'  (íåòó)')
												if imgui.CenterColumnSmallButton(btn .. '##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
													value.in_fastmenu = not value.in_fastmenu
													save_module('commands')
												end
												imgui.NextColumn()
												imgui.CenterColumnText('/' .. value.cmd)
												imgui.NextColumn()
												imgui.CenterColumnText(u8(value.description))
												imgui.Columns(1)
											end
										end
										if no_id_commands then
											imgui.Separator()
											imgui.NewLine()
											imgui.NewLine()
											imgui.NewLine()
											imgui.NewLine()
											imgui.NewLine()
											imgui.NewLine()
											imgui.NewLine()
											imgui.Separator()
											imgui.CenterText(fa.CIRCLE_EXCLAMATION .. u8" Âíèìàíèå " .. fa.CIRCLE_EXCLAMATION)
											imgui.CenterText(u8("Ó âàñ íåòó RP êîìàíä, êîòîðûå ïðèíèìàþò è èñïîëüçóþò àðãóìåíò {id}"))
											local list_name = (name == 'Leader FastMenu') and "'RP êîìàíäû (9/10)'" or "'RP êîìàíäû'"
											imgui.CenterText(u8("Äîáàâüòå èõ â ðàçäåëå 'Êîìàíäû è RP îòûãðîâêè' - " .. list_name))
										end
										imgui.Separator()
										imgui.EndChild()
									end
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##close_fast', imgui.ImVec2(591 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.EndChild()
							end
						end
						render_fastmenu('FastMenu', u8'/hm ID èëè ' .. fa.KEYBOARD .. (IS_MOBILE and u8' Êíîïî÷êè' or u8' Hotkeys'), 'Áûñòðûå RP êîìàíäû', '{id}')
						imgui.SameLine()
						render_fastmenu('Leader FastMenu', u8'/lm ID' .. (IS_MOBILE and '' or (u8' èëè ' .. fa.KEYBOARD .. u8' Hotkeys')), 'Áûñòðûå RP êîìàíäû 9-10', '{id}')
						imgui.SameLine()
						if imgui.BeginChild('##piemenu_editor', imgui.ImVec2(193.3 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							imgui.CenterText(u8("PieMenu"))
							imgui.Separator()
							imgui.CenterText(u8("Èñïîëüçîâàíèå:"))
							if IS_MOBILE then
								imgui.CenterText(fa.KEYBOARD .. u8' Êíîïî÷êè')
							else
								imgui.CenterText(fa.COMPUTER_MOUSE .. u8' ÑÊÌ (êîë¸ñèêî)')
								if imgui.CenterButton(settings.general.piemenu and fa.TOGGLE_ON .. u8(' Îòêëþ÷èòü') or fa.TOGGLE_OFF .. u8(' Âêëþ÷èòü')) then
									if pie_no_errors then
										settings.general.piemenu = not settings.general.piemenu
										MODULE.PieMenu.Window[0] = settings.general.piemenu
										save_settings()
									else
										sampAddChatMessage('[Radical Helper] {ffffff}Ó âàñ îòñóñòâóåò áèáëèîòåêà PieMenu, íåâîçìîæíî âêëþ÷èòü/íàñòðîèòü êðóãîâîå ìåíþ!', message_color)
									end
								end
							end
							imgui.SetCursorPosY(120 * settings.general.custom_dpi)
							imgui.CenterText(fa.CIRCLE_INFO .. u8(" Îïèñàíèå:"))
							imgui.CenterText(u8('Áûñòðûé âûçîâ êîìàíä'))
							imgui.SetCursorPosY(210 * settings.general.custom_dpi)
							imgui.CenterText(fa.TAG .. u8(" Òðåáóåòñÿ àðãóìåíò:"))
							imgui.CenterText(u8('Áåç àðãóìåíòà'))
							imgui.SetCursorPosY(308 * settings.general.custom_dpi)
							if imgui.Button(fa.GEAR .. u8(' Íàñòðîèòü êðóãîâîå ìåíþ ')) then
								if pie_no_errors then
									MODULE.PieMenu.editor.current = modules.piemenu.data
									imgui.OpenPopup(fa.COMPASS .. u8' Íàñòðîéêà PieMenu ' .. fa.COMPASS)
								else
									sampAddChatMessage('[Radical Helper] {ffffff}Ó âàñ îòñóñòâóåò áèáëèîòåêà PieMenu, íåâîçìîæíî âêëþ÷èòü/íàñòðîèòü êðóãîâîå ìåíþ!', message_color)
								end
							end
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(fa.COMPASS .. u8' Íàñòðîéêà PieMenu ' .. fa.COMPASS, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
								change_dpi()
								if imgui.BeginChild('##piemenu_configurige', imgui.ImVec2(591 * settings.general.custom_dpi, 365 * settings.general.custom_dpi), true) then
									if MODULE.PieMenu.editor.title ~= '' then
										imgui.CenterText(u8('Ðåäàêòèðîâàíèå ïîäìåíþ ') ..iconTextFormat(MODULE.PieMenu.editor.title))
										imgui.Separator()
									end
									for i, item in ipairs(MODULE.PieMenu.editor.current) do
										imgui.Columns(2)
										imgui.BulletText(iconTextFormat(item))
										imgui.NextColumn()
										if imgui.Button(fa.PEN_TO_SQUARE .. '##edit_' .. i) then
											MODULE.PieMenu.editor.item   = item
											MODULE.PieMenu.editor.name   = imgui.new.char[64](u8(item.name))
											MODULE.PieMenu.editor.action = imgui.new.char[256](u8(item.action or ''))
											MODULE.PieMenu.editor.icon   = item.icon or ''
											imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå ýëåìåíòà ' .. fa.PEN_TO_SQUARE)
										end
										imgui.SameLine()
										if item.next then
											if imgui.Button(fa.GEAR .. '##open_' .. i) then
												table.insert(MODULE.PieMenu.editor.history, {title = MODULE.PieMenu.editor.title, items = MODULE.PieMenu.editor.current})
												MODULE.PieMenu.editor.current = item.next
												MODULE.PieMenu.editor.title = item
											end
											imgui.SameLine()
										end
										imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
										if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. item.name .. i, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
											change_dpi()
											imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü ' .. u8(item.next and 'ïîäìåíþ ' or 'ïóíêò ') .. iconTextFormat(item) .. '?')
											imgui.Separator()
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##delete' .. i, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
												imgui.CloseCurrentPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü##delete' .. i, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
												table.remove(MODULE.PieMenu.editor.current, i)
												save_module('piemenu')
												imgui.CloseCurrentPopup()
											end
											imgui.End()
										end
										if imgui.Button(fa.TRASH_CAN .. '##del' .. i) then
											imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. item.name .. i)
										end
										imgui.Columns(1)
										imgui.Separator()
									end
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå ýëåìåíòà ' .. fa.PEN_TO_SQUARE, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										change_dpi()
										imgui.CenterText(fa.SIGNATURE .. u8' Íàçâàíèå:')
										imgui.PushItemWidth(205 * settings.general.custom_dpi)
										imgui.InputTextWithHint(u8'##name', u8'Ëó÷øå EN äëÿ ìåíüøåãî ðàçìåðà', MODULE.PieMenu.editor.name, 64)
										imgui.Separator()
										
										---@diagnostic disable-next-line: inject-field, undefined-field
										if not MODULE.PieMenu.editor.item.next then
											imgui.CenterText(fa.CIRCLE_PLAY ..  u8' Äåéñòâèå (â ÷àò):')
											imgui.PushItemWidth(205 * settings.general.custom_dpi)
											imgui.InputTextWithHint(u8'##action', u8'Ëþáîé òåêñò/êîìàíäà äëÿ ÷àòà', MODULE.PieMenu.editor.action, 256)
										else
											imgui.CenterText(fa.CIRCLE_PLAY ..  u8' Äåéñòâèå:')
											imgui.CenterText(u8'Îòêðûâàåò ïóíêòû âíóòðè ñåáÿ')
										end
										imgui.Separator()
										imgui.CenterText(fa.IMAGE .. u8' Èêîíêà â èíòåðôåéñå:')
										if MODULE.PieMenu.editor.icon ~= '' then
											imgui.SameLine()
											imgui.Text(fa[MODULE.PieMenu.editor.icon])
										end
										imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
										imgui.SetNextWindowSize(imgui.ImVec2(250 * settings.general.custom_dpi, 295 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
										if imgui.BeginPopupModal(fa.IMAGE .. u8' Âûáîð èêîíêè ýëåìåíòà PieMenu ' .. fa.IMAGE, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
											imgui.PushItemWidth(240 * settings.general.custom_dpi)
											imgui.InputTextWithHint('##icon_filter', u8'Èùèòå èêîíêè ïî íàçâàíèþ íà àíãë...', MODULE.Icons.input, 32)
											local filter = ffi.string(MODULE.Icons.input):upper()
											imgui.GetStyle().ScrollbarSize = 17 * settings.general.custom_dpi
											if imgui.BeginChild('##icons', imgui.ImVec2(240 * settings.general.custom_dpi, 200 * settings.general.custom_dpi), true) then
												for _, key in ipairs(MODULE.Icons.keys) do
													if filter == '' or key:find(filter, 1, true) then
														if imgui.Selectable(fa[key] .. ' ' .. key) then
															MODULE.PieMenu.editor.icon = key
															imgui.CloseCurrentPopup()
														end
													end
												end
												imgui.EndChild()
											end
											imgui.GetStyle().ScrollbarSize = (IS_MOBILE and 15 or 10) * settings.general.custom_dpi
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
												imgui.CloseCurrentPopup()
											end
											imgui.EndPopup()
										end
										if imgui.Button(fa.HAND_POINT_RIGHT .. u8' Âûáðàòü èêîíêó èç ñïèñêà ' .. fa.HAND_POINT_LEFT) then
											imgui.OpenPopup(fa.IMAGE .. u8' Âûáîð èêîíêè ýëåìåíòà PieMenu ' .. fa.IMAGE)
										end
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##pie_editor', imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##pie_editor', imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											---@diagnostic disable: inject-field, undefined-field
											MODULE.PieMenu.editor.item.name = u8:decode(ffi.string(MODULE.PieMenu.editor.name))
											MODULE.PieMenu.editor.item.icon = MODULE.PieMenu.editor.icon
											if not MODULE.PieMenu.editor.item.next then
												MODULE.PieMenu.editor.item.action = u8:decode(ffi.string(MODULE.PieMenu.editor.action))
											end
											---@diagnostic enable: inject-field, undefined-field
											save_module('piemenu')
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
									imgui.EndChild()
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' Âûáåðèòå ÷òî èìåííî íóæíî äîáàâèòü ' .. fa.CIRCLE_PLUS, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
									change_dpi()
									if imgui.ItemSelector(u8'', { u8'Îäèí ïóíêò', u8'Ïîäìåíþ äëÿ ïóíêòîâ' }, MODULE.PieMenu.editor.selector, 200 * settings.general.custom_dpi) then
										local bool = (MODULE.PieMenu.editor.selector[0] ~= 2)
										local number = #MODULE.PieMenu.editor.current
										if number < (thisScript().version:find('VIP') and 8 or 5) then
											number = number + 1
											if bool then
												table.insert(MODULE.PieMenu.editor.current, {name = 'Item ' .. number, icon = '', action = 'Item ' .. number})
											else
												table.insert(MODULE.PieMenu.editor.current, {name = 'SubMenu ' .. number, icon = '', next = {}})
											end
											save_module('piemenu')
										else
											if thisScript().version:find('VIP') then
												sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ ñòàáèëüíîñòè ëèìèò 8 ýëåìåíòîâ â îäíîì ìåíþ, èñïîëüçóéòå ïîäìåíþ!', message_color)
											else
												sampAddChatMessage('[Radical Helper] {ffffff}Îãðàíè÷åíèå 5 (â VIP 8) ýëåìåíòîâ â îäíîì ìåíþ, èñïîëüçóéòå ïîäìåíþ èëè VIP!', message_color)
											end
										end
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								if MODULE.PieMenu.editor.current == modules.piemenu.data then
									if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü ïóíêò/ïîäìåíþ##add_pie_item', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' Âûáåðèòå ÷òî èìåííî íóæíî äîáàâèòü ' .. fa.CIRCLE_PLUS)
									end
									imgui.SameLine()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##close_pie_editor', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
								else
									if imgui.Button(fa.ARROW_LEFT .. u8' Íàçàä##pie_editor_menu', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										local prev = table.remove(MODULE.PieMenu.editor.history)
										MODULE.PieMenu.editor.current = prev.items
										MODULE.PieMenu.editor.title = prev.title
									end
									imgui.SameLine()
									if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü ïóíêò/ïîäìåíþ##add_pie_item', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' Âûáåðèòå ÷òî èìåííî íóæíî äîáàâèòü ' .. fa.CIRCLE_PLUS)
									end
									imgui.SameLine()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##close_pie_editor', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
								end
								imgui.End()
							end
							imgui.EndChild()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.KEYBOARD .. (IS_MOBILE and u8' Êíîïî÷êè' or u8' Õîòêåè')) then 
						if IS_MOBILE then
							if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 309 * settings.general.custom_dpi), true) then
								imgui.Columns(3)
								imgui.CenterColumnText(u8'Êíîïêà')
								imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8'Äåéñòâèå êíîïêè')
								imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
								imgui.NextColumn()
								imgui.CenterColumnText(u8'Óïðàâëåíèå')
								imgui.SetColumnWidth(-1, 120 * settings.general.custom_dpi)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								if settings.general.mobile_fastmenu_button then
									imgui.CenterColumnText(fa.IMAGE_PORTRAIT .. u8(' Âçàèìîäåéñòâèå (õ32 ONLY)'))
								else
									imgui.CenterColumnTextDisabled(fa.IMAGE_PORTRAIT .. u8(' Âçàèìîäåéñòâèå'))
								end
								imgui.NextColumn()
								if settings.general.mobile_fastmenu_button then
									imgui.CenterColumnText(u8('Áûñòðûé àíàëîã /hm ID'))
								else
									imgui.CenterColumnTextDisabled(u8('Áûñòðûé àíàëîã /hm ID'))
								end
								imgui.NextColumn()
								if imgui.CenterColumnSmallButton((settings.general.mobile_fastmenu_button and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##mobile_fastmenu_button') then
									settings.general.mobile_fastmenu_button = not settings.general.mobile_fastmenu_button
									MODULE.FastMenuButton.Window[0] = settings.general.mobile_fastmenu_button
									save_settings()
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8(settings.general.mobile_fastmenu_button and "Îòêëþ÷èòü êíîïêó" or "Âêëþ÷èòü êíîïêó"))
								end
								imgui.Columns(1)
								imgui.Separator()

								imgui.Columns(3)
								if settings.general.mobile_stop_button then
									imgui.CenterColumnText(fa.CIRCLE_STOP..u8' Îñòàíîâèòü îòûãðîâêó')
								else
									imgui.CenterColumnTextDisabled(fa.CIRCLE_STOP..u8' Îñòàíîâèòü îòûãðîâêó')
								end
								imgui.NextColumn()
								if settings.general.mobile_stop_button then
									imgui.CenterColumnText(u8('Áûñòðûé àíàëîã /stop'))
								else
									imgui.CenterColumnTextDisabled(u8('Áûñòðûé àíàëîã /stop'))
								end
								imgui.NextColumn()
								if imgui.CenterColumnSmallButton((settings.general.mobile_stop_button and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##mobile_stop_button') then
									settings.general.mobile_stop_button = not settings.general.mobile_stop_button
									save_settings()
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8(settings.general.mobile_stop_button and "Îòêëþ÷èòü êíîïêó" or "Âêëþ÷èòü êíîïêó"))
								end
								imgui.Columns(1)
								imgui.Separator()

								imgui.Columns(3)
								if settings.general.piemenu then
									imgui.CenterColumnText(fa.GEAR .. u8(' PieMenu'))
								else
									imgui.CenterColumnTextDisabled(fa.GEAR .. u8(' PieMenu'))
								end
								imgui.NextColumn()
								if settings.general.piemenu then
									imgui.CenterColumnText(u8('Îòêðûòü êðóãîâîå ìåíþ'))
								else
									imgui.CenterColumnTextDisabled(u8('Îòêðûòü êðóãîâîå ìåíþ'))
								end
								imgui.NextColumn()
								if imgui.CenterColumnSmallButton((settings.general.piemenu and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##mobile_piemenu_button') then
									if pie_no_errors then
										settings.general.piemenu = not settings.general.piemenu
										MODULE.PieMenu.Window[0] = settings.general.piemenu
										save_settings()
									else
										sampAddChatMessage('[Radical Helper] {ffffff}Ó âàñ îòñóñòâóåò áèáëèîòåêà PieMenu, íåâîçìîæíî âêëþ÷èòü/íàñòðîèòü êðóãîâîå ìåíþ!', message_color)
									end
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8(settings.general.piemenu and "Îòêëþ÷èòü êíîïêó" or "Âêëþ÷èòü êíîïêó"))
								end
								imgui.Columns(1)
								imgui.Separator()

								for index, button in ipairs(modules.buttons.data) do
									imgui.Columns(3)
									if button.enable then
										imgui.CenterColumnText(iconTextFormat(button))
									else
										imgui.CenterColumnTextDisabled(iconTextFormat(button))
									end
									imgui.NextColumn()
									if button.enable then
										imgui.CenterColumnText(u8(button.action))
									else
										imgui.CenterColumnTextDisabled(u8(button.action))
									end
									imgui.NextColumn()
									imgui.SetCursorPosX(imgui.GetCursorPos().x + 17 * settings.general.custom_dpi)
									if imgui.SmallButton((button.enable and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##mb_toggle' .. index) then
										button.enable = not button.enable
										local WindowName = button.name .. index
										if MODULE.Buttons[WindowName] then
											MODULE.Buttons[WindowName][0] = button.enable
										else
											sampAddChatMessage('[Radical Helper] {ffffff}Êíîïêà çàðàáîòàåò òîëüêî ïîñëå ïåðåçàãðóçêè õåëïåðà èëè ïåðåçàõîäà â èãðó!', message_color)
											play_sound()
										end
										save_module('buttons')
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8(button.enable and "Îòêëþ÷èòü êíîïêó" or "Âêëþ÷èòü êíîïêó"))
									end
									imgui.SameLine()
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå êíîïêè ' .. fa.PEN_TO_SQUARE .. '##' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										change_dpi()
										imgui.CenterText(fa.SIGNATURE .. u8' Íàçâàíèå:')
										imgui.PushItemWidth(205 * settings.general.custom_dpi)
										imgui.InputTextWithHint(u8'##name', u8'Òåêñò êîòîðûé áóäåò íà êíîïêå', MODULE.Buttons.Editor.name, 64)
										imgui.Separator()
										imgui.CenterText(fa.CIRCLE_PLAY ..  u8' Äåéñòâèå (â ÷àò):')
										imgui.PushItemWidth(205 * settings.general.custom_dpi)
										imgui.InputTextWithHint(u8'##action', u8'Ëþáîé òåêñò/êîìàíäà äëÿ ÷àòà', MODULE.Buttons.Editor.action, 256)
										imgui.Separator()
										imgui.CenterText(fa.IMAGE .. u8' Èêîíêà:')
										if button.icon ~= '' then
											imgui.SameLine()
											imgui.Text(fa[button.icon])
										end
										imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
										imgui.SetNextWindowSize(imgui.ImVec2(250 * settings.general.custom_dpi, 295 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
										if imgui.BeginPopupModal(fa.IMAGE .. u8' Âûáîð èêîíêè äëÿ êíîïêè ' .. fa.IMAGE, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
											imgui.PushItemWidth(240 * settings.general.custom_dpi)
											imgui.InputTextWithHint('##icon_filter', u8'Èùèòå èêîíêè ïî íàçâàíèþ íà àíãë...', MODULE.Icons.input, 32)
											local filter = ffi.string(MODULE.Icons.input):upper()
											imgui.GetStyle().ScrollbarSize = 17 * settings.general.custom_dpi
											if imgui.BeginChild('##icons', imgui.ImVec2(240 * settings.general.custom_dpi, 200 * settings.general.custom_dpi), true) then
												for _, key in ipairs(MODULE.Icons.keys) do
													if filter == '' or key:find(filter, 1, true) then
														if imgui.Selectable(fa[key] .. ' ' .. key) then
															button.icon = key
															imgui.CloseCurrentPopup()
														end
													end
												end
												imgui.EndChild()
											end
											imgui.GetStyle().ScrollbarSize = (IS_MOBILE and 15 or 10) * settings.general.custom_dpi
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
												imgui.CloseCurrentPopup()
											end
											imgui.EndPopup()
										end
										if imgui.Button(fa.HAND_POINT_RIGHT .. u8' Âûáðàòü èêîíêó èç ñïèñêà ' .. fa.HAND_POINT_LEFT) then
											imgui.OpenPopup(fa.IMAGE .. u8' Âûáîð èêîíêè äëÿ êíîïêè ' .. fa.IMAGE)
										end
										imgui.Separator()
										imgui.CenterText(fa.MAXIMIZE .. u8(" Ðàçìåð (X, Y):"))
										imgui.PushItemWidth(100 * settings.general.custom_dpi)
										imgui.SliderInt(u8"##sizex", MODULE.Buttons.Editor.size.x, 1, 500)
										imgui.SameLine()
										imgui.PushItemWidth(100 * settings.general.custom_dpi)
										imgui.SliderInt(u8"##sizey", MODULE.Buttons.Editor.size.y, 1, 500)
										imgui.Separator()
										imgui.CenterText(fa.DRAW_POLYGON .. u8(" Ïîçèöèÿ íà ýêðàíå:"))
										imgui.CenterText(u8('Çàæìèòå êíîïêó â óãëó è äâèãàéòå'))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											button.name = u8:decode(ffi.string(MODULE.Buttons.Editor.name))
											button.action = u8:decode(ffi.string(MODULE.Buttons.Editor.action))
											button.size.x = MODULE.Buttons.Editor.size.x[0]
											button.size.y = MODULE.Buttons.Editor.size.y[0]
											save_module('buttons')
											sampAddChatMessage('[Radical Helper] {ffffff}Ðàçìåð èçìåíèòñÿ òîëüêî ïîñëå ïåðåçàãðóçêè õåëïåðà èëè ïåðåçàõîäà â èãðó!', message_color)
											play_sound()
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end

									if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##mb_edit' .. index) then
										imgui.StrCopy(MODULE.Buttons.Editor.name, u8(button.name))
										imgui.StrCopy(MODULE.Buttons.Editor.action, u8(button.action))
										MODULE.Buttons.Editor.size.x  = imgui.new.int(button.size.x)
										MODULE.Buttons.Editor.size.y  = imgui.new.int(button.size.y)
										imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå êíîïêè ' .. fa.PEN_TO_SQUARE .. '##' .. index)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8("Ðåäàêòèðîâàòü êíîïêó"))
									end
									imgui.SameLine()
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										change_dpi()
										imgui.CenterText(u8("Âû äåéñòâèòåëüíî õîòèòå óäàëèòü \"" .. button.name .. "\"?"))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											table.remove(modules.buttons.data, index)
											save_module('buttons')
											local WindowName = button.name .. index
											if MODULE.Buttons[WindowName] and MODULE.Buttons[WindowName][0] then
												MODULE.Buttons[WindowName][0] = false
											end
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
									if imgui.SmallButton(fa.TRASH_CAN .. '##mb_delete' .. index) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. index)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8("Óäàëèòü êíîïêó"))
									end
									imgui.Columns(1)
									imgui.Separator()
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü êíîïêó##add_mobile_button', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								if #modules.buttons.data > 5 then
									sampAddChatMessage('[Radical Helper] {ffffff}Â áåñïëàòíîé âåðñèè îãðàíè÷åíèå âñåãî 5 êíîïîê! Êóïèòå VIP âåðñèþ äëÿ áåçëèìèòíûõ êíîïîê!', message_color)
									return
								end
								local new_button = {icon = '', name = 'Button ' .. (#modules.buttons.data + 1), action = '', enable = false,  size = {x = 100, y = 25}, pos = {x = sizeX / 2, y = sizeY / 2}}
								table.insert(modules.buttons.data, new_button)
								save_module('buttons')
							end
						else
							if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
								imgui.CenterText(fa.KEYBOARD .. u8' Ãëàâíûå áèíäû äëÿ ðàáîòû õåëïåðà (áèíäû äëÿ RP êîìàíä â ðåäàêòîðå êîìàíä) ' .. fa.KEYBOARD)
								if hotkey_no_errors then
									imgui.Separator()
									imgui.CenterText(u8'Îòêðûòèå/çàêðûòèå ãëàâíîãî ìåíþ õåëïåðà (àíàëîã /helper):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
									imgui.SetCursorPosX( width / 2 - calc.x / 2 )
									if MainMenuHotKey:ShowHotKey() then
										settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Îòêðûòèå áûñòðîãî ìåíþ âçàèìîäåéñòâèÿ ñ èãðîêîì (àíàëîã /hm):')
									imgui.CenterText(u8'Íàâåñòèñü íà èãðîêà ÷åðåç ÏÊÌ è íàæàòü êëàâèøó')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if FastMenuHotKey:ShowHotKey() then
										settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
										save_settings()
									end

									if modules.player.data.fraction_rank_number >= 9 then
										imgui.Separator()
										imgui.CenterText(u8'Îòêðûòèå áûñòðîãî ìåíþ óïðàâëåíèÿ èãðîêîì (àíàëîã /lm äëÿ 9/10):')
										imgui.CenterText(u8'Íàâåñòèñü íà èãðîêà ÷åðåç ÏÊÌ è íàæàòü êëàâèøó')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_leader_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if LeaderFastMenuHotKey:ShowHotKey() then
											settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey:GetHotKey())
											save_settings()
										end
									end

									imgui.Separator()
									imgui.CenterText(u8'Âûïîëíèòü äåéñòâèå (íàïðèìåð "Ïðîäîëæèòü îòûãðîâêó", "Õèë èç ÷àòà"):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_action))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if ActionHotKey:ShowHotKey() then
										settings.general.bind_action = encodeJson(ActionHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Ïðèîñòàíîâèòü îòûãðîâêó êîìàíäû (àíàëîã /stop):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_command_stop))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if CommandStopHotKey:ShowHotKey() then
										settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
										save_settings()
									end
									imgui.Separator()
								else
									imgui.Separator()
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' Ó âàñ îòñóòñòâóåò áèáëèîòåêà mimgui_hotkeys.lua ' .. fa.TRIANGLE_EXCLAMATION)
								end
								imgui.EndChild()
							end
						end
						imgui.EndTabItem() 
					end
					imgui.EndTabBar() 
				end
				imgui.EndTabItem()
			end
			local fraction = isMode('smi') and 'ÑÌÈ' or modules.player.data.fraction_tag:sub(1, 5)
			if imgui.BeginTabItem(fa.GEARS .. u8' Ôóíêöèè ' .. u8(fraction)) then
				render_fractions_functions()
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.FILE_PEN..u8' Çàìåòêè') then 
			 	imgui.BeginChild('##notes1', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"Ñïèñîê âàøèõ çàìåòîê è øïàðãàëîê:")
				imgui.SetColumnWidth(-1, 495 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"Äåéñòâèÿ")
				imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(modules.notes.data) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(note.note_name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.UP_RIGHT_FROM_SQUARE .. '##' .. i) then
						MODULE.Note.show_note_name = u8(note.note_name)
						MODULE.Note.show_note_text = u8(note.note_text)
						MODULE.Note.Window[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Îòêðûòü çàìåòêó "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&','\n')
						MODULE.Note.input_text = imgui.new.char[1048576](u8(note_text))
						MODULE.Note.input_name = imgui.new.char[256](u8(note.note_name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå çàìåòêè ' .. fa.PEN_TO_SQUARE .. '##' .. i)	
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Ðåäàêòèðîâàíèå çàìåòêè "' .. u8(note.note_name) .. '"')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå çàìåòêè ' .. fa.PEN_TO_SQUARE .. '##' .. i, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						if imgui.BeginChild('##node_edit_window', imgui.ImVec2(589 * settings.general.custom_dpi, 369 * settings.general.custom_dpi), true) then	
							imgui.PushItemWidth(578 * settings.general.custom_dpi)
							imgui.InputText(u8'##note_name', MODULE.Note.input_name, 6256)
							imgui.InputTextMultiline("##note_text", MODULE.Note.input_text, 1048576, imgui.ImVec2(578 * settings.general.custom_dpi, 329 * settings.general.custom_dpi))
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(MODULE.Note.input_name))
							local temp = u8:decode(ffi.string(MODULE.Note.input_text))
							note.note_text = temp:gsub('\n', '&')
							save_module('notes')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. i .. note.note_name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Óäàëåíèå çàìåòêè "' .. u8(note.note_name) .. '"')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. i .. note.note_name, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü çàìåòêó "' .. u8(note.note_name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíèòü', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							table.remove(modules.notes.data, i)
							save_module('notes')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' Ñîçäàòü çàìåòêó', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					if #modules.notes.data > 5 then
						return
					end
					table.insert(modules.notes.data, {note_name = "Íîâàÿ çàìåòêà " .. #modules.notes.data + 1, note_text = "Òåêñò âàøåé íîâîé çàìåòêè"})
					save_module('notes')
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR..u8' Íàñòðîéêè') then 
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 187 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.CIRCLE_INFO .. u8' Äîïîëíèòåëüíàÿ èíôîðìàöèÿ î õåëïåðå ' .. fa.CIRCLE_INFO)
					imgui.Separator()
					imgui.Text(fa.CIRCLE_USER..u8" Ðàçðàáîò÷èê õåëïåðà: MAITREYA HESOYAM 31 SERVER DRAKE!")
					imgui.Separator()
					imgui.Text(fa.CIRCLE_INFO..u8" Âåðñèÿ õåëïåðà: " .. u8(thisScript().version))
					imgui.Separator()
					imgui.Text(fa.HEADSET..u8" Òåõíè÷åñêàÿ ïîääåðæêà:")
					imgui.SameLine()
					--if imgui.SmallButton(u8'Discord') then
						--openLink(' ')
					--end
					--if imgui.IsItemHovered() then
					--	imgui.SetTooltip(u8'Ïåðåéòè â Discord ñåðâåð STRIPTISAFUNCLUB(âðåìåííî íå äîñòóïíî)')
					--end
					imgui.SameLine()
					imgui.Text('/')
					imgui.SameLine()
					if imgui.SmallButton(u8'Telegram') then
						--openLink(' ')
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Ïåðåéòè â Telegram êàíàë STRIPTISAFUNCLUB(âðåìåííî íå äîñòóïíî)')
					end
					--imgui.Separator()
					--imgui.Text(u8'Åùå åñòü óíèêàëüíàÿ âîçìîæíîñòü áûòü íà ñâÿçå ñ ðàçðàáîò÷èêîì!\nâñòóïèâ â íàø ôëóä Hushed Voices')
					--if imgui.SmallButton(u8'Telegram(Çàÿâêà äëÿ àíêåòû)') then
						--openLink(' ')
					--end
					--if imgui.IsItemHovered() then
				--		imgui.SetTooltip(u8'Ïåðåõîä â òåëåãðàì áîò Ðàçðàáîò÷èêà õåëïåðà! ÍÎ ÄÀÍÍÀß ÂÎÇÌÎÆÍÎÑÒÜ ÏÎÊÀ ÍÅ ÄÎÑÒÓÏÍÀ!')
					--end
					imgui.Separator()
					imgui.Text(u8" Äàííûé õåëïåð áóäåò ïîëíîñòüþ ìîäèôèöèðîâàí!\n è áóäåò áåñïëàòåí äëÿ âñåõ ïîëüçîâàòåëåé ñî âñåìè ôóíêöèÿìè " )
					imgui.Separator() 
					imgui.Text(u8"!!! Cåìüè Hesoyam Áóäåò äîñòóïíà ïîëíàÿ âåðñèÿ Radical Helper !!!\nïðîéòè âåðèôèêàöèÿ ìîæíî â îôôèöèàëüíîì Discord êàíàëå ñåìüè Hesoyam" )
					if imgui.SmallButton(u8'Discord') then
						--openLink(' ')
					end
					imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 135 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.PALETTE .. u8(' Íàñòðîéêè èíòåðôåéñà ') .. fa.PALETTE)
					imgui.Separator()
					imgui.Columns(4)
					imgui.CenterColumnText(fa.BRUSH .. u8(' Öâåò'))
					if monet_no_errors then
						function moon_monet_edit()
							local r,g,b = MODULE.Main.mmcolor[0] * 255, MODULE.Main.mmcolor[1] * 255, MODULE.Main.mmcolor[2] * 255
							local argb = join_argb(0, r, g, b)
							settings.general.helper_theme = 0
							settings.general.moonmonet_theme_color = argb
							settings.general.message_color = argb
							message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
							message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
							MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.message_color)
						end
						if imgui.RadioButtonIntPtr(u8" Custom", MODULE.Main.theme, 0) then
							moon_monet_edit()
							apply_moonmonet_theme()
							save_settings()
						end
						imgui.SameLine()
						if imgui.ColorEdit3('## COLOR1', MODULE.Main.mmcolor, imgui.ColorEditFlags.NoInputs) then
							if MODULE.Main.theme[0] == 0 then
								moon_monet_edit()
								apply_moonmonet_theme()
								save_settings()
							end
						end
					else
						if imgui.RadioButtonIntPtr(u8" Ñustom ", MODULE.Main.theme, 0) then
							MODULE.Main.theme[0] = settings.general.helper_theme
							sampAddChatMessage('[Radical Helper] {ffffff}Óñòàíîâèòå áèáëèîòåêó MoonMonet!', message_color)
						end
					end
					if imgui.RadioButtonIntPtr(" Dark Theme ", MODULE.Main.theme, 1) then	
						settings.general.helper_theme = 1
						save_settings()
						apply_dark_theme()
					end
					if imgui.RadioButtonIntPtr(" White Theme ", MODULE.Main.theme, 2) then	
						settings.general.helper_theme = 2
						save_settings()
						apply_white_theme()
					end
					imgui.NextColumn()
					imgui.CenterColumnText(fa.FILL_DRIP .. u8' Ïðîçðà÷íîñòü')
					imgui.PushItemWidth(138 * settings.general.custom_dpi)
					imgui.SetCursorPosY(72 * settings.general.custom_dpi)
					imgui.SliderInt('##slider_helper_transparent', MODULE.Main.slider.transparent, 10, 100)
					if settings.general.transparent ~= MODULE.Main.slider.transparent[0] then
						if imgui.CenterColumnSmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' Ïðèìåíèòü ' .. fa.CIRCLE_ARROW_LEFT .. '##change_transparent') then
							settings.general.transparent = MODULE.Main.slider.transparent[0]
							save_settings()
							if settings.general.helper_theme == 0 and monet_no_errors then
								apply_moonmonet_theme()
							elseif settings.general.helper_theme == 1 then
								apply_dark_theme()
							elseif settings.general.helper_theme == 2 then
								apply_white_theme()
							end
						end
					end
					imgui.NextColumn()
					imgui.CenterColumnText(fa.MESSAGE .. u8(' Öâåò ñîîáùåíèé'))
					imgui.SetCursorPosX(350 * settings.general.custom_dpi)
					imgui.SetCursorPosY(72 * settings.general.custom_dpi)
					if MODULE.Main.theme[0] == 0 then
						imgui.CenterColumnText(u8('Äóáëèðîâàíèå Custom'))
						imgui.CenterColumnText(u8('Ìåíÿòü â Dark/White'))
					else
						if imgui.ColorEdit3('## COLOR2', MODULE.Main.msgcolor, imgui.ColorEditFlags.NoInputs) then
							local r,g,b = MODULE.Main.msgcolor[0] * 255, MODULE.Main.msgcolor[1] * 255, MODULE.Main.msgcolor[2] * 255
							local argb = join_argb(0, r, g, b)
							settings.general.message_color = argb
							-- settings.general.moonmonet_theme_color = argb
							message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
							message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
							save_settings()
						end
					end
					imgui.NextColumn()
					imgui.CenterColumnText(fa.MAXIMIZE .. u8' Ðàçìåð')
					imgui.PushItemWidth(138 * settings.general.custom_dpi)
					imgui.SetCursorPosY((72 * settings.general.custom_dpi))
					imgui.SliderFloat('##slider_helper_size', MODULE.Main.slider.dpi, 0.5, 3)
					if settings.general.custom_dpi ~= tonumber(string.format('%.3f', MODULE.Main.slider.dpi[0])) then
						if imgui.CenterColumnSmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' Ïðèìåíèòü ' .. fa.CIRCLE_ARROW_LEFT .. '##change_Size') then
							imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##change_size')
						end
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##change_size', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå èçìåíèòü ðàçìåð èíòåðôåéñà õåëïåðà?')
						imgui.CenterText(u8('Òåêóùèé ðàçìåð ') .. settings.general.custom_dpi .. u8(', à âûáðàííûé íîâûé ') .. string.format('%.3f', MODULE.Main.slider.dpi[0]))
						local size_text = (settings.general.custom_dpi < MODULE.Main.slider.dpi[0]) and 'áîëüøîé' or 'ìåëêèé'
						imgui.CenterColorText(imgui.ImVec4(1, 0, 0, 1), u8('Åñëè èíòåðôåéñ ñòàíåò ñëèøêîì ') .. u8(size_text) .. u8(', èñïîëüçóéòå /fixsize'))
						imgui.Separator()
						imgui.CenterText(u8('Åñëè ìåíþøêè "ïëàâàþò" ïî ýêðàíó, ïîäáèðàéòå äðóãîé ðàçìåð'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##change_size', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							MODULE.Main.slider.dpi[0] = settings.general.custom_dpi
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Äà, èçìåíèòü##change_size', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							local new_dpi = tonumber(string.format('%.3f', MODULE.Main.slider.dpi[0]))
							if IS_MOBILE and new_dpi < MONET_DPI_SCALE then
								sampAddChatMessage('[Radical Helper] {ffffff}Äëÿ âàøåãî äèñïëåÿ íåëüçÿ ñäåëàòü ðàçìåð ìåíüøå ' .. MONET_DPI_SCALE, message_color)
								imgui.CloseCurrentPopup()
							else
								settings.general.custom_dpi = new_dpi
								save_settings()
								sampAddChatMessage('[Radical Helper] {ffffff}Åñëè èíòåðôåéñ áóäåò ñëèøêîì ' .. size_text .. ', òî èñïîëüçóéòå êîìàíäó ' .. message_color_hex .. '/fixsize', message_color)
								sampAddChatMessage('[Radical Helper] {ffffff}Ïåðåçàãðóçêà ñêðèïòà äëÿ èçìåíåíèÿ ðàçìåðà èíòåðôåéñà...', message_color)
								reload_script = true
								thisScript():reload()
							end
						end
						imgui.End()
					end 
					imgui.Columns(1)
					imgui.EndChild()
				end
				if imgui.BeginChild("##3",imgui.ImVec2(589 * settings.general.custom_dpi, 35 * settings.general.custom_dpi),true) then
					if imgui.Button(fa.POWER_OFF .. u8" Îòêëþ÷èòü õåëïåð", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						sampAddChatMessage('[Radical Helper] {ffffff}Õåëïåð ïðèîñòàíîâèë ñâîþ ðàáîòó äî ñëåäóþùåãî âõîäà â èãðó.', message_color)
						if not IS_MOBILE then
							sampAddChatMessage('[Radical Helper] {ffffff}Ëèáî èñïîëüçóéòå ñî÷åòàíèå êëàâèø ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R{ffffff}, ÷òîáû ïîâòîðíî çàïóñòèòü õåëïåð.', message_color)
						end
						reload_script = true
						thisScript():unload()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" Ñáðîñ äàííûõ õåëïåðà", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##reset_helper')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##reset_helper', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå ñáðîñèòü âñå äàííûå õåëïåðà?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_restore', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' Ñáðîñèòü##yes_restore', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							delete_helper_data()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8" Óäàëèòü õåëïåð", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##delete_helper')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##delete_helper', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü Arizona&Rodina Helper?')
						imgui.CenterText(u8'Òàêæå áóäóò óäàëåíû âñå íàñòðîéêè, êîìàíäû è çàìåòêè.')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_delete_helper', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü##delete_helper', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							delete_helper_data(true)
						end
						imgui.End()
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8'Ñïèñîê èçìåíåíèé') then 
				imgui.Text(u8'1. Ïîêà ÷òî ÇÁÒ äàííîãî ñêðèïòà!')
				imgui.Text(u8'1. Ïîêà ÷òî ÇÁÒ äàííîãî ñêðèïòà!')
			end
		imgui.EndTabBar() end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return MODULE.Binder.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' Ðåäàêòèðîâàíèå êîìàíäû /' .. MODULE.Binder.data.change_cmd, MODULE.Binder.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' Îïèñàíèå êîìàíäû:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##MODULE.Binder.data.input_description", MODULE.Binder.input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' Êîìàíäà äëÿ èñïîëüçîâàíèÿ â ÷àòå (áåç /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##MODULE.Binder.input_cmd", MODULE.Binder.input_cmd, 256)
			local cmd = ffi.string(MODULE.Binder.input_cmd)
			if cmd:sub(1,1) == '/' then
				cmd = cmd:gsub("^/+", "")
				imgui.StrCopy(MODULE.Binder.input_cmd, cmd)
			end
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' Àðãóìåíòû êîòîðûå ïðèíèìàåò êîìàíäà:')
			local args = {[1] = '{arg}', [2] = '{id}', [3] = '{id} {arg}', [4] = '{id} {number} {arg}'}
			local selected_args = args[MODULE.Binder.ComboTags[0]]
			if selected_args then
				for token in selected_args:gmatch("{[^}]+}") do
					if imgui.Button(token, imgui.ImVec2(65 * settings.general.custom_dpi, 24 * settings.general.custom_dpi)) then
						insert_to_cursor(token .. ' ', MODULE.Binder.input_text)
					end
					imgui.SameLine()
				end
			end
			imgui.PushItemWidth(581 * settings.general.custom_dpi - imgui.GetCursorPos().x)
	    	imgui.Combo(u8'', MODULE.Binder.ComboTags, MODULE.Binder.ImItems, #MODULE.Binder.item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' Òåêñòîâûé áèíä êîìàíäû:')
			imgui.InputTextMultiline("##text_multiple", MODULE.Binder.input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi), imgui.InputTextFlags.CallbackAlways + imgui.InputTextFlags.CallbackCompletion, TextEditCallback)
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##binder_cancel', imgui.ImVec2(imgui.GetMiddleButtonX(IS_MOBILE and 4 or 5), 0)) then
			MODULE.Binder.Window[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' Çàäåðæêà##binder_wait', imgui.ImVec2(imgui.GetMiddleButtonX(IS_MOBILE and 4 or 5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' Çàäåðæêà (â ñåêóíäàõ) '  .. fa.CLOCK)
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.CLOCK .. u8' Çàäåðæêà (â ñåêóíäàõ) ' .. fa.CLOCK, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', MODULE.Binder.waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##binder_wait_menu', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Binder.waiting_slider = imgui.new.float(tonumber(MODULE.Binder.data.change_waiting))
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##binder_wait_menu', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' Òåãè##binder_tags', imgui.ImVec2(imgui.GetMiddleButtonX(IS_MOBILE and 4 or 5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' Òåãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå ' .. fa.TAGS)
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.TAGS .. u8' Òåãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå ' .. fa.TAGS, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			if imgui.BeginChild("taglist", imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
				imgui.Columns(3, "tags_columns", true)
				imgui.Text(u8"Òåã")
				imgui.NextColumn()
				imgui.Text(u8"Îïèñàíèå òåãà")
				imgui.NextColumn()
				imgui.Text(u8"Ðåçóëüòàò èñïîëüçîâàíèÿ òåãà")
				imgui.NextColumn()
				imgui.Columns(1)
				imgui.Separator()
				imgui.BulletText(u8("Âçàèìîäåéñòâèå ñ áèíäåðîì"))
				imgui.Separator()
				imgui.Columns(3, "tags_columns", true)
				if imgui.Selectable("{pause}") then
					insert_to_cursor("{pause}", MODULE.Binder.input_text)
					imgui.CloseCurrentPopup()
				end
				imgui.NextColumn()
				imgui.Text(u8('Ïîñòàâèòü êîìàíäó íà ïàóçó'))
				imgui.NextColumn()
				imgui.Text(u8('Ìåíþøêà ïàóçû êîìàíäû'))
				imgui.NextColumn()
				imgui.Columns(1)
				imgui.Columns(3, "tags_columns", true)
				if imgui.Selectable("{wait(5000)}") then
					insert_to_cursor("{wait(5000)}", MODULE.Binder.input_text)
					imgui.CloseCurrentPopup()
				end
				imgui.NextColumn()
				imgui.Text(u8('Äîï.êàñòîìíàÿ çàäåðæêà'))
				imgui.NextColumn()
				imgui.Text(u8('Âìåñòî 5000 ëþáîå âðåìÿ â ÌÑ'))
				imgui.NextColumn()
				imgui.Columns(1)
				local last_category = nil
				for _, tag in ipairs(MODULE.Binder.tags) do
					if tag.category ~= last_category then
						imgui.Columns(1)
						imgui.Separator()
						imgui.BulletText(u8(tag.category))
						imgui.Separator()
						imgui.Columns(3, "tags_columns", true)
						last_category = tag.category
					end
					if imgui.Selectable("{" .. tag.key .. "}") then
						insert_to_cursor("{" .. tag.key .. "}", MODULE.Binder.input_text)
						imgui.CloseCurrentPopup()
					end
					imgui.NextColumn()
					imgui.Text(u8(tag.description))
					imgui.NextColumn()
					local example = ""
					if tag.func then
						local ok, result = pcall(tag.func)
						if ok and result then
							example = tostring(result)
						end
					end
					imgui.Text(u8(example))
					imgui.NextColumn()
				end
				imgui.Columns(1)
				imgui.EndChild()
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		if not IS_MOBILE then
			imgui.SameLine()
			if imgui.Button(fa.KEYBOARD .. u8' Çàáèíäèòü##binder_bind', imgui.ImVec2(imgui.GetMiddleButtonX(IS_MOBILE and 4 or 5), 0)) then
				if MODULE.Binder.ComboTags[0] == 0 then
					if hotkey_no_errors then
						if hotkey.HotKeyIsEdit ~= nil then hotkey.HotKeyIsEdit = nil end
						imgui.OpenPopup(fa.KEYBOARD .. u8' Áèíä äëÿ êîìàíäû /' .. MODULE.Binder.data.change_cmd)
					else
						sampAddChatMessage('[Radical Helper] {ffffff}Äàííàÿ ôóíêöèÿ íåäîñòóïíà, ó âàñ îòñóñòâóþò ôàéëû áèáëèîòåêè mimgui_hotkeys!', message_color)
					end
				else
					sampAddChatMessage('[Radical Helper] {ffffff}Äàííàÿ ôóíêöèÿ äîñòóïà òîëüêî åñëè êîìàíäà "Áåç àðãóìåíòîâ"', message_color)
				end
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			if imgui.BeginPopupModal(fa.KEYBOARD .. u8' Áèíä äëÿ êîìàíäû /' .. MODULE.Binder.data.change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
				local hotkeyObject = hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"]
				if hotkeyObject then
					imgui.CenterText(u8('Êëàâèøà àêòèâàöèè áèíäà:'))
					local calc
					if MODULE.Binder.data.change_bind == '{}' or MODULE.Binder.data.change_bind == '[]' then
						calc = imgui.CalcTextSize('< click and select keys >')
					elseif MODULE.Binder.data.change_bind == nil then
						MODULE.Binder.data.change_bind = {}
					else
						calc = imgui.CalcTextSize(getNameKeysFrom(MODULE.Binder.data.change_bind))
					end
					local width = imgui.GetWindowWidth()
					local temp = (calc and calc.x and calc.x / 2) or 0
					imgui.SetCursorPosX(width / 2 - temp)
					if hotkeyObject:ShowHotKey() then
						MODULE.Binder.data.change_bind = encodeJson(hotkeyObject:GetHotKey())
					end
				else
					if not MODULE.Binder.data.change_bind then
						MODULE.Binder.data.change_bind = {}
					end
					hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"] = hotkey.RegisterHotKey(MODULE.Binder.data.change_cmd .. "HotKey", false, decodeJson(MODULE.Binder.data.change_bind), function()
						if not sampIsCursorActive() then sampProcessChatInput('/' .. MODULE.Binder.data.change_cmd) end
					end)
					hotkeyObject = hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"]
				end
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##binder_bind_close', imgui.ImVec2(300 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.End()
			end
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##binder_save', imgui.ImVec2(imgui.GetMiddleButtonX(IS_MOBILE and 4 or 5), 0)) then	
			local cmd = ffi.string(MODULE.Binder.input_cmd)
			local desc = ffi.string(MODULE.Binder.input_description)
			local text_value = ffi.string(MODULE.Binder.input_text)
			local has_id = text_value:find("{id}")
			local has_arg = text_value:find("{arg}")
			local has_number = text_value:find("{number}")
			if cmd:find("[^%w_]") or cmd == '' or desc == ''  or text_value == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Îøèáêà ñîõðàíåíèÿ êîìàíäû ' .. fa.TRIANGLE_EXCLAMATION)
			else
				local new_arg = ''
				if has_number or MODULE.Binder.ComboTags[0] == 4 then
					new_arg = '{id} {number} {arg}'
				elseif (has_id and has_arg) or MODULE.Binder.ComboTags[0] == 3 then
					new_arg = '{id} {arg}'
				elseif has_id or MODULE.Binder.ComboTags[0] == 2 then
					new_arg = '{id}'
				elseif has_arg or MODULE.Binder.ComboTags[0] == 1 then
					new_arg = '{arg}'
				else
					new_arg = ''
				end
				local new_command = u8:decode(ffi.string(MODULE.Binder.input_cmd))
				local temp_array = (MODULE.Binder.data.create_command_9_10) and modules.commands.data.commands_manage.my or modules.commands.data.commands.my
				for _, command in ipairs(temp_array) do
					if command.cmd == MODULE.Binder.data.change_cmd and command.arg == MODULE.Binder.data.change_arg and command.text:gsub('&', '\n') == MODULE.Binder.data.change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = u8:decode(ffi.string(MODULE.Binder.input_description))
						command.text = u8:decode(ffi.string(MODULE.Binder.input_text)):gsub('\n', '&')
						command.bind = MODULE.Binder.data.change_bind
						command.waiting = MODULE.Binder.waiting_slider[0]
						command.enable = true
						save_module('commands')
						if command.arg == '' then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà ' .. message_color_hex .. '/' .. new_command .. ' [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{id}' then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà ' .. message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{id} {arg}' then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà ' .. message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{id} {number} {arg}' then
							sampAddChatMessage('[Radical Helper] {ffffff}Êîìàíäà ' .. message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] [÷èñëî] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						end
						sampUnregisterChatCommand(MODULE.Binder.data.change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						if not IS_MOBILE then createHotkeyForCommand(command) end
						break
					end
				end
				MODULE.Binder.Window[0] = false
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Îøèáêà ñîõðàíåíèÿ êîìàíäû ' .. fa.TRIANGLE_EXCLAMATION, _, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar) then
			if ffi.string(MODULE.Binder.input_cmd):find('%W') then
				imgui.BulletText(u8" Â êîìàíäå ìîæíî èñïîëüçîâàòü òîëüêî àíãë.áóêâû è öèôðû!")
			elseif ffi.string(MODULE.Binder.input_cmd) == '' then
				imgui.BulletText(u8" Òåêñòîâûé áèíä êîìàíäû íå ìîæåò áûòü ïóñòîé!")
			end
			if ffi.string(MODULE.Binder.input_description) == '' then
				imgui.BulletText(u8" Îïèñàíèå êîìàíäû íå ìîæåò áûòü ïóñòîå!")
			end
			if ffi.string(MODULE.Binder.input_text) == '' then
				imgui.BulletText(u8" Áèíä êîìàíäû íå ìîæåò áûòü ïóñòîé!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##binder_error_save_close', imgui.ImVec2(400 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end	
		imgui.End()
    end
)

imgui.OnFrame(
    function() return MODULE.Note.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400 * settings.general.custom_dpi, 300 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.FILE_PEN .. ' '.. MODULE.Note.show_note_name .. ' ' .. fa.FILE_PEN, MODULE.Note.Window)
        change_dpi()
		for line in MODULE.Note.show_note_text:gsub("&", "\n"):gmatch("[^\r\n]+") do -- by Milky
			imgui.TextUnformatted(line) 
		end
        imgui.End()
    end
)

function iconTextFormat(item)
	if item.icon and item.icon ~= '' and fa[item.icon] then
		return fa[item.icon] .. ' ' .. u8(item.name)
	end
	return u8(item.name)
end
function render_buttons()
	for index, value in ipairs(modules.buttons.data) do
		local WindowName = value.name .. index
		if not MODULE.Buttons[WindowName] then
			MODULE.Buttons[WindowName] = imgui.new.bool(value.enable)
		end
		imgui.OnFrame(
			function() return MODULE.Buttons[WindowName][0] end,
			function(player)
				imgui.SetNextWindowPos(imgui.ImVec2(value.pos.x, value.pos.y), imgui.Cond.FirstUseEver)
				imgui.Begin("##BUTTON" .. value.name, MODULE.Buttons[WindowName], imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
				change_dpi()
				if imgui.Button(iconTextFormat(value), imgui.ImVec2(value.size.x * settings.general.custom_dpi, value.size.y * settings.general.custom_dpi)) then
					sampProcessChatInput(value.action)
				end
				local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
				if posX ~= value.pos.x or posY ~= value.pos.y then
					value.pos.x = posX
					value.pos.y = posY
					save_module('buttons')
				end
				imgui.End()
			end
		)
	end
end
------------------------------------------ FRACTION GUI -------------------------------------------
function render_assist_item(name, description, tbl, key, isVip, func)
	imgui.Separator()
	imgui.Columns(3)
	if tbl and tbl[key] then
		if isVip then
			imgui.CenterColumnColorText(imgui.ImVec4(0.93, 0.79, 0.15, 1.0), fa.CROWN .. ' ' .. u8(name))
		else
			imgui.CenterColumnText(u8(name))
		end
	else
		if isVip then
			imgui.CenterColumnColorText(imgui.ImVec4(0.55, 0.45, 0.08, 1.0), fa.CROWN .. ' ' .. u8(name))
		else
			imgui.CenterColumnTextDisabled(u8(name))
		end
	end
	imgui.NextColumn()
	imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
	if imgui.BeginPopupModal(fa.CIRCLE_INFO .. ' ' .. u8(name) .. ' ' .. fa.CIRCLE_INFO, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
		change_dpi()
		imgui.TextWrapped(u8(description))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(500 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
	if imgui.CenterColumnSmallButton(u8('Ïîñìîòðåòü##' .. name .. key)) then
		imgui.OpenPopup(fa.CIRCLE_INFO .. ' ' .. u8(name) .. ' ' .. fa.CIRCLE_INFO)
	end
	imgui.NextColumn()
	if imgui.CenterColumnSmallButton((((tbl and tbl[key]) and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##' .. name .. key)) then
		if isVip then 
			tbl[key] = not tbl[key]
			save_settings()
		end
	end
	if imgui.IsItemHovered() then
		local label = (tbl and tbl[key]) and ('Îòêëþ÷èòü') or ('Âêëþ÷èòü')
		imgui.SetTooltip(u8(label))
	end
	if func and tbl and tbl[key] then
		imgui.SameLine()
		if imgui.SmallButton(fa.GEAR .. '##' .. name) then
			func()
		end
		if imgui.IsItemHovered() then
			imgui.SetTooltip(u8("Íàñòðîèòü"))
		end
	end
	imgui.Columns(1)
end
function firs_render_assist_gui()
	imgui.Columns(3)
	imgui.CenterColumnText(u8("Ôóíêöèÿ Àññèñòåíòà"))
	imgui.SetColumnWidth(-1, 320 * settings.general.custom_dpi)
	imgui.NextColumn()
	imgui.CenterColumnText(u8("Îïèñàíèå ôóíêöèè"))
	imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
	imgui.NextColumn()
	imgui.CenterColumnText(u8("Óïðàâëåíèå"))
	imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
	imgui.NextColumn()
	imgui.Columns(1)
	render_assist_item(
		"RP îáùåíèå â ÷àòàõ",
		"Âàøè ñîîáùåíèÿ â ÷àò áóäóò îòïðàâëÿòüñÿ ñ çàãëàâíîé áóêâû è òî÷êîé â êîíöå.\nÒàê-æå ðàáîòàåò è â òàêèõ ÷àòàõ êàê: /s /do /f /fb /r /rb /j /jb /fam /al",
		settings.general,
		"rp_chat"
	)
	render_assist_item(
		"RP îòûãðîâêà îðóæèÿ",
		"Ïðè èñïîëüçîâàíèè èëè ñêðîëëå îðóæèÿ, â ÷àòå áóäóò RP îòûãðîâêè.\nÍàñòðîèòü ìîæíî ÷åðåç êîìàíäó /rpguns èëè êíîïêîé øåñòåðåíêè ñïðàâà.",
		settings.general,
		"rp_guns",
		false,
		function()
			MODULE.RPWeapon.Window[0] = true
			MODULE.Main.Window[0] = false
		end
	)
	render_assist_item(
		"RP ïðîâåðêà äîêóìåíòîâ",
		"Àâòîìàòè÷åñêè ïðèíèìàåò äîêóìåíòû èç /offer\nÒàê-æå ÷åðåç RP îòûãðîâêó ïðîâåðÿåò èõ, çàòåì âîçâðàùàåò.",
		settings.general,
		"auto_accept_docs"
	)
	render_assist_item(
		"Ïèíã â ÷àòå @" .. MODULE.Binder.tag.my_nick(),
		"Çâóêîâîå îïîâåùåíèå íà ïèíã âàøåãî íèêíåéìà â èãðîâûõ ÷àòàõ",
		settings.general,
		"ping"
	)
	render_assist_item(
		"Àâòîôëèï äîìêðàòîì",
		"Åñëè ïåðåâåðí¸òåñü íà àâòî, àâòîìàòè÷åñêè èñïîëüçóåòñÿ /domkrat äëÿ ñïàñåíèÿ.\nÅñëè ó âàñ íå áóäåò èõ â èíâåíòàðå, òî âàøå àâòî íå ïåðåâåðí¸òñÿ!",
		settings.general,
		"aflip_domkrat",
		true
	)
	render_assist_item(
		"Ïåðåîäåâàíèå ìàñêè",
		"Åñëè âàøà ìàñêà ñëåòàåò, ñðàçó æå àâòîìàòè÷åñêè íàäåâàåò íîâóþ.\nÂàø öâåòíîé êëèñò äàæå íå óñïååò ïîÿâèòüñÿ íà êàðòå.",
		settings.general,
		"auto_mask",
		true
	)
	if not isMode('none') then
		render_assist_item(
			"Îáíîâëåíèå ñïèñêà /mb",
			"Àâòîìàòè÷åñêè îáíîâëÿåò ñïèñîê ñîòðóäíèêîâ â /mb êàæäûå 3 ñåêóíäû.",
			settings.general,
			"auto_update_members",
			true
		)
		render_assist_item(
			"Àâòî-äîêëàäû /post",
			"Àâòîìàòè÷åñêè îòïðàâëÿåò äîêëàä â ðàöèþ êàæäûå 5 ìèíóò íà ïîñòó.\n(âû äîëæíû íà÷àòü /post ÷òîáû äàííàÿ ôóíêöèÿ ðàáîòàëà)",
			settings.general,
			"auto_doklad_post",
			true
		)
	end
	if modules.player.data.fraction_rank_number >= 9 then
		render_assist_item(
			"Èíâàéò èãðîêîâ ïî ôðàçå [9/10]",
			'Àâòîìàòè÷åñêè èíâàéòèò èãðîêîâ, êîòîðûå ïðîñÿò èíâàéò â ÷àòå.\nÄëÿ íàñòðîéêè âûäà÷è ðàíãà íàæìèòå íà øåñòåð¸íêó ñïðàâà îò êíîïêè',
			settings.general.auto_invite,
			"enable",
			true,
			function()
				imgui.OpenPopup(fa.PERSON_CIRCLE_CHECK .. u8' Ðàíã äëÿ àâòî-èíâàéòà ' .. fa.PERSON_CIRCLE_CHECK)
			end
		)
		render_assist_item(
			"Óâàë ñîòðóäíèêîâ ïî ÏÑÆ [9/10]",
			"Àâòîìàòè÷åñêîå óâîëüíåíèå ñîòðóäíèêîâ, êîòîðûå ïðîñÿò óâàë ÏÑÆ â /r /rb /f /fb\nÏðèìåð ñèòóàöèè êàê ýòî ðàáîòàåò:\n1) Èãðîê ïèøåò â /r Óâîëüòå ìåíÿ ïî ïñæ\n2) Cêðèïò îòâå÷àåò: /rb Nick_Name, îòïðàâüòå /rb +++ ÷òîáû óâîëèòüñÿ ÏÑÆ!\n3) Èãðîê îòïðàâëÿåò /rb +++ è ñêðèïò åãî óâîëüíÿåò ïî ÏÑÆ\n\nP.S. Åñëè èãðîê ôëóäèò ïðîñüáàìè îá óâàëå, ñêðèïò ÑÀÌ åãî óâîëèò, áåç +++\nP.S.S. Äàííàÿ ôóíêöèÿ ðàáîòàåò òîëüêî åñëè âû îäåòû â ðàáî÷óþ ôîðìó.",
			settings.general,
			"auto_uninvite"
		)
	end
end
function render_fractions_functions() 
	if (isMode('police') or isMode('fbi')) then 
		if imgui.BeginTabBar('FractinFunctions') then
			if imgui.BeginTabItem(fa.ROBOT .. u8' Ëè÷íûé ïîìîùíèê "Àññèñòåíò"') then 
				if imgui.BeginChild('##mj_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					firs_render_assist_gui()
					render_assist_item(
						"Ïðîáèâ /time íà îáûñê/ðîçûñê/àðåñò",
						"Àâòîìàòè÷åñêè äåëàåò /time äëÿ ñêðèíøîòîâ ïðè âàæíûõ äåéñòâèÿõ.",
						settings.mj,
						"auto_time"
					)
					render_assist_item(
						"Ñìåíà CODE 3/4 îò ñòàòóñà ìèãàëîê ò/ñ",
						"Àâòîìàòè÷åñêè ìåíÿåò ñèòóàöèîííûé êîä ïðè óïðàâëåíèè ìèãàëêàìè.",
						settings.mj,
						"auto_change_code_siren"
					)
					render_assist_item(
						"Àíòè-âçëîì íàðó÷íèêîâ ñêðåïàìè",
						"Åñëè èãðîê ïîïûòàåòñÿ âçëîìàòü íàðóíèêè ñêðåïêàìè, âû ïîëó÷èòå óâåäîìëåíèå.\nÒàê-æå ñêðèïò ïîïðîáóåò àâòîìàòè÷åñêè èçüÿòü ñêðåïêè ó èãðîêà, åñëè âû ðÿäîì.",
						settings.mj,
						"anti_screpki"
					)
					render_assist_item(
						"Äîêëàä CODE 0 ïðè íàïàäåíèè",
						"Ïðè ïîëó÷åíèè óðîíà îòïðàâëÿåò äîêëàä /r CODE 0 ñ óêàçàíèåì íèêà íàïàäàâøåãî.",
						settings.mj,
						"auto_doklad_damage"
					)
					render_assist_item(
						"Àâòî-äîêëàäû /patrool",
						"Àâòîìàòè÷åñêè îòïðàâëÿåò äîêëàä â ðàöèþ êàæäûå 5 ìèíóò â ïàòðóëå.\n(âû äîëæíû íà÷àòü /patrool ÷òîáû ôóíêöèÿ ðàáîòàëà)",
						settings.mj,
						"auto_doklad_patrool",
						true
					)
					render_assist_item(
						"Äîêëàä ïîñëå àðåñòà èãðîêà",
						"Ïîñëå çàâåðøåíèÿ àðåñòà àâòîìàòè÷åñêè îòïðàâëÿåò äîêëàä â ðàöèþ ñ èìåíåì àðåñòîâàííîãî.",
						settings.mj,
						"auto_doklad_arrest",
						true
					)
					render_assist_item(
						"Îáíîâëåíèå ñïèñêà /wanteds",
						"Àâòîìàòè÷åñêè îáíîâëÿåò ñïèñîê /wanteds êàæäûå 15 ñåêóíä.",
						settings.mj,
						"auto_update_wanteds",
						true
					)
					render_assist_item(
						"Çàïîëíåíèå ðàññëåäîâàíèé",
						"Àâòîìàòè÷åñêè çàïîëíÿåò âñå äàííûå â äèàëîãàõ ðàññëåäîâàíèÿ óáèéñòâ.",
						settings.mj,
						"auto_case_documentation",
						true
					)
					render_assist_item(
						"Êëèêåð íà ÃÐÏ",
						"Àâòîêëèêåð â ìåíþøêàõ íà Ñëó÷àéíûõ Ñèòóàöèÿõ (ðàçáîð çàâàëîâ).",
						settings.general,
						"auto_clicker",
						true
					)
					render_assist_item(
						"Àâòî-îòûãðîâêè RP íà ÃÐÏ",
						"Àâòîìàòè÷åñêèå RP îòûãðîâêè íà Ñëó÷àéíûõ Ñèòóàöèÿõ (ñèñòåìíûõ ÃÐÏ).\nÂìåñòî âàñ áóäåò îòûãðûâàòü äåéñòâèÿ ñ çàâàëàìè äëÿ ïîëó÷åíèÿ RP point",
						settings.mj,
						"auto_rp_situation",
						true
					)
					render_assist_item(
						"AWANTED (ïðåñòóïíèêè âîçëå âàñ)",
						"Îïîâåùàåò âàñ, åñëè â çîíå ïðîðèñîâêè ïîÿâèëñÿ ïðåñòóïíèê.\nÒàê-æå êèäàåò íà íåãî /find è /z (åñëè ðÿäîì)",
						settings.mj,
						"awanted",
						true
					)
					imgui.Separator()
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.STAR .. u8' Ñèñòåìà óìíîãî ðîçûñêà') then 
				renderSmartGUI(
					'Ñèñòåìà óìíîãî ðîçûñêà',
					fa.STAR,
					'https://mtgmods.github.io/arizona-helper/SmartUK/' .. getServerNumber() .. '/SmartUK.json',
					'ñèñòåìû óìíîãî ðîçûñêà',
					modules.smart_uk.data,
					function() save_module("smart_uk") end,
					'Èñïîëüçóéòå: /sum [ID èãðîêà]',
					modules.smart_uk.path,
					'smart_uk',
					'óìíûé ðîçûñê'
				)
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.TICKET .. u8' Ñèñòåìà óìíûõ øòðàôîâ') then 
				renderSmartGUI(
					'Ñèñòåìà óìíûõ øòðàôîâ', 
					fa.TICKET, 
					'https://mtgmods.github.io/arizona-helper/SmartPDD/' .. getServerNumber() .. '/SmartPDD.json', 
					'ñèñòåìû óìíûõ øòðàôîâ', 
					modules.smart_pdd.data, 
					function() save_module("smart_pdd") end, 
					'Èñïîëüçóéòå: /tsm [ID èãðîêà]', 
					modules.smart_pdd.path,
					'smart_pdd',
					'óìíûå øòðàôû'
				)
				imgui.EndTabItem()
			end
			imgui.EndTabBar() 
		end
	elseif isMode('army') then
		if imgui.BeginChild('##army_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
			firs_render_assist_gui()
			render_assist_item(
				"Äîêëàä CODE 0 ïðè íàïàäåíèè",
				"Ïðè ïîëó÷åíèè óðîíà îòïðàâëÿåò äîêëàä /r CODE 0 ñ óêàçàíèåì íèêà íàïàäàâøåãî.",
				settings.md,
				"auto_doklad_damage"
			)
			render_assist_item(
				"Àâòî-äîêëàä ïðè ïàòðóëå òåðèòîðèè",
				"Ïðè ñèñòåìíîì ïàòðóëèðîâàíèè òåððèòîðèè ñ îðóæèåì â ðóêàõ, äåëàåò äîêëàäû /r.\n(âû äîëæíû íà÷àòü ïàòðóëèðîâàíèå òåððèòîðèè, ÷òîáû ôóíêöèÿ ðàáîòàëà)",
				settings.md,
				"auto_doklad_patrool",
				true
			)
			imgui.Separator()
			imgui.EndChild()
		end
	elseif isMode('prison') then
		if imgui.BeginTabBar('FractinFunctions') then
			if imgui.BeginTabItem(fa.ROBOT .. u8' Ëè÷íûé ïîìîùíèê "Àññèñòåíò"') then 
				if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					firs_render_assist_gui()
					render_assist_item(
						"Äîêëàä CODE 0 ïðè íàïàäåíèè",
						"Ïðè ïîëó÷åíèè óðîíà îòïðàâëÿåò äîêëàä /r CODE 0 ñ óêàçàíèåì íèêà íàïàäàâøåãî.",
						settings.md,
						"auto_doklad_damage"
					)
					render_assist_item(
						"Àâòî-äîêëàä ïðè ïàòðóëå òåðèòîðèè",
						"Ïðè ñèñòåìíîì ïàòðóëèðîâàíèè òåððèòîðèè ñ îðóæèåì â ðóêàõ, äåëàåò äîêëàäû /r.\n(âû äîëæíû íà÷àòü ïàòðóëèðîâàíèå òåððèòîðèè, ÷òîáû ôóíêöèÿ ðàáîòàëà)",
						settings.md,
						"auto_doklad_patrool",
						true
					)
					imgui.Separator()
					imgui.EndChild()	
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.STAR .. u8' Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà') then 
				renderSmartGUI(
					'Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà', 
					fa.TICKET, 
					'https://mtgmods.github.io/arizona-helper/SmartRPTP/' .. getServerNumber() .. '/SmartRPTP.json', 
					'ñèñòåìû óìíîãî ñðîêà', 
					modules.smart_rptp.data, 
					function() save_module("smart_rptp") end, 
					'Èñïîëüçîâàíèå: /pum [ID èãðîêà]', 
					modules.smart_rptp.path,
					'smart_rptp',
					'óìíûé ñðîê'
				)
				imgui.EndTabItem()
			end
			imgui.EndTabBar() 
		end
	elseif isMode('smi') then
		if imgui.BeginTabBar('FractinFunctions') then
			if imgui.BeginTabItem(fa.ROBOT .. u8' Ëè÷íûé ïîìîùíèê "Àññèñòåíò"') then 
				if imgui.BeginChild('##smi_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then	
					firs_render_assist_gui()
					render_assist_item(
						"Çâóêîâîå îïîâåùåíèå î îáüÿâëåíèÿõ",
						"Ñîçàä¸ò çâóêîâîå óâåäîìëåíèå ïðè ïîñòóïëåíèè íîâûõ îáüÿâëåíèé îò èãðîêîâ.",
						settings.smi,
						"notify_new_ads"
					)
					render_assist_item(
						"Êíîïêè âñòàâêè òåêñòà â ìåíþ ðåäàêòà",
						"Êíîïêè ñ ãîòîâûì òåêñòîì äëÿ âñòàâêè â ñòðî÷êó ðåäàêòèðîâàíèÿ îáüÿâëåíèé.\nÄëÿ ïðåìåíåíèÿ ñîñòîÿíèÿ íåîáõîäèìî ïåðåçàãðóçèòü ñêðèïò / ïåðåçàéòè â èãðó",
						settings.smi,
						"ads_buttons"
					)
					render_assist_item(
						"Èñòîðèÿ îòðåäà÷åííûõ îáüÿâëåíèé",
						"Ñîõðàíèå â èñòîðèþ îáüÿâëåíèé, êîòîðûå áûëè îòðåäà÷åííû ëè÷íî âàìè.\nÒàêèì îáðàçîì, âû ñìîæåòå âñòàâëÿòü èç èñòîðèè â ñòðî÷êó ðåäàêòà.",
						settings.smi,
						"ads_history"
					)
					render_assist_item(
						"Âçÿòèå ñâîáîäíûõ îáüÿâëåíèé",
						"Â ñïèñêå îáüÿâ àâòîìàòè÷åñêè áóäåò âûáèðàòüñÿ ïåðâîå ñâîáîäíîå îáüÿâëåíèå.\nÒàêèì îáðàçîì, âàì íå íóæíî áóäåò âðó÷íóþ âûáèðàòü îáüÿâëåíèÿ â òîì ñïèñêå.",
						settings.smi,
						"auto_select_first_ad"
					)
					render_assist_item(
						"Êîïèðîâàíèå ÷óæèõ ðåäàêòîâ",
						"Ñîõðàíèå â èñòîðèþ îáüÿâëåíèé, êîòîðûå îòðåäàêòèðîâàëè âàøè êîëëåãè.\nÒàêèì îáðàçîì, ó âàñ áóäåò âîçìîæíîñòü áûñòðîé îòïðàâêè òàêîãî îáüÿâëåíèÿ.\n\nÅñëè 2+ îáüÿâû îäíîâðåìåííî, òî ôóíêöèÿ ìîæåò äàòü ñáîé è ñîõðàíèò íåâåðíî!",
						settings.smi,
						"steal_other_ads",
						true
					)
					render_assist_item(
						"AI ãåíåðàöèÿ îáüÿâëåíèé",
						"Ãåíåðàöèÿ ðåäàêòèðîâàíèÿ îáüÿâëåíèé ñ ïîìîùüþ AI òåïåðü äîñòóïíà â õåëïåðå!\n\nÏîääåðæèâàåò 2 ðåæèìà ðàáîòû:\n1) Ïî êíîïêå ðîáîòà, â ìåíþøêå ðåäàêòèðîâàíèÿ (ÐÅÊÎÌÅÍÄÓÞ)\n2) Àâòîìàòè÷åñêè ñ îòïðàâêîé, áåç îòêðûòèÿ ìåíþøêè ðåäàêòèðîâàíèÿ.\n\nÏÅÐÅÄ ÈÑÏÎËÜÇÎÂÀÍÈÅÌ ÂÀÌ ÍÓÆÍÎ ÍÀÑÒÐÎÈÒÜ ÑÂÎÉ Gemini API key\nRADICAL HELPER ÍÅ ÄÀ¨Ò ÂÀÌ AI ÃÅÍÅÐÀÒÎÐ, ÒÎËÜÊÎ ÑÂßÇÛÂÀÅÒ ÝÒÎÒ ÑÊÐÈÏÒ Ñ GEMINI!\n\nÄëÿ íàñòðîéêè AI ãåíåðàöèè èñïîëüçóéòå êíîïêó øåñòåðåíêè ñïðàâà\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
						settings.smi.ai_generate,
						"enable",
						true,
						function() imgui.OpenPopup(fa.ROBOT .. u8' Íàñòðîéêà AI ãåíåðàöèè îáüÿâëåíèé ' .. fa.ROBOT) end
					)
					render_assist_item(
						"Àâòî-ðåäàêò èç èñòîðèè îáüÿâ",
						"Àâòî-îòïðàâà ñîõðàí¸ííîé îáúÿâû îò òîãî æå èãðîêà, åñëè îí êèäàåò ïîâòîðíî.\nËèáî âñòàâèò òåêñò îáüÿâêè â ñòðî÷êó ðåäàêòèðîâàíèÿ, åñëè ôóíêöèÿ îòêëþ÷åíà\n\nÌîæíî íàñòðîèòü ñâîþ çàäåðæêó ïåðåä îòïðàâêîé êíîïêîé øåñòåðåíêè ñïðàâà\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
						settings.smi,
						"send_from_history",
						true,
						function() imgui.OpenPopup(fa.FILE_LINES .. u8' Íàñòðîéêà àâòîðåäàêòà ñ èñòîðèè ' .. fa.FILE_LINES) end
					)
					render_assist_item(
						"Ëîâëÿ íîâûõ îáúÿâëåíèé",
						"Ïðè ïîñòóïëåíèè íîâîé îáüÿâêè ïðîïèñûâàåò /newsredak è ïûòàåòñÿ ñëîâèòü å¸.\nÅñëè ñðàçó äâà èãðîêà ñ ôóíêöèé, òî ñëîâèò òîò, ó êîãî ìåíüøå PING & PacketLoss.\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
						settings.smi,
						"auto_catch_ads",
						true
					)
					imgui.Separator()
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.CLOCK_ROTATE_LEFT .. u8' Óïðàâëåíèå èñòîðèåé îáüÿâÿâëåíèé') then
				if imgui.BeginChild('##ads_history_menu', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					if settings.smi.ads_history then
						if modules.ads_history.data then 
							if #modules.ads_history.data == 0 then
								imgui.CenterText(u8('Èñòîðèÿ îáüÿâëåíèé ïóñòà'))
								imgui.Separator()
								imgui.CenterText(u8('Îòðåäàêòèðîâàííûå îáüÿâëåíèÿ áóäóò îòîáðàæàòüñÿ çäåñü'))
							else
								imgui.PushItemWidth(570 * settings.general.custom_dpi)
								imgui.InputTextWithHint(u8'##input_ads_search', u8'Ïîèñê îáüÿâëåíèé ïî íóæíîé ôðàçå, íà÷èíàéòå ââîäèòü å¸ ñþäà...', MODULE.SmiEdit.input_search, 128)
								imgui.Separator()
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.CLOCK_ROTATE_LEFT .. u8' Îáüÿâëåíèå èç èñòîðèè îòðåäà÷åííûõ îáüÿâ', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
									change_dpi()
									imgui.CenterText(u8(MODULE.SmiEdit.adshistory_orig))
									imgui.PushItemWidth(500 * settings.general.custom_dpi)
									imgui.InputTextWithHint(u8'##input_ads_my_edit', u8'Ââåäèòå âàø âàðèàíò ðåäàêöèè äàííîãî îáüÿàëåíèÿ...', MODULE.SmiEdit.adshistory_input_text, 128)
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										for id, ad in ipairs(modules.ads_history.data) do
											if ad.text == MODULE.SmiEdit.adshistory_orig then
												table.remove(modules.ads_history.data, id)
												save_module('ads_history')
												sampAddChatMessage("[Radical Helper] {ffffff}Îáüÿâëåíèå èç èñòîðèè óñïåøíî óäàëåíî!", message_color)
												break
											end
										end
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
										for id, ad in ipairs(modules.ads_history.data) do
											if ad.text == MODULE.SmiEdit.adshistory_orig then
												ad.my_text = u8:decode(ffi.string(MODULE.SmiEdit.adshistory_input_text))
												save_module('ads_history')
												sampAddChatMessage("[Radical Helper] {ffffff}Îáüÿâëåíèå èç èñòîðèè óñïåøíî èçìåíåíî è ñîõðàíåíî!", message_color)
												break
											end
										end
										imgui.CloseCurrentPopup()
									end
									imgui.EndPopup()
								end
								local input_ads_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_search))
								for id, ad in ipairs(modules.ads_history.data) do
									if (ad and ad.text and ad.my_text) then
										if ((input_ads_decoded == '') or (ad.my_text:rupper():find(input_ads_decoded:rupper(), 1, true))) then
											if imgui.Button(u8(ad.my_text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
												MODULE.SmiEdit.adshistory_orig = ad.text
												imgui.StrCopy(MODULE.SmiEdit.adshistory_input_text, u8(ad.my_text))
												imgui.OpenPopup(fa.CLOCK_ROTATE_LEFT .. u8' Îáüÿâëåíèå èç èñòîðèè îòðåäà÷åííûõ îáüÿâ')
											end
										end
									end
								end
							end
						else
							imgui.CenterText(u8('Îøèáêà çàãðóçêè èñòîðèè îáüÿâëåíèé, ÷òî-òî ñëîìàëîñü'))
							imgui.Separator()
							imgui.CenterText(u8('×òîáû ïîôèêñèòü, óäàëèòå ôàéëèê Ads.json, êîòîðûé íàõîäèòñÿ ïî ïóòè:'))
							imgui.TextWrapped(u8(modules.ads_history.path))
							imgui.Separator()
							imgui.CenterText(u8('Ëèáî åñëè âû îïûòíûé þçåð, âðó÷íóþ îòêðîéòå ôàéë â CP1251 è èñïðàâüòå îøèáêó'))
						end
					else
						imgui.CenterText(u8('Âû îòêëþ÷èëè ôóíêöèþ "Èñòîðèÿ îáüÿâëåíèé" â /helper - Ôóíêöèè ÑÌÈ, âêëþ÷èòå å¸'))
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			imgui.EndTabBar() 
		end
	elseif isMode('hospital') then
		if imgui.BeginTabBar('FractinFunctions') then
			if imgui.BeginTabItem(fa.ROBOT .. u8' Ëè÷íûé ïîìîùíèê "Àññèñòåíò"') then 
				if imgui.BeginChild('##hospital_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					firs_render_assist_gui()
					render_assist_item(
						"Õèë èç ÷àòà",
						"Ïîçâîëÿåò áûñòðî ëå÷èòü ïàöèåíòîâ êîòîðûå ïðîñÿò ÷òîáû èõ âûëå÷èëè\n\nÅñòü äâà ðåæèìà ðàáîòû õèëà èç ÷àòà:\n1) Ïî íàæàòèþ êíîïêè\n2) Àâòîìàòè÷åñêèé\nÄëÿ ñìåíû ðåæèìà èñïîëüçóéòå êíîïî÷êó øåñòåð¸íêè ñïðàâà\n\nÀÂÒÎÕÈË ÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REP",
						settings.mh.heal_in_chat,
						"enable",
						false,
						function() imgui.OpenPopup(fa.KIT_MEDICAL .. u8' Ðåæèì ëå÷åíèÿ èãðîêîâ ' .. fa.KIT_MEDICAL) end
					)
					render_assist_item(
						"Àâòî-êëèêåð íà ÃÐÏ",
						"Àâòîêëèêåð â ìåíþøêàõ íà Ñëó÷àéíûõ Ñèòóàöèÿõ (õèë, íîñèëêè)\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
						settings.general,
						"auto_clicker",
						true
					)
					render_assist_item(
						"Àâòî-îòûãðîâêè RP íà ÃÐÏ",
						"Àâòîìàòè÷åñêèå RP îòûãðîâêè íà Ñëó÷àéíûõ Ñèòóàöèÿõ (ñèñòåìíûõ ÃÐÏ).\nÂìåñòî âàñ áóäåò îòûãðûâàòü äåéñòâèÿ ñ NPC äëÿ ïîëó÷åíèÿ RP point\n(êàðåòà, ðàíåííûå, ïîñòðàäàâøèå, îïåðàöèè, ìîðã)",
						settings.mh,
						"auto_rp_situation",
						true
					)
					imgui.Separator()
					imgui.EndChild()	
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.SACK_DOLLAR .. u8' Öåíîâàÿ ïîëèòèêà áîëüíèöû') then 
				if imgui.BeginChild('##hospital_price', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					local med_price_fields = {}
					local server = getServerNumber()
					if tonumber(server) > 300 then -- rodina
						med_price_fields = {
							{label = '  Ëå÷åíèå èãðîêà',              					key = 'heal',},
							{label = '  Âûäà÷à ðåöåïòà',                     			key = 'recept'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 7 äíåé',         			key = 'med7'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 14 äíåé',        			key = 'med14'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 30 äíåé',        			key = 'med30'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 60 äíåé',       			key = 'med60'},
						}
					else
						med_price_fields = {
							{label = '  Ëå÷åíèå èãðîêà (SA $)',              			key = 'heal', same_line = true},
							{label = '  Ëå÷åíèå èãðîêà (VC $)',             			key = 'heal_vc'},
							{label = '  Ëå÷åíèå îõðàííèêà (SA $)',           			key = 'healactor', same_line = true},
							{label = '  Ëå÷åíèå îõðàííèêà (VC $)',           			key = 'healactor_vc'},
							{label = '  Ïðîâåäåíèå ìåä. îñìîòðà äëÿ ïèëîòîâ', 			key = 'medosm'},
							{label = '  Ïðîâåäåíèå ìåä. îñìîòðà äëÿ âîåííîãî áèëåòà', 	key = 'mticket'},
							{label = '  Ïðîâåäåíèå ëå÷åíèÿ çàâèñèìîñòè îò óêðîïà', 	key = 'healbad'},
							{label = '  Âûäà÷à ðåöåïòà',                     			key = 'recept'},
							{label = '  Âûäà÷à àíòèáèîòèêà',                 			key = 'ant'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 7 äíåé',         			key = 'med7', same_line = true},
							{label = '  Âûäà÷à ìåä.êàðòû íà 14 äíåé',        			key = 'med14'},
							{label = '  Âûäà÷à ìåä.êàðòû íà 30 äíåé',        			key = 'med30', same_line = true},
							{label = '  Âûäà÷à ìåä.êàðòû íà 60 äíåé',       			key = 'med60'},
						}
					end
					for i, field in ipairs(med_price_fields) do
						imgui.PushItemWidth(65 * settings.general.custom_dpi)
						local buf = MODULE.MedicalPrice[field.key]
						if imgui.InputText(u8(field.label), buf, 8) then
							local str = u8:decode(ffi.string(buf)):gsub("%D", "")
							local num = tonumber(str)
							if num then
								settings.mh.price[field.key] = num
								save_settings()
							end
						end
						if field.same_line then 
							imgui.SameLine()
							imgui.SetCursorPosX((320 * settings.general.custom_dpi))
						else 
							imgui.Separator() 
						end
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			imgui.EndTabBar() 
		end
	elseif isMode('lc') then
		if imgui.BeginTabBar('FractinFunctions') then
			if imgui.BeginTabItem(fa.ROBOT .. u8' Ëè÷íûé ïîìîùíèê "Àññèñòåíò"') then 
				if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					firs_render_assist_gui()
					render_assist_item(
						"Àâòî-âûáîð áëèæàéøåãî çíàêà",
						"Àâòîìàòè÷åñêè âûáèðàåò áëèæàéøèé äîðîæíûé çíàê äëÿ îáñëóæèâàíèÿ.",
						settings.lc,
						"auto_find_clorest_znak"
					)
					render_assist_item(
						"Àâòî-êëèêåð íà ðåìîíò çíàêîâ",
						"Àâòîêëèêåð â ìåíþøêå ðåìîíòà ñëîìàííîãî äîðîæíîãî çíàêà.",
						settings.lc.auto_repair_znak,
						"enable",
						true,
						function() imgui.OpenPopup(fa.GEAR .. u8' Íàñòðîéêà àâòî-ðåìîíòà çíàêîâ ' .. fa.GEAR) end
					)
					render_assist_item(
						"Àâòî-êëèêåð íà óñòàíîâêó çíàêà",
						"Àâòîêëèêåð â ìåíþøêå óñòàíîâêè íîâîãî äîðîæíîãî çíàêà.",
						settings.lc.auto_install_znak,
						"enable",
						true,
						function() imgui.OpenPopup(fa.GEAR .. u8' Íàñòðîéêà àâòî-óñòàíîâêè çíàêîâ ' .. fa.GEAR) end
					)
					render_assist_item(
						"Àâòî-âûäà÷à ëèöåíçèé",
						"Àâòîìàòå÷åñêè âûäà¸ò ëèöåíçèè èãðîêàì ïîêà âû ñòîèòå çà ñòîéêîé.\nÈãðîêè äîëæíû íàïèñàòü â ÷àò òèï ëèöåíçèè (÷àñòîèñïîëüçóåìûå ôðàçû) è ñðîê.\nÅñëè ñðîê íå íàïèñàí, íàïðèìåð ïðîñòî \"ïðàâà\", òî àâòîâûäà÷à âûäàñò íà 3 ìåñÿöà.\n\nÅñòü äâà ðåæèìà ðàáîòû àâòî-âûäà÷è ëèöåíçèé:\n1) Áåç RP îòûãðîâêè\n2) Èñïîëüçóÿ RP îòûãðîâêó\nÄëÿ ñìåíû ðåæèìà èñïîëüçóéòå êíîïî÷êó øåñòåð¸íêè ñïðàâà\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
						settings.lc.auto_lic,
						"enable",
						true,
						function() imgui.OpenPopup(fa.FILE_LINES .. u8' Ðåæèì âûäà÷è ëèöåíçèé ' .. fa.FILE_LINES) end
					)
					imgui.Separator()
					imgui.EndChild()	
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.SACK_DOLLAR .. u8' Öåíîâàÿ ïîëèòèêà ëèöåíçèé') then 
				if imgui.BeginChild('##license_price', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
					local isRodina = tonumber(getServerNumber()) > 300
					local license_types = {
						{name = 'Àâòî', key = 'avto'},
						{name = 'Ìîòî', key = 'moto'},
						{name = 'Ëîäêè', key = 'swim'},
						{name = 'Ïîëåòû', key = 'fly'},
						{name = 'Îðóæèå', key = 'gun'},
						{name = 'Ðûáàëêà', key = 'fish'},
						{name = 'Îõîòà', key = 'hunt'},
					}
					if isRodina then
						table.insert(license_types, {name = 'Ïîåçä', key = 'train'})
					else
						table.insert(license_types, {name = 'Ðàñêîïêè', key = 'klad'})
						table.insert(license_types, {name = 'Òàêñè', key = 'taxi'})
						table.insert(license_types, {name = 'Ìåõàíèê', key = 'mexa'})
					end
					for i, license in ipairs(license_types) do
						for month = 1, (isRodina and 1 or 3) do
							local month_label = (month == 1) and " %s (ìåñÿö)" or string.format(" %%s (%d ìåñÿöà)", month)
							local label = string.format(month_label, license.name)
							local key = license.key .. month
							local buf = MODULE.LicensePrice[key]
							imgui.PushItemWidth(65 * settings.general.custom_dpi)
							if imgui.InputText(u8(label), buf, 9) then
								local str = u8:decode(ffi.string(buf))
								str = str:gsub("%D","")
								local num = tonumber(str)
								if num then
									settings.lc.price[key] = num
									save_settings()
								end
							end
							if month == 1 and not isRodina then
								imgui.SameLine()
								imgui.SetCursorPosX(195 * settings.general.custom_dpi)
							elseif month == 2 then
								imgui.SameLine()
								imgui.SetCursorPosX(395 * settings.general.custom_dpi)
							elseif i ~= #license_types then
								imgui.Separator()
							end
						end
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			imgui.EndTabBar() 
		end
	elseif isMode('gov') then
		if imgui.BeginChild('##gov_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
			firs_render_assist_gui()
			render_assist_item(
				"Àíòè Òðåâîæíàÿ Êíîïêà",
				"Óáèðàåò òðåâîæíóþ êíîïêó êîòîðàÿ íàõîäèòñÿ íà 2 ýòàæå.\nÒåì ñàìûì âû íå áóäåòå ñëó÷àéíî âûçûâàòü ÌÞ èç-çà ýòîé êíîïêè.",
				settings.gov,
				"anti_trivoga"
			)
			render_assist_item(
				"Êàñòîìíàÿ ìåíþøêà /zeks",
				"Âûâîäèò ñïèñîê çàêëþ÷åííûõ íà ýêðàí, ÷òîáû íå îòêðûâàòü êàæäûé ðàç /zeks",
				settings.gov,
				"custom_zeks"
			)
			render_assist_item(
				"Àâòîîáíîâëåíèå ìåíþøêè /zeks",
				"Àâòîìàòè÷åñêè (ðàç â 15 ñåêóíä) îáíîâëÿåò ñïèñîê ìåíþøêè /zeks",
				settings.gov,
				"auto_update_zeks",
				true
			)
			imgui.Separator()
			imgui.EndChild()
		end
	elseif isMode('fd') then
		if imgui.BeginChild('##fd_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
			firs_render_assist_gui()
			render_assist_item(
				"Äîêëàä ïðî ïðèíÿòèå ïîæàðà",
				"Àâòîäîêëàä â ðàöèþ /r î ïðèíÿòèè ïîæàðà èç ñïèñêà /fires è âûåçäå ê íåìó.",
				settings.fd.doklads,
				"togo"
			)
			render_assist_item(
				"Äîêëàä ïðî ïðèáûòèè íà ïîæàð",
				"Àâòîäîêëàä â ðàöèþ /r î ïðèáûòèè â çîíó ïîæàðà.",
				settings.fd.doklads,
				"here"
			)
			render_assist_item(
				"Äîêëàä ïðî òóøåíèå ïîæàðà",
				"Àâòîäîêëàä â ðàöèþ /r îá óñòðàíåíèè î÷àãîâ ïîæàðà.",
				settings.fd.doklads,
				"fire",
				true
			)
			render_assist_item(
				"Äîêëàä ïðî íîñèëêè",
				"Àâòîäîêëàä â ðàöèþ /r î íàëè÷èè íîñèëîê â çîíå ïîæàðà.",
				settings.fd.doklads,
				"stretcher",
				true
			)
			render_assist_item(
				"Äîêëàä ïðî ïîñòðàäàâøåãî",
				"Àâòîäîêëàä â ðàöèþ /r î ñïàñåíèè ïîñòðàäàâøåãî â çîíå ïîæàðà.",
				settings.fd.doklads,
				"npc_save",
				true
			)
			render_assist_item(
				"Äîêëàä ïðî çàâåðøåíèå ïîæàðà",
				"Àâòîäîêëàä â ðàöèþ /r î ïîëíîì çàâåðøåíèè ïîæàðà.",
				settings.fd.doklads,
				"file_end"
			)
			render_assist_item(
				"Äîêëàä ïðî ñáîð ïàëàòêè",
				"Àâòîäîêëàä â ðàöèþ /r î ñáîðå ïàëàòêè ïîñëå ïîæàðà.",
				settings.fd.doklads,
				"tent"
			)
			imgui.Separator()
			imgui.EndChild()
		end
	elseif isMode('ins') then
		if imgui.BeginChild('##ins_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
			firs_render_assist_gui()
			render_assist_item(
				"Àíòè Òðåâîæíàÿ Êíîïêà",
				"Óáèðàåò òðåâîæíóþ êíîïêó âûçîâà ïîëèöèè ñ èíòåðüåðà.\nÒåì ñàìûì âû íå áóäåòå ñëó÷àéíî âûçûâàòü ÌÞ èç-çà ýòîé êíîïêè.",
				settings.ins,
				"anti_trivoga"
			)
			render_assist_item(
				"Çâóêîâîå îïîâåùåíèå î çàÿâêàõ",
				"Ñîçäà¸ò çâóêîâîå óâåäîìëåíèå ïðè ïîñòóïëåíèè íîâûõ çàÿâîê íà ñòðàõîâêó",
				settings.ins,
				"notify_new_ticket"
			)
			render_assist_item(
				"Áûñòðûé âûáîð çàÿâîê",
				"Àâòîìàòè÷åñêè âûáèðàåò ïîñëåäíåãî èãðîêà, ïîäàâøåãî çàÿâêó, â ñïèñêå çàÿâîê.",
				settings.ins,
				"auto_catch_ticket",
				true
			)
			render_assist_item(
				"Êëèêåð (1 êàá)",
				"Àâòîìàòè÷åñêèå íàæàòèÿ ïðè ðàáîòå â 1 êàáèíåòå.\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
				settings.general,
				"auto_clicker",
				true
			)
			if not IS_MOBILE then
				render_assist_item(
					"Ïîäñêàçêè êîíâåðòîâ (2 êàá)",
					"Ïîäñêàçêè ïðàâèëüíûõ êîíâåðòîâ ïðè ðàáîòå âî 2 êàáèíåòå.",
					settings.ins,
					"hint_in_sort"
				)
			end
			render_assist_item(
				"Ìèíè-èãðà (2 êàá)",
				"Àâòîìàòè÷åñêîå ïðîõîæäåíèå ìèíè-èãðû ñ êîíâåðàòàìè âî 2 êàáèíåòå.\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
				settings.ins,
				"auto_find_game",
				true
			)
			render_assist_item(
				"Çàïîëíåíèå äèàëîãîâ (3 êàá)",
				"Àâòîìàòè÷åñêîå çàïîëíåíèå äèàëîãîâ ïðè ðàáîòå â 3 êàáèíåòå.",
				settings.ins,
				"auto_input_ticket"
			)
			render_assist_item(
				"Àâòîêëèêåð ïóíêòîâ (3 êàá)",
				"Äîïîëíåíèå ê çàïîëíåíèþ äèàëîãîâ â 3 êàáèíåòå, áåç íåãî ÍÅ ðàáîòàåò.\nÒåì ñàìûì ïîëíîñòüþ àâòîìàòèçèðóåò ðàáîòó â 3 êàáèíåòå, íàæèìàÿ âñ¸ çà âàñ.\n\nÌÎÆÅÒ ÁÛÒÜ ÇÀÏÐÅÙÅÍÎ ÍÀ ÍÅÊÎÒÎÐÛÕ ÑÅÐÂÅÐÀÕ! ÓÒÎ×ÍßÉÒÅ Â /REPORT",
				settings.ins,
				"auto_clicker_step3",
				true
			)
			imgui.Separator()
			imgui.EndChild()
		end
	else
		if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
			firs_render_assist_gui()
			imgui.Separator()
			imgui.EndChild()
		end
	end	
end
if (not isMode('none')) then
	imgui.OnFrame(
		function() return MODULE.Members.Window[0] end,
		function(player)
			if #MODULE.Members.all == 0 then
				sampAddChatMessage('[Radical Helper] {ffffff}Îøèáêà, ñïèñîê ñîòðóäíèêîâ ïóñòîé!', message_color)
				MODULE.Members.Window[0] = false
			elseif #MODULE.Members.all >= 16 then 
				sizeYY = 413 + 21
			else
				sizeYY = 24.5 * (#MODULE.Members.all + 1) + 21
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(730 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. " " ..  u8(MODULE.Members.info.fraction) .. " - " .. #MODULE.Members.all .. u8' ñîòðóäíèêîâ îíëàéí ' .. getHelperIcon(), MODULE.Members.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			imgui.Columns(4)
			imgui.CenterColumnText(getUserIcon() .. u8(" Cîòðóäíèê"))
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.RANKING_STAR .. u8(" Äîëæíîñòü"))
			imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.TRIANGLE_EXCLAMATION .. u8(" Âûãîâîðû"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.INFO .. u8(" Èíôî"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.Columns(1)
			for i, v in ipairs(MODULE.Members.all) do
				imgui.Separator()
				imgui.Columns(4)
				if v.working then
					imgui_RGBA = (settings.general.helper_theme ~= 2) and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0, 0, 0, 1)
				else
					imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1)
				end
				local text = u8(v.nick) .. ' [' .. v.id .. ']'
				if tonumber(v.afk) then
					local afk = tonumber(v.afk)
					if afk > 0 then
						if afk < 60 then
							text = text .. ' [AFK ' .. afk .. 's]'
						else
							text = text .. ' [AFK ' .. math.floor(afk / 60) .. 'm]'
						end
					end
				end
				imgui.CenterColumnColorText(imgui_RGBA, text)
				if (imgui.IsItemClicked() and modules.player.data.fraction_rank_number >= 9) then 
					show_leader_fast_menu(v.id)
					MODULE.Members.Window[0] = false
				end
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
				imgui.NextColumn()
				if tonumber(v.warns) == 0 then
					imgui.CenterColumnText(u8(v.warns .. '/3'))
				elseif tonumber(v.warns) == 1 then
					imgui.CenterColumnColorText(imgui.ImVec4(1, 1, 0.231, 1), u8(v.warns .. '/3'))
				else
					imgui.CenterColumnColorText(imgui.ImVec4(1, 0.231, 0.231, 1), u8(v.warns .. '/3'))
				end
				imgui.NextColumn()
				if v.info == '-' then
					imgui.CenterColumnText(u8(v.info))
				else
					imgui.CenterColumnColorText(imgui.ImVec4(1, 0.231, 0.231, 1), u8(v.info))
				end
				imgui.Columns(1)
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.GiveRank.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(getHelperIcon().." Radical Helper " .. getHelperIcon() .. "##rank", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Âûáåðèòå ðàíã äëÿ '.. u8(sampGetPlayerNickname(MODULE.GiveRank.player_id)) .. ':')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.GiveRank.number, 1, (modules.player.data.fraction_rank_number == 9) and 8 or 9)
			imgui.Separator()
			local label = ' Âûäàòü ðàíã' .. ((hotkey_no_errors and settings.general.bind_action) and (' [' .. getNameKeysFrom(settings.general.bind_action) .. ']') or '')
			if imgui.Button(fa.USER .. u8(label), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				MODULE.GiveRank.Window[0] = false
			end
			imgui.End()
		end
	)
end
if not (isMode('ghetto') or isMode('mafia')) then
	imgui.OnFrame(
		function() return MODULE.Sobes.Window[0] end,
		function(player)
			if MODULE.Sobes.player_id ~= nil and isParamSampID(MODULE.Sobes.player_id) then
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
				imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' Ïðîâåäåíèå ñîáåñåäîâàíèÿ èãðîêó ' .. u8(sampGetPlayerNickname(MODULE.Sobes.player_id)) .. ' ' .. fa.PERSON_CIRCLE_CHECK, MODULE.Sobes.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
				change_dpi()
				if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 180 * settings.general.custom_dpi), true) then
					imgui.CenterColumnText(fa.BOOKMARK .. u8" Îñíîâíîå")
					imgui.Separator()
					if imgui.Button(fa.PLAY .. u8" Íà÷àòü ñîáåñåäîâàíèå", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						lua_thread.create(function()
							sampSendChat("Çäðàâñòâóéòå, ÿ " .. modules.player.data.name_surname .. " - " .. modules.player.data.fraction_rank .. ' ' .. modules.player.data.fraction_tag)
							wait(1500)
							sampSendChat("Âû ïðèøëè ê íàì íà ñîáåñåäîâàíèå?")
						end)
					end
					if imgui.Button(fa.PASSPORT .. u8" Ïîïðîñèòü äîêóìåíòû", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						lua_thread.create(function()
							sampSendChat("Õîðîøî, ïðåäîñòàâüòå ìíå âñå âàøè äîêóìåíòû äëÿ ïðîâåðêè.")
							wait(1500)
							sampSendChat("Ìíå íóæåí âàø Ïàñïîðò, Ìåä.êàðòà è Ëèöåíçèè.")
							wait(1500)
							sampSendChat("/n " .. sampGetPlayerNickname(MODULE.Sobes.player_id) .. ", èñïîëüçóéòå /showpass")
							wait(1500)
							sampSendChat("/n Îáÿçàòåëüíî ñ RP îòûãðîâêàìè!")
						end)
					end
					if imgui.Button(fa.USER .. u8" Ðàññêàæèòå î ñåáå", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Íåìíîãî ðàññêàæèòå î ñåáå.")
					end		
					if imgui.Button(fa.CHECK .. u8" Ñîáåñåäîâàíèå ïðîéäåíî", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("/todo Ïîçäðàâëÿþ! Âû óñïåøíî ïðîøëè ñîáåñåäîâàíèå!*óëûáàÿñü")
					end
					if imgui.Button(fa.USER_PLUS .. u8" Ïðèãëàñèòü â îðãàíèçàöèþ", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						find_and_use_command('/invite {id}', MODULE.Sobes.player_id)
						MODULE.Sobes.Window[0] = false
					end
					imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 180 * settings.general.custom_dpi), true) then
					imgui.CenterColumnText(fa.BOOKMARK..u8" Äîïîëíèòåëüíî")
					imgui.Separator()
					if imgui.Button(fa.GLOBE .. u8" Íàëè÷èå ñïåö.ðàöèè Discord", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Èìååòñÿ ëè ó Âàñ ñïåö. ðàöèÿ Discord?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Íàëè÷èå îïûòà ðàáîòû", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Èìååòñÿ ëè ó Âàñ îïûò ðàáîòû â íàøåé ñôåðå?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Ïî÷åìó èìåííî ìû?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Ñêàæèòå ïî÷åìó Âû âûáðàëè èìåííî íàñ?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" ×òî òàêîå àäåêâàòíîñòü?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Ñêàæèòå ÷òî ïî âàøåìó çíà÷èò \"Àäåêâàòíîñòü\"?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" ×òî òàêîå ÄÌ?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Ñêàæèòå êàê âû äóìàåòå, ÷òî òàêîå \"ÄÌ\"?")
					end
				imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true, imgui.WindowFlags.NoScrollbar) then
					imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" Îòêàçû")
					imgui.Separator()
					local function otkaz(reason)
						lua_thread.create(function()
							MODULE.Sobes.Window[0] = false
							sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
							wait(1500)
							sampSendChat(reason)
						end)
					end
					if imgui.Selectable(u8"Çàêîíîïîñëóøíîñòü") then
						otkaz("Ó âàñ ïëîõàÿ çàêîíîïîñëóøíîñòü.")
					end
					if imgui.Selectable(u8"Óêðîïîçàâèñèìîñòü") then
						otkaz("Âàì íåîáõîäèìî âûëå÷èòü çàâèñèìîñòü îò óêðîïà â ëþáîé áîëüíèöå!")
					end
					if imgui.Selectable(u8"Àêòèâíàÿ ïîâåñòêà") then
						otkaz("Ó âàñ ïîâåñòêà, îòñëóæèòå ëèáî ïðîéäèòå îáñëåäîâàíèÿ â áîëüíèöå.")
					end
					if imgui.Selectable(u8"Íåòó ìåä.êàðòû") then
						otkaz("Ó âàñ íåòó ìåä.êàðòû, ïîëó÷èòå å¸ â ëþáîé áîëüíèöå.")
					end
					if imgui.Selectable(u8"Íåòó âîåííîãî áèëåòà") then
						otkaz("Ó âàñ íåòó âîåííîãî áèëåòà!")
					end
					if imgui.Selectable(u8"Íåòó æèëüÿ") then
						otkaz("Ó âàñ íåòó æèëüÿ! Íàéäèòå ñåáå äîì/îòåëü/òðåéëåð.")
					end
					if imgui.Selectable(u8"Ñîñòîèò â ×Ñ") then
						otkaz("Âû ñîñòîèòå â ×¸ðíîì Ñïèñêå íàøåé îðãàíèçàöèè!")
					end
					if imgui.Selectable(u8"Ïðîô.íåïðèãîäíîñòü") then
						otkaz("Âû íå ïîäõîäèòå äëÿ íàøåé ðàáîòû ïî ïðîôåññèîíàëüíûì êà÷åñòâàì.")
					end
				end
				imgui.EndChild()
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ïðîçèîøëà îøèáêà, ID èãðîêà íåäåéñòâèòåëåí!', message_color)
				MODULE.Sobes.Window[0] = false
			end
		end
	)
	imgui.OnFrame(
		function() return MODULE.Departament.Window[0] end,
		function(player)
			local function createTagPopup(tag_type, input_var, setting_key)
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.TAG .. u8' Òåãè îðãàíèçàöèé##'..tag_type, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
					change_dpi()
					if imgui.BeginTabBar('TabTags') then
						local function createTagTab(title, tags)
							if imgui.BeginTabItem(fa.BARS..u8' '..title..' ') then 
								local line_started = false
								for i, tag in ipairs(tags) do
									if tag ~= 'skip' then
										if line_started then
											imgui.SameLine()
										else
											line_started = true
										end
										if tags == modules.departament.data.dep_tags_custom then
											imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
											if imgui.BeginPopupModal(fa.GEAR .. u8' Âûáåðèòå ÷òî èìåííî íóæíî ñäåëàòü ' .. fa.GEAR .. '##' .. i, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
												change_dpi()
												if imgui.ItemSelector(u8'', { u8'Èñïîëüçîâàòü òåã', u8'Óäàëèòü òåã' }, MODULE.Departament.selector.tag, 200 * settings.general.custom_dpi) then
													local bool = (MODULE.Departament.selector.tag[0] ~= 2)
													if bool then
														imgui.StrCopy(input_var, u8(tag))
													else
														table.remove(tags, i)
													end
													save_module('departament')
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
										end
										if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
											if tags == modules.departament.data.dep_tags_custom then
												imgui.OpenPopup(fa.GEAR .. u8' Âûáåðèòå ÷òî èìåííî íóæíî ñäåëàòü ' .. fa.GEAR .. '##' .. i)
											else
												imgui.StrCopy(input_var, u8(tag))
												save_module('departament')
												imgui.CloseCurrentPopup()
											end
										end
									else
										line_started = false
									end
								end
								imgui.Separator()
								if title:find(u8'êàñòîì') then
									if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü òåã##depAddTag', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										imgui.OpenPopup(fa.TAG .. u8' Äîáàâëåíèå íîâîãî òåãà ' .. fa.TAG .. '##'..tag_type)
									end
									imgui.SameLine()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##depAddTag', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(fa.TAG .. u8' Äîáàâëåíèå íîâîãî òåãà ' .. fa.TAG .. '##'..tag_type, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										imgui.CenterText(u8('Åñëè íóæåí ïåðåõîä íà ñëåäóùóþ'))
										imgui.CenterText(u8('ñòðîêó, âìåñòî òåãà óêàæèòå skip'))
										imgui.PushItemWidth(215 * settings.general.custom_dpi)
										imgui.InputText('##MODULE.Departament.new_tag', MODULE.Departament.new_tag, 256) 
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##dep_add_tag'..tag_type, 
											imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##dep_add_tag'..tag_type, 
											imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
											table.insert(modules.departament.data.dep_tags_custom, u8:decode(ffi.string(MODULE.Departament.new_tag)))
											save_module('departament')
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
								end
								imgui.EndTabItem()
							end
						end
						createTagTab(u8'Ñòàíäàðòíûå òåãè (ru)', modules.departament.data.dep_tags)
						createTagTab(u8'Ñòàíäàðòíûå òåãè (en)', modules.departament.data.dep_tags_en)
						createTagTab(u8'Âàøè êàñòîìíûå òåãè', modules.departament.data.dep_tags_custom)
						imgui.EndTabBar()
					end
					imgui.End()
				end
			end
			local function createFrequencyPopup()
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' ×àñòîòà äëÿ èñïîëüçîâàíèÿ ðàöèè /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
					imgui.SetWindowSizeVec2(imgui.ImVec2(400 * settings.general.custom_dpi, 180 * settings.general.custom_dpi))
					change_dpi()
					local line_started = false
					for i, tag in ipairs(modules.departament.data.dep_fms) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(fa.GEAR .. u8' Âûáåðèòå ÷òî èìåííî íóæíî ñäåëàòü ' .. fa.GEAR .. '##' .. i, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
								change_dpi()
								if imgui.ItemSelector(u8'', { u8'Èñïîëüçîâàòü ÷àñòîòó', u8'Óäàëèòü ÷àñòîòó' }, MODULE.Departament.selector.fm, 200 * settings.general.custom_dpi) then
									local bool = (MODULE.Departament.selector.fm[0] ~= 2)
									if bool then
										imgui.StrCopy(MODULE.Departament.fm, u8(tag))
										modules.departament.data.dep_fm = u8:decode(ffi.string(MODULE.Departament.fm))
									else
										table.remove(modules.departament.data.dep_fms, i)
									end
									save_module('departament')
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								imgui.OpenPopup(fa.GEAR .. u8' Âûáåðèòå ÷òî èìåííî íóæíî ñäåëàòü ' .. fa.GEAR .. '##' .. i)
							end
						else
							line_started = false
						end
					end
					
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü ÷àñòîòó', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' Äîáàâëåíèå íîâîé ÷àñòîòû##2')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TAG .. u8' Äîáàâëåíèå íîâîé ÷àñòîòû##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar) then
						imgui.CenterText(u8('Åñëè íóæåí ïåðåõîä íà ñëåäóùóþ'))
						imgui.CenterText(u8('ñòðîêó, âìåñòî ÷àñòîòû óêàæèòå skip'))
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##MODULE.Departament.new_tag', MODULE.Departament.new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then 
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(modules.departament.data.dep_fms, u8:decode(ffi.string(MODULE.Departament.new_tag)))
							save_module('departament')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.WALKIE_TALKIE .. u8" Ðàöèÿ äåïàðòàìåíòà " .. fa.WALKIE_TALKIE, MODULE.Departament.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			change_dpi()
			if imgui.BeginChild('##2', imgui.ImVec2(500 * settings.general.custom_dpi, 190 * settings.general.custom_dpi), true) then
				imgui.Columns(3)
				imgui.CenterColumnText(u8('Âàø òåã:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.tag1', MODULE.Departament.tag1, 256) then
					modules.departament.data.dep_tag1 = u8:decode(ffi.string(MODULE.Departament.tag1))
					save_module('departament')
				end
				if imgui.CenterColumnButton(u8('Âûáðàòü òåã##1')) then
					imgui.OpenPopup(fa.TAG .. u8' Òåãè îðãàíèçàöèé##1')
				end
				createTagPopup('1', MODULE.Departament.tag1, 'dep_tag1')
				
				imgui.NextColumn()
				imgui.CenterColumnText(u8('×àñòîòà ðàöèè:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.fm', MODULE.Departament.fm, 256) then
					modules.departament.data.dep_fm = u8:decode(ffi.string(MODULE.Departament.fm))
					save_module('departament')
				end
				if imgui.CenterColumnButton(u8('Âûáðàòü ÷àñòîòó##1')) then
					imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' ×àñòîòà äëÿ èñïîëüçîâàíèÿ ðàöèè /d')
				end
				createFrequencyPopup()
				imgui.NextColumn()
				imgui.CenterColumnText(u8('Òåã ïîëó÷àòåëÿ:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.tag2', MODULE.Departament.tag2, 256) then
					modules.departament.data.dep_tag2 = u8:decode(ffi.string(MODULE.Departament.tag2))
					save_module('departament')
				end
				if imgui.CenterColumnButton(u8('Âûáðàòü òåã##2')) then
					imgui.OpenPopup(fa.TAG .. u8' Òåãè îðãàíèçàöèé##2')
				end
				createTagPopup('2', MODULE.Departament.tag2, 'dep_tag2')
				imgui.Columns(1)
				imgui.Separator()
				imgui.CenterText(u8('Òåêñò:'))
				imgui.PushItemWidth(405 * settings.general.custom_dpi)
				imgui.InputText(u8'##dep_input_text', MODULE.Departament.text, 256)
				imgui.SameLine()
				if imgui.Button(u8' Îòïðàâèòü ') then
					local tag1 = modules.departament.data.anti_skobki and u8:decode(ffi.string(MODULE.Departament.tag1)):gsub("[%[%]]", "") or u8:decode(ffi.string(MODULE.Departament.tag1))
					local tag2 = modules.departament.data.anti_skobki and u8:decode(ffi.string(MODULE.Departament.tag2)):gsub("[%[%]]", "") or u8:decode(ffi.string(MODULE.Departament.tag2))
					sampSendChat('/d ' .. tag1 .. ' ' .. u8:decode(ffi.string(MODULE.Departament.fm)) .. ' ' .. tag2 .. ': ' .. u8:decode(ffi.string(MODULE.Departament.text)))
				end
				local tag1 = ffi.string(MODULE.Departament.tag1)
				local tag2 = ffi.string(MODULE.Departament.tag2)
				local fm = ffi.string(MODULE.Departament.fm)
				local text = ffi.string(MODULE.Departament.text)
				if modules.departament.data.anti_skobki then
					tag1 = tag1:gsub("[%[%]]", "")
					tag2 = tag2:gsub("[%[%]]", "")
				end
				local preview_text = ('/d ' .. tag1 .. ' ' .. fm .. ' ' .. tag2 .. ': ' .. text)
				imgui.CenterText(preview_text)
				imgui.Separator()
				if imgui.Checkbox(u8(' Îòêëþ÷èòü èñïîëüçîâàíèå ñèìâîëîâ [] (ñêîáîê) â òåãàõ îðãàíèçàöèé'), MODULE.Departament.checkbox.anti_skobki) then
					modules.departament.data.anti_skobki = MODULE.Departament.checkbox.anti_skobki[0]
					save_module('departament')
				end
				imgui.EndChild()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Post.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. u8" Radical Helper " .. getHelperIcon() .. '##post_info_menu', MODULE.Post.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			safery_disable_cursor(player)
			if MODULE.Post.active then
				imgui.Text(fa.MAP_LOCATION_DOT .. u8(' Ïîñò: ') .. u8(MODULE.Binder.tag.get_post_name()))
				imgui.Text(fa.CLOCK .. u8(' Âðåìÿ íà ïîñòó: ') .. u8(MODULE.Binder.tag.get_post_time()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ñîñòîÿíèå: ') .. u8(MODULE.Binder.tag.get_post_code()))
				imgui.SameLine()
				if imgui.SmallButton(fa.GEAR) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Radical Helper##post_select_code'))
				end
				imgui.Separator()
				if imgui.Button(fa.WALKIE_TALKIE .. u8(' Äîêëàä##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if (not MODULE.Post.process_doklad) then
						MODULE.Post.process_doklad = true
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. '. Ïîñò: ' .. MODULE.Binder.tag.get_post_name() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_post_code())
							wait(1500)
							sampSendChat('/r Íàõîæóñü íà ïîñòó óæå ' .. MODULE.Binder.tag.get_post_format_time())
							MODULE.Binder.state.isActive = false
							MODULE.Post.process_doklad = false
						end)
					end
				end	
				imgui.SameLine()
				if imgui.Button(fa.CIRCLE_STOP .. u8(' Êîíåö##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						MODULE.Post.Window[0] = false
						MODULE.Post.active = false
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tag.my_doklad_nick() .. ' íà CONTROL. Ïîñò: ' .. MODULE.Binder.tag.get_post_name() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_post_code() .. '.')
						wait(1500)
						sampSendChat('/r Îñâîáîæäàþ ïîñò! Ïðîñòîÿë' .. MODULE.Binder.tag.sex() .. ' íà ïîñòó: ' .. MODULE.Binder.tag.get_post_format_time() .. '.', -1)
						MODULE.Binder.state.isActive = false
						MODULE.Post.time = 0
						MODULE.Post.start_time = 0
						MODULE.Post.current_time = 0
						MODULE.Post.code = 'CODE4'
						MODULE.Post.ComboCode[0] = 5
					end)
				end
			else
				player.HideCursor = false
				imgui.PushItemWidth(200 * settings.general.custom_dpi)
				if imgui.InputTextWithHint(u8'##post_name', u8('Óêàæèòå íàçâàíèå âàøåãî ïîñòà'), MODULE.Post.input, 256) then
					MODULE.Post.name = u8:decode(ffi.string(MODULE.Post.input))
				end
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ñîñòîÿíèå: ') .. u8(MODULE.Binder.tag.get_post_code()))
				imgui.SameLine()
				if imgui.SmallButton(fa.GEAR) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Radical Helper##post_select_code'))
				end
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Post.Window[0] = false
				end
				imgui.SameLine()
				if imgui.Button(fa.WALKIE_TALKIE .. u8' Çàñòóïèòü##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Post.time = 0
					MODULE.Post.start_time = os.time()
					MODULE.Post.active = true
					MODULE.Binder.state.isActive = true
					sampSendChat('/r Äîêëàäûâàåò ' .. MODULE.Binder.tag.my_doklad_nick() .. '. Çàñòóïàþ íà ïîñò ' .. MODULE.Binder.tag.get_post_name() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_post_code() .. '.')
					MODULE.Binder.state.isActive = false
					imgui.CloseCurrentPopup()
				end
			end
			if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Radical Helper##post_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
				change_dpi()
				player.HideCursor = false 
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##post_code', MODULE.Post.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Post.codes) then
					MODULE.Post.code = MODULE.Post.codes[MODULE.Post.ComboCode[0] + 1]
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.post_menu.x or posY ~= settings.windows_pos.post_menu.y then
				settings.windows_pos.post_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
end
if isMode('police') or isMode('fbi') or isMode('prison') then
	function get_updated_at(data)
		for index, value in ipairs(data) do
			if value.name == '##updated_at' then
				return os.date("%d.%m.%Y %H:%M", value.updated_at)
			end
		end
		return nil
	end
	function set_updated_at(data, module, timestamp)
		for index, value in ipairs(data) do
			if value.name == '##updated_at' then
				value.updated_at = timestamp
				save_module(module)
				return
			end
		end
		table.insert(data, {name = '##updated_at', updated_at = timestamp})
		save_module(module)
	end
	function renderSmartGUI(title, icon, downloadPath, editPopupTitle, data, saveFunction, usageText, pathDisplay, download_file_name, download_item)
		if imgui.BeginChild('##smart'..title, imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true, imgui.WindowFlags.NoScrollbar) then
			if #data ~= 0 then
				imgui.CenterColorText(imgui.ImVec4(0, 1, 0, 1), u8("Àêòèâíî - ") .. u8(usageText))
			else
				imgui.CenterColorText(imgui.ImVec4(1, 0.231, 0.231, 1), u8("Íåàêòèâíî - Çàãðóçèòå ") .. u8(download_item) .. u8(" èç îáëàêà èëè çàïîëíèòå âðó÷íóþ"))
			end
			imgui.Separator()
			local updated_at = get_updated_at(data)
			if updated_at then
				imgui.CenterText(u8("Ïîñëåäíåå îáíîâëåíèå " .. editPopupTitle .. ": ") .. get_updated_at(data))
			end
			imgui.SetCursorPosY(90 * settings.general.custom_dpi)
			imgui.SetCursorPosX(220 * settings.general.custom_dpi)
			if imgui.Button(fa.DOWNLOAD .. (#data ~= 0 and u8' Îáíîâèòü èç îáëàêà 'or u8' Çàãðóçèòü èç îáëàêà ') .. fa.DOWNLOAD .. '##smart'..title) then
				_G['download_'..title:lower()] = true
				download_file = download_file_name
				downloadFileFromUrlToPath(downloadPath, pathDisplay)
				imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Îïîâåùåíèå ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title)
			end
			imgui.CenterText(u8'Äàííûå èç îáëàêà óñòàðåëè èëè íåàêòóàëüíû?')
			imgui.CenterText(u8'Ñîîáùèòå SMART-ðåäàêòîðàì íà íàøåì Discord-ñåðâåðå.')
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Îïîâåùåíèå ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
				if _G['download_'..title:lower()] then
					change_dpi()
					imgui.CenterText(u8'Èä¸ò ñêà÷èâàíèå ' .. u8(editPopupTitle) .. u8' äëÿ ñåðâåðà ' .. u8(getServerName(getServerNumber())) .. " [" .. getServerNumber() .. ']')
					imgui.CenterText(u8'Ïîñëå óñïåøíîé çàãðóçêè îêíî àâòîìàòè÷åñêè çàêðîåòñÿ è âû óâèäèòå ñîîáùåíèå â ÷àòå')
					imgui.Separator()
					imgui.CenterText(u8'Åñëè ïðîøëî áîëüøå 10 ñåêóíä è íè÷åãî íå ïðîèñõîäèò, òî ïðîèçîøëà îøèáêà çàãðóçêè')
					imgui.CenterText(u8'×òî ìîæíî ñäåëàòü â ñëó÷àå îøèáêè:')
					imgui.CenterText(u8'1) Çàïîëíèòü äàííûå âðó÷íóþ, íàæàâ êíîïêó «Îòðåäàêòèðîâàòü»')
					imgui.CenterText(u8'2) Ñêà÷àòü èç îáëàêà JSON-ôàéë âðó÷íóþ è ïîìåñòèòü åãî ïî ïóòè:')
					if #pathDisplay > 98 then
						local first_part = pathDisplay:sub(1, 98)
						local second_part = pathDisplay:sub(99, #pathDisplay)
						imgui.CenterText(u8(first_part))
						imgui.CenterText(u8(second_part))
					else
						imgui.CenterText(u8(pathDisplay))
					end
					imgui.Separator()
				else
					MODULE.Main.Window[0] = false
					imgui.CloseCurrentPopup()
				end
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##close_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(fa.GLOBE .. u8' Îòêðûòü îáëàêî##open_web_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					openLink("https://github.com/MTGMODS/arizona-helper")
					openLink(downloadPath)
					imgui.CloseCurrentPopup()
					MODULE.Main.Window[0] = false
				end
				imgui.EndPopup()
			end
			imgui.SetCursorPosY(220 * settings.general.custom_dpi)
			imgui.SetCursorPosX(200 * settings.general.custom_dpi)
			if imgui.Button(fa.PEN_TO_SQUARE .. u8' Îòðåäàêòèðîâàòü âðó÷íóþ ' .. fa.PEN_TO_SQUARE .. '##smart'..title) then
				imgui.OpenPopup(icon .. ' ' .. u8(title) .. ' ' .. icon .. '##smart'..title)
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			if imgui.BeginPopupModal(icon .. ' ' .. u8(title) .. ' ' .. icon .. '##smart'..title, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
				change_dpi()
				if imgui.BeginChild('##smart'..title..'edit', imgui.ImVec2(589 * settings.general.custom_dpi, 368 * settings.general.custom_dpi), true) then
					for chapter_index, chapter in ipairs(data) do
						if chapter.name ~= '##updated_at' then
							imgui.Columns(2)
							imgui.Text("> " .. u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. title .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name).. '##' .. title .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##' .. title .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index)
							end
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
								change_dpi()
								imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü ðàçäåë?')
								if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##cancel_delete_item_smart' .. chapter_index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü##delete_item_smart' .. chapter_index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
									table.remove(data, chapter_index)
									set_updated_at(data, download_file_name, os.time())
									saveFunction()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(u8(chapter.name).. '##' .. title .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
								change_dpi()
								if imgui.BeginChild('##smart'..title..'edititem', imgui.ImVec2(589 * settings.general.custom_dpi, 368 * settings.general.custom_dpi), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.Text("> " .. u8(item.text))
											imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##' .. title .. index) then
												_G['input_'..title:lower()..'_text'] = imgui.new.char[8192](u8(item.text))
												_G['input_'..title:lower()..'_value'] = imgui.new.char[256](u8(item[title:find('óìíîãî') and 'lvl' or 'amount']))
												_G['input_'..title:lower()..'_reason'] = imgui.new.char[1024](u8(item.reason))
												imgui.OpenPopup(u8("Ðåäàêòèðîâàíèå ïîäïóíêòà##") .. title .. chapter.name .. index .. chapter_index)
											end
											imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
											if imgui.BeginPopupModal(u8("Ðåäàêòèðîâàíèå ïîäïóíêòà##") .. title .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
												change_dpi()
												if imgui.BeginChild('##smart'..title..'edititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then    
													imgui.CenterText(u8'Íàçâàíèå ïîäïóíêòà:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_'..title:lower()..'_text', _G['input_'..title:lower()..'_text'], 8192)
													if title == 'Ñèñòåìà óìíîãî ðîçûñêà' then
														imgui.CenterText(u8'Óðîâåíü ðîçûñêà äëÿ âûäà÷è (îò 1 äî 6):')
													elseif title == 'Ñèñòåìà óìíûõ øòðàôîâ' then
														imgui.CenterText(u8'Ñóììà øòðàôà (öèôðû áåç êàêèõ ëèáî ñèìâîëîâ):')
													elseif title == 'Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà' then
														imgui.CenterText(u8'Óðîâåíü ñðîêà äëÿ âûäà÷è (îò 1 äî 10):')
													end
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_'..title:lower()..'_value', _G['input_'..title:lower()..'_value'], 256)
													imgui.CenterText(u8'Ïðè÷èíà:')
													imgui.PushItemWidth(478 * settings.general.custom_dpi)
													imgui.InputText(u8'##input_'..title:lower()..'_reason', _G['input_'..title:lower()..'_reason'], 1024)
													imgui.EndChild()
												end    
												if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##canceledititem', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##saveedititem', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													local text = u8:decode(ffi.string(_G['input_'..title:lower()..'_text']))
													local value = u8:decode(ffi.string(_G['input_'..title:lower()..'_value']))
													local reason = u8:decode(ffi.string(_G['input_'..title:lower()..'_reason']))
													local isValid = false
													if title == 'Ñèñòåìà óìíîãî ðîçûñêà' then
														isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 6 and text ~= '' and reason ~= ''
													elseif title == 'Ñèñòåìà óìíûõ øòðàôîâ' then
														isValid = value ~= '' and value:find('%d') and not value:find('%D') and text ~= '' and reason ~= ''
													elseif title == 'Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà' then
														isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 10 and text ~= '' and reason ~= ''
													end
													if isValid then
														item.text = text
														item[title:find('óìíîãî') and 'lvl' or 'amount'] = value
														item.reason = reason
														saveFunction()
														set_updated_at(data, download_file_name, os.time())
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage('[Radical Helper] {ffffff}Îøèáêà â óêàçàííûõ äàííûõ, èñïðàâüòå!', message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '##' .. title .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index .. '##' .. index)
											end
											imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ïðåäóïðåæäåíèå ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
												change_dpi()
												imgui.CenterText(u8'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü ïîäïóíêò?')
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##canceldeleteitem', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8' Óäàëèòü##yesdeleteitem', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
													table.remove(chapter.item, index)
													saveFunction()
													set_updated_at(data, download_file_name, os.time())
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü íîâûé ïîäïóíêò##smart_add_subitem' .. chapter_index, imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									_G['input_'..title:lower()..'_text'] = imgui.new.char[8192](u8(''))
									_G['input_'..title:lower()..'_value'] = imgui.new.char[256](u8(''))
									_G['input_'..title:lower()..'_reason'] = imgui.new.char[8192](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' Äîáàâëåíèå íîâîãî ïîäïóíêòà ') .. fa.CIRCLE_PLUS .. '##smart_add_subitem' .. chapter_index)
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' Äîáàâëåíèå íîâîãî ïîäïóíêòà ') .. fa.CIRCLE_PLUS .. '##smart_add_subitem' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
									if imgui.BeginChild('##smart'..title..'edititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then   
										change_dpi() 
										imgui.CenterText(u8'Íàçâàíèå ïîäïóíêòà:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_'..title:lower()..'_text', _G['input_'..title:lower()..'_text'], 8192)
										if title == 'Ñèñòåìà óìíîãî ðîçûñêà' then
											imgui.CenterText(u8'Óðîâåíü ðîçûñêà äëÿ âûäà÷è (îò 1 äî 6):')
										elseif title == 'Ñèñòåìà óìíûõ øòðàôîâ' then
											imgui.CenterText(u8'Ñóììà øòðàôà (öèôðû áåç êàêèõ ëèáî ñèìâîëîâ):')
										elseif title == 'Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà' then
											imgui.CenterText(u8'Óðîâåíü ñðîêà äëÿ âûäà÷è (îò 1 äî 10):')
										end
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_'..title:lower()..'_value', _G['input_'..title:lower()..'_value'], 256)
										imgui.CenterText(u8'Ïðè÷èíà:')
										imgui.PushItemWidth(478 * settings.general.custom_dpi)
										imgui.InputText(u8'##input_'..title:lower()..'_reason', _G['input_'..title:lower()..'_reason'], 8192)
										imgui.EndChild()
									end    
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##' .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü##' .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(_G['input_'..title:lower()..'_text']))
										local value = u8:decode(ffi.string(_G['input_'..title:lower()..'_value']))
										local reason = u8:decode(ffi.string(_G['input_'..title:lower()..'_reason']))
										local isValid = false
										if title == 'Ñèñòåìà óìíîãî ðîçûñêà' then
											isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 6 and text ~= '' and reason ~= ''
										elseif title == 'Ñèñòåìà óìíûõ øòðàôîâ' then
											isValid = value ~= '' and value:find('%d') and not value:find('%D') and text ~= '' and reason ~= ''
										elseif title == 'Ñèñòåìà óìíîãî ïðîäëåíèÿ ñðîêà' then
											isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 10 and text ~= '' and reason ~= ''
										end
										if isValid then
											table.insert(chapter.item, {text = text, [title:find('óìíîãî') and 'lvl' or 'amount'] = value, reason = reason})
											saveFunction()
											set_updated_at(data, download_file_name, os.time())
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage('[Radical Helper] {ffffff}Îøèáêà â óêàçàííûõ äàííûõ, èñïðàâüòå!', message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##close' .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
					end
					imgui.EndChild()	
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü ðàçäåë##smart_add' .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						_G['input_'..title:lower()..'_name'] = imgui.new.char[512](u8(''))
						imgui.OpenPopup(u8'Äîáàâëåíèå íîâîãî ðàçäåëà')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(u8'Äîáàâëåíèå íîâîãî ðàçäåëà', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_'..title:lower()..'_name', u8("Ââåäèòå íàçâàíèå íîâîãî ðàçäåëà..."), _G['input_'..title:lower()..'_name'], 512)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##smart_add' .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_PLUS .. u8' Äîáàâèòü##smart_add' .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							local temp = u8:decode(ffi.string(_G['input_'..title:lower()..'_name']))
							table.insert(data, {name = temp, item = {}})
							saveFunction()
							set_updated_at(data, download_file_name, os.time())
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü##smart_close' .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
			end
			imgui.CenterText(u8'Åñëè äàííûå äëÿ âàøåãî ñåðâåðà îòñóòñòâóþò')
			imgui.CenterText(u8'Äëÿ ïðîäâèíóòûõ ïîëüçîâàòåëåé')
			imgui.EndChild()
		end
	end
end
if isMode('prison') then
	imgui.OnFrame(
		function() return MODULE.PumMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Óìíàÿ âûäà÷à ïîâûøåííîãî ñðîêà " .. fa.STAR .. "##pum_menu", MODULE.PumMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_rptp.data ~= nil and isParamSampID(MODULE.PumMenu.player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_sum', u8('Ïîèñê ñòàòåé (ïîäïóíêòîâ) â ãëàâàõ (ïóíêòàõ)'), MODULE.PumMenu.input, 128) 
				imgui.Separator()
				local input_sum_decoded = u8:decode(ffi.string(MODULE.PumMenu.input))
				for _, chapter in ipairs(modules.smart_rptp.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_sum_decoded:rupper(), 1, true) or input_sum_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for index, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_sum_decoded:rupper(), 1, true) or input_sum_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Ïåðåïðîâåðüòå äàííûå ïåðåä ïîâûøåíèåì ñðîêà ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. chapter.name .. '_' .. index
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button(u8(split_text_into_lines(item.text, 85))..'##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										imgui.Text(fa.USER .. u8' Èãðîê: ' .. u8(sampGetPlayerNickname(MODULE.PumMenu.player_id)) .. '[' .. MODULE.PumMenu.player_id .. ']')
										imgui.Text(fa.STAR .. u8' Óðîâåíü ñðîêà: ' .. item.lvl)
										imgui.Text(fa.COMMENT .. u8' Ïðè÷èíà ïîâûøåíèÿ ñðîêà: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##pum', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.STAR .. u8' Ïîâûñèòü ñðîê##pum', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.PumMenu.Window[0] = false
											find_and_use_command('/punish {id} {number} 2 {arg}', MODULE.PumMenu.player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ïðîèçîøëà îøèáêà óìíîãî ñðîêà (íåòó äàííûõ ëèáî èãðîê îôíóëñÿ)!', message_color)
				MODULE.SumMenu.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('police') or isMode('fbi') then
	imgui.OnFrame(
		function() return MODULE.Patrool.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. u8" Radical Helper " .. getHelperIcon() .. '##patrool_info_menu', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			safery_disable_cursor(player)
			if MODULE.Patrool.active then
				imgui.Text(fa.CLOCK .. u8(' Âðåìÿ ïàòðóëèðîâàíèÿ: ') .. u8(MODULE.Binder.tag.get_patrool_time()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Âàøà ìàðêèðîâêà: ') .. u8(MODULE.Binder.tag.get_patrool_mark()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Âàøå ñîñòîÿíèå: ') .. u8(MODULE.Binder.tag.get_patrool_code()))
				imgui.SameLine()
				if imgui.SmallButton(fa.GEAR) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Radical Helper##patrool_select_code'))
				end
				imgui.Separator()
				if imgui.Button(fa.WALKIE_TALKIE .. u8(' Äîêëàä'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if (not MODULE.Patrool.process_doklad) then
						MODULE.Patrool.process_doklad = true
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							sampSendChat('/r ' .. MODULE.Binder.tag.my_doklad_nick() .. ' íà CONTROL.')
							wait(1500)
							sampSendChat('/r Ïðîäîëæàþ ïàòðóëü, íàõîæóñü â ðàéîíå ' .. MODULE.Binder.tag.get_area() .. " (" .. MODULE.Binder.tag.get_square() .. ').')
							wait(1500)
							if MODULE.Binder.tag.get_car_units() ~= 'Íåòó' then
								sampSendChat('/r Ïàòðóëèðóþ óæå ' .. MODULE.Binder.tag.get_patrool_format_time() .. ' â ñîñòàâå þíèòà ' .. MODULE.Binder.tag.get_car_units() .. ', ñîñòîÿíèå ' .. u8(MODULE.Binder.tag.get_patrool_code()) .. '.')
							else
								sampSendChat('/r Ïàòðóëèðóþ óæå ' .. MODULE.Binder.tag.get_patrool_format_time() .. ', ñîñòîÿíèå ' .. u8(MODULE.Binder.tag.get_patrool_code()) .. '.')
							end
							MODULE.Binder.state.isActive = false
							MODULE.Patrool.process_doklad = false
						end)
					end
				end
				imgui.SameLine()
				if imgui.Button(fa.CIRCLE_STOP .. u8(' Çàâåðøèòü'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						MODULE.Patrool.Window[0] = false
						MODULE.Patrool.active = false
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tag.my_doklad_nick() .. ' íà CONTROL.')
						wait(1500)
						sampSendChat('/r Çàâåðøàþ ïàòðóëü, îñâîáîæäàþ ìàðêèðîâêó ' .. MODULE.Binder.tag.get_patrool_mark() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_patrool_code())
						wait(1500)
						sampSendChat('/r Ïàòðóëèðîâàë' .. MODULE.Binder.tag.sex() .. ' ' .. MODULE.Binder.tag.get_patrool_format_time())
						MODULE.Patrool.time = 0
						MODULE.Patrool.start_time = 0
						MODULE.Patrool.current_time = 0
						MODULE.Patrool.code = 'CODE4'
						MODULE.Patrool.ComboCode[0] = 5
						wait(1500)
						sampSendChat('/delvdesc')
						MODULE.Binder.state.isActive = false
					end)
				end
			else
				player.HideCursor = false	
				imgui.CenterText(u8('Íàñòðîéêà äàííûõ ïåðåä íà÷àëîì ïàòðóëÿ:'))
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Âàøà ìàðêèðîâêà: '))
				imgui.SameLine()
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_mark', MODULE.Patrool.ComboMark, MODULE.Patrool.ImItemsMark, #MODULE.Patrool.marks) then
					MODULE.Patrool.mark = MODULE.Patrool.marks[MODULE.Patrool.ComboMark[0] + 1] 
				end
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Âàøå ñîñòîÿíèå: '))
				imgui.SameLine()
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_code', MODULE.Patrool.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Patrool.codes) then
					MODULE.Patrool.code = MODULE.Patrool.codes[MODULE.Patrool.ComboCode[0] + 1]
				end
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Íàïàðíèêè: ') .. u8(MODULE.Binder.tag.get_car_units()))
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà ', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Patrool.Window[0] = false
				end
				imgui.SameLine()
				if imgui.Button(fa.WALKIE_TALKIE .. u8' Íà÷àòü ïàòðóëü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Patrool.time = 0
					MODULE.Patrool.start_time = os.time()
					MODULE.Patrool.active = true
					lua_thread.create(function()
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tag.my_doklad_nick() .. ' íà CONTROL.')
						wait(1500)
						sampSendChat('/r Íà÷èíàþ ïàòðóëü, íàõîæóñü â ðàéîíå ' .. MODULE.Binder.tag.get_area() .. " (" .. MODULE.Binder.tag.get_square() .. ').')
						wait(1500)
						if MODULE.Binder.tag.get_car_units() ~= 'Íåòó' then
							sampSendChat('/r Çàíèìàþ ìàðêèðîâêó ' .. MODULE.Binder.tag.get_patrool_mark() .. ', íàõîæóñü â ñîñòàâå þíèòà ' .. MODULE.Binder.tag.get_car_units() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_patrool_code() .. '.')
						else
							sampSendChat('/r Çàíèìàþ ìàðêèðîâêó ' .. MODULE.Binder.tag.get_patrool_mark() .. ', ñîñòîÿíèå ' .. MODULE.Binder.tag.get_patrool_code() .. '.')
						end
						wait(1500)
						sampSendChat('/vdesc ' .. MODULE.Binder.tag.get_patrool_mark())
						MODULE.Binder.state.isActive = false
					end)
					imgui.CloseCurrentPopup()
				end
			end
			if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Radical Helper##patrool_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
				change_dpi()
				player.HideCursor = false 
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_code', MODULE.Patrool.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Patrool.codes) then
					MODULE.Patrool.code = MODULE.Patrool.codes[MODULE.Patrool.ComboCode[0] + 1]
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.patrool_menu.x or posY ~= settings.windows_pos.patrool_menu.y then
				settings.windows_pos.patrool_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Wanted.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.wanteds_menu.x, settings.windows_pos.wanteds_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Ñïèñîê ïðåñòóïíèêîâ (âñåãî " .. #MODULE.Wanted.all .. u8') ' .. fa.STAR, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
			change_dpi()
			
			if tonumber(#MODULE.Wanted.all) == 0 then 
				sampAddChatMessage('[Radical Helper] {ffffff}Ñåé÷àñ íà ñåðâåðå íåòó èãðîêîâ ñ ðîçûñêîì!', message_color)
				MODULE.Wanted.Window[0] = false
			end

			safery_disable_cursor(player)
			if settings.mj.auto_update_wanteds then
				local text_time_wait = tostring(15 - tonumber(MODULE.Wanted.updwanteds.time))
				if tonumber(text_time_wait) < 10 then
					text_time_wait = '0' .. text_time_wait
				end
				imgui.Text(u8('Îáíîâëåíèå ñïèñêà ïðåñòóïíèêîâ áóäåò ÷åðåç ') .. tostring(text_time_wait) .. u8(' ñåêóíä'))
				imgui.Separator()
			else
				if imgui.Button(u8'Îáíîâèòü ñïèñîê ïðåñòóïíèêîâ', imgui.ImVec2(340 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					MODULE.Wanted.Window[0] = false
					sampAddChatMessage('[Radical Helper] {ffffff}Âû ìîæåòå âêëþ÷èòü àâòî-îáíîâëåíèå ñïèñêà /wanteds â /helper - Ôóíêöèè ' .. modules.player.data.fraction_tag .. '!', message_color)
					sampProcessChatInput('/wanteds')
				end
				imgui.Separator()
			end	
			imgui.Columns(3)
			imgui.CenterColumnText(u8("Íèêíåéì"))
			imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Ðîçûñê"))
			imgui.SetColumnWidth(-1, 65 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Ðàññòîÿíèå"))
			imgui.SetColumnWidth(-1, 80 * settings.general.custom_dpi)
			imgui.Columns(1)
			for i, v in ipairs(MODULE.Wanted.all) do
				imgui.Separator()
				imgui.Columns(3)
				if sampGetPlayerColor(v.id) == 368966908 then
					imgui_RGBA = (settings.general.helper_theme ~= 2) and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0, 0, 0, 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				else
					local rgbNormalized = argbToRgbNormalized(sampGetPlayerColor(v.id))
					local imgui_RGBA = imgui.ImVec4(rgbNormalized[1], rgbNormalized[2], rgbNormalized[3], 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				end
				if imgui.IsItemClicked() and not v.dist:find('Â èíòåðüåðå') then
					sampSendChat('/pursuit ' .. v.id)
				end
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.lvl) .. ' ' .. fa.STAR)
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.dist))
				imgui.NextColumn()
				imgui.Columns(1)
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.wanteds_menu.x or posY ~= settings.windows_pos.wanteds_menu.y then
				settings.windows_pos.wanteds_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.SumMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Óìíàÿ âûäà÷à ðîçûñêà " .. fa.STAR .. "##sum_menu", MODULE.SumMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_uk.data ~= nil and isParamSampID(MODULE.SumMenu.player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_sum', u8('Ïîèñê ñòàòåé (ïîäïóíêòîâ) â ãëàâàõ (ïóíêòàõ)'), MODULE.SumMenu.input, 128) 
				imgui.Separator()
				local input_sum_decoded = u8:decode(ffi.string(MODULE.SumMenu.input))
				for _, chapter in ipairs(modules.smart_uk.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_sum_decoded:rupper(), 1, true) or input_sum_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for index, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_sum_decoded:rupper(), 1, true) or input_sum_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Ïåðåïðîâåðüòå äàííûå ïåðåä âûäà÷åé ðîçûñêà ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. chapter.name .. '_' .. index
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button("> " .. u8(split_text_into_lines(item.text, 85))..'##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										imgui.Text(fa.USER .. u8' Èãðîê: ' .. u8(sampGetPlayerNickname(MODULE.SumMenu.player_id)) .. '[' .. MODULE.SumMenu.player_id .. ']')
										imgui.Text(fa.STAR .. u8' Óðîâåíü ðîçûñêà: ' .. item.lvl)
										imgui.Text(fa.COMMENT .. u8' Ïðè÷èíà âûäà÷è ðîçûñêà: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##sum', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.WALKIE_TALKIE .. u8' Çàïðîñèòü ðîçûñê##sum', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.SumMenu.Window[0] = false
											find_and_use_command('Ïðîøó îáüÿâèòü â ðîçûñê %{number%} ñòåïåíè äåëî N%{id%}%. Ïðè÷èíà%: %{arg%}', MODULE.SumMenu.player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										local text_rank = ((modules.player.data.fraction == 'FBI' or modules.player.data.fraction == 'ÔCÁ') and '[4+]' or '[5+]')
										if imgui.Button(fa.STAR .. u8' Âûäàòü ðîçûñê ' .. text_rank, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.SumMenu.Window[0] = false
											find_and_use_command('/su {id} {number} {arg}', MODULE.SumMenu.player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ïðîèçîøëà îøèáêà óìíîãî ðîçûñêà (íåòó äàííûõ ëèáî èãðîê îôíóëñÿ)!', message_color)
				MODULE.SumMenu.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.TsmMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.TICKET .. u8" Óìíàÿ âûäà÷à øòðàôîâ " .. fa.TICKET .. "##tsm_menu", MODULE.TsmMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_pdd.data ~= nil and isParamSampID(MODULE.TsmMenu.player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_tsm', u8('Ïîèñê ñòàòåé (ïîäïóíêòîâ) â ãëàâàõ (ïóíêòàõ)'), MODULE.TsmMenu.input, 128) 
				imgui.Separator()
				local input_tsm_decoded = u8:decode(ffi.string(MODULE.TsmMenu.input))
				for _, chapter in ipairs(modules.smart_pdd.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_tsm_decoded:rupper(), 1, true) or input_tsm_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for index, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_tsm_decoded:rupper(), 1, true) or input_tsm_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Ïåðåïðîâåðüòå äàííûå ïåðåä âûäà÷åé øòðàôà ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. chapter.name .. '_' .. index
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button(u8(split_text_into_lines(item.text,85))..'##' .. index, imgui.ImVec2( imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end 
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
										imgui.Text(fa.USER .. u8' Èãðîê: ' .. u8(sampGetPlayerNickname(MODULE.TsmMenu.player_id)) .. '[' .. MODULE.TsmMenu.player_id .. ']')
										imgui.Text(fa.MONEY_CHECK_DOLLAR .. u8' Ñóììà øòðàôà: $' .. item.amount)
										imgui.Text(fa.COMMENT .. u8' Ïðè÷èíà âûäà÷è øòðàôà: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà##tsm', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TICKET .. u8' Âûïèñàòü øòðàô##tsm', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.TsmMenu.Window[0] = false
											find_and_use_command('ticket {id}', MODULE.TsmMenu.player_id .. ' ' .. item.amount .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Radical Helper] {ffffff}Ïðîèçîøëà îøèáêà óìíûõ øòðàôîâ (íåòó äàííûõ ëèáî èãðîê îôíóëñÿ)!', message_color)
				MODULE.TsmMenu.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('hospital') then
	imgui.OnFrame(
		function() return MODULE.MedCard.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Radical Helper " .. fa.HOSPITAL .. "##medcard", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Ñðîê äåéñòâèÿ ìåä.êàðòû:')
			if imgui.RadioButtonIntPtr(u8" 7 äíåé ##0",MODULE.MedCard.days,0) then
				MODULE.MedCard.days[0] = 0
			end
			if imgui.RadioButtonIntPtr(u8" 14 äíåé ##1",MODULE.MedCard.days,1) then
				MODULE.MedCard.days[0] = 1
			end
			if imgui.RadioButtonIntPtr(u8" 30 äíåé ##2",MODULE.MedCard.days,2) then
				MODULE.MedCard.days[0] = 2
			end
			if imgui.RadioButtonIntPtr(u8" 60 äíåé ##3",MODULE.MedCard.days,3) then
				MODULE.MedCard.days[0] = 3
			end
			imgui.Separator()
			imgui.CenterText(u8'Còàòóñ çäîðîâüÿ ïàöèåíòà:')
			if imgui.RadioButtonIntPtr(u8" Íå îïðåäåëåí ##0", MODULE.MedCard.status,0) then
				MODULE.MedCard.status[0] = 0
			end
			if imgui.RadioButtonIntPtr(u8" Ïñèõè÷åñêè íå çäîðîâ ##1", MODULE.MedCard.status,1) then
				MODULE.MedCard.status[0] = 1
			end
			if imgui.RadioButtonIntPtr(u8" Íàáëþäàþòñÿ îòêëîíåíèÿ ##2", MODULE.MedCard.status,2) then
				MODULE.MedCard.status[0] = 2
			end
			if imgui.RadioButtonIntPtr(u8" Ïîëíîñòüþ çäîðîâ ##3", MODULE.MedCard.status,3) then
				MODULE.MedCard.status[0] = 3
			end
			imgui.Separator()
			local label = ' Âûäàòü ' .. ((hotkey_no_errors and settings.general.bind_action) and ('[' .. getNameKeysFrom(settings.general.bind_action) .. ']') or 'ìåä.êàðòó')
			if imgui.Button(fa.ID_CARD_CLIP .. u8(label), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				MODULE.MedCard.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Recept.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Radical Helper " .. fa.HOSPITAL .. "##recept", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Êîëè÷åñòâî ðåöåïòîâ äëÿ âûäà÷è:')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.Recept.recepts, 1, 5)
			imgui.Separator()
			local label = ' Âûäàòü ' .. ((hotkey_no_errors and settings.general.bind_action) and ('[' .. getNameKeysFrom(settings.general.bind_action) .. ']') or 'ðåöåïòû')
			if imgui.Button(fa.CAPSULES .. u8(label), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				MODULE.Recept.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Antibiotik.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Radical Helper " .. fa.HOSPITAL .. "##ant", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Êîëè÷åñòâî àíòèáèîòèêîâ äëÿ âûäà÷è:')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.Antibiotik.ants, 1, 20)
			imgui.Separator()
			local label = ' Âûäàòü ' .. ((hotkey_no_errors and settings.general.bind_action) and ('[' .. getNameKeysFrom(settings.general.bind_action) .. ']') or 'àíòèáèîòèêè')
			if imgui.Button(fa.CAPSULES .. u8(label), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				MODULE.Antibiotik.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.HealChat.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 1.9), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Radical Helper " .. fa.HOSPITAL .. "##fast_heal", MODULE.HealChat.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar +  imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			if imgui.Button(fa.KIT_MEDICAL..u8' Âûëå÷èòü '.. u8(sampGetPlayerNickname(MODULE.HealChat.player_id))) then
				find_and_use_command("/heal {id}", MODULE.HealChat.player_id)
				MODULE.HealChat.bool = false
				MODULE.HealChat.player_id = nil
				MODULE.HealChat.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('smi') then
	imgui.OnFrame(
		function() return MODULE.SmiEdit.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			local size_window_y = settings.smi.ads_buttons and 301.5 or 137
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, size_window_y * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. u8" Radical Helper " .. getHelperIcon() .. '##MODULE.SmiEdit.Window', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar )
			change_dpi()
			imgui.Text(fa.CIRCLE_INFO .. u8" Îáúÿâëåíèå ïîäàë èãðîê: " .. u8(MODULE.SmiEdit.ad_from) .. '[' .. sampGetPlayerIdByNickname(MODULE.SmiEdit.ad_from) .. ']')
			imgui.Text(fa.CIRCLE_INFO .. u8" Òåêñò: " .. (u8(MODULE.SmiEdit.ad_message)))
			imgui.SameLine()
			if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT) then
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(MODULE.SmiEdit.ad_message))
			end
			if imgui.IsItemHovered() then
				imgui.SetTooltip(u8'Ïåðåíåñòè òåêñò â ïîëå äëÿ ðåäàêòà')
			end
			imgui.Separator()
			local window_size = imgui.GetWindowSize()
			local size_item_width = (settings.smi.ads_history and 105 or 75)
			imgui.PushItemWidth(window_size.x - size_item_width * settings.general.custom_dpi)
			imgui.InputTextWithHint(
				"##smi_edit_ad",
				u8"Îòðåäàêòèðóéòå îáúÿâëåíèå ëèáî ââåäèòå ïðè÷èíó äëÿ îòêëîíåíèÿ",
				MODULE.SmiEdit.input_edit_text,
				256,
				imgui.InputTextFlags.CallbackAlways + imgui.InputTextFlags.CallbackCompletion, 
				TextEditCallback
			)
			imgui.SameLine()
			if imgui.Button(fa.DELETE_LEFT, imgui.ImVec2(27 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				if #text > 0 then imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text:sub(1, -2))) end
			end
			imgui.SameLine()
			if imgui.Button(fa.TRASH_CAN, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
			end
			if settings.smi.ads_history then
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.CLOCK_ROTATE_LEFT .. u8' Èñòîðèÿ îáüÿâëåíèé')	
				end
				if imgui.IsItemHovered() then
					imgui.SetTooltip(u8'Èñòîðèÿ îáüÿâëåíèé')
				end
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.CLOCK_ROTATE_LEFT .. u8' Èñòîðèÿ îáüÿâëåíèé', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
					imgui.SetWindowSizeVec2(imgui.ImVec2(610 * settings.general.custom_dpi, 350 * settings.general.custom_dpi))
					if imgui.BeginChild('##99999999', imgui.ImVec2(600 * settings.general.custom_dpi, 285 * settings.general.custom_dpi), true) then	
						change_dpi()
						if modules.ads_history.data then 
							if #modules.ads_history.data == 0 then
								imgui.CenterText(u8('Èñòîðèÿ îáüÿâëåíèé ïóñòà'))
								imgui.CenterText(u8('Îòðåäàêòèðîâàííûå îáüÿâëåíèÿ áóäóò îòîáðàæàòüñÿ çäåñü'))
							else
								imgui.PushItemWidth(579 * settings.general.custom_dpi)
								imgui.InputTextWithHint(u8'##input_ads_search', u8'Ïîèñê îáüÿâëåíèé ïî íóæíîé ôðàçå, íà÷èíàéòå ââîäèòü å¸ ñþäà...', MODULE.SmiEdit.input_search, 128)
								imgui.Separator()
								local input_ads_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_search))
								local shown = {}
								for id, ad in ipairs(modules.ads_history.data) do
									if ad and ad.text and ad.my_text then
										local text = ad.my_text
										if not shown[text] then
											if input_ads_decoded == '' or (text:rupper():find(input_ads_decoded:rupper(), 1, true)) then
												if imgui.Button(u8(text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
													imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
													imgui.CloseCurrentPopup()
												end
												shown[text] = true
											end
										end
									end
								end
							end
						else
							imgui.CenterText(u8('Îøèáêà çàãðóçêè èñòîðèè îáüÿâëåíèé, ÷òî-òî ñëîìàëîñü'))
							imgui.Separator()
							imgui.CenterText(u8('×òîáû ïîôèêñèòü, óäàëèòå ôàéëèê Ads.json, êîòîðûé íàõîäèòñÿ ïî ïóòè:'))
							imgui.TextWrapped(u8(modules.ads_history.path))
							imgui.Separator()
							imgui.CenterText(u8('Ëèáî åñëè âû îïûòíûé þçåð, âðó÷íóþ îòêðîéòå ôàéë â CP1251 è èñïðàâüòå îøèáêó'))
						end
						imgui.EndChild()
					end		
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
			end
			imgui.Separator()
			if settings.smi.ads_buttons then
				local smi_groups = {
					{
						id = "##1",
						width = 105,
						per_row = 1,
						items = {
							"Êóïëþ",
							"Ïðîäàì",
							"Îáìåíÿþ",
							"Ñäàì â àðåíäó",
							"Àðåíäóþ",
						}
					},
					{
						id = "##2",
						width = 150,
						per_row = 4,
						items = {
							-- Àêñåññóàðû, ñêèíû
							"à/ñ", "î/ï", "è/ò", "ð/ñ", 
							-- Òðàíñïîðò
							"à/ì", "ì/ö", "ã/ô", "â/ò",
							"ñ/ì", "â/ñ", "ë/ä", "í/ç",
							-- Ïðî÷åå
							"á/ç", "ï/ì", "ë/î", "ä/ò", 
							"ï/ò", "ì/ô", "÷/ä", "â/î", 
						}
					},
					{
						id = "##3",
						width = 70,
						per_row = 1,
						items = {
							"Æèëü¸",
							"Ëîêàöèè",
							"Ìàðêè",
							"Áèçíåñû",
							"Íàáîðû",
						}
					},
					{
						id = "##4",
						width = 90,
						per_row = 1,
						items = {
							"Öåíà:",
							"Öåíà çà øò:",
							"Äîãîâîðíàÿ",
							"Áþäæåò:",
							"Ñâîáîäíûé",
						}
					},
					{
						id = "##5",
						width = 100,
						per_row = 3,
						items = {
							"1","2","3",
							"4","5","6",
							"7","8","9",
							".","0", ',',
							"ñ ãðàâèðîâêîé +"
						}
					},
					{
						id = "##6",
						width = 50,
						per_row = 1,
						items = {"$", '"', "òûñ.", "ìëí", "ìëðä"}
					}
				}
				for gi, group in ipairs(smi_groups) do
					if imgui.BeginChild(group.id, imgui.ImVec2(group.width * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.CAR .. u8" Ìàðêè òðàíñïîðòà " .. fa.CAR, nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove) then
							imgui.PushItemWidth(200 * settings.general.custom_dpi)
							imgui.InputTextWithHint(u8(''), u8('Èùèòå íóæíóþ âàì ìîäåëü...'), MODULE.SmiEdit.input_search, 64)
							imgui.Separator()
							local input_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_search)):rlower()
							if imgui.BeginChild("veh_list", imgui.ImVec2(200 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
								for id, name in pairs(modules.arz_veh.byId or {}) do
									if input_decoded == "" or name:rlower():find(input_decoded) then
										if imgui.Selectable(u8(name)) then
											insert_to_cursor('"' .. u8(name) .. '" ', MODULE.SmiEdit.input_edit_text)
											imgui.CloseCurrentPopup()
										end
									end
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_XMARK .. u8(" Çàêðûòü"), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.BUILDING .. u8" Íàáîðû â îðãàíèçàöèè/ñåìüè " .. fa.BUILDING, nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove) then
							local orgs = {
								'Ïðîõîäèò ñîáåñåäîâàíèå â îðãàíèçàöèþ "". Æä¸ì â õîëëå',
								'Èä¸ò íàáîð â ôóòáîëüíûé êëóá "". Æä¸ì íà òåððèòîðèè êëóáà',
								'Ïðîõîäèò ñîáåñåäîâàíèå â êîðïîðàöèþ "". Ïðîñüáà ñâÿçàòüñÿ',
								'Èùó ñâîèõ äàëüíèõ ðîäñòâåííèêîâ. Ïðîñüáà ñâÿçàòüñÿ',
								'Ðàçâèòàÿ ñåìüÿ "" èùåò äàëüíèõ ðîäñòâåííèêîâ. Ïðîñüáà ñâÿçàòüñÿ',
								'Ñåìüÿ "" èùåò äàëüíèõ ðîäñòâåííèêîâ. Ïðîñüáà ñâÿçàòüñÿ',
							}
							for id, text in pairs(orgs) do
								if imgui.Selectable(u8(text)) then
									imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
									imgui.CloseCurrentPopup()
								end
							end
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8(" Çàêðûòü"), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.HOUSE .. u8" Æèëü¸ " .. fa.HOUSE, nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove) then
							local houses = {
								'äîì â',
								'äîì ñ ïîäâàëîì â',
								'äîì ñ ãàðàæîì â',
								'äîì ñ ãàðàæîì è ïîäâàëîì â',
								'äîì íà êîë¸ñàõ',
								'êâàðòèðó â'
							}
							for id, text in pairs(houses) do
								if imgui.Selectable(u8(text)) then
									insert_to_cursor(u8(text) .. ' ', MODULE.SmiEdit.input_edit_text)
									imgui.CloseCurrentPopup()
								end
							end
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8(" Çàêðûòü"), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.SHOP .. u8" Áèçíåñû " .. fa.SHOP, nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove) then
							local business = {
								'ÀÇÑ', 'Âîäíàÿ ÀÇÑ', 'Áàð', 'Îòåëü', 'Çàêóñî÷íàÿ', 'Ëàðåê ñ óëè÷íîé åäîé', 'Ìàãàçèí 24 íà 7', 'Àìóíèöèÿ', 'Àâòîìàñòåðñêàÿ', 'ÑÒÎ', 
								'Ìàãàçèí òþíèíãà', 'Àðåíäà òðàíñïîðòà', 'Ìàãàçèí àêñåññóàðîâ', 'Ìàãàçèí îäåæäû', 'Ôåðìà', 'Àâòîðûíîê', 'Àâòîìîéêà', 'Ñàëîí òðåéëåðîâ',
								'Òåëåôîííàÿ êîìïàíèÿ', 'Ðåêëàìíûå áàííåðû', 'Òåëåôîííûå áóäêè', 'Øêîëà òàíöåâ', 'Ñïîðòçàë', 'Ìàãàçèí ðûáàëêè', 'Ëîìáàðä', 'Øàõòà', 
								'Íàçåìíàÿ íåôòåâûøêà', 'Âîäíàÿ íåôòåâûøêà', 'Ýëåêñèð Ìàñòåð', 'Ñåêîíä Õåíä', 'Ìàñòåðñêàÿ îäåæäû', 'Ìàãàçèí âèäåîêàðò'
							}
							imgui.PushItemWidth(200 * settings.general.custom_dpi)
							imgui.InputTextWithHint(u8(''), u8('Èùèòå íóæíûé âàì áèçíåñ...'), MODULE.SmiEdit.input_search, 64)
							imgui.Separator()
							local input_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_search)):rlower()
							if imgui.BeginChild("bizlist", imgui.ImVec2(200 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
								for id, name in pairs(business) do
									if input_decoded == "" or name:rlower():find(input_decoded) then
										if imgui.Selectable(u8(name)) then
											insert_to_cursor('"' .. u8(name) .. '" ', MODULE.SmiEdit.input_edit_text)
											imgui.CloseCurrentPopup()
										end
									end
								end
								imgui.EndChild()
							end
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8(" Çàêðûòü"), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.MAP_LOCATION_DOT .. u8" Ëîêàöèè " .. fa.MAP_LOCATION_DOT, nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove) then
							local locations = {
								'ã. Ëîñ-Ñàíòîñ.', 'ã. Ñàí-Ôèåððî.', 'ã. Ëàñ-Âåíòóðàñ.', 'ã. Àðçàìàñ.', 'ã. Ýäîâî.', 
								'ëþáîé òî÷êå øòàòà.', 'ëþáîé òî÷êå îêðóãà.', 'îïàñíîì ðàéîíå.',
								'ä. Ïàëîìèíî Êðèê.', 'ä. Ðåä Êàóíòðè.', 'ä. Ìîíòãîìåðè.', 'ä. Ëàñ Áàðàíêàñ.', 'ä. Àíãåë Ïåéí.', 
								'ä. Ýëü Êåáðàäîñ.', 'ä. Ëàñ Ïàéñàäàñ.', 'ä. Òüåððà Ðîáàäà.', 'ä. ÁëóÁåððè.', 'ï. Áàòûðåâî.',
								'Ïîëèöèÿ ËÑ', 'Ïîëèöèÿ ËÂ', 'Ïîëèöèÿ ÑÔ', 'Ïîëèöèÿ ÂÑ', 'Îáëàñòíàÿ ïîëèöèÿ', 'Ïîëèöèÿ îêðóãà', 'Ãîðîäñêàÿ ïîëèöèÿ',
								'ÔÁÐ', 'ÔÑÁ', "ÊÒÖ", 'Àðìèÿ ËÑ', 'Àðìèÿ ÑÔ', 'Àðìèÿ', 'Òþðüìà ñòðîãîãî ðåæèìà',
								'TV ñòóäèÿ', 'TV ñòóäèÿ ËÑ', 'TV ñòóäèÿ ËÂ', 'TV ñòóäèÿ ÑÔ', 'TV ñòóäèÿ ÂÑ', 'Íîâîñòíîå àãåíòñòâî',
								'Áîëüíèöà ËÑ', 'Áîëüíèöà ËÂ', 'Áîëüíèöà ÑÔ', 'Áîëüíèöà ÂÑ', 'Áîëüíèöà Äæåôôåðñîí', 'Áîëüíèöà îêðóãà', 'Ãîðîäñêàÿ áîëüíèöà',
								'Ïðàâèòåëüñòâî', 'Ñóä', 'Öåíòð ëèöåíçèðîâàíèÿ', 'Ïîæàðíûé äåïàðòàìåíò', 'Ñòðàõîâàÿ êîìïàíèÿ',
								'Ðóññêàÿ ìàôèÿ', 'Yakuza', 'La Cosa Nostra', 'Warlock MC', 'Tierra Robada Bikers', 'Óêðàèíñêàÿ ìàôèÿ', 'Êàâêàçñêàÿ ìàôèÿ',
								'Grove Street', 'Los Santos Vagos', 'East Side Ballas', 'Varrios Los Aztecas', 'The Rifa', 'Night Wolves'
							}
							imgui.PushItemWidth(200 * settings.general.custom_dpi)
							imgui.InputTextWithHint(u8(''), u8('Èùèòå íóæíóþ âàì ëîêàöèþ...'), MODULE.SmiEdit.input_search, 64)
							imgui.Separator()
							local input_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_search)):rlower()
							if imgui.BeginChild("locateslist", imgui.ImVec2(200 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
								for id, name in pairs(locations) do
									if input_decoded == "" or name:rlower():find(input_decoded) then
										if imgui.Selectable(u8(name)) then
											insert_to_cursor(u8(name) .. ' ', MODULE.SmiEdit.input_edit_text)
											imgui.CloseCurrentPopup()
										end
									end
								end
								imgui.EndChild()
							end
							imgui.Separator()
							if imgui.Button(fa.CIRCLE_XMARK .. u8(" Çàêðûòü"), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						for i, label in ipairs(group.items) do
							local btns = (label == 'ñ ãðàâèðîâêîé +') and 1 or group.per_row
							if imgui.Button(u8(label), imgui.ImVec2(imgui.GetMiddleButtonX(btns), 25 * settings.general.custom_dpi)) then
								if label == "Æèëü¸" then
									imgui.OpenPopup(fa.HOUSE .. u8" Æèëü¸ " .. fa.HOUSE)
								elseif label == "Ìàðêè" then
									imgui.OpenPopup(fa.CAR .. u8" Ìàðêè òðàíñïîðòà " .. fa.CAR)
								elseif label == "Ëîêàöèè" then
									imgui.OpenPopup(fa.MAP_LOCATION_DOT .. u8" Ëîêàöèè " .. fa.MAP_LOCATION_DOT)
								elseif label == "Áèçíåñû" then
									imgui.OpenPopup(fa.SHOP .. u8" Áèçíåñû " .. fa.SHOP)
								elseif label == "Íàáîðû" then
									imgui.OpenPopup(fa.BUILDING .. u8" Íàáîðû â îðãàíèçàöèè/ñåìüè " .. fa.BUILDING)
								else
									local text_to_insert = ''
									if group.id:find('1') or group.id:find('2') or (group.id:find('4') and label ~= 'Äîãîâîðíàÿ' and label ~= 'Ñâîáîäíûé') then
										text_to_insert = label .. ' '
									else
										text_to_insert = label
									end
									insert_to_cursor(u8(text_to_insert), MODULE.SmiEdit.input_edit_text)
								end
							end
							if group.per_row > 1 and (i % group.per_row ~= 0) then imgui.SameLine() end
						end
						imgui.EndChild()
					end
					if gi < #smi_groups then imgui.SameLine() end
				end
				imgui.Separator()
			end
			local send_ad_label = IS_MOBILE and " Îïóáëèêîâàòü" or " Îïóáëèêîâàòü [Enter]"
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8(send_ad_label), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				local ad_text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				if ad_text == '' then return end
				if modules.ads_history.data then
					if settings.smi.ads_history then
						local exists = false
						for _, ad in ipairs(modules.ads_history.data) do
							if ad and ad.text and ad.text == MODULE.SmiEdit.ad_message then
								exists = true
								break
							end
						end
						if not exists then
							table.insert(modules.ads_history.data, 1, {text = MODULE.SmiEdit.ad_message, my_text = ad_text})
							save_module('ads_history')
						end
					end
				else	
					sampAddChatMessage('[Radical Helper] {ffffff}Ñëîìàëñÿ ôàéë ' .. modules.ads_history.path, message_color)
					sampAddChatMessage('[Radical Helper] {ffffff}Óäàëèòå åãî, ëèáî åñëè øàðèòå, òî íàéäèòå îøèáêó è èñïðàâüòå (ôàéë â êîäèðîâêå 1251)', message_color)
					play_sound()
				end
				if MODULE.SmiEdit.vip_pause then
					lua_thread.create(function()
						sampAddChatMessage('[Radical Helper | Àññèñòåíò] {ffffff}Ñåðâåðíîå ÊÄ 10 ñåê ïîñëå VIP îáüÿâû, æäèòå...', message_color)
						play_sound()
						MODULE.SmiEdit.Window[0] = false
						while MODULE.SmiEdit.vip_pause do wait(0) end
						try_send_ad(ad_text)
					end)
				else
					if try_send_ad(ad_text) then
						MODULE.SmiEdit.Window[0] = false
					end
				end
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòêëîíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				if u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) == '' then
					reason_cancel = 'Îòêàç ÏÐÎ'
				else
					reason_cancel = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				end
				sampSendDialogResponse(MODULE.SmiEdit.ad_dialog_id, 0, 0, reason_cancel)
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
				MODULE.SmiEdit.Window[0] = false
				MODULE.SmiEdit.is_active_ad = false
			end
			imgui.SameLine()
			if imgui.Button(fa.FORWARD .. u8' Ïðîïóñòèòü', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				MODULE.SmiEdit.skip_dialog = true
				sampSendChat('/mm')
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
				MODULE.SmiEdit.is_active_ad = false
				MODULE.SmiEdit.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('gov') then
	imgui.OnFrame(
		function() return MODULE.Zeks.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.zeks_menu.x, settings.windows_pos.zeks_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.HANDCUFFS .. u8" Ñïèñîê çàêëþ÷åííûõ èãðîêîâ (âñåãî " .. #MODULE.Zeks.all .. u8') ' .. fa.HANDCUFFS, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
			change_dpi()
			if tonumber(#MODULE.Zeks.all) == 0 then 
				sampAddChatMessage('[Radical Helper] {ffffff}Ñåé÷àñ íà ñåðâåðå íåòó çàêëþ÷åííûõ èãðîêîâ!', message_color)
				MODULE.Zeks.Window[0] = false
			end
			safery_disable_cursor(player)
			if settings.gov.auto_update_zeks then
				local text_time_wait = tostring(15 - tonumber(MODULE.Zeks.updzeks.time))
				if tonumber(text_time_wait) < 10 then
					text_time_wait = '0' .. text_time_wait
				end
				imgui.Text(u8('Àâòîìàòè÷åñêîå îáíîâëåíèå ñïèñêà çàêëþ÷åííûõ áóäåò ÷åðåç ') .. tostring(text_time_wait) .. u8(' ñåêóíä'))
				imgui.Separator()
			else
				if imgui.Button(u8'Îáíîâèòü ñïèñîê çàêëþ÷åííûõ', imgui.ImVec2(450 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					MODULE.Zeks.Window[0] = false
					sampAddChatMessage('[Radical Helper] {ffffff}Âû ìîæåòå âêëþ÷èòü àâòî-îáíîâëåíèå ñïèñêà /zeks â /helper - Ôóíêöèè ' .. modules.player.data.fraction_tag .. '!', message_color)
					sampProcessChatInput('/zeks')
				end
				imgui.Separator()
			end	
			imgui.Columns(4)
			imgui.CenterColumnText(u8("Íèêíåéì"))
			imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Âðåìÿ"))
			imgui.SetColumnWidth(-1, 65 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Íàõîæäåíèå"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Àäâîêàò"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.Columns(1)
			for i, v in ipairs(MODULE.Zeks.all) do
				imgui.Separator()
				imgui.Columns(4)
				if sampGetPlayerColor(v.id) == 368966908 then
					imgui_RGBA = (settings.general.helper_theme ~= 2) and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0, 0, 0, 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				else
					local rgbNormalized = argbToRgbNormalized(sampGetPlayerColor(v.id))
					local imgui_RGBA = imgui.ImVec4(rgbNormalized[1], rgbNormalized[2], rgbNormalized[3], 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				end
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.time .. ' ìèí.'))
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.kpz))
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.adv))
				imgui.Columns(1)
			end
			
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.zeks_menu.x or posY ~= settings.windows_pos.zeks_menu.y then
				settings.windows_pos.zeks_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
end
----------------------------------------- FAST MENU GUI -------------------------------------------
imgui.OnFrame(
    function() return MODULE.FastMenu.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER .. ' '.. u8(sampGetPlayerNickname(MODULE.FastMenu.player_id)) ..' [' .. MODULE.FastMenu.player_id .. ']##FastMenu', MODULE.FastMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands.my) do
			if command.enable and command.arg == '{id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. MODULE.FastMenu.player_id)
					MODULE.FastMenu.Window[0] = false
				end
				check = true
			end
		end
		if not check then
			sampAddChatMessage('[Radical Helper] {ffffff}Íàñòðîéòå FastMenu â /helper - Êîìàíäû è RP îòûãðîâêè - Ôàñò Ìåíþ - FastMenu', message_color)
			MODULE.FastMenu.Window[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.FastMenuButton.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.mobile_fastmenu_button.x, settings.windows_pos.mobile_fastmenu_button.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .." Radical Helper##fast_menu_button", MODULE.FastMenuButton.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar)
		change_dpi()
		if imgui.Button(fa.IMAGE_PORTRAIT .. u8' Âçàèìîäåéñòâèå ') then
			local players = get_players()
			if #players == 1 then
				show_fast_menu(players[1])
				MODULE.FastMenuButton.Window[0] = false
			elseif #players > 1 then
				MODULE.FastMenuPlayers.Window[0] = true
				MODULE.FastMenuButton.Window[0] = false
			end
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.mobile_fastmenu_button.x or posY ~= settings.windows_pos.mobile_fastmenu_button.y then
			settings.windows_pos.mobile_fastmenu_button = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.FastMenuPlayers.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .. u8" Âûáåðèòå èãðîêà " .. getHelperIcon() .. "##fast_menu_players", MODULE.FastMenuPlayers.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		local players = get_players()
		if #players == 0 then
			show_fast_menu(players[1])
			MODULE.FastMenuPlayers.Window[0] = false
		elseif #players >= 1 then
			for _, player in ipairs(players) do
				local id = tonumber(player)
				if imgui.Button(u8(sampGetPlayerNickname(id)), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if #players ~= 0 then show_fast_menu(id) end
					MODULE.FastMenuPlayers.Window[0] = false
				end
			end
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.LeaderFastMenu.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getUserIcon() .. ' ' .. u8(sampGetPlayerNickname(MODULE.LeaderFastMenu.player_id)) .. ' [' .. MODULE.LeaderFastMenu.player_id .. ']##LeaderFastMenu', MODULE.LeaderFastMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			if command.enable and command.arg == '{id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. MODULE.LeaderFastMenu.player_id)
					MODULE.LeaderFastMenu.Window[0] = false
				end
				check = true
			end
		end
		if IS_MOBILE and not check then
			sampAddChatMessage('[Radical Helper] {ffffff}Íàñòðîéòå Leader FastMenu â /helper - Êîìàíäû è RP îòûãðîâêè - Ôàñò Ìåíþ - Leader FastMenu', message_color)
			MODULE.FastMenu.Window[0] = false
		elseif not IS_MOBILE then
			if imgui.Button(u8"Âûäàòü âûãîâîð",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig ' .. MODULE.LeaderFastMenu.player_id .. ' ')
				MODULE.LeaderFastMenu.Window[0] = false
			end
			if imgui.Button(u8"Óâîëèòü èç îðãàíèçàöèè",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/unv ' .. MODULE.LeaderFastMenu.player_id .. ' ')
				MODULE.LeaderFastMenu.Window[0] = false
			end
		end
		imgui.End()
    end
)
----------------------------------------- PIEMENU GUI -------------------------------------------
function iconTextFormat(item)
    if item.icon and item.icon ~= '' and fa[item.icon] then
        return fa[item.icon] .. ' ' .. u8(item.name)
    end
    return u8(item.name)
end
function drawPieSub(v)
    if pie.BeginPieMenu(iconTextFormat(v)) then
        for _, item in ipairs(v.next) do
            if item.next == nil then
                if pie.PieMenuItem(iconTextFormat(item)) then
                    sampProcessChatInput(item.action)
                end
            elseif type(item.next) == 'table' then
                drawPieSub(item)
            end
        end
        pie.EndPieMenu()
    end
end

imgui.OnFrame(
	function() return MODULE.PieMenu.Window[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.pie.x, settings.windows_pos.pie.y), imgui.Cond.FirstUseEver)
		imgui.Begin('##MODULE.PieMenu.Window', MODULE.PieMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
		safery_disable_cursor(player)
		if IS_MOBILE then
			imgui.Button(fa.GEAR .. '##PieMenuButton', imgui.ImVec2(50 * settings.general.custom_dpi, 50 * settings.general.custom_dpi))
			if imgui.IsItemClicked(0) then
				imgui.OpenPopup("PieMenu")
			end
		else
			if imgui.IsMouseClicked(2) then
				imgui.OpenPopup('PieMenu')
			end
		end
		if pie.BeginPiePopup('PieMenu', 2) then
			if not IS_MOBILE then player.HideCursor = false end
			if #modules.piemenu.data == 0 then
				sampAddChatMessage('[Radical Helper] {ffffff}Íàñòðîéòå èëè îòêëþ÷èòå PieMenu â /helper - Êîìàíäû è RP îòûãðîâêè - Ôàñò Ìåíþ - PieMenu', message_color)
			end
			for _, item in ipairs(modules.piemenu.data) do
				if item.next == nil then
					if pie.PieMenuItem(iconTextFormat(item)) then
						sampProcessChatInput(item.action)
					end
				else
					drawPieSub(item)
				end
			end
			pie.EndPiePopup()
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.pie.x or posY ~= settings.windows_pos.pie.y then
			settings.windows_pos.pie = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
	end
)
----------------------------------- UPDATE GUI -----------------------------
imgui.OnFrame(
    function() return MODULE.Update.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.CIRCLE_INFO .. u8" Äîñòóïíî îáíîâëåíèå Radical Helper ".. fa.CIRCLE_INFO .. "##update_window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		if not IS_MOBILE then change_dpi() end
		imgui.CenterText(u8("Ñïèñîê èçìåíåíèé â íîâîé âåðñèè:"))
		for line in MODULE.Update.info:gmatch("[^\r\n]+") do
			imgui.BulletText(u8(line))
		end
		imgui.Separator()

		if not MODULE.Update.version:find('VIP') then

			if imgui.Button(fa.CLOCK .. u8' Íàïîìíèòü ïîçæå', imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				isUpdateChecked = true
				MODULE.Update.Window[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.DOWNLOAD ..u8' Îáíîâèòü äî ' .. u8(MODULE.Update.version), imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				download_file = 'helper'
				downloadFileFromUrlToPath(MODULE.Update.url, worked_dir .. "/Radical Helper.lua")
				MODULE.Update.Window[0] = false
			end

		else

			if imgui.Button(fa.DOWNLOAD ..u8' Îáíîâèòü äî ' .. u8(MODULE.Update.version) .. u8' ÷åðåç VIP áîòà ' .. fa.DOWNLOAD, imgui.ImVec2(500 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå êîìàíäó /helper â íàøåì Telegram/Discord VIP áîòå!', message_color)
				reload_script = true
				thisScript():unload()
			end

		end
		
		imgui.End()
    end
)
----------------------------------- Other GUI -----------------------------
imgui.OnFrame(
    function() return MODULE.RPWeapon.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.GUN .. u8" RP îòûãðîâêà îðóæèÿ â ÷àòå " .. fa.GUN, MODULE.RPWeapon.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
        imgui.PushItemWidth(385 * settings.general.custom_dpi)
        imgui.InputTextWithHint(u8'##inputsearch_weapon_name', u8('Ââîäèòå ÷òîáû èñêàòü îðóæèå ïî åãî ID èëè íàçâàíèþ...'), MODULE.RPWeapon.input_search, 256) 
		imgui.SameLine()
		if imgui.Button(u8("Âêëþ÷èòü âñ¸")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = true
			end
			initialize_guns()
			save_module('rpgun')
		end		
		imgui.SameLine()
		if imgui.Button(u8("Îòêëþ÷èòü âñ¸")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = false
			end
			save_module('rpgun')
		end		
		if imgui.BeginChild('##rpguns1', imgui.ImVec2(588 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.Columns(3)
			imgui.CenterColumnText(u8"Ðàáîòîñïîñîáíîñòü")
			imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"ID è íàçâàíèå îðóæèÿ")
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Ðàñïîëîæåíèå")
			imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
			imgui.Columns(1)
			imgui.Separator()
			local decoded_input = u8:decode(ffi.string(MODULE.RPWeapon.input_search))
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				if decoded_input == '' or (value.name and value.name:upper():find(decoded_input:upper())) or value.id == tonumber(decoded_input) then
					imgui.Columns(3)
					if value.enable then
						if imgui.CenterColumnSmallButton(fa.SQUARE_CHECK .. u8'  (ðàáîòàåò)##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
							value.enable = not value.enable
							save_module('rpgun')
						end
					else
						if imgui.CenterColumnSmallButton(fa.SQUARE .. u8' (îòêëþ÷¸í)##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
							value.enable = not value.enable
							save_module('rpgun')
						end
					end
					imgui.NextColumn()
					imgui.CenterColumnText('[' .. value.id .. '] ' .. u8(value.name))
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_name' .. index) then
						_G.weapon_input = imgui.new.char[256]()
						imgui.StrCopy(_G.weapon_input, u8(value.name))
						imgui.OpenPopup(fa.GUN .. u8' Íàçâàíèå îðóæèÿ ' .. fa.GUN .. '##weapon_name' .. index)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.GUN .. u8' Íàçâàíèå îðóæèÿ ' .. fa.GUN .. '##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.InputText(u8'##weapon_name', _G.weapon_input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							value.name = u8:decode(ffi.string(_G.weapon_input))
							save_module('rpgun')
							initialize_guns()
							_G.weapon_input = nil
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.NextColumn()
					local position = ''
					if value.rpTake == 1 then
						position = 'Ñïèíà'
					elseif value.rpTake == 2 then
						position = 'Êàðìàí'
					elseif value.rpTake == 3 then
						position = 'Ïîÿñ'
					elseif value.rpTake == 4 then
						position = 'Êîáóðà'
					end
					imgui.CenterColumnText(u8(position))
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_position' .. index) then
						MODULE.RPWeapon.ComboTags[0] = value.rpTake - 1
						imgui.OpenPopup(fa.GUN .. u8' Ðàñïîëîæåíèå îðóæèÿ##weapon_name' .. index)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.GUN .. u8' Ðàñïîëîæåíèå îðóæèÿ##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.Combo(u8'##' .. index, MODULE.RPWeapon.ComboTags, MODULE.RPWeapon.ImItems, 4)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Îòìåíà', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Ñîõðàíèòü', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							value.rpTake = MODULE.RPWeapon.ComboTags[0] + 1
							save_module('rpgun')
							initialize_guns()
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
			end
			imgui.EndChild()
		end
        imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.CommandStop.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .. " Radical Helper " .. getHelperIcon() .. "##MODULE.CommandStop.Window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if IS_MOBILE and MODULE.Binder.state.isActive then
			if imgui.Button(fa.CIRCLE_STOP..u8' Îñòàíîâèòü îòûãðîâêó') then
				MODULE.Binder.state.isStop = true 
				MODULE.CommandStop.Window[0] = false
			end
		else
			MODULE.CommandStop.Window[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.CommandPause.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .." Radical Helper " .. getHelperIcon() .. "##MODULE.CommandPause.Window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if MODULE.Binder.state.isPause then
			safery_disable_cursor(player)
			local label = ' Ïðîäîëæèòü' .. (hotkey_no_errors and settings.general.bind_action and ' [' .. getNameKeysFrom(settings.general.bind_action) .. ']' or '')
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8(label), imgui.ImVec2(180 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				MODULE.Binder.state.isPause = false
				MODULE.CommandPause.Window[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Ïîëíûé STOP ', imgui.ImVec2(180 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				MODULE.Binder.state.isStop = true 
				MODULE.Binder.state.isPause = false
				MODULE.CommandPause.Window[0] = false
			end
		else
			MODULE.CommandPause.Window[0] = false
		end
		imgui.End()
    end
)
---------------------------------- GUI ITEMS -----------------------------
function imgui.CenterUnderlineText(text)
	local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX(width / 2 - calc.x / 2)
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    imgui.Text(text)
    local size = imgui.GetItemRectSize()
    local Y = p.y + size.y
    dl:AddLine(imgui.ImVec2(p.x, Y), imgui.ImVec2(p.x + size.x, Y), imgui.GetColorU32(imgui.Col.Text), 1)
end
function imgui.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(text)
        imgui.EndTooltip()
    end
end
function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.CenterTextDisabled(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.TextDisabled(text)
end
function imgui.CenterColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end
function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterSmallButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnSmallButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnRadioButtonIntPtr(text, arg1, arg2)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.RadioButtonIntPtr(text, arg1, arg2) then
		return true
	else
		return false
	end
end
function imgui.ItemSelector(name, items, selected, fixedSize, dontDrawBorders)
    assert(items and #items > 1, 'items must be array of strings')
    assert(selected[0], 'Wrong argument #3. Selected must be "imgui.new.int"')
    local DL = imgui.GetWindowDrawList()
    local style = {
        rounding = imgui.GetStyle().FrameRounding,
        padding = imgui.GetStyle().FramePadding,
        col = {
            default = imgui.GetStyle().Colors[imgui.Col.Button],
            hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered],
            active = imgui.GetStyle().Colors[imgui.Col.ButtonActive],
            text = imgui.GetStyle().Colors[imgui.Col.Text]
        }
    }
    local pos = imgui.GetCursorScreenPos()
    local start = pos
    local maxSize = 0
    for index, item in ipairs(items) do
        local textSize = imgui.CalcTextSize(item)
        local sizeX = (fixedSize or textSize.x) + style.padding.x * 2
        imgui.SetCursorScreenPos(pos)
        if imgui.InvisibleButton('##imguiSelector_'..item..'_'..tostring(index), imgui.ImVec2(sizeX, textSize.y + style.padding.y * 2)) then
            local old = selected[0]
            selected[0] = index
            return selected[0], old
        end
        DL:AddRectFilled(
            pos,
            imgui.ImVec2(pos.x + sizeX, pos.y + textSize.y + style.padding.y * 2),
            imgui.GetColorU32Vec4((selected[0] == index or imgui.IsItemActive()) and style.col.active or (imgui.IsItemHovered() and style.col.hovered or style.col.default)),
            style.rounding,
            (index == 1 and 5 or (index == #items and 10 or 0))
        )
        if index > 1 and not dontDrawBorders then DL:AddLine(imgui.ImVec2(pos.x, pos.y + style.padding.y), imgui.ImVec2(pos.x, pos.y + textSize.y + style.padding.y), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Border]), 1) end
        DL:AddText(imgui.ImVec2(pos.x + sizeX / 2 - textSize.x / 2, pos.y + style.padding.y), imgui.GetColorU32Vec4(style.col.text), item)
        pos = imgui.ImVec2(pos.x + sizeX, pos.y)
    end
    DL:AddRect(start, imgui.ImVec2(pos.x, pos.y + imgui.CalcTextSize('A').y + style.padding.y * 2), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Border]), imgui.GetStyle().FrameRounding, nil, imgui.GetStyle().FrameBorderSize)
    DL:AddText(imgui.ImVec2(pos.x + style.padding.x, pos.y + (imgui.CalcTextSize(name).y + style.padding.y * 2) / 2 - imgui.CalcTextSize(name).y / 2), imgui.GetColorU32Vec4(style.col.text), name)
end
function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() 
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width/count - ((space * (count-1)) / count)
end
function safery_disable_cursor(gui)
	if not IS_MOBILE and not sampIsCursorActive() then gui.HideCursor = true else gui.HideCursor = false end
end
function apply_dark_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = (IS_MOBILE and 15 or 10) * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.12, 0.12, 0.12, 0.9)
end
function apply_white_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = (IS_MOBILE and 15 or 10) * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.88, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.80, 0.89, 0.97, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100) 
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.94, 0.94, 0.94, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, settings.general.transparent / 1000)
    imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.20, 0.20, 0.20, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.00, 0.48, 0.85, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.80, 0.80, 0.80, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.88, 0.88, 0.88, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.88, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.80, 0.89, 0.97, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.88, 0.88, 0.88, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.88, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.89, 0.97, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.50, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.10, 0.40, 0.75, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.10, 0.40, 0.75, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.00, 0.00, 0.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.00, 0.00, 0.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.00, 0.00, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.88, 0.88, 0.88, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.88, 1.00, 1.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabActive] = imgui.ImVec4(0.80, 0.89, 0.97, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.00, 0.47, 0.84, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, settings.general.transparent / 100)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.8)
end
function apply_moonmonet_theme()
	local generated_color = moon_monet.buildColors(settings.general.moonmonet_theme_color, 1.0, true)
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = (IS_MOBILE and 15 or 10) * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4_orig()
	imgui.GetStyle().Colors[imgui.Col.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4_orig()
	imgui.GetStyle().Colors[imgui.Col.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x70):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0x7f):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0,0,0,0)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x85):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x80):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4_orig()
end
function argbToRgbNormalized(argb)
    local a = math.floor(argb / 0x1000000) % 0x100
    local r = math.floor(argb / 0x10000) % 0x100
    local g = math.floor(argb / 0x100) % 0x100
    local b = argb % 0x100
    local normalizedR = r / 255.0
    local normalizedG = g / 255.0
    local normalizedB = b / 255.0
    return {normalizedR, normalizedG, normalizedB}
end
function argbToHexWithoutAlpha(alpha, red, green, blue)
    return string.format("%02X%02X%02X", red, green, blue)
end
function rgba_to_argb(rgba_color)
    local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
    local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
    local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
    local a = bit32.band(rgba_color, 0xFF)
    local argb_color = bit32.bor(bit32.lshift(a, 24), bit32.lshift(r, 16), bit32.lshift(g, 8), b)
    return argb_color
end
function join_argb(a, r, g, b)
    local argb = b 
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))    
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
function rgba_to_hex(rgba)
    local r = bit.rshift(rgba, 24) % 256
    local g = bit.rshift(rgba, 16) % 256
    local b = bit.rshift(rgba, 8) % 256
    local a = rgba % 256
    return string.format("%02X%02X%02X", r, g, b)
end
function ARGBtoRGB(color) 
	return bit.band(color, 0xFFFFFF) 
end
function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha)
        self.a = alpha
        return self
    end
    function ret:as_u32()
        return join_argb(self.a, self.b, self.g, self.r)
    end
    function ret:as_vec4()
		local multiplier = (settings.general.transparent or 100) / 100
		return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, (self.a / 255) * multiplier)
    end
	function ret:as_vec4_orig()
		return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
    end
    function ret:as_argb()
        return join_argb(self.a, self.r, self.g, self.b)
    end
    function ret:as_rgba()
        return join_argb(self.r, self.g, self.b, self.a)
    end
    function ret:as_chat()
        return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
    end 
    return ret
end
function change_dpi()
	imgui.PushFont(MODULE.FONT) 
end
function getHelperIcon()
	local HELPER_ICONS = {
		police   = fa.BUILDING_SHIELD,
		fbi      = fa.BUILDING_SHIELD,
		army     = fa.BUILDING_SHIELD,
		prison   = fa.BUILDING_SHIELD,
		hospital = fa.HOSPITAL,
		smi      = fa.BUILDING_NGO,
		gov      = fa.BUILDING_COLUMNS,
		fd       = fa.HOTEL,
		mafia    = fa.TORII_GATE,
		ghetto   = fa.BUILDING_WHEAT,
		none     = fa.BUILDING_CIRCLE_XMARK
	}
	return HELPER_ICONS[settings.general.fraction_mode] or fa.BUILDING
end
function getUserIcon()
	local USER_ICONS = {
		police   = fa.USER_NURSE,
		fbi      = fa.USER_NURSE,
		army     = fa.PERSON_MILITARY_RIFLE,
		prison   = fa.PERSON_MILITARY_RIFLE,
		hospital = fa.USER_DOCTOR,
		fd       = fa.USER_ASTRONAUT,
		lc       = fa.USER_TIE,
		ins      = fa.USER_TIE,
		mafia    = fa.USER_NINJA,
		ghetto   = fa.USER_NINJA
	}
	return USER_ICONS[settings.general.fraction_mode] or fa.USER
end
function insert_to_cursor(insert_text, buffer)
    local current = ffi.string(buffer)
    local start
    local finish
    if MODULE.INPUT.USER_MOVED_CURSOR then
        start = MODULE.INPUT.SELECTION_START
        finish = MODULE.INPUT.SELECTION_END
		sampAddChatMessage('[Radical Helper] {ffffff}Êóðñîð äëÿ âñòàâêè óñòàíîâëåí â êîíåö ñòðî÷êè!', message_color)
    else
        start = #current
        finish = #current
    end
    local before = current:sub(1, start)
    local after = current:sub(finish + 1)
    local new_text = before .. insert_text .. after
    imgui.StrCopy(buffer, new_text)
    local new_cursor = start + #insert_text
    MODULE.INPUT.CURSOR_POS = new_cursor
    MODULE.INPUT.SELECTION_START = new_cursor
    MODULE.INPUT.SELECTION_END = new_cursor
    MODULE.INPUT.USER_MOVED_CURSOR = false
end
-------------------------------------------- Networking ----------------------------------------
function asyncHttpRequest(method, url, args, resolve, reject)
    local thread_code = [[
        return function (method, url, args, is_mobile)
            local requests = require 'requests'
			if is_mobile then
				local effil = require 'effil'
				if type(args) == "userdata" then args = effil.dump(args) end
			end
            local result, response = pcall(requests.request, method, url, args)
            if result then
                response.json, response.xml = nil, nil
                return true, response
            else
                return false, response
            end
        end
    ]]
    local thread_func = assert(loadstring(thread_code))()
    local request_thread = effil.thread(thread_func)(method, url, args, IS_MOBILE)
    resolve = resolve or function(...) end
	reject = reject or function(...) end
    lua_thread.create(function()
        local runner = request_thread
        while true do
            local status, err = runner:status()
            if not err then
                if status == 'completed' then
                    local result, response = runner:get()
                    if result then
                        resolve(response)
                    else
                        reject(response)
                    end
                    return
                elseif status == 'canceled' then
                    return reject(status)
                end
            else
                return reject(err)
            end
            wait(0)
        end
    end)
end
-------------------------------------------- Analytichs ----------------------------------------
function getHWID()
	if IS_MOBILE then
		local success, id = pcall(function()
			local envu = require("android.jnienv-util")
			envu.LooperPrepare()
			local activity = require("android.jni-raw").activity
			local contentResolver = envu.CallObjectMethod(
				activity,
				"getContentResolver",
				"()Landroid/content/ContentResolver;"
			)
			local ANDROID_ID = envu.GetStaticObjectField(
				"android/provider/Settings$Secure",
				"ANDROID_ID",
				"Ljava/lang/String;"
			)
			local jstr = envu.CallStaticObjectMethod(
				"android/provider/Settings$Secure",
				"getString",
				"(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;",
				contentResolver,
				ANDROID_ID
			)
			local android_id = envu.FromJString(jstr)
			return android_id
		end)
		if success then return id end
	else
		-- Ñîãë ýòî íå íîðì äëÿ óíèêàëüíîñòè, íî íà ïåðâîå âðåìÿ ñîéäåò
		local success, id = pcall(function()
			ffi.cdef[[
				int __stdcall GetVolumeInformationA(
						const char* lpRootPathName,
						char* lpVolumeNameBuffer,
						uint32_t nVolumeNameSize,
						uint32_t* lpVolumeSerialNumber,
						uint32_t* lpMaximumComponentLength,
						uint32_t* lpFileSystemFlags,
						char* lpFileSystemNameBuffer,
						uint32_t nFileSystemNameSize
				);
				]]
			local serial = ffi.new("unsigned long[1]", 0)
			ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
			return serial[0]
		end)
		if success then return string.format("%08X", id) end
	end
	return 'Unknown'
end
function sendAnalytics()
	asyncHttpRequest(
		"POST",
        "https://api.mtgmods.com/v1/usage/launch",
        {
            headers = {
                ["Content-Type"] = "application/json"
            },
            data = safe_encode_json({
                version = thisScript().version,
                hwid = getHWID(),
                server_id = tonumber(getServerNumber()),
                device = IS_MOBILE and "MOBILE" or "PC"
            }),
            timeout = 5
        }
    )
end
------------------------------------------ PC KEY ACTIONS --------------------------------------
if not IS_MOBILE then
	function onWindowMessage(msg, wparam, lparam)
		if msg == 0x101 then
			if (wparam == VK_ESCAPE and MODULE.Main.Window[0]) then
				consumeWindowMessage(true, false)
				MODULE.Main.Window[0] = false
			end
			if (wparam == 13 and MODULE.SmiEdit.Window[0]) then
				consumeWindowMessage(true, false)
				local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				if try_send_ad(text) then MODULE.SmiEdit.Window[0] = false end
			end
		end
	end
end
-------------------------------------------- Terminate ------------------------------------------
function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		if MODULE.InfraredVision then setInfraredVision(false) end
		if MODULE.NightVision then setNightVision(false) end
		sampAddChatMessage('[Radical Helper] {ffffff}Ïðîèçîøëà íåèçâåñòíàÿ îøèáêà, õåëïåð ïðèîñòàíîâèë ñâîþ ðàáîòó!', message_color)
		if not IS_MOBILE then 
			sampAddChatMessage('[Radical Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}÷òîáû ïåðåçàïóñòèòü õåëïåð.', message_color)
		end
    end
end
