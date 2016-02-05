-- Broadcast by danny9484
PLUGIN = nil

function Initialize(Plugin)
	Plugin:SetName("Broadcast")
	Plugin:SetVersion(1)

	-- Hooks
  cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnTick);

	PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that

	-- Command Bindings

  -- read Config
  local IniFile = cIniFile();
  if (IniFile:ReadFile(PLUGIN:GetLocalFolder() .. "/config.ini")) then
    Message_counter = 1
    Messages = {}
    Time = IniFile:GetValue("Settings", "Messagetime")
    Time_counter = 0
    Message_Prefix = IniFile:GetValue("Settings", "Prefix")
    NoRepeat = IniFile:GetValue("Settings", "NoRepeat")
    Message_last = ""
    if NoRepeat == "true" then
      LOG(Plugin:GetName() .. ": NoRepeat is on")
    else
      LOG(Plugin:GetName() .. ": NoRepeat is off")
    end
    while IniFile:GetValue("Messages", tostring(Message_counter)) ~= "" do
      Messages[Message_counter] = IniFile:GetValue("Messages", tostring(Message_counter))
      LOG(Plugin:GetName() .. ": Message Initialized: " .. Messages[Message_counter])
      Message_counter = Message_counter + 1
    end
  else
    LOG("can't read config.ini")
    return false
  end


	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnTick(World, TimeDelta)
  Time_counter = Time_counter + TimeDelta
  if Time_counter / 5000 > tonumber(Time) then
    local callback = function(Player)
      Player:SendMessage(Message_Prefix .. " " .. Messages[random])
    end
    random = math.random(1, Message_counter - 1)
    if NoRepeat == "true" then
      while Message_last == Messages[random] do
        random = math.random(1, Message_counter - 1)
      end
      Message_last = Messages[random]
    end
    cRoot:Get():ForEachPlayer(callback)
    Time_counter = 0
  end
end
