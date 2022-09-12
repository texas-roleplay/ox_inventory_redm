local key = GetConvar('datadog:key', 'd353c117032f899b2b98eafb4ddf29a2')
local response = {
	[400] = 'bad request',
	[401] = 'unauthorized',
	[403] = 'forbidden',
	[404] = 'not found',
	[405] = 'method not allowed',
	[408] = 'request timeout',
	[413] = 'payload too large',
	[429] = 'too many requests',
	[500] = 'internal server error',
	[502] = 'gateway unavailable',
	[503] = 'service unavailable'
}

if key ~= '' then
	local site = ('https://http-intake.logs.%s/api/v2/logs'):format(GetConvar('datadog:site', 'datadoghq.com'))

	function server.logs(message, source, ...)
		local ddtags = string.strjoin(',', string.tostringall(...))
		PerformHttpRequest(site, function(status)
			if status ~= 202 then
				print(('unable to submit logs to %s (%s)'):format(site, response[status]))
			end
		end, 'POST', json.encode({
			hostname = GetConvar('datadog:hostname', 'FXServer'),
			service = shared.resource,
			message = message,
			ddsource = source,
			ddtags = ddtags
		}), {
			['Content-Type'] = 'application/json',
			['DD-API-KEY'] = key
		})
	end
else
	local webhook = GetConvar('inventory:discordWebhook', '')

	if webhook ~= '' then
		function server.logs(message, source, ...)
			local user = exports.redemrp_roleplay:getPlayerFromId(source)			
			local characterName = ('%s %s'):format(user?.getFirstname() or '?', user?.getLastname() or '?')

			PerformHttpRequest(webhook, function(status)
				if status ~= 204 then
					if status == 429 then
						print('congratulations, you\'re being rate limited by Discord after submitting too many logs')
					else
						print(('unable to submit logs to discord (%s)'):format(status))
					end
				end
			end, 'POST', json.encode({
				username = shared.resource,
				embeds = {{
					color = 16705372,
					title = string.strjoin(', ', string.tostringall(...)),

					author =
                    {
                        name = ('%s ( %d )'):format(characterName, user?.getId() or 0),
                        -- url = 'https://www.reddit.com/r/Pizza/',
                        icon_url = 'https://camo.githubusercontent.com/06d7964b046d9a166e6b825789674e000ef2bdf88c2c1d35d1bdc75b84608795/687474703a2f2f66656d67612e636f6d2f696d616765732f73616d706c65732f75695f74657874757265732f67656e657269635f74657874757265732f74656d705f70656473686f742e706e67'
                    },
					fields = ... and {{
						name = 'Descrição',
						value = message
					}},
					footer = {
						text = os.date(),
						icon_url = 'https://avatars.githubusercontent.com/u/88127058?s=200&v=4'
					}
				}}
			}), { ['Content-Type'] = 'application/json' })
		end
	end
end

if not server.logs then
	function server.logs() end
end