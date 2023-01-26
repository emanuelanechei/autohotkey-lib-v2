#Include <Paths>
#Include <Abstractions\Text>
#Include <Converters\DateTime>
#Include <Extensions\Json>
#Include <Tools\Info>

Class Timer {

	/**
	 * The json file path that timer writes and reads from
	 * @type {String}
	 */
	static jsonPath := Paths.Ptf["Timer.json"]

	shouldRing := true

	static RestartTimers() {
		jsonObj := JSON.parse(ReadFile(this.jsonPath))
		for key, value in jsonObj {
			if value["end"] < A_Now {
				Info("Timer for " value["duration"] " ran out")
				jsonObj.Delete(key)
				continue
			}

			; time := 
		}
	}

	__New(time) {

		this.timestamp := time
		this.startTime := A_Now
		this.endTime := DateTime.AddTimestamp(this.startTime, time)
		this.duration := DateTime.ConvertToSeconds(time)
		this.hash := String(Random(1, 100000))

	}

	Start() {
		jsonObj := JSON.parse(ReadFile(Timer.jsonPath))
		jsonObj.Set(this.hash, Map(
			"start",    this.startTime,
			"end",      this.endTime,
			"duration", this.duration
		))
		WriteFile(Timer.jsonPath, JSON.stringify(jsonObj))

		if this.shouldRing {
			action := this.Alarm.Bind(this)
		} else {
			action := this.StopSound.Bind(this)
		}

		SetTimer(action, -this.duration * 1000)
		Info("Timer set for " this.timestamp)
	}

	__DeleteJson() {
		jsonObj := JSON.parse(ReadFile(Timer.jsonPath))
		jsonObj.Delete(this.hash)
		WriteFile(Timer.jsonPath, JSON.stringify(jsonObj))
	}

	/**
	 * The ringer. Will show you an Infos that displays the time you set that timer for
	 * Will continue to beep intermittently until you close the info (press escape or click on the info)
	 * @private
	 */
	Alarm() {
		this.__DeleteJson()
		infoHwnd := Infos("Your timer for " this.timestamp " is up!").gInfo.Hwnd
		while WinExist(infoHwnd) {
			SoundBeep()
			Sleep(200)
		}
	}

	/**
	 * An alternative to the usual beeping ringer, that will instead just disable your music
	 * You can get this behavior if you set the "shouldRing" property to false
	 * @private
	 */
	StopSound() => (Send("{Media_Stop}"), this.__DeleteJson())
}